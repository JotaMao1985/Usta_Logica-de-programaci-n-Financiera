#!/usr/bin/env Rscript
# ============================================================================
# Vendorización de los recursos externos · app del parcial
#
# `lp-base.html` carga 23 archivos de seis dominios distintos (unpkg, jsdelivr,
# cdnjs, cdn.tailwindcss.com, cdn.plot.ly y Google Fonts). En una sala de
# cómputo institucional eso son seis puntos de fallo que el docente no controla:
# basta que el proxy bloquee uno para que el examen no se pinte.
#
# Este guion los descarga a `parcial/app/www/vendor/`, sigue las referencias
# `url(...)` que hay DENTRO de los CSS —las tipografías, que son las que se
# olvidan— y deja escrita la cabecera lista para incrustar.
#
# Uso:
#   Rscript parcial/vendorizar.R
#   Rscript parcial/vendorizar.R --verificar   # no descarga: solo comprueba
# ============================================================================

if (!isTRUE(l10n_info()$`UTF-8`)) {
  for (loc in c("es_CO.UTF-8", "es_ES.UTF-8", "en_US.UTF-8", "C.UTF-8"))
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
}
suppressPackageStartupMessages(library(jsonlite))

verde <- function(x) paste0("\033[32m", x, "\033[0m")
rojo  <- function(x) paste0("\033[31m", x, "\033[0m")
amar  <- function(x) paste0("\033[33m", x, "\033[0m")
gris  <- function(x) paste0("\033[90m", x, "\033[0m")

ruta_script <- grep("^--file=", commandArgs(FALSE), value = TRUE)[1]
BASE <- if (!is.na(ruta_script))
  normalizePath(dirname(dirname(gsub("~\\+~", " ", sub("^--file=", "", ruta_script))))) else getwd()

FUENTE <- file.path(BASE, "Material html", "_plantilla", "lp-base.html")
DESTINO<- file.path(BASE, "parcial", "app", "www", "vendor")
VERIF  <- "--verificar" %in% commandArgs(TRUE)

## Un navegador moderno en la cabecera: Google Fonts devuelve TTF en vez de
## woff2 si el User-Agent le parece antiguo, y se descargarían 4 veces más
## bytes de los necesarios.
UA <- paste("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7)",
            "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36")

# ---------------------------------------------------------------------------
# Qué necesita la PÁGINA DEL EXAMEN. No es lo mismo que lo que necesita el
# material: el examen no dibuja gráficas ni resalta SQL, y Plotly solo pesa
# 3,5 MB por estudiante que se descargarían en el peor momento posible —los
# primeros minutos, con todo el curso conectándose a la vez—.
# ---------------------------------------------------------------------------
necesario <- function(url) {
  if (grepl("plot\\.ly", url)) return(FALSE)
  if (grepl("prism/1[.]29[.]0/components/prism-(bash|docker|json|sql|toml|yaml)", url)) return(FALSE)
  TRUE
}

## El nombre local DEBE conservar la cadena de consulta. Los dos CSS de Google
## Fonts solo se distinguen por ella —`?family=Montserrat...` y
## `?family=Fira+Code...`—: al recortarla, ambos caían en el mismo archivo y el
## segundo se daba por descargado. El resultado habría sido el examen entero
## con la tipografía monoespaciada del código sin cargar, y sin ningún error
## visible que lo delatara.
nombre_local <- function(url, tipo = NULL) {
  u <- gsub("[^A-Za-z0-9._-]", "_", sub("^https?://", "", url))
  ## Y la extensión debe corresponder al tipo: el paso que reescribe las
  ## referencias internas busca hojas de estilo, y `fonts.googleapis.com_css2`
  ## no lo parecía, así que sus tipografías se quedaron apuntando a internet.
  if (!is.null(tipo)) {
    ext <- if (identical(tipo, "css")) ".css" else ".js"
    if (!grepl(paste0("\\", ext, "$"), u)) u <- paste0(u, ext)
  }
  u
}

descargar <- function(url, destino) {
  if (file.exists(destino) && file.size(destino) > 0) return("cache")
  r <- tryCatch({
    suppressWarnings(utils::download.file(url, destino, quiet = TRUE, mode = "wb",
                                          headers = c("User-Agent" = UA)))
    if (file.exists(destino) && file.size(destino) > 0) "ok" else "vacío"
  }, error = function(e) paste("error:", conditionMessage(e)))
  r
}

# --- 1. Qué carga la plantilla -------------------------------------------
if (!file.exists(FUENTE)) stop("no encuentro ", FUENTE, call. = FALSE)
html <- paste(readLines(FUENTE, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

## Se distingue href= de src= para saber qué es hoja de estilo y qué es guion:
## la extensión del URL no basta (Google Fonts sirve CSS desde `/css2?...`).
hrefs <- unique(unlist(regmatches(html, gregexpr('(?<=href=")https?://[^"]+', html, perl = TRUE))))
srcs  <- unique(unlist(regmatches(html, gregexpr('(?<=src=")https?://[^"]+',  html, perl = TRUE))))
## Los `preconnect` a fonts.googleapis.com / gstatic.com son pistas, no archivos.
hrefs <- hrefs[!grepl("^https?://fonts\\.(googleapis|gstatic)\\.com/?$", hrefs)]
urls  <- c(hrefs, srcs)
tipos <- c(rep("css", length(hrefs)), rep("js", length(srcs)))
names(tipos) <- urls

cat(sprintf("\n  recursos externos en lp-base.html: %s\n", length(urls)))
dominios <- unique(sub("^https?://([^/]+).*$", "\\1", urls))
cat(gris(sprintf("  dominios: %s\n\n", paste(dominios, collapse = ", "))))

if (VERIF) {
  ## Solo se exige lo que la página del examen carga: Plotly y los Prism que
  ## no se usan quedan fuera del repositorio a propósito y su ausencia no es
  ## un fallo (ver .gitignore).
  exigidos <- urls[vapply(urls, necesario, TRUE)]
  faltan <- exigidos[!file.exists(file.path(DESTINO,
              vapply(exigidos, function(u) nombre_local(u, tipos[[u]]), "")))]
  if (length(faltan)) {
    cat(rojo(sprintf("  ✗ faltan %d recursos por vendorizar\n", length(faltan))))
    for (f in faltan) cat(rojo(paste0("    - ", f, "\n")))
    quit(status = 1L)
  }
  cat(verde(sprintf("  ✓ los %d recursos que carga el examen están vendorizados\n\n",
                    length(exigidos)))); quit(status = 0L)
}

dir.create(DESTINO, recursive = TRUE, showWarnings = FALSE)

# --- 2. Descargar ---------------------------------------------------------
mapa <- list(); fallos <- character(0)
for (u in urls) {
  local <- nombre_local(u, tipos[[u]])
  r <- descargar(u, file.path(DESTINO, local))
  usa <- necesario(u)
  if (r %in% c("ok", "cache")) {
    kb <- file.size(file.path(DESTINO, local)) / 1024
    mapa[[u]] <- list(url = u, local = local, tipo = tipos[[u]], kb = round(kb, 1), examen = usa)
    cat(sprintf("  %s %7.1f KB  %s%s\n", if (r == "cache") gris("·") else verde("↓"), kb,
                gris(sub("^https?://", "", u)),
                if (!usa) amar("  (no se carga en el examen)") else ""))
  } else {
    fallos <- c(fallos, sprintf("%s → %s", u, r))
    cat(rojo(sprintf("  ✗          %s  (%s)\n", sub("^https?://", "", u), r)))
  }
}

# --- 3. Seguir las referencias dentro de los CSS --------------------------
## Font Awesome pide sus `../webfonts/*.woff2` y Google Fonts sus archivos en
## fonts.gstatic.com. Si solo se baja el CSS, la página carga pero sin iconos
## ni tipografías, y encima intenta salir a internet igual.
cat(gris("\n  siguiendo las referencias dentro de los CSS...\n"))
sub_total <- 0L
for (m in mapa) {
  if (!identical(m$tipo, "css")) next
  ruta <- file.path(DESTINO, m$local)
  css  <- paste(readLines(ruta, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  refs <- unique(unlist(regmatches(css, gregexpr("url\\(([^)]+)\\)", css))))
  cambios <- 0L
  for (ref in refs) {
    dentro <- gsub("^url\\(|\\)$|[\"']", "", ref)
    if (grepl("^data:", dentro)) next
    abs <- if (grepl("^https?://", dentro)) dentro
           else if (grepl("^//", dentro)) paste0("https:", dentro)
           else {
             raiz <- sub("/[^/]*$", "", m$url)
             normalizar <- function(p) { while (grepl("/[^/]+/\\.\\./", p)) p <- sub("/[^/]+/\\.\\./", "/", p); p }
             normalizar(paste0(raiz, "/", dentro))
           }
    hijo <- nombre_local(abs)
    r <- descargar(abs, file.path(DESTINO, hijo))
    if (r %in% c("ok", "cache")) {
      css <- gsub(ref, sprintf("url(%s)", hijo), css, fixed = TRUE)
      cambios <- cambios + 1L; sub_total <- sub_total + 1L
    } else fallos <- c(fallos, sprintf("%s (dentro de %s) → %s", abs, m$local, r))
  }
  if (cambios) {
    writeLines(css, ruta, useBytes = TRUE)
    cat(sprintf("    %s %2d referencia(s) reescritas en %s\n", verde("✓"), cambios, gris(m$local)))
  }
}

# --- 4. Cabecera lista para incrustar -------------------------------------
orden <- urls[urls %in% names(mapa)]
lineas <- c('<!-- Generado por parcial/vendorizar.R. No editar a mano. -->',
            '<!-- Todo local: la página del examen no sale a internet. -->')
for (u in orden) {
  m <- mapa[[u]]; if (!m$examen) next
  lineas <- c(lineas, if (identical(m$tipo, "css"))
    sprintf('<link rel="stylesheet" href="vendor/%s">', m$local)
  else sprintf('<script src="vendor/%s"></script>', m$local))
}
writeLines(lineas, file.path(DESTINO, "cabecera.html"), useBytes = TRUE)
write_json(unname(mapa), file.path(DESTINO, "manifiesto.json"), auto_unbox = TRUE, pretty = TRUE)

# --- 5. Resumen ------------------------------------------------------------
kb_todo <- sum(vapply(mapa, function(m) m$kb, 0))
kb_exam <- sum(vapply(Filter(function(m) m$examen, mapa), function(m) m$kb, 0))
kb_sub  <- sum(file.size(list.files(DESTINO, full.names = TRUE))) / 1024 - kb_todo

colgando <- character(0)
for (m in mapa) {
  if (!identical(m$tipo, "css")) next
  css <- paste(readLines(file.path(DESTINO, m$local), warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  quedan <- unlist(regmatches(css, gregexpr("url\\((\"|')?https?://[^)]+\\)", css)))
  if (length(quedan)) colgando <- c(colgando, sprintf("%s → %s", m$local, paste(quedan, collapse = ", ")))
}

cat("\n")
cat(sprintf("  archivos principales : %d  (%.1f MB)\n", length(mapa), kb_todo / 1024))
cat(sprintf("  archivos referidos   : %d  (%.1f MB)\n", sub_total, max(0, kb_sub) / 1024))
cat(sprintf("  %s\n", verde(sprintf("carga del examen     : %.1f MB por estudiante", kb_exam / 1024))))
cat(gris(sprintf("  ahorro por no cargar Plotly y los Prism que no se usan: %.1f MB\n",
                 (kb_todo - kb_exam) / 1024)))
if (length(colgando)) {
  cat(rojo("\n  ✗ hay CSS que siguen apuntando a internet:\n"))
  for (c in colgando) cat(rojo(paste0("    - ", c, "\n")))
  fallos <- c(fallos, colgando)
} else {
  cat(verde("  ✓ ningún CSS queda apuntando a internet\n"))
}
if (length(fallos)) {
  cat(rojo(sprintf("\n  ✗ %d recurso(s) no se pudieron traer:\n", length(fallos))))
  for (f in fallos) cat(rojo(paste0("    - ", f, "\n")))
  cat(rojo("    Sin ellos la página del examen depende de internet.\n\n"))
  quit(status = 1L)
}
cat(gris(sprintf("\n  cabecera: %s\n\n", file.path(DESTINO, "cabecera.html"))))
