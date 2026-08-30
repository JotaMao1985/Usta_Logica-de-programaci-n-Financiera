#!/usr/bin/env Rscript
# ============================================================================
# Calificador del parcial · Lógica de Programación Financiera
#
# Una sola función decide la nota, y la usan los dos sitios que califican:
# la app al cerrar el examen y la exportación al LMS. Si hubiera dos
# implementaciones, tarde o temprano darían notas distintas y el reclamo
# tendría razón.
#
# El puntaje NO se reinventa: lo calcula `exams_eval()` con la misma
# configuración que usa `exams2moodle` —crédito parcial, sin negativos, regla
# "false2"—, de modo que la nota de la app es la que habría dado Moodle
# (ver PLAN_PARCIAL1_APP.md §H3).
#
# Uso:
#   source("parcial/calificar.R")            # desde la app
#   Rscript parcial/calificar.R --pruebas    # batería de pruebas
# ============================================================================

suppressPackageStartupMessages(library(exams))

EVAL <- exams_eval(partial = TRUE, negative = FALSE, rule = "false2")

# ---------------------------------------------------------------------------
# Lectura de un número tecleado por un estudiante colombiano.
#
# "10.368.000", "10368000", "10,5" y "1.234,56" son todas escrituras legítimas
# de la misma persona bajo presión. `as.numeric()` devuelve NA en la mitad de
# ellas, y una respuesta correcta marcada como NA es un reclamo garantizado.
#
# Reglas, en orden:
#   1. Si aparecen los dos signos, el de más a la derecha es el decimal.
#   2. Si aparece uno solo y más de una vez, son separadores de miles.
#   3. Si aparece uno solo y una vez:
#        - si deja exactamente tres dígitos a la derecha, es AMBIGUO
#          ("1.500" puede ser mil quinientos o uno coma cinco) y se devuelven
#          las dos lecturas: que decida la tolerancia;
#        - en cualquier otro caso es separador decimal ("10.5" es 10,5 y no 105).
#
# Devuelve todas las lecturas plausibles. `calificar_item` acepta si CUALQUIERA
# cae dentro de la tolerancia, y deja constancia de cuál se usó.
# ---------------------------------------------------------------------------
interpretar_numero <- function(texto) {
  if (is.null(texto) || length(texto) == 0L) return(numeric(0))
  x <- trimws(as.character(texto)[1])
  if (is.na(x) || x == "") return(numeric(0))

  x <- gsub("[[:space:] ]", "", x)     # espacios, incluido el duro
  x <- gsub("[^0-9.,+-]", "", x)            # $ % letras: fuera
  x <- sub("^\\+", "", x)
  if (!grepl("[0-9]", x)) return(numeric(0))

  negativo <- grepl("^-", x)
  x <- sub("^-", "", x)
  signo <- if (negativo) -1 else 1

  n_pun <- lengths(regmatches(x, gregexpr("\\.", x)))
  n_com <- lengths(regmatches(x, gregexpr(",",  x)))

  cand <- if (n_pun > 0L && n_com > 0L) {
    ## 1. el de más a la derecha manda
    if (max(gregexpr("\\.", x)[[1]]) > max(gregexpr(",", x)[[1]])) {
      gsub(",", "", x)                                   # el punto es el decimal
    } else {
      ## Primero se quitan los miles y DESPUÉS se convierte el decimal: al
      ## revés, el gsub de los puntos se comía el punto recién creado y
      ## "1.234,56" salía como 123456.
      sub(",", ".", gsub("\\.", "", x), fixed = TRUE)
    }
  } else if (n_pun + n_com == 0L) {
    x
  } else {
    sep   <- if (n_pun > 0L) "." else ","
    veces <- n_pun + n_com
    cola  <- sub(paste0("^.*\\", sep), "", x)
    if (veces > 1L) {
      ## 2. varios separadores iguales: miles
      gsub(paste0("\\", sep), "", x)
    } else if (nchar(cola) == 3L) {
      ## 3a. ambiguo: las dos lecturas
      c(gsub(paste0("\\", sep), "", x), sub(paste0("\\", sep), ".", x))
    } else {
      ## 3b. decimal
      sub(paste0("\\", sep), ".", x)
    }
  }

  v <- suppressWarnings(as.numeric(cand))
  unique(signo * v[!is.na(v)])
}

# ---------------------------------------------------------------------------
# Califica UN sub-ítem.
#
#   respuesta   num/string : lo que tecleó, tal cual
#               schoice    : índice de la opción marcada (1..k) o NA
#               mchoice    : vector de índices marcados (puede ir vacío)
#   item        la entrada correspondiente del JSON de la clave
#
# Los índices van SIEMPRE en el orden barajado que vio el estudiante: la clave
# guarda su solución ya permutada, así que aquí no hay que deshacer nada.
# ---------------------------------------------------------------------------
calificar_item <- function(respuesta, item) {
  max_pts <- as.numeric(item$puntos)
  vacio <- is.null(respuesta) || length(respuesta) == 0L ||
    (length(respuesta) == 1L && (is.na(respuesta[1]) || identical(trimws(as.character(respuesta[1])), "")))

  fin <- function(frac, estado, detalle = "") {
    ## exams_eval devuelve -0 en varios caminos; sin este max() la exportación
    ## mostraría notas "-0" y las sumas arrastrarían el signo.
    frac <- max(0, as.numeric(frac))
    list(id = item$id, tipo = item$tipo, puntos_max = max_pts,
         puntos = round(frac * max_pts, 4), fraccion = frac,
         estado = estado, detalle = detalle)
  }

  if (vacio) return(fin(0, "sin responder"))

  sol <- unlist(item$sol)

  if (identical(item$tipo, "num")) {
    tol <- as.numeric(item$tol); if (is.na(tol)) tol <- 0
    correcta <- as.numeric(sol[1])
    lecturas <- interpretar_numero(respuesta)
    if (!length(lecturas)) return(fin(0, "ilegible", sprintf("no es un número: «%s»", respuesta)))
    dentro <- abs(lecturas - correcta) <= tol + 1e-9
    if (any(dentro)) {
      usada <- lecturas[which(dentro)[1]]
      det <- if (length(lecturas) > 1L)
        sprintf("leído como %s (de %s)", format(usada, scientific = FALSE),
                paste(format(lecturas, scientific = FALSE), collapse = " o ")) else ""
      fin(1, "correcta", det)
    } else {
      fin(0, "incorrecta", sprintf("respondió %s, se esperaba %s ± %s",
          paste(format(lecturas, scientific = FALSE), collapse = " o "),
          format(correcta, scientific = FALSE), format(tol, scientific = FALSE)))
    }

  } else if (identical(item$tipo, "schoice")) {
    idx <- suppressWarnings(as.integer(respuesta[1]))
    if (is.na(idx) || idx < 1L || idx > length(sol)) {
      return(fin(0, "ilegible", sprintf("opción fuera de rango: %s", respuesta[1])))
    }
    marcado <- rep(FALSE, length(sol)); marcado[idx] <- TRUE
    fin(EVAL$pointsum(as.logical(sol), marcado),
        if (isTRUE(as.logical(sol)[idx])) "correcta" else "incorrecta",
        sprintf("marcó la opción %d", idx))

  } else if (identical(item$tipo, "mchoice")) {
    idx <- suppressWarnings(as.integer(unlist(respuesta)))
    idx <- idx[!is.na(idx) & idx >= 1L & idx <= length(sol)]
    marcado <- rep(FALSE, length(sol)); if (length(idx)) marcado[idx] <- TRUE
    frac <- EVAL$pointsum(as.logical(sol), marcado)
    estado <- if (frac >= 1) "correcta" else if (frac > 0) "parcial" else "incorrecta"
    fin(frac, estado, sprintf("marcó %s de %d",
        if (length(idx)) paste(sort(idx), collapse = ",") else "ninguna", length(sol)))

  } else if (identical(item$tipo, "string")) {
    norm <- function(z) tolower(trimws(gsub("[[:space:]]+", " ", as.character(z))))
    ok <- norm(respuesta[1]) %in% norm(sol)
    fin(as.numeric(ok), if (ok) "correcta" else "incorrecta")

  } else {
    fin(0, "tipo desconocido", item$tipo)
  }
}

# ---------------------------------------------------------------------------
# Califica el examen completo.
#
# Los ítems abiertos NO se autocalifican: se devuelven como pendientes con su
# puntaje máximo, para que el panel docente los sume después. La nota que sale
# de aquí es por tanto PROVISIONAL mientras haya abiertos sin revisar, y el
# resultado lo dice explícitamente en vez de dejarlo suponer.
# ---------------------------------------------------------------------------
calificar_examen <- function(respuestas, clave, manuales = list()) {
  filas <- list()
  for (e in clave$ejercicios) {
    for (it in e$items) {
      r <- calificar_item(respuestas[[it$id]], it)
      filas[[length(filas) + 1L]] <- data.frame(
        ejercicio = e$nombre, id = r$id, tipo = r$tipo, puntos_max = r$puntos_max,
        puntos = r$puntos, estado = r$estado, detalle = r$detalle,
        stringsAsFactors = FALSE)
    }
  }
  items <- if (length(filas)) do.call(rbind, filas) else
    data.frame(ejercicio = character(0), id = character(0), tipo = character(0),
               puntos_max = numeric(0), puntos = numeric(0), estado = character(0),
               detalle = character(0), stringsAsFactors = FALSE)

  ab_max <- 0; ab_obt <- 0; ab_pend <- character(0)
  for (a in clave$abiertos) {
    ab_max <- ab_max + as.numeric(a$puntos)
    if (!is.null(manuales[[a$id]])) {
      ab_obt <- ab_obt + min(as.numeric(manuales[[a$id]]), as.numeric(a$puntos))
    } else ab_pend <- c(ab_pend, a$id)
  }

  pts_max <- sum(items$puntos_max) + ab_max
  pts     <- sum(items$puntos) + ab_obt
  nota    <- if (pts_max > 0) round(as.numeric(clave$nota_maxima) * pts / pts_max, 2) else NA_real_

  list(sid = clave$sid, items = items,
       puntos_cloze = sum(items$puntos), puntos_cloze_max = sum(items$puntos_max),
       puntos_abiertos = ab_obt, puntos_abiertos_max = ab_max,
       puntos = round(pts, 4), puntos_max = pts_max, nota = nota,
       abiertos_pendientes = ab_pend,
       provisional = length(ab_pend) > 0L)
}

# ===========================================================================
# Pruebas.  Rscript parcial/calificar.R --pruebas
# ===========================================================================
pruebas <- function() {
  ok <- 0L; mal <- 0L
  verde <- function(x) paste0("\033[32m", x, "\033[0m")
  rojo  <- function(x) paste0("\033[31m", x, "\033[0m")

  comprobar <- function(desc, obtenido, esperado) {
    bien <- isTRUE(all.equal(obtenido, esperado))
    if (bien) { ok <<- ok + 1L; cat(verde("  ✓ "), desc, "\n", sep = "") }
    else { mal <<- mal + 1L
      cat(rojo("  ✗ "), desc, rojo(sprintf("  (obtuvo %s, esperaba %s)",
          paste(format(obtenido), collapse=","), paste(format(esperado), collapse=","))), "\n", sep = "") }
  }

  cat("\n--- lectura de números ---\n")
  comprobar("entero simple",              interpretar_numero("10368000"), 10368000)
  comprobar("miles con punto",            interpretar_numero("10.368.000"), 10368000)
  comprobar("decimal con coma",           interpretar_numero("10,5"), 10.5)
  comprobar("miles y decimal",            interpretar_numero("1.234,56"), 1234.56)
  comprobar("formato inglés",             interpretar_numero("1,234.56"), 1234.56)
  comprobar("un punto, cola de 1 → decimal", interpretar_numero("10.5"), 10.5)
  comprobar("un punto, cola de 3 → ambiguo", sort(interpretar_numero("1.500")), c(1.5, 1500))
  comprobar("con pesos y espacios",       interpretar_numero(" $ 24.000.000 "), 24000000)
  comprobar("negativo",                   interpretar_numero("-1.250,75"), -1250.75)
  comprobar("porcentaje",                 interpretar_numero("64,8 %"), 64.8)
  comprobar("texto sin cifras",           interpretar_numero("no sé"), numeric(0))
  comprobar("vacío",                      interpretar_numero(""), numeric(0))

  cat("\n--- sub-ítems numéricos (correcta 10368000, tolerancia 1) ---\n")
  num <- list(id = "e1_1", tipo = "num", sol = 10368000, tol = 1, puntos = 5)
  comprobar("exacta",            calificar_item("10368000", num)$puntos, 5)
  comprobar("con separadores",   calificar_item("10.368.000", num)$puntos, 5)
  comprobar("dentro de la tolerancia", calificar_item("10367999", num)$puntos, 5)
  comprobar("fuera de la tolerancia",  calificar_item("10367990", num)$puntos, 0)
  comprobar("vacía",             calificar_item("", num)$estado, "sin responder")
  comprobar("nula",              calificar_item(NULL, num)$estado, "sin responder")
  comprobar("ilegible",          calificar_item("no sé", num)$estado, "ilegible")
  comprobar("ambigua que acierta", calificar_item("1.500", list(id="x", tipo="num",
                                     sol = 1500, tol = 0, puntos = 5))$puntos, 5)

  cat("\n--- schoice (4 opciones, correcta la 2) ---\n")
  sc <- list(id = "e2_1", tipo = "schoice", sol = c(FALSE,TRUE,FALSE,FALSE), tol = 0, puntos = 4)
  comprobar("acierta",            calificar_item(2L, sc)$puntos, 4)
  comprobar("falla",              calificar_item(3L, sc)$puntos, 0)
  comprobar("sin marcar",         calificar_item(NA, sc)$estado, "sin responder")
  comprobar("fuera de rango",     calificar_item(9L, sc)$estado, "ilegible")
  comprobar("nunca negativo",     calificar_item(1L, sc)$puntos >= 0, TRUE)

  cat("\n--- mchoice (4 opciones, correctas 1 y 4) — la semántica de Moodle ---\n")
  mc <- list(id = "e3_1", tipo = "mchoice", sol = c(TRUE,FALSE,FALSE,TRUE), tol = 0, puntos = 6)
  comprobar("las dos correctas",       calificar_item(c(1L,4L), mc)$puntos, 6)
  comprobar("una de dos → mitad",      calificar_item(c(1L),    mc)$puntos, 3)
  comprobar("una bien y una mal → 0",  calificar_item(c(1L,3L), mc)$puntos, 0)
  comprobar("marca todo → 0",          calificar_item(1:4,      mc)$puntos, 0)
  comprobar("estado parcial",          calificar_item(c(4L),    mc)$estado, "parcial")
  comprobar("nada marcado",            calificar_item(integer(0), mc)$estado, "sin responder")

  cat("\n--- examen completo ---\n")
  clave <- list(sid = "prueba", nota_maxima = 5, puntos_totales = 100,
    ejercicios = list(list(id="e1", nombre="uno", items = list(num, sc, mc))),
    abiertos = list(list(id = "sustentacion", puntos = 15, rubrica = list("a"))))
  r1 <- calificar_examen(list(e1_1 = "10368000", e2_1 = 2L, e3_1 = c(1L)), clave)
  comprobar("puntos de cloze",     r1$puntos_cloze, 12)
  comprobar("máximo de cloze",     r1$puntos_cloze_max, 15)
  comprobar("abierto pendiente",   r1$abiertos_pendientes, "sustentacion")
  comprobar("marca provisional",   r1$provisional, TRUE)
  comprobar("nota provisional",    r1$nota, round(5 * 12 / 30, 2))
  r2 <- calificar_examen(list(e1_1 = "10368000", e2_1 = 2L, e3_1 = c(1L,4L)), clave,
                         manuales = list(sustentacion = 15))
  comprobar("con el abierto calificado", r2$puntos, 30)
  comprobar("nota final",                r2$nota, 5)
  comprobar("ya no es provisional",      r2$provisional, FALSE)
  r3 <- calificar_examen(list(), clave)
  comprobar("examen en blanco",          r3$puntos_cloze, 0)
  comprobar("todo sin responder",        all(r3$items$estado == "sin responder"), TRUE)

  cat(sprintf("\n  %d pruebas · %s\n\n", ok + mal,
      if (mal == 0L) verde(sprintf("%d correctas", ok)) else rojo(sprintf("%d FALLIDAS", mal))))
  invisible(mal == 0L)
}

if ("--pruebas" %in% commandArgs(TRUE)) {
  if (!isTRUE(pruebas())) quit(status = 1L)
}
