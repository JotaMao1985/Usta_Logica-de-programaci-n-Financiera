#!/usr/bin/env Rscript
# ============================================================================
# Informe del simulacro · el veredicto sale de los datos
#
#   LPF_BD=parcial/app/datos/simulacro.sqlite \
#   LPF_SALIDA=parcial/salida_simulacro \
#   Rscript parcial/despliegue/informe_simulacro.R
#
# El criterio de aborto se fijó por escrito ANTES del simulacro (PLAN §D8):
# si más del 10 % del curso no pudo entrar o tuvo incidentes, el parcial va
# por Moodle. Este guion lo calcula; no lo interpreta y no lo negocia.
# ============================================================================

if (!isTRUE(l10n_info()$`UTF-8`)) {
  for (loc in c("es_CO.UTF-8", "es_ES.UTF-8", "en_US.UTF-8", "C.UTF-8"))
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
}
suppressPackageStartupMessages({ library(DBI); library(RSQLite) })

verde <- function(x) paste0("\033[32m", x, "\033[0m")
rojo  <- function(x) paste0("\033[31m", x, "\033[0m")
amar  <- function(x) paste0("\033[33m", x, "\033[0m")
gris  <- function(x) paste0("\033[90m", x, "\033[0m")

ruta <- grep("^--file=", commandArgs(FALSE), value = TRUE)[1]
BASE <- if (!is.na(ruta))
  normalizePath(dirname(dirname(dirname(gsub("~\\+~", " ", sub("^--file=", "", ruta)))))) else getwd()
SALIDA <- Sys.getenv("LPF_SALIDA", file.path(BASE, "parcial", "salida_simulacro"))
BD     <- Sys.getenv("LPF_BD",     file.path(BASE, "parcial", "app", "datos", "simulacro.sqlite"))
UMBRAL <- as.numeric(Sys.getenv("LPF_UMBRAL", "10"))   # por ciento

if (!file.exists(BD)) stop("no encuentro la base del simulacro en ", BD, call. = FALSE)
con <- dbConnect(SQLite(), BD); on.exit(dbDisconnect(con))

man <- file.path(SALIDA, "manifiesto.csv")
convocados <- if (file.exists(man))
  nrow(read.csv(man, colClasses = "character", encoding = "UTF-8")) else NA_integer_

ses <- dbGetQuery(con, "SELECT * FROM sesiones")
ev  <- dbGetQuery(con, "SELECT sid, tipo, detalle FROM eventos")
rsp <- dbGetQuery(con, "SELECT sid, COUNT(*) AS n FROM respuestas
                        WHERE valor NOT IN ('null','\"\"') GROUP BY sid")

entraron  <- nrow(ses)
entregaron<- sum(ses$entregado == 1, na.rm = TRUE)
sin_entrar<- if (is.na(convocados)) NA_integer_ else convocados - entraron

## Tipos de evento que significan «a esta persona le pasó algo».
graves <- c("error_interfaz", "examen_corrupto", "entrega_sin_clave",
            "entrega_sin_calificar", "reloj_resellado")
con_incidente <- unique(ev$sid[ev$tipo %in% graves])
con_incidente <- con_incidente[nzchar(con_incidente)]

## Reanudar no es un fallo —el sistema hizo su trabajo— pero SÍ es la huella
## de que algo se cayó: se cuenta aparte y se mira.
reanudaron <- unique(ev$sid[ev$tipo == "reanuda"])
desplazados <- unique(ev$sid[ev$tipo == "desplazado"])
acc_fallidos <- sum(ev$tipo == "acceso_fallido")

## Sesión abierta que nunca entregó y sin respuestas: no llegó a usar la app.
vacias <- setdiff(ses$sid, rsp$sid)

afectados <- unique(c(con_incidente, vacias))
n_afectados <- length(afectados) + (if (is.na(sin_entrar)) 0L else max(0L, sin_entrar))
base <- if (is.na(convocados)) entraron else convocados
pct <- if (base > 0) 100 * n_afectados / base else 0

linea <- function(etiqueta, valor, nota = "") cat(sprintf("  %-34s %6s  %s\n", etiqueta, valor, gris(nota)))

cat("\n  Informe del simulacro\n")
cat(gris(sprintf("  base: %s\n\n", BD)))
linea("convocados (manifiesto)", ifelse(is.na(convocados), "?", convocados))
linea("entraron", entraron)
linea("no entraron", ifelse(is.na(sin_entrar), "?", sin_entrar),
      "cada uno cuenta como afectado")
linea("entregaron", entregaron)
linea("sesiones sin una sola respuesta", length(vacias), "entraron y no pudieron responder")
cat("\n")
linea("con incidente grave", length(con_incidente),
      if (length(con_incidente)) paste(unique(ev$tipo[ev$tipo %in% graves]), collapse = ", ") else "")
linea("reanudaron (algo se les cayó)", length(reanudaron), "no es un fallo, es una huella")
linea("desplazados (dos ventanas)", length(desplazados))
linea("accesos fallidos", acc_fallidos, "código mal escrito o documento ausente")

cat("\n  ", strrep("─", 52), "\n", sep = "")
cat(sprintf("  afectados: %d de %d  = %.1f %%   (umbral: %.0f %%)\n",
            n_afectados, base, pct, UMBRAL))
if (pct > UMBRAL) {
  cat(rojo("\n  NO APTO. El parcial va por Moodle.\n"))
  cat(gris("  El criterio se fijó antes del simulacro para no negociarlo ahora.\n\n"))
  quit(status = 1L)
}
cat(verde("\n  APTO. El parcial puede servirse con la app.\n"))
if (length(reanudaron)) {
  cat(amar(sprintf("  Ojo: %d estudiante(s) tuvieron que reanudar. Mire por qué antes del parcial.\n",
                   length(reanudaron))))
}
cat("\n")
