#!/usr/bin/env Rscript
# ============================================================================
# Comprobación previa al parcial
#
# Se ejecuta ANTES de abrir la puerta del salón. Cada comprobación existe
# porque su ausencia produce un fallo que solo se ve cuando ya es tarde.
#
#   Rscript parcial/despliegue/comprobar.R
#
# Devuelve 1 si algo está mal. Nada de esto es opinión: o pasa, o no se abre.
# ============================================================================

if (!isTRUE(l10n_info()$`UTF-8`)) {
  for (loc in c("es_CO.UTF-8", "es_ES.UTF-8", "en_US.UTF-8", "C.UTF-8"))
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
}
suppressPackageStartupMessages({ library(jsonlite); library(DBI); library(RSQLite); library(digest) })

verde <- function(x) paste0("\033[32m", x, "\033[0m")
rojo  <- function(x) paste0("\033[31m", x, "\033[0m")
amar  <- function(x) paste0("\033[33m", x, "\033[0m")
gris  <- function(x) paste0("\033[90m", x, "\033[0m")

ruta <- grep("^--file=", commandArgs(FALSE), value = TRUE)[1]
BASE <- if (!is.na(ruta))
  normalizePath(dirname(dirname(dirname(gsub("~\\+~", " ", sub("^--file=", "", ruta)))))) else getwd()
SALIDA <- Sys.getenv("LPF_SALIDA", file.path(BASE, "parcial", "salida"))
BD     <- Sys.getenv("LPF_BD",     file.path(BASE, "parcial", "app", "datos", "parcial.sqlite"))

fallos <- 0L; avisos <- 0L
ok    <- function(t) cat(verde("  ✓ "), t, "\n", sep = "")
mal   <- function(t, por) { fallos <<- fallos + 1L
  cat(rojo("  ✗ "), t, "\n", gris(paste0("      ", por, "\n")), sep = "") }
aviso <- function(t, por) { avisos <<- avisos + 1L
  cat(amar("  ! "), t, "\n", gris(paste0("      ", por, "\n")), sep = "") }

cat("\n  Comprobación previa al parcial\n")
cat(gris(sprintf("  salida: %s\n  base:   %s\n\n", SALIDA, BD)))

# --- 1. Secretos ----------------------------------------------------------
pepper <- Sys.getenv("LPF_PEPPER", "")
codigo <- Sys.getenv("LPF_CODIGO", "")
clave  <- Sys.getenv("LPF_PANEL_CLAVE", "")

if (pepper == "") {
  mal("LPF_PEPPER definido",
      "sin él la app calcula identificadores distintos a los del generador: no entra nadie")
} else if (grepl("DEMOSTRACION", pepper)) {
  mal("LPF_PEPPER no es el de demostración",
      "el pepper de demostración está escrito en el repositorio")
} else if (nchar(pepper) < 32) {
  aviso("LPF_PEPPER es corto", sprintf("%d caracteres; use `openssl rand -hex 32`", nchar(pepper)))
} else ok("LPF_PEPPER definido y no es el de demostración")

## Que el pepper sea bueno no basta: tiene que ser EL MISMO con el que se
## generaron los exámenes.
fh <- file.path(SALIDA, "huella_pepper.txt")
if (pepper != "" && file.exists(fh)) {
  esperada <- trimws(readLines(fh, warn = FALSE)[1])
  actual   <- digest::digest(pepper, algo = "sha256", serialize = FALSE)
  if (!identical(esperada, actual)) {
    mal("el pepper es el mismo con el que se generaron los exámenes",
        "no coincide: la app calcularía otros identificadores y NADIE podría entrar")
  } else ok("el pepper coincide con el que generó los exámenes")
} else if (pepper != "") {
  aviso("huella del pepper presente",
        "regenere los exámenes para poder comprobar que el pepper es el correcto")
}

if (codigo == "" || identical(codigo, "PRUEBA")) {
  mal("LPF_CODIGO definido", "el código del día no puede quedar en el de prueba")
} else ok("LPF_CODIGO definido")

if (clave == "" || identical(clave, "PANEL")) {
  mal("LPF_PANEL_CLAVE definido", "sin ella el panel docente queda con la clave de prueba")
} else if (identical(clave, codigo)) {
  mal("la clave del panel es distinta del código del día",
      "si son iguales, cualquier estudiante entra al panel docente")
} else ok("LPF_PANEL_CLAVE definida y distinta del código del día")

# --- 2. Exámenes generados ------------------------------------------------
ex <- list.files(file.path(SALIDA, "examenes"), pattern = "[.]json$")
cl <- list.files(file.path(SALIDA, "claves"),   pattern = "[.]json$")
pa <- list.files(file.path(SALIDA, "papel"),    pattern = "[.]pdf$")

if (!length(ex)) {
  mal("hay exámenes generados", "la carpeta examenes/ está vacía")
} else if (!setequal(ex, cl)) {
  mal("cada examen tiene su clave",
      sprintf("%d exámenes y %d claves; sin clave, ese examen no se puede calificar",
              length(ex), length(cl)))
} else ok(sprintf("%d exámenes, cada uno con su clave", length(ex)))

## Sobrantes de una generación anterior. Regenerar con otro pepper —o con otro
## roster— no borra los archivos viejos: quedan exámenes huérfanos que nadie
## reclamará y que hacen que las cuentas del salón no cuadren.
fm0 <- file.path(SALIDA, "manifiesto.csv")
if (length(ex) && file.exists(fm0)) {
  n_man <- nrow(read.csv(fm0, colClasses = "character", encoding = "UTF-8"))
  if (length(ex) != n_man) {
    mal(sprintf("los exámenes cuadran con el manifiesto (%d vs %d)", length(ex), n_man),
        "hay exámenes de una generación anterior; vacíe salida/ y vuelva a generar")
  } else ok(sprintf("los %d exámenes cuadran con el manifiesto", n_man))
}

if (length(ex) && length(pa) < length(ex)) {
  aviso("respaldo en papel completo",
        sprintf("%d PDF para %d exámenes: %d estudiantes se quedarían sin plan B",
                length(pa), length(ex), length(ex) - length(pa)))
} else if (length(ex)) ok(sprintf("%d PDF de respaldo, uno por examen", length(pa)))

## Los JSON que van al servidor no pueden traer la clave dentro.
prohibidos <- c("sol", "tol", "retro", "perm", "rubrica", "solucion")
fuga <- character(0)
for (f in head(ex, 200)) {
  x <- tryCatch(fromJSON(file.path(SALIDA, "examenes", f), simplifyVector = FALSE),
                error = function(e) NULL)
  if (is.null(x)) { fuga <- c(fuga, paste(f, "(ilegible)")); next }
  hay <- function(y) if (is.list(y)) any(names(y) %in% prohibidos) ||
    any(vapply(y, hay, TRUE)) else FALSE
  if (hay(x)) fuga <- c(fuga, f)
}
if (length(fuga)) {
  mal("ningún examen filtra la clave", paste("revisar:", paste(head(fuga, 5), collapse = ", ")))
} else if (length(ex)) ok("ningún examen contiene campos de la clave")

# --- 3. El manifiesto no puede llevar cédulas ------------------------------
fm <- file.path(SALIDA, "manifiesto.csv")
if (!file.exists(fm)) {
  aviso("manifiesto presente", "sin él, el panel muestra identificadores y no nombres")
} else {
  m <- read.csv(fm, colClasses = "character", encoding = "UTF-8", nrows = 5)
  if (any(grepl("cedula|documento|identificacion", names(m), ignore.case = TRUE)))
    mal("el manifiesto no lleva cédulas",
        "las cédulas no pueden salir de su máquina (Ley 1581 de 2012)")
  else ok("manifiesto sin cédulas")
}

# --- 4. Recursos vendorizados ---------------------------------------------
vend <- file.path(BASE, "parcial", "app", "www", "vendor")
faltan <- !file.exists(file.path(vend, "cabecera.html"))
if (faltan) {
  mal("recursos vendorizados",
      "ejecute Rscript parcial/vendorizar.R; sin ellos la página depende de internet")
} else {
  cab <- readLines(file.path(vend, "cabecera.html"), warn = FALSE)
  refs <- sub('.*(href|src)="vendor/([^"]+)".*', "\\2", grep("vendor/", cab, value = TRUE))
  perdidos <- refs[!file.exists(file.path(vend, refs))]
  if (length(perdidos)) {
    mal("todos los recursos vendorizados están en disco",
        paste("faltan:", paste(head(perdidos, 3), collapse = ", ")))
  } else ok(sprintf("%d recursos vendorizados y presentes", length(refs)))
}

# --- 5. El calificador -----------------------------------------------------
res <- suppressWarnings(system2("Rscript", c(shQuote(file.path(BASE, "parcial", "calificar.R")),
                                             "--pruebas"), stdout = TRUE, stderr = TRUE))
if (!is.null(attr(res, "status")) && attr(res, "status") != 0) {
  mal("las pruebas del calificador pasan", "Rscript parcial/calificar.R --pruebas falla")
} else ok("las 41 pruebas del calificador pasan")

# --- 6. La base de datos debe estar LIMPIA ---------------------------------
## Arrancar el parcial con datos de prueba dentro significa estudiantes marcados
## como «ya entregado» que no podrán entrar. Es el error más caro y el más fácil
## de cometer, porque la base de las pruebas se ve idéntica a la buena.
if (!file.exists(BD)) {
  ok("base de datos limpia (todavía no existe)")
} else {
  con <- dbConnect(SQLite(), BD); on.exit(dbDisconnect(con))
  n <- tryCatch(dbGetQuery(con, "SELECT COUNT(*) AS n FROM sesiones")$n, error = function(e) 0)
  if (n > 0) {
    mal(sprintf("base de datos limpia (tiene %d sesión(es))", n),
        sprintf("mueva %s antes de empezar, o los de prueba bloquearán a los reales", BD))
  } else ok("base de datos limpia")
}

# --- resumen ---------------------------------------------------------------
cat("\n")
if (fallos == 0L && avisos == 0L) {
  cat(verde("  Todo en orden. Se puede abrir el salón.\n\n"))
} else {
  if (avisos) cat(amar(sprintf("  %d aviso(s)\n", avisos)))
  if (fallos) cat(rojo(sprintf("  %d comprobación(es) fallidas: NO abra el parcial así.\n", fallos)))
  cat("\n")
}
quit(status = if (fallos > 0L) 1L else 0L)
