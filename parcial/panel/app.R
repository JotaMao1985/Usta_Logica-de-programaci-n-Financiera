# ============================================================================
# Panel docente · parcial de Lógica de Programación Financiera
#
# App SEPARADA de la del examen, a propósito: la app del estudiante debe tener
# una sola puerta, y un panel de docente colgado de ella es una puerta más que
# puede abrirse por error o a la fuerza. Aquí no entra ningún estudiante.
#
# No comparte proceso con el examen: se comunican por la base de datos, que es
# la única verdad. Por eso «+N minutos» surte efecto en el reloj del estudiante
# en menos de un segundo sin tocar su sesión.
#
# NO se publica en internet. Se sirve en 127.0.0.1 y se llega por túnel SSH:
#   ssh -N -L 8899:127.0.0.1:8899 usuario@servidor
#
# Uso:
#   export LPF_PANEL_CLAVE="..."   distinta del código del día
#   R -e 'shiny::runApp("parcial/panel", port = 8899, host = "127.0.0.1")'
# ============================================================================

if (!isTRUE(l10n_info()$`UTF-8`)) {
  for (loc in c("es_CO.UTF-8", "es_ES.UTF-8", "en_US.UTF-8", "C.UTF-8"))
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
}

suppressPackageStartupMessages({
  library(shiny); library(bslib); library(DBI); library(RSQLite)
  library(jsonlite)
})
options(shiny.sanitize.errors = TRUE)
`%||%` <- function(a, b) if (is.null(a)) b else a

DIR_APP <- getwd()
BASE    <- normalizePath(file.path(DIR_APP, "..", ".."), mustWork = FALSE)
source(file.path(BASE, "parcial", "calificar.R"))
source(file.path(BASE, "parcial", "esquema.R"))

SALIDA <- Sys.getenv("LPF_SALIDA", file.path(BASE, "parcial", "salida"))
BD     <- Sys.getenv("LPF_BD",     file.path(BASE, "parcial", "app", "datos", "parcial.sqlite"))
CLAVE  <- Sys.getenv("LPF_PANEL_CLAVE", "")
if (CLAVE == "") { CLAVE <- "PANEL"; message("⚠ LPF_PANEL_CLAVE sin definir: la clave es 'PANEL'.") }

REFRESCO <- 5000

con_bd <- function(f) {
  con <- dbConnect(SQLite(), BD); on.exit(dbDisconnect(con))
  dbExecute(con, "PRAGMA busy_timeout=8000"); f(con)
}
## El esquema lo define un solo archivo, compartido con la app del examen.
con_bd(esquema)

ahora <- function() format(Sys.time(), "%Y-%m-%dT%H:%M:%OS3%z")

# --------------------------------------------------------------------------
# El manifiesto trae `sid → nombre`. Contiene nombres, NO cédulas: las cédulas
# no salen nunca de la máquina del docente (PLAN §H4). Sin él, el panel
# funciona igual pero mostrando identificadores, que en mitad del parcial no
# sirven para localizar a nadie.
# --------------------------------------------------------------------------
leer_manifiesto <- function() {
  f <- file.path(SALIDA, "manifiesto.csv")
  if (!file.exists(f)) return(NULL)
  m <- tryCatch(read.csv(f, colClasses = "character", encoding = "UTF-8"),
                error = function(e) NULL)
  if (is.null(m) || !all(c("sid", "nombre") %in% names(m))) return(NULL)
  if (any(grepl("cedula|documento", names(m), ignore.case = TRUE))) {
    warning("el manifiesto trae una columna de cédulas: no debe subirse al servidor")
  }
  m
}

mmss <- function(seg) {
  if (is.na(seg)) return("—")
  neg <- seg < 0; seg <- abs(seg)
  sprintf("%s%02d:%02d", if (neg) "−" else "", floor(seg / 60), floor(seg %% 60))
}

estado_curso <- function() {
  man <- leer_manifiesto()
  ses <- con_bd(function(con) dbGetQuery(con, "SELECT * FROM sesiones"))
  notas <- con_bd(function(con) dbGetQuery(con,
    "SELECT sid, puntos, puntos_max, nota, provisional FROM notas"))
  ## MAX(ts_epoch) y no MAX(ts): comparar contra una cadena con desfase horario
  ## obliga a parsearla, y ahí es donde se cuelan los errores de cinco horas.
  resp <- con_bd(function(con) dbGetQuery(con,
    "SELECT sid, COUNT(*) AS n, MAX(ts_epoch) AS ultima FROM respuestas
     WHERE valor NOT IN ('null','\"\"') GROUP BY sid"))

  base <- if (!is.null(man)) man[, c("sid", "nombre", "grupo")] else
    data.frame(sid = character(0), nombre = character(0), grupo = character(0))
  ## Quien aparezca en la base de datos pero no en el manifiesto también se
  ## muestra: es justamente el caso que hay que ver, no esconder.
  huerfanos <- setdiff(ses$sid, base$sid)
  if (length(huerfanos)) base <- rbind(base, data.frame(
    sid = huerfanos, nombre = paste0("(fuera del manifiesto) ", substr(huerfanos, 1, 8)),
    grupo = "", stringsAsFactors = FALSE))

  d <- merge(base, ses, by = "sid", all.x = TRUE)
  d <- merge(d, resp, by = "sid", all.x = TRUE)
  d <- merge(d, notas, by = "sid", all.x = TRUE)

  t0 <- as.numeric(Sys.time())
  d$restante <- ifelse(is.na(d$inicio_epoch), NA_real_,
    (d$minutos * 60) + ifelse(is.na(d$extra_segundos), 0, d$extra_segundos) -
      (t0 - as.numeric(d$inicio_epoch)))
  d$n[is.na(d$n)] <- 0L
  motivo <- ifelse(is.na(d$motivo_cierre) | d$motivo_cierre == "", "enviado", d$motivo_cierre)
  d$estado <- ifelse(is.na(d$inicio), "sin entrar",
              ifelse(d$entregado == 1, paste0("entregado · ", motivo),
              ## Una sesión abierta SIN reloj es una anomalía que hay que ver,
              ## no un guion en la columna del tiempo.
              ifelse(is.na(d$restante), "SIN RELOJ",
              ifelse(d$restante < 0, "TIEMPO VENCIDO", "en curso"))))
  ## Última señal de vida: sirve para ver de un vistazo a quién se le cayó algo.
  d$silencio <- ifelse(is.na(d$ultima), NA_real_, t0 - as.numeric(d$ultima))
  d[order(d$nombre), ]
}

# --------------------------------------------------------------------------
MORADO <- "#3D008D"; ROSA <- "#ED1E79"
ui <- page_fluid(
  theme = bs_theme(version = 5, primary = MORADO, secondary = ROSA,
                   base_font = font_collection("Montserrat", "system-ui", "sans-serif")),
  tags$head(tags$link(rel = "stylesheet", href = "panel.css"),
            tags$title("Panel docente · parcial")),
  uiOutput("pantalla")
)

server <- function(input, output, session) {
  st <- reactiveValues(dentro = FALSE, aviso = NULL, msg = NULL, opciones = character(0))

  observeEvent(input$entrar, {
    if (identical(trimws(input$clave %||% ""), CLAVE)) { st$dentro <- TRUE; st$aviso <- NULL }
    else st$aviso <- "Clave incorrecta."
  })

  ## Tiempo extra. Un solo observador para todos los botones: los envía el
  ## navegador con el sid dentro, en vez de crear un observador por fila.
  observeEvent(input$lp_extra, {
    req(st$dentro)
    sid <- input$lp_extra$sid; min <- as.numeric(input$lp_extra$min)
    con_bd(function(con) dbExecute(con,
      "UPDATE sesiones SET extra_segundos = COALESCE(extra_segundos,0) + ? WHERE sid = ?",
      list(min * 60, sid)))
    con_bd(function(con) dbExecute(con,
      "INSERT INTO eventos (sid, tipo, detalle, ts) VALUES (?,?,?,?)",
      list(sid, "tiempo_extra", sprintf("%+g minutos desde el panel", min), ahora())))
    st$msg <- sprintf("%+g minutos a %s", min, substr(sid, 1, 8))
  }, ignoreInit = TRUE)

  # --- calificación manual de los ítems abiertos --------------------------
  abiertos_de <- function(sid) {
    f <- file.path(SALIDA, "claves", paste0(sid, ".json"))
    if (!file.exists(f)) return(NULL)
    cl <- tryCatch(fromJSON(f, simplifyVector = FALSE), error = function(e) NULL)
    if (is.null(cl)) return(NULL)
    cl
  }

  observeEvent(input$guardar_manual, {
    req(st$dentro, input$sel_sid)
    sid <- input$sel_sid
    cl <- abiertos_de(sid); req(!is.null(cl))
    for (a in cl$abiertos) {
      v <- input[[paste0("pts_", a$id)]]
      if (is.null(v) || is.na(v)) next
      v <- max(0, min(as.numeric(v), as.numeric(a$puntos)))
      con_bd(function(con) dbExecute(con,
        "INSERT INTO manuales (sid, item, puntos, ts) VALUES (?,?,?,?)
         ON CONFLICT(sid,item) DO UPDATE SET puntos=excluded.puntos, ts=excluded.ts",
        list(sid, a$id, v, ahora())))
    }
    ## Recalcular la nota completa con lo manual ya incluido.
    resp <- con_bd(function(con) dbGetQuery(con,
      "SELECT item, valor FROM respuestas WHERE sid = ?", list(sid)))
    lista <- if (nrow(resp)) setNames(lapply(resp$valor, function(v)
      tryCatch(fromJSON(v), error = function(e) NULL)), resp$item) else list()
    man <- con_bd(function(con) dbGetQuery(con,
      "SELECT item, puntos FROM manuales WHERE sid = ?", list(sid)))
    manl <- if (nrow(man)) setNames(as.list(man$puntos), man$item) else list()
    r <- calificar_examen(lista, cl, manuales = manl)
    con_bd(function(con) dbExecute(con,
      "INSERT INTO notas (sid, puntos, puntos_max, nota, provisional, calculada, detalle)
       VALUES (?,?,?,?,?,?,?) ON CONFLICT(sid) DO UPDATE SET puntos=excluded.puntos,
       puntos_max=excluded.puntos_max, nota=excluded.nota, provisional=excluded.provisional,
       calculada=excluded.calculada, detalle=excluded.detalle",
      list(sid, r$puntos, r$puntos_max, r$nota, as.integer(r$provisional), ahora(),
           toJSON(r$items, auto_unbox = TRUE))))
    st$msg <- sprintf("nota de %s recalculada: %.2f%s", substr(sid, 1, 8), r$nota,
                      if (r$provisional) " (aún provisional)" else "")
  })

  # --- exportación --------------------------------------------------------
  tabla_resultados <- function() {
    d <- estado_curso()
    data.frame(
      nombre = d$nombre, grupo = d$grupo %||% "", sid = d$sid,
      estado = d$estado, respondidas = d$n,
      puntos = round(d$puntos, 2), puntos_max = d$puntos_max,
      nota = round(d$nota, 2),
      provisional = ifelse(is.na(d$provisional), NA, d$provisional == 1),
      inicio = d$inicio, fin = d$fin, motivo = d$motivo_cierre,
      stringsAsFactors = FALSE)
  }

  ## La exportación de emergencia escribe SIEMPRE en disco además de ofrecer la
  ## descarga: si el navegador falla justo en ese momento, el archivo ya existe.
  observeEvent(input$exportar_disco, {
    req(st$dentro)
    f <- file.path(SALIDA, sprintf("resultados_%s.csv",
                                   format(Sys.time(), "%Y%m%d_%H%M%S")))
    write.csv(tabla_resultados(), f, row.names = FALSE, fileEncoding = "UTF-8")
    st$msg <- paste("escrito en", f)
  })

  output$descargar <- downloadHandler(
    filename = function() sprintf("resultados_%s.csv", format(Sys.time(), "%Y%m%d_%H%M")),
    content = function(file) write.csv(tabla_resultados(), file,
                                       row.names = FALSE, fileEncoding = "UTF-8"))

  # --- pintar -------------------------------------------------------------
  output$pantalla <- renderUI({
    if (!st$dentro) return(
      div(class = "pn-centro", div(class = "pn-tarjeta",
        div(class = "pn-cabecera", h1("Panel docente"), p("Parcial · Lógica de Programación Financiera")),
        div(class = "pn-cuerpo",
          passwordInput("clave", "Clave del panel"),
          if (!is.null(st$aviso)) div(class = "pn-error", st$aviso),
          actionButton("entrar", "Entrar", class = "btn btn-primary w-100"),
          div(class = "pn-nota", "Esta clave es distinta del código del día. ",
              "Si son la misma, cualquier estudiante entra al panel.")))))

    div(class = "pn-panel",
      div(class = "pn-barra",
        strong("Panel docente"),
        span(class = "pn-tenue", " · parcial de Lógica de Programación Financiera"),
        div(class = "pn-acciones",
          actionButton("exportar_disco", "Exportar al servidor", class = "btn btn-sm btn-light"),
          downloadButton("descargar", "Descargar CSV", class = "btn btn-sm btn-light"))),
      div(class = "pn-contenido",
        if (!is.null(st$msg)) div(class = "pn-msg", icon("circle-info"), " ", st$msg),
        uiOutput("resumen"),
        uiOutput("tabla"),
        uiOutput("manual")))
  })

  output$resumen <- renderUI({
    invalidateLater(REFRESCO, session)
    d <- tryCatch(estado_curso(), error = function(e)
      return(NULL))
    if (is.null(d)) return(div(class = "pn-error",
      "No se pudo leer el estado del curso. Revise la base de datos."))
    ficha <- function(n, etiqueta, clase = "") div(class = paste("pn-ficha", clase),
      div(class = "pn-num", n), div(class = "pn-lab", etiqueta))
    div(class = "pn-fichas",
      ficha(nrow(d), "en el manifiesto"),
      ficha(sum(d$estado == "sin entrar"), "sin entrar", "pn-gris"),
      ficha(sum(d$estado == "en curso"), "en curso", "pn-verde"),
      ficha(sum(grepl("^entregado", d$estado)), "entregados", "pn-morado"),
      ficha(sum(d$estado %in% c("TIEMPO VENCIDO", "SIN RELOJ")), "requieren atención", "pn-rojo"),
      ficha(sum(!is.na(d$silencio) & d$silencio > 120 & d$estado == "en curso"),
            "sin señal >2 min", "pn-ambar"))
  })

  output$tabla <- renderUI({
    invalidateLater(REFRESCO, session)
    d <- tryCatch(estado_curso(), error = function(e) NULL)
    if (is.null(d)) return(div(class = "pn-error",
      "No se pudo leer la tabla. El panel sigue vivo; los datos están en la base."))
    if (!nrow(d)) return(div(class = "pn-vacio", "No hay exámenes generados todavía."))
    filas <- lapply(seq_len(nrow(d)), function(i) {
      r <- d[i, ]
      clase <- switch(r$estado, "sin entrar" = "pn-f-gris", "en curso" = "pn-f-verde",
                      "TIEMPO VENCIDO" = "pn-f-rojo", "SIN RELOJ" = "pn-f-rojo", "pn-f-morado")
      botones <- if (r$estado %in% c("en curso", "TIEMPO VENCIDO", "SIN RELOJ"))
        HTML(sprintf(
          '<button class="pn-mas" onclick="Shiny.setInputValue(\'lp_extra\',{sid:\'%s\',min:5,n:++window.__c||1})">+5</button>
           <button class="pn-mas" onclick="Shiny.setInputValue(\'lp_extra\',{sid:\'%s\',min:10,n:++window.__c||1})">+10</button>',
          r$sid, r$sid)) else NULL
      tags$tr(class = clase,
        tags$td(r$nombre), tags$td(class = "pn-mono", substr(r$sid, 1, 8)),
        tags$td(r$estado),
        tags$td(class = "pn-mono", sprintf("%d", r$n)),
        tags$td(class = "pn-mono", mmss(r$restante)),
        tags$td(class = "pn-mono", if (is.na(r$silencio)) "—" else mmss(r$silencio)),
        tags$td(class = "pn-mono", if (is.na(r$nota)) "—" else
          sprintf("%.2f%s", r$nota, if (isTRUE(r$provisional == 1)) "*" else "")),
        tags$td(botones))
    })
    div(class = "pn-tabla-caja", tags$table(class = "pn-tabla",
      tags$thead(tags$tr(lapply(c("Estudiante", "id", "Estado", "Resp.", "Restante",
                                  "Silencio", "Nota", "Tiempo extra"), tags$th))),
      tags$tbody(filas)))
  })

  ## La lista de entregados se mantiene con `updateSelectInput` y NO
  ## re-renderizando el bloque.
  ##
  ## Renderizarlo cada vez tenía dos problemas: si no depende de nada reactivo
  ## se pinta una sola vez y la lista nunca crece —que es lo que pasaba: dos
  ## estudiantes entregados y uno solo en el desplegable—; y si se le hace
  ## depender del estado, se repinta cada cinco segundos y le borra al docente
  ## la nota que está escribiendo. Actualizar solo las opciones evita las dos.
  observe({
    req(st$dentro)
    invalidateLater(REFRESCO, session)
    d <- tryCatch(estado_curso(), error = function(e) NULL)
    if (is.null(d)) return()
    ent <- d[grepl("^entregado", d$estado), , drop = FALSE]
    nuevas <- setNames(ent$sid, ent$nombre)
    if (!identical(isolate(st$opciones), nuevas)) {
      previo <- isolate(input$sel_sid)
      st$opciones <- nuevas
      updateSelectInput(session, "sel_sid", choices = nuevas,
                        selected = if (!is.null(previo) && previo %in% nuevas) previo else NULL)
    }
  })

  output$manual <- renderUI({
    req(st$dentro)
    div(class = "pn-manual",
      h3("Calificar la sustentación"),
      p(class = "pn-tenue",
        "El ítem abierto no se autocalifica. Las notas con * siguen provisionales.
         La lista se actualiza sola a medida que entregan."),
      selectInput("sel_sid", "Estudiante", choices = isolate(st$opciones), width = "320px"),
      uiOutput("manual_detalle"))
  })

  output$manual_detalle <- renderUI({
    req(input$sel_sid)
    sid <- input$sel_sid
    cl <- abiertos_de(sid); req(!is.null(cl), length(cl$abiertos) > 0)
    man <- con_bd(function(con) dbGetQuery(con,
      "SELECT item, puntos FROM manuales WHERE sid = ?", list(sid)))
    resp <- con_bd(function(con) dbGetQuery(con,
      "SELECT item, valor FROM respuestas WHERE sid = ?", list(sid)))
    texto_de <- function(id) {
      v <- resp$valor[resp$item == id]
      if (!length(v)) return("(sin responder)")
      x <- tryCatch(fromJSON(v[1]), error = function(e) NULL)
      if (is.null(x) || !nzchar(paste(x, collapse = ""))) "(sin responder)" else paste(x, collapse = "\n")
    }
    tagList(lapply(cl$abiertos, function(a) {
      previo <- man$puntos[man$item == a$id]
      div(class = "pn-abierto",
        div(class = "pn-rubrica", strong("Rúbrica: "),
            tags$ul(lapply(unlist(a$rubrica), tags$li))),
        div(class = "pn-respuesta", tags$pre(texto_de(a$id))),
        numericInput(paste0("pts_", a$id), sprintf("Puntos (máximo %s)", a$puntos),
                     value = if (length(previo)) previo[1] else 0,
                     min = 0, max = as.numeric(a$puntos), step = 0.5, width = "200px"))
    }), actionButton("guardar_manual", "Guardar y recalcular la nota", class = "btn btn-primary"))
  })
}

shinyApp(ui, server)
