#!/usr/bin/env Rscript
# ============================================================================
# Generador del parcial · Lógica de Programación Financiera
# Universidad Santo Tomás · 2026-II
#
# Produce, para cada estudiante del roster y a partir del banco cloze ya
# existente en `Banco Moodle/rmd/`, tres artefactos:
#
#   salida/examenes/<sid>.json   enunciados. SIN la clave. Va al servidor.
#   salida/claves/<sid>.json     la clave. NUNCA sale de aquí ni del servidor.
#   salida/papel/<sid>.pdf       el mismo examen en papel: el plan B.
#
# El examen se genera EN FRÍO, la noche anterior. La app no compila R/exams
# durante el parcial (ver PLAN_PARCIAL1_APP.md §H1).
#
# Uso:
#   Rscript parcial/generar.R --demo 5              # cinco estudiantes ficticios
#   Rscript parcial/generar.R --roster roster.csv   # el curso real
#   Rscript parcial/generar.R --roster roster.csv --sin-pdf
#   Rscript parcial/generar.R --solo 1020304050     # regenerar a una persona
#
# El roster es un CSV con columnas: cedula,nombre,grupo
# NO se versiona. Contiene datos personales.
# ============================================================================

## --- 0. Locale ------------------------------------------------------------
## R arranca en locale "C" cuando LANG no está en el entorno, y entonces
## readLines() se atraganta con cualquier acento. Un examen entero en español
## saldría con la codificación rota y no se vería hasta abrir el JSON.
## Se corrige aquí y no en la línea de comandos: el guion no puede depender
## de cómo tenga configurada la terminal quien lo ejecute.
if (!isTRUE(l10n_info()$`UTF-8`)) {
  for (loc in c("es_CO.UTF-8", "es_ES.UTF-8", "en_US.UTF-8", "C.UTF-8")) {
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
  }
}
if (!isTRUE(l10n_info()$`UTF-8`)) {
  stop("no hay un locale UTF-8 disponible: los acentos saldrían rotos. ",
       "Exporte LANG=es_ES.UTF-8 antes de ejecutar.", call. = FALSE)
}

suppressPackageStartupMessages({
  library(exams); library(jsonlite); library(digest); library(yaml)
})

verde <- function(x) paste0("\033[32m", x, "\033[0m")
rojo  <- function(x) paste0("\033[31m", x, "\033[0m")
amar  <- function(x) paste0("\033[33m", x, "\033[0m")
gris  <- function(x) paste0("\033[90m", x, "\033[0m")

## --- 1. Opciones ----------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
opcion <- function(nombre, defecto = NULL) {
  i <- match(nombre, args)
  if (is.na(i) || i == length(args)) defecto else args[i + 1L]
}
bandera <- function(nombre) nombre %in% args

## Rscript codifica los espacios de la ruta como "~+~" en --file=
ruta_script <- grep("^--file=", commandArgs(FALSE), value = TRUE)[1]
BASE <- if (!is.na(ruta_script)) {
  normalizePath(dirname(dirname(gsub("~\\+~", " ", sub("^--file=", "", ruta_script)))))
} else getwd()

DIR_RMD  <- file.path(BASE, "Banco Moodle", "rmd")
source(file.path(BASE, "parcial", "trazas.R"))
DIR_OUT  <- opcion("--out", file.path(BASE, "parcial", "salida"))
BLUEPRINT<- opcion("--blueprint", file.path(BASE, "parcial", "blueprint.yml"))
PLANTILLA<- opcion("--plantilla", file.path(BASE, "parcial", "plantilla_papel.tex"))
ROSTER   <- opcion("--roster")
N_DEMO   <- as.integer(opcion("--demo", "0"))
SOLO     <- opcion("--solo")
SIN_PDF  <- bandera("--sin-pdf")

## --- Plantilla del roster --------------------------------------------------
## Se escribe desde aquí y no en la documentación para que el formato no pueda
## divergir de lo que el guion espera leer: el encabezado sale del mismo sitio
## que la validación.
if (bandera("--plantilla-roster")) {
  destino <- opcion("--plantilla-roster", file.path(BASE, "roster.csv"))
  if (file.exists(destino)) {
    stop("ya existe ", destino, ": no se sobrescribe una lista de curso", call. = FALSE)
  }
  writeLines(c(
    "cedula,nombre,grupo",
    "1020304050,Pérez Gómez Ana María,A",
    "1122334455,Rodríguez Díaz Juan Camilo,A"),
    destino, useBytes = TRUE)
  cat("  plantilla escrita en ", destino, "\n", sep = "")
  cat("  - `cedula` admite puntos y espacios: se normaliza a solo dígitos.\n")
  cat("  - `grupo` puede ir vacío; se usa solo para agrupar en el panel.\n")
  cat("  - Guárdelo FUERA del repositorio o déjelo aquí: está en .gitignore.\n")
  cat("  - Borre las dos filas de ejemplo antes de usarlo.\n")
  quit(status = 0L)
}

if (!dir.exists(DIR_RMD)) stop("no encuentro el banco en ", DIR_RMD, call. = FALSE)

## --- 2. El pepper ---------------------------------------------------------
## La app nunca guarda la cédula: guarda HMAC(pepper, cédula). El pepper vive
## en el entorno, no en el repositorio (PLAN §H4).
PEPPER <- Sys.getenv("LPF_PEPPER", "")
if (PEPPER == "") {
  if (N_DEMO > 0L) {
    PEPPER <- "PEPPER-DE-DEMOSTRACION-NO-USAR-EN-EL-PARCIAL"
    cat(amar("⚠ LPF_PEPPER no está definido: usando el pepper de demostración.\n"))
    cat(gris("  Para el parcial real: export LPF_PEPPER=\"$(openssl rand -hex 32)\"\n"))
  } else {
    stop("LPF_PEPPER no está definido. Sin él los identificadores no son secretos.\n",
         "  export LPF_PEPPER=\"$(openssl rand -hex 32)\"   # y guárdelo: sin el mismo ",
         "pepper, nadie podrá entrar", call. = FALSE)
  }
}

## --- 3. Identidad y semillas ---------------------------------------------
## La cédula se teclea de mil maneras: 1.020.304, 1020304, " 1020304 ".
## Si no se normaliza antes de aplicar el hash, el estudiante no entra.
normalizar_cedula <- function(x) gsub("[^0-9]", "", as.character(x))

sid_de <- function(cedula) {
  substr(digest::hmac(PEPPER, normalizar_cedula(cedula), algo = "sha256"), 1L, 16L)
}

## Semillas independientes por propósito, todas derivadas del sid: el mismo
## estudiante recibe siempre el mismo examen, y dos estudiantes nunca el mismo.
##
## La EDICIÓN entra en la semilla y no es un adorno. Sin ella, el simulacro y
## el parcial —mismo estudiante, mismo ejercicio, misma posición— sortean los
## mismos números, y el ensayo general le enseñaría a cada quien las cifras
## exactas de su propio parcial. Cada blueprint declara la suya.
EDICION <- "parcial"
semilla <- function(sid, etiqueta) {
  h <- digest::digest(paste0(sid, "|", EDICION, "|", etiqueta),
                      algo = "sha256", serialize = FALSE)
  strtoi(substr(h, 1L, 7L), 16L)   # < 2^28: cabe en integer sin desbordar
}

## sample() con un vector de longitud 1 sortea sobre 1:x, no sobre x.
muestra <- function(x, k) x[sample.int(length(x), k)]

## --- 4. Blueprint ---------------------------------------------------------
bp <- yaml::read_yaml(BLUEPRINT)
if (is.null(bp$edicion) || !nzchar(bp$edicion)) {
  stop("el blueprint debe declarar `edicion:`. Es lo que impide que el simulacro\n",
       "  y el parcial sorteen las mismas cifras para el mismo estudiante.", call. = FALSE)
}
EDICION <- as.character(bp$edicion)
PUNTOS_TOTALES <- sum(vapply(bp$grupos, function(g) g$elegir * g$puntos, numeric(1))) +
  (if (length(bp$abiertos)) sum(vapply(bp$abiertos, function(a) a$puntos, numeric(1))) else 0) +
  (if (!is.null(bp$trazas)) bp$trazas$elegir * bp$trazas$puntos else 0)

if (!is.null(bp$trazas)) {
  faltan_t <- setdiff(bp$trazas$de, names(TRAZAS))
  if (length(faltan_t)) {
    stop("el blueprint pide trazas que no existen en parcial/trazas.R: ",
         paste(faltan_t, collapse = ", "), call. = FALSE)
  }
}

for (g in bp$grupos) {
  faltan <- setdiff(g$de, sub("\\.Rmd$", "", list.files(file.path(DIR_RMD, g$capitulo))))
  if (length(faltan)) {
    stop("el blueprint pide ejercicios que no están en el banco (", g$capitulo, "): ",
         paste(faltan, collapse = ", "), call. = FALSE)
  }
  if (g$elegir > length(g$de)) {
    stop("el grupo ", g$capitulo, " pide elegir ", g$elegir, " de ", length(g$de),
         " ejercicios", call. = FALSE)
  }
}

## --------------------------------------------------------------------------
## La traza en LaTeX, para el examen en papel.
##
## R/exams solo sabe del banco `.Rmd`, así que el PDF que genera NO incluye las
## trazas: el respaldo en papel se quedaría quince puntos corto y el plan B
## dejaría de ser el mismo examen. Se inyecta a mano en el `.tex` que deja
## `exams2pdf` y se recompila.
## --------------------------------------------------------------------------
html_a_latex <- function(html) {
  tmp <- tempfile(fileext = ".html"); on.exit(unlink(tmp))
  writeLines(html, tmp, useBytes = TRUE)
  paste(system2("pandoc", c("-f", "html", "-t", "latex", shQuote(tmp)),
                stdout = TRUE), collapse = "\n")
}

escapar_tex <- function(x) {
  x <- as.character(x)
  x <- gsub("\\", "\\textbackslash{}", x, fixed = TRUE)
  for (c in c("&", "%", "$", "#", "_", "{", "}")) x <- gsub(c, paste0("\\", c), x, fixed = TRUE)
  x <- gsub("~", "\\textasciitilde{}", x, fixed = TRUE)
  x <- gsub("^", "\\textasciicircum{}", x, fixed = TRUE)
  x
}

traza_a_latex <- function(tz) {
  ocultas <- vapply(tz$celdas, function(c) paste0(c$fila, "|", c$columna), "")
  cols <- vapply(tz$columnas, function(c) c$clave, "")
  align <- paste(c("c", "l", rep("c", length(cols) - 2L)), collapse = "|")

  cabecera <- paste(vapply(tz$columnas, function(c) paste0("\\textbf{", escapar_tex(c$titulo), "}"), ""),
                    collapse = " & ")
  filas <- vapply(seq_along(tz$filas), function(fi) {
    fila <- tz$filas[[fi]]
    celdas <- vapply(cols, function(cl) {
      if (paste0(fi, "|", cl) %in% ocultas) return("\\rule{0pt}{2.6ex}\\rule{2.2cm}{0.4pt}")
      v <- fila[[cl]]
      v <- if (is.null(v) || is.na(v)) "" else as.character(v)
      if (identical(cl, "instruccion")) paste0("\\texttt{\\small ", escapar_tex(v), "}")
      else escapar_tex(v)
    }, "")
    paste(paste(celdas, collapse = " & "), "\\\\")
  }, "")

  paste0(
    "\n\\begin{question}\n\\textbf{", escapar_tex(tz$titulo), "}\\newline\n",
    html_a_latex(tz$enunciado), "\n\n",
    "\\begin{verbatim}\n", tz$codigo$pseudo, "\n\\end{verbatim}\n\n",
    "\\noindent\\begin{tabular}{|", align, "|}\n\\hline\n",
    cabecera, " \\\\\n\\hline\n",
    paste(filas, collapse = "\n"), "\n\\hline\n\\end{tabular}\n",
    "\n\\vspace{0.4em}\n\\noindent{\\small Escriba --- si la variable todavía no tiene valor.}\n",
    "\\end{question}\n")
}

## Markdown → HTML para los ítems abiertos, con el mismo pandoc que usa R/exams.
md_a_html <- function(md) {
  tmp <- tempfile(fileext = ".md"); on.exit(unlink(tmp))
  writeLines(md, tmp, useBytes = TRUE)
  paste(system2("pandoc", c("-f", "markdown", "-t", "html", shQuote(tmp)),
                stdout = TRUE), collapse = "\n")
}

## --- 5. Roster ------------------------------------------------------------
if (!is.null(ROSTER)) {
  roster <- read.csv(ROSTER, colClasses = "character", encoding = "UTF-8")
  obligatorias <- c("cedula", "nombre")
  if (!all(obligatorias %in% names(roster))) {
    stop("el roster necesita las columnas: ", paste(obligatorias, collapse = ", "),
         call. = FALSE)
  }
  if (is.null(roster$grupo)) roster$grupo <- ""
} else if (N_DEMO > 0L) {
  roster <- data.frame(
    cedula = sprintf("10%08d", seq_len(N_DEMO)),
    nombre = sprintf("Estudiante de prueba %02d", seq_len(N_DEMO)),
    grupo  = "DEMO", stringsAsFactors = FALSE)
} else {
  stop("indique --roster archivo.csv o --demo N", call. = FALSE)
}

if (!is.null(SOLO)) {
  roster <- roster[normalizar_cedula(roster$cedula) == normalizar_cedula(SOLO), , drop = FALSE]
  if (!nrow(roster)) stop("esa cédula no está en el roster", call. = FALSE)
}

## Dos cédulas que se normalizan al mismo número serían la misma persona para
## el sistema: la segunda sobrescribiría el examen de la primera.
dup <- normalizar_cedula(roster$cedula)[duplicated(normalizar_cedula(roster$cedula))]
if (length(dup)) stop("cédulas repetidas en el roster: ", paste(unique(dup), collapse = ", "),
                      call. = FALSE)
vacias <- which(normalizar_cedula(roster$cedula) == "")
if (length(vacias)) stop("hay filas sin cédula: ", paste(vacias, collapse = ", "), call. = FALSE)

## --- 6. Preparar salida ---------------------------------------------------
for (d in c("examenes", "claves", "papel")) {
  dir.create(file.path(DIR_OUT, d), recursive = TRUE, showWarnings = FALSE)
}

## Huella del pepper.
##
## Si el día del parcial la app arranca con un pepper distinto del que generó
## los exámenes, calcula identificadores distintos y NO ENTRA NADIE — y todo lo
## demás se ve perfectamente normal: los archivos están, la app responde, el
## código del día funciona. Es el fallo más difícil de diagnosticar con el
## salón lleno. Se deja aquí el sha256 del pepper (no el pepper) para que
## `comprobar.R` pueda cotejarlo antes de abrir la puerta.
writeLines(digest::digest(PEPPER, algo = "sha256", serialize = FALSE),
           file.path(DIR_OUT, "huella_pepper.txt"))

trafo <- make_exercise_transform_html(converter = "pandoc", base64 = TRUE)

## --- 7. Trocear el cloze --------------------------------------------------
## `questionlist` llega plano: una entrada por sub-ítem num/string y UNA POR
## OPCIÓN en los schoice/mchoice. Hay que devolverle la estructura usando
## `clozetype` y la longitud de cada solución — la misma regla que valida
## `Banco Moodle/compilar_banco.R`.
trocear <- function(e) {
  tipos <- e$metainfo$clozetype
  sols  <- e$metainfo$solution
  tols  <- suppressWarnings(as.numeric(unlist(e$metainfo$tolerance)))
  if (length(tols) != length(tipos)) tols <- rep(0, length(tipos))
  ql <- e$questionlist
  sl <- if (length(e$solutionlist)) e$solutionlist else rep("", length(ql))

  pos <- 1L
  lapply(seq_along(tipos), function(k) {
    n <- if (tipos[k] %in% c("schoice", "mchoice")) length(sols[[k]]) else 1L
    idx <- seq(pos, length.out = n); pos <<- pos + n
    list(tipo = tipos[k], textos = ql[idx], retro = sl[idx],
         sol = sols[[k]], tol = tols[k])
  })
}

## --- 8. Generar ------------------------------------------------------------
cat(sprintf("\n%s · %s\n", bp$titulo, bp$subtitulo))
cat(gris(sprintf("edición: %s | estudiantes: %d | puntos: %g\n", EDICION,
                 nrow(roster), PUNTOS_TOTALES)))
cat(gris(sprintf("salida: %s\n\n", DIR_OUT)))

manifiesto <- list()
fallos <- character(0)
divergencias <- character(0)
comparados <- 0L   # cuántas veces se pudo COMPARAR de verdad papel contra pantalla

for (i in seq_len(nrow(roster))) {
  cedula <- roster$cedula[i]; nombre <- roster$nombre[i]
  sid <- sid_de(cedula)

  ## Selección: sorteada por estudiante, pero en orden de capítulo.
  set.seed(semilla(sid, "seleccion"))
  elegidos <- do.call(rbind, lapply(bp$grupos, function(g) {
    data.frame(capitulo = g$capitulo, nombre = muestra(g$de, g$elegir),
               puntos = g$puntos, stringsAsFactors = FALSE)
  }))
  rutas <- file.path(DIR_RMD, elegidos$capitulo, paste0(elegidos$nombre, ".Rmd"))

  ## Una semilla por ejercicio. Es lo que hace que la pasada de HTML y la de
  ## PDF sorteen exactamente los mismos números: no coinciden por suerte,
  ## coinciden por construcción.
  seed_mat <- matrix(vapply(seq_along(rutas),
                            function(j) semilla(sid, paste0("ejercicio", j)),
                            integer(1)), nrow = 1L)

  ex <- tryCatch(
    xexams(rutas, n = 1L, seed = seed_mat,
           driver = list(sweave = NULL, read = NULL, transform = trafo, write = NULL),
           dir = tempfile("xex"), verbose = FALSE),
    error = function(e) { fallos <<- c(fallos, sprintf("%s: %s", nombre, conditionMessage(e))); NULL })
  if (is.null(ex)) { cat(rojo(sprintf("  ✗ %-28s falló la compilación\n", nombre))); next }

  ejercicios <- list(); clave_ej <- list(); pts_acum <- 0

  for (j in seq_along(ex[[1]])) {
    e <- ex[[1]][[j]]
    subs <- trocear(e)
    eid <- sprintf("e%d", j)
    pts_ej <- elegidos$puntos[j]
    ## Reparto de puntos entre sub-ítems; el último absorbe el redondeo para
    ## que la suma del examen sea exactamente la declarada en el blueprint.
    pts <- rep(round(pts_ej / length(subs), 2), length(subs))
    pts[length(pts)] <- round(pts_ej - sum(pts[-length(pts)]), 2)

    items <- list(); clave_it <- list()
    for (k in seq_along(subs)) {
      s <- subs[[k]]; iid <- sprintf("%s_%d", eid, k)
      if (s$tipo %in% c("schoice", "mchoice")) {
        ## Barajado por estudiante: cierra el H10 del capítulo 3 —la clave
        ## que siempre caía en la misma letra— por construcción.
        set.seed(semilla(sid, paste0("baraja", j, "_", k)))
        p <- sample.int(length(s$sol))
        items[[k]] <- list(id = iid, tipo = s$tipo, etiqueta = "",
                           opciones = I(unname(s$textos[p])),
                           multiple = identical(s$tipo, "mchoice"), puntos = pts[k])
        clave_it[[k]] <- list(id = iid, tipo = s$tipo, sol = I(unname(s$sol[p])),
                              perm = I(p), retro = I(unname(s$retro[p])),
                              tol = 0, puntos = pts[k])
      } else {
        items[[k]] <- list(id = iid, tipo = s$tipo, etiqueta = unname(s$textos[1]),
                           opciones = I(character(0)), multiple = FALSE, puntos = pts[k])
        clave_it[[k]] <- list(id = iid, tipo = s$tipo, sol = I(unname(s$sol)),
                              perm = I(integer(0)), retro = I(unname(s$retro[1])),
                              tol = s$tol, puntos = pts[k])
      }
    }

    ejercicios[[j]] <- list(id = eid, capitulo = elegidos$capitulo[j],
                            nombre = e$metainfo$name,
                            enunciado = paste(e$question, collapse = "\n"),
                            puntos = pts_ej, items = items)
    clave_ej[[j]]  <- list(id = eid, nombre = e$metainfo$name,
                           solucion = paste(e$solution, collapse = "\n"),
                           items = clave_it)
    pts_acum <- pts_acum + pts_ej
  }

  ## --- Trazas (E1) ---------------------------------------------------------
  ## Se generan aquí, no en R/exams: la prueba de escritorio necesita una tabla
  ## estructurada —columnas, filas y qué celda se oculta— que el formato cloze
  ## no sabe expresar.
  trazas <- list(); clave_tr <- list()
  if (!is.null(bp$trazas) && bp$trazas$elegir > 0) {
    set.seed(semilla(sid, "seleccion_traza"))
    elegidas <- muestra(bp$trazas$de, bp$trazas$elegir)
    for (k in seq_along(elegidas)) {
      tz <- TRAZAS[[elegidas[k]]](semilla(sid, paste0("traza", k)))
      tid <- sprintf("t%d", k)
      celdas <- list(); clave_celdas <- list()
      ## Las filas que van al navegador llevan la celda oculta VACÍA: la
      ## respuesta se queda aquí. Ver PLAN §H9.
      filas_visibles <- tz$filas
      ## De `ocultas_desde` salen todas las celdas de la columna a partir de
      ## la fila indicada. La primera de cada columna es el ORIGEN; las
      ## siguientes se marcan con `arrastre` apuntando a ella.
      ##
      ## `ic` y no `i`: `i` es la variable del bucle de ESTUDIANTES, unas
      ## cuantas decenas de líneas más arriba. Reutilizarla hacía que todos
      ## escribieran en la misma fila del manifiesto y solo sobreviviera el
      ## último. No daba ningún error.
      ic <- 0L
      for (col in names(tz$ocultas_desde)) {
        desde <- tz$ocultas_desde[[col]]
        origen <- NULL
        for (fi in seq(desde, length(tz$filas))) {
          ic <- ic + 1L
          iid <- sprintf("%s_%d_%s", tid, fi, col)
          sol <- tz$filas[[fi]][[col]]
          filas_visibles[[fi]][[col]] <- NA
          celdas[[ic]] <- list(id = iid, fila = fi, columna = col)
          clave_celdas[[ic]] <- list(id = iid, tipo = "celda", sol = I(sol),
                                     tol = tz$tolerancia,
                                     arrastre = if (is.null(origen)) NULL else origen)
          if (is.null(origen)) origen <- iid
        }
      }
      ## Los puntos se reparten al final, cuando ya se sabe cuántas celdas hay.
      pts_celda <- round(bp$trazas$puntos / ic, 2)
      for (n in seq_len(ic)) {
        pts <- if (n == ic) round(bp$trazas$puntos - pts_celda * (ic - 1), 2) else pts_celda
        celdas[[n]]$puntos <- pts
        clave_celdas[[n]]$puntos <- pts
      }
      trazas[[k]] <- list(id = tid, nombre = tz$nombre, titulo = tz$titulo,
                          enunciado = tz$enunciado, codigo = tz$codigo,
                          columnas = tz$columnas, filas = filas_visibles,
                          puntos = bp$trazas$puntos, celdas = celdas)
      clave_tr[[k]] <- list(id = tid, nombre = tz$nombre, items = clave_celdas)
      pts_acum <- pts_acum + bp$trazas$puntos
    }
  }

  ## Ítems abiertos: se recogen como texto y se califican a mano (PLAN §H5).
  abiertos <- list(); clave_ab <- list()
  if (length(bp$abiertos)) for (a in seq_along(bp$abiertos)) {
    ab <- bp$abiertos[[a]]
    abiertos[[a]] <- list(id = ab$id, enunciado = md_a_html(ab$enunciado), puntos = ab$puntos)
    clave_ab[[a]] <- list(id = ab$id, puntos = ab$puntos, rubrica = I(unlist(ab$rubrica)))
    pts_acum <- pts_acum + ab$puntos
  }

  write_json(list(
    sid = sid, version = 1L, edicion = EDICION,
    titulo = bp$titulo, subtitulo = bp$subtitulo,
    periodo = bp$periodo, minutos = bp$minutos,
    gracia_segundos = if (is.null(bp$gracia_segundos)) 30L else bp$gracia_segundos,
    nota_maxima = bp$nota_maxima, puntos_totales = pts_acum,
    ejercicios = ejercicios, trazas = trazas, abiertos = abiertos
  ), file.path(DIR_OUT, "examenes", paste0(sid, ".json")),
  auto_unbox = TRUE, pretty = TRUE, null = "null")

  write_json(list(
    sid = sid, version = 1L, edicion = EDICION,
    puntos_totales = pts_acum, nota_maxima = bp$nota_maxima,
    ejercicios = clave_ej, trazas = clave_tr, abiertos = clave_ab
  ), file.path(DIR_OUT, "claves", paste0(sid, ".json")),
  auto_unbox = TRUE, pretty = TRUE, null = "null", digits = NA)

  ## --- PDF de respaldo, del mismo sorteo -----------------------------------
  estado_pdf <- "—"
  if (!SIN_PDF) {
    pdf_ok <- tryCatch({
      texdir <- tempfile("tex"); dir.create(texdir)
      ex_pdf <- exams2pdf(rutas, n = 1L, seed = seed_mat, dir = file.path(DIR_OUT, "papel"),
                          name = sid, template = PLANTILLA, encoding = "UTF-8",
                          header = list(Estudiante = nombre, Identificador = sid,
                                        Minutos = bp$minutos),
                          texdir = texdir, quiet = TRUE, verbose = FALSE)

      ## Se añaden las trazas al .tex ya generado y se recompila, para que el
      ## papel lleve exactamente los mismos ejercicios que la pantalla.
      if (length(trazas)) {
        ftex <- file.path(texdir, paste0(sid, "1.tex"))
        if (file.exists(ftex)) {
          tex <- readLines(ftex, warn = FALSE, encoding = "UTF-8")
          corte <- tail(grep("^\\\\end\\{enumerate\\}", tex), 1)
          if (length(corte)) {
            extra <- unlist(lapply(trazas, traza_a_latex))
            tex <- append(tex, unlist(strsplit(paste(extra, collapse = "\n"), "\n")), after = corte - 1L)
            writeLines(tex, ftex, useBytes = TRUE)
            wd <- getwd(); setwd(texdir)
            ok2 <- tryCatch({
              system2("pdflatex", c("-interaction=nonstopmode", shQuote(basename(ftex))),
                      stdout = FALSE, stderr = FALSE)
              file.exists(sub("[.]tex$", ".pdf", basename(ftex)))
            }, error = function(e) FALSE)
            setwd(wd)
            if (ok2) file.copy(file.path(texdir, paste0(sid, "1.pdf")),
                               file.path(DIR_OUT, "papel", paste0(sid, "1.pdf")), overwrite = TRUE)
            else fallos <<- c(fallos, sprintf("%s: la traza no compiló en el PDF", nombre))
          }
        }
      }
      ## La comprobación que exige el plan: si el papel y la pantalla no traen
      ## los mismos números, el plan B es inservible.
      a <- unlist(lapply(ex[[1]],     function(z) as.character(unlist(z$metainfo$solution))))
      b <- unlist(lapply(ex_pdf[[1]], function(z) as.character(unlist(z$metainfo$solution))))
      comparados <<- comparados + 1L
      if (!identical(a, b)) {
        divergencias <<- c(divergencias, nombre); "DIVERGE"
      } else "ok"
    }, error = function(e) {
      fallos <<- c(fallos, sprintf("%s (pdf): %s", nombre, conditionMessage(e))); "error"
    })
    estado_pdf <- pdf_ok
  }

  manifiesto[[i]] <- data.frame(
    sid = sid, nombre = nombre, grupo = roster$grupo[i],
    ejercicios = paste(c(elegidos$nombre,
                         vapply(trazas, function(z) paste0("traza:", z$nombre), "")),
                       collapse = ";"),
    puntos = pts_acum, pdf = estado_pdf, stringsAsFactors = FALSE)

  marca <- if (identical(estado_pdf, "DIVERGE")) rojo("✗") else verde("✓")
  cat(sprintf("  %s %-28s %s  %s\n", marca, substr(nombre, 1, 28), gris(sid),
              gris(paste(elegidos$nombre, collapse = ", "))))
}

## --- 9. Manifiesto y resumen ---------------------------------------------
if (length(manifiesto)) {
  man <- do.call(rbind, manifiesto)
  ## Si el manifiesto no tiene una fila por estudiante generado, algo se
  ## sobrescribió. Pasó —por reutilizar la variable de un bucle— y no dio
  ## ningún error: simplemente faltaban estudiantes.
  if (nrow(man) != length(manifiesto) || nrow(man) != nrow(roster) - length(fallos)) {
    stop(sprintf("el manifiesto tiene %d filas y se generaron %d exámenes: algo se sobrescribió",
                 nrow(man), nrow(roster) - length(fallos)), call. = FALSE)
  }
  ## Contiene nombres: se queda en su máquina. No se sube al servidor ni al repo.
  write.csv(man, file.path(DIR_OUT, "manifiesto.csv"), row.names = FALSE, fileEncoding = "UTF-8")
}

cat("\n")
cat(sprintf("  exámenes generados : %d\n", length(manifiesto)))
cat(sprintf("  puntos por examen  : %g  (nota máxima %g)\n", PUNTOS_TOTALES, bp$nota_maxima))
if (!SIN_PDF) {
  cat(sprintf("  papel comprobado   : %d de %d\n", comparados, length(manifiesto)))
  if (length(divergencias)) {
    cat(rojo(sprintf("  ✗ el PDF NO coincide con el JSON en: %s\n", paste(divergencias, collapse = ", "))))
    cat(rojo("    El respaldo en papel es inservible mientras esto no se resuelva.\n"))
  } else if (comparados == 0L) {
    cat(rojo("  ✗ no se pudo comparar ni un solo PDF: no hay respaldo en papel\n"))
  } else if (comparados < length(manifiesto)) {
    cat(amar(sprintf("  ⚠ %d examen(es) sin PDF: esos estudiantes no tienen plan B\n",
                     length(manifiesto) - comparados)))
  } else {
    cat(verde(sprintf("  ✓ el PDF coincide con el JSON en los %d casos comprobados\n", comparados)))
  }
}
if (length(fallos)) {
  cat(rojo(sprintf("  ✗ %d fallo(s):\n", length(fallos))))
  for (f in fallos) cat(rojo(paste0("    - ", f, "\n")))
}
cat(gris(sprintf("\n  al servidor: %s/{examenes,claves}\n", DIR_OUT)))
cat(gris(sprintf("  se queda aquí: %s/{papel,manifiesto.csv}\n\n", DIR_OUT)))

if (length(fallos) || length(divergencias)) quit(status = 1L)
