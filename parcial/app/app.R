# ============================================================================
# App del parcial · Lógica de Programación Financiera
# Universidad Santo Tomás · 2026-II
#
# La app NO compila R/exams: lee los JSON que dejó `parcial/generar.R`.
# La clave nunca se envía al navegador: se queda aquí y solo se usa al calificar.
#
# El principio que ordena todo el archivo: **la base de datos es la verdad, no
# la pantalla**. Se califica lo que está guardado, no lo que hay en los campos,
# porque el navegador puede haberse ido hace rato y el examen sigue existiendo.
#
# Uso:
#   export LPF_PEPPER="..."      el mismo con el que se generaron los exámenes
#   export LPF_CODIGO="..."      el código que se dicta en el tablero
#   R -e 'shiny::runApp("parcial/app", port = 8080, host = "0.0.0.0")'
# ============================================================================

if (!isTRUE(l10n_info()$`UTF-8`)) {
  for (loc in c("es_CO.UTF-8", "es_ES.UTF-8", "en_US.UTF-8", "C.UTF-8"))
    if (suppressWarnings(Sys.setlocale("LC_CTYPE", loc)) != "") break
}

suppressPackageStartupMessages({
  library(shiny); library(bslib); library(DBI); library(RSQLite)
  library(jsonlite); library(digest)
})

## Que un error interno nunca le muestre a un estudiante una traza de R.
options(shiny.sanitize.errors = TRUE)

`%||%` <- function(a, b) if (is.null(a)) b else a

DIR_APP <- getwd()
BASE    <- normalizePath(file.path(DIR_APP, "..", ".."), mustWork = FALSE)
source(file.path(BASE, "parcial", "calificar.R"))
source(file.path(BASE, "parcial", "esquema.R"))

SALIDA  <- Sys.getenv("LPF_SALIDA", file.path(BASE, "parcial", "salida"))
BD      <- Sys.getenv("LPF_BD",     file.path(DIR_APP, "datos", "parcial.sqlite"))
BITACORA<- Sys.getenv("LPF_BITACORA", file.path(dirname(BD), "eventos.jsonl"))
CODIGO  <- Sys.getenv("LPF_CODIGO", "")
PEPPER  <- Sys.getenv("LPF_PEPPER", "")

if (PEPPER == "") {
  PEPPER <- "PEPPER-DE-DEMOSTRACION-NO-USAR-EN-EL-PARCIAL"
  message("⚠ LPF_PEPPER sin definir: usando el de demostración.")
}
if (CODIGO == "") {
  CODIGO <- "PRUEBA"
  message("⚠ LPF_CODIGO sin definir: el código del día es 'PRUEBA'.")
}

REBOTE_TEXTO  <- 900   # ms: se guarda 0,9 s después de la última tecla
REBOTE_OPCION <- 250   # ms: marcar una opción es un acto deliberado
INSTANTANEA   <- 20000 # ms: red de seguridad periódica
LATIDO_SESION <- 5000  # ms: cada cuánto se comprueba si a uno lo desplazaron

# ==========================================================================
# Base de datos
# ==========================================================================
con_bd <- function(f) {
  con <- dbConnect(SQLite(), BD)
  on.exit(dbDisconnect(con))
  dbExecute(con, "PRAGMA journal_mode=WAL")
  dbExecute(con, "PRAGMA busy_timeout=8000")
  f(con)
}

iniciar_bd <- function() {
  dir.create(dirname(BD), recursive = TRUE, showWarnings = FALSE)
  con_bd(esquema)
}
iniciar_bd()

ahora     <- function() format(Sys.time(), "%Y-%m-%dT%H:%M:%OS3%z")
epoch     <- function() as.numeric(Sys.time())

# --------------------------------------------------------------------------
# Bitácora append-only.
#
# La segunda copia de todo, en un archivo que solo crece. Si la base de datos
# se corrompe —o alguien la borra— el parcial se reconstruye desde aquí, y por
# eso guarda también los VALORES de las respuestas y no solo que hubo un cambio.
# --------------------------------------------------------------------------
anotar <- function(sid, tipo, detalle = "", valor = NULL) {
  linea <- toJSON(list(ts = ahora(), sid = sid %||% "", tipo = tipo,
                       detalle = detalle, valor = valor),
                  auto_unbox = TRUE, null = "null")
  try(cat(linea, "\n", sep = "", file = BITACORA, append = TRUE), silent = TRUE)
  try(con_bd(function(con) dbExecute(con,
    "INSERT INTO eventos (sid, tipo, detalle, ts) VALUES (?,?,?,?)",
    list(sid %||% "", tipo, detalle, ahora()))), silent = TRUE)
  invisible(NULL)
}

guardar_respuesta <- function(sid, item, valor) {
  json <- toJSON(valor, auto_unbox = TRUE, null = "null")
  con_bd(function(con) dbExecute(con,
    "INSERT INTO respuestas (sid, item, valor, ts, ts_epoch) VALUES (?,?,?,?,?)
     ON CONFLICT(sid, item) DO UPDATE SET valor=excluded.valor, ts=excluded.ts,
       ts_epoch=excluded.ts_epoch",
    list(sid, item, json, ahora(), epoch())))
  anotar(sid, "respuesta", item, valor)
}

leer_respuestas <- function(sid) {
  r <- con_bd(function(con) dbGetQuery(con,
    "SELECT item, valor FROM respuestas WHERE sid = ?", list(sid)))
  if (!nrow(r)) return(list())
  setNames(lapply(r$valor, function(v)
    tryCatch(fromJSON(v), error = function(e) NULL)), r$item)
}

sesion_estado <- function(sid) {
  con_bd(function(con) {
    r <- dbGetQuery(con, "SELECT * FROM sesiones WHERE sid = ?", list(sid))
    if (nrow(r)) as.list(r[1, ]) else NULL
  })
}

## Abre la sesión si no existía y toma posesión con un token nuevo. El token es
## lo que implementa el relevo: manda quien entró último.
sesion_tomar <- function(sid, minutos) {
  token <- paste0(format(epoch(), digits = 15), "-",
                  paste(sample(c(letters, 0:9), 8, TRUE), collapse = ""))
  con_bd(function(con) {
    dbExecute(con, "INSERT INTO sesiones (sid, inicio, inicio_epoch, minutos, token)
                    VALUES (?,?,?,?,?) ON CONFLICT(sid) DO UPDATE SET token = excluded.token",
              list(sid, ahora(), epoch(), minutos, token))
    ## Red de seguridad: una sesión sin `inicio_epoch` no tendría cronómetro.
    ## Se sella ahora y se anota, porque regalar el reloj entero es menos malo
    ## que dejar correr un examen sin límite y sin que nadie lo note. En una
    ## base de datos limpia —que es como debe arrancar el parcial— nunca ocurre.
    n <- dbExecute(con, "UPDATE sesiones SET inicio_epoch = ? WHERE sid = ? AND inicio_epoch IS NULL",
                   list(epoch(), sid))
    if (n > 0) dbExecute(con, "INSERT INTO eventos (sid, tipo, detalle, ts) VALUES (?,?,?,?)",
                         list(sid, "reloj_resellado", "la sesión no tenía inicio_epoch", ahora()))
  })
  token
}
sesion_token <- function(sid) {
  con_bd(function(con) {
    r <- dbGetQuery(con, "SELECT token FROM sesiones WHERE sid = ?", list(sid))
    if (nrow(r)) r$token[1] else NA_character_
  })
}
sesion_cerrar <- function(sid, motivo) {
  con_bd(function(con) dbExecute(con,
    "UPDATE sesiones SET fin = ?, entregado = 1, motivo_cierre = ? WHERE sid = ?",
    list(ahora(), motivo, sid)))
}

nota_guardar <- function(r) {
  con_bd(function(con) dbExecute(con,
    "INSERT INTO notas (sid, puntos, puntos_max, nota, provisional, calculada, detalle)
     VALUES (?,?,?,?,?,?,?)
     ON CONFLICT(sid) DO UPDATE SET puntos=excluded.puntos, puntos_max=excluded.puntos_max,
       nota=excluded.nota, provisional=excluded.provisional,
       calculada=excluded.calculada, detalle=excluded.detalle",
    list(r$sid, r$puntos, r$puntos_max, r$nota, as.integer(r$provisional), ahora(),
         toJSON(r$items, auto_unbox = TRUE))))
}

# ==========================================================================
# Identidad y carga del examen
# ==========================================================================
normalizar_cedula <- function(x) gsub("[^0-9]", "", as.character(x))
sid_de <- function(cedula) substr(digest::hmac(PEPPER, normalizar_cedula(cedula),
                                               algo = "sha256"), 1L, 16L)

## Un archivo que NO existe y uno que existe pero está corrupto son dos
## problemas distintos y con dos remedios distintos: el primero es un
## estudiante que no está en el roster; el segundo es un archivo que hay que
## regenerar. Decirle «no tiene examen asignado» a quien sí lo tiene mandaría
## al docente a buscar donde no es, el día del parcial y con prisa.
cargar_json <- function(carpeta, sid) {
  f <- file.path(SALIDA, carpeta, paste0(sid, ".json"))
  if (!file.exists(f)) return(structure(list(), clase = "ausente"))
  tryCatch(fromJSON(f, simplifyVector = FALSE),
           error = function(e) structure(list(mensaje = conditionMessage(e)),
                                         clase = "corrupto"))
}
falla <- function(x) attr(x, "clase")
cargar_examen <- function(sid) cargar_json("examenes", sid)
cargar_clave  <- function(sid) cargar_json("claves", sid)

## Catálogo plano de los ítems de un examen: id y tipo. Lo usan el autoguardado,
## la reanudación y la instantánea periódica.
catalogo <- function(ex) {
  filas <- list()
  for (e in ex$ejercicios) for (it in e$items)
    filas[[length(filas) + 1L]] <- list(id = it$id, tipo = it$tipo)
  for (a in ex$abiertos)
    filas[[length(filas) + 1L]] <- list(id = a$id, tipo = "abierto")
  filas
}

## De lo que hay en pantalla al valor que se guarda.
normalizar_valor <- function(tipo, v) {
  if (is.null(v) || !length(v)) return(NULL)
  if (tipo %in% c("schoice", "mchoice")) as.integer(v) else as.character(v)
}

# ==========================================================================
# Interfaz
# ==========================================================================
MORADO <- "#3D008D"; ROSA <- "#ED1E79"

tema <- bs_theme(version = 5, primary = MORADO, secondary = ROSA,
                 base_font = font_collection("Montserrat", "system-ui", "sans-serif"),
                 code_font = font_collection("Fira Code", "monospace"))

ui <- page_fluid(
  theme = tema,
  tags$head(
    tags$link(rel = "stylesheet", href = "vendor/fonts.googleapis.com_css2_family_Montserrat_wght_300_400_500_600_700_800_display_swap.css"),
    tags$link(rel = "stylesheet", href = "vendor/fonts.googleapis.com_css2_family_Fira_Code_wght_400_500_display_swap.css"),
    tags$link(rel = "stylesheet", href = "vendor/cdnjs.cloudflare.com_ajax_libs_font-awesome_6.5.2_css_all.min.css"),
    tags$link(rel = "stylesheet", href = "examen.css"),
    tags$title("Primer parcial · Lógica de Programación Financiera"),
    ## Aviso propio de desconexión. El de Shiny cubre la pantalla de gris con
    ## «Disconnected from the server» y un enlace para recargar: en un examen
    ## eso se lee como «perdió todo». Aquí se dice lo contrario, que es además
    ## lo cierto, y se reintenta solo.
    tags$script(HTML("
      $(document).on('shiny:disconnected', function(){
        $('#shiny-disconnected-overlay').remove();
        if (!document.getElementById('lp-caida')) {
          $('body').append('<div id=\"lp-caida\" class=\"lp-caida\">' +
            '<strong>Se perdió la conexión.</strong> Sus respuestas están guardadas. ' +
            'Reintentando sin que usted tenga que hacer nada…</div>');
        }
      });
      $(document).on('shiny:connected', function(){ $('#lp-caida').remove(); });
    ")),
    ## Al salir de un campo se guarda de inmediato, sin esperar al rebote.
    ## `focusout` y no `blur`: blur no se propaga y la delegación no lo vería.
    tags$script(HTML("
      $(document).on('focusout', '.lp-item input, .lp-item textarea, .lp-abierto textarea',
        function(){ if (this.id) Shiny.setInputValue('lp_salida_campo',
                    {id: this.id, n: (window.__lpn = (window.__lpn||0) + 1)}); });
    "))
  ),
  uiOutput("pantalla")
)

pantalla_acceso <- function(aviso = NULL, cedula = "") {
  div(class = "lp-centro",
    div(class = "lp-tarjeta",
      div(class = "lp-cabecera",
        h1("Primer parcial"),
        p("Lógica de Programación Financiera · Capítulos 1 a 3"),
        p(class = "lp-tenue", "Universidad Santo Tomás · 2026-II")),
      div(class = "lp-cuerpo",
        textInput("cedula", "Número de documento", value = cedula,
                  placeholder = "sin puntos ni espacios"),
        passwordInput("codigo", "Código del día", placeholder = "el que aparece en el tablero"),
        if (!is.null(aviso)) div(class = "lp-error", icon("circle-exclamation"), " ", aviso),
        actionButton("entrar", "Entrar al examen", class = "btn btn-primary w-100 lp-boton"),
        div(class = "lp-aviso",
          strong("Tratamiento de datos. "),
          "Su número de documento se usa únicamente para localizar su examen y no se
           almacena: el sistema guarda un código derivado del que no es posible
           recuperarlo. Se conservan sus respuestas y las marcas de tiempo del examen.
           Ley 1581 de 2012.")))
  )
}

control_item <- function(it, valor = NULL) {
  etiqueta <- if (nzchar(it$etiqueta %||% "")) HTML(it$etiqueta) else NULL
  valores  <- as.character(seq_along(it$opciones))
  nombres  <- lapply(it$opciones, function(o) HTML(as.character(o)))
  sel      <- if (is.null(valor)) character(0) else as.character(unlist(valor))

  cuerpo <- switch(it$tipo,
    num = textInput(it$id, label = etiqueta, width = "260px",
                    value = if (is.null(valor)) "" else as.character(valor)[1]),
    ## `selected = character(0)` es obligatorio: por defecto radioButtons deja
    ## marcada la primera opción, y quien no responda entregaría una respuesta
    ## que nunca dio (PLAN §H17).
    schoice = radioButtons(it$id, label = etiqueta, choiceNames = nombres,
                           choiceValues = valores, selected = sel),
    mchoice = checkboxGroupInput(it$id, label = etiqueta, choiceNames = nombres,
                                 choiceValues = valores, selected = sel),
    string  = textInput(it$id, label = etiqueta,
                        value = if (is.null(valor)) "" else as.character(valor)[1]),
    p(class = "lp-error", sprintf("tipo de ítem no soportado: %s", it$tipo)))

  div(class = "lp-item",
      div(class = "lp-puntos", sprintf("%s pts", format(it$puntos))),
      cuerpo)
}

pantalla_examen <- function(ex, respuestas = list(), reanudado = FALSE) {
  div(class = "lp-examen",
    div(class = "lp-barra",
      div(strong(ex$titulo), span(class = "lp-tenue", " · ", ex$subtitulo)),
      div(class = "lp-barra-dcha",
        span(class = "lp-guardado", id = "lp-guardado", ""),
        uiOutput("reloj", inline = TRUE))),
    div(class = "lp-contenido",
      if (reanudado) div(class = "lp-reanudado", icon("rotate-left"),
        " Se recuperaron las respuestas que ya había escrito. Continúe donde iba."),
      lapply(seq_along(ex$ejercicios), function(j) {
        e <- ex$ejercicios[[j]]
        div(class = "lp-ejercicio",
          div(class = "lp-ej-cabecera",
            span(class = "lp-ej-num", j),
            span(class = "lp-ej-tit", sprintf("Ejercicio %d", j)),
            span(class = "lp-ej-pts", sprintf("%s puntos", format(e$puntos)))),
          div(class = "lp-enunciado", HTML(e$enunciado)),
          div(class = "lp-items", lapply(e$items, function(it)
            control_item(it, respuestas[[it$id]]))))
      }),
      lapply(ex$abiertos, function(a) {
        div(class = "lp-ejercicio lp-abierto",
          div(class = "lp-ej-cabecera",
            span(class = "lp-ej-num", icon("pen")),
            span(class = "lp-ej-tit", "Sustentación"),
            span(class = "lp-ej-pts", sprintf("%s puntos", format(a$puntos)))),
          div(class = "lp-enunciado", HTML(a$enunciado)),
          textAreaInput(a$id, label = NULL, rows = 12, width = "100%",
                        value = as.character(respuestas[[a$id]] %||% ""),
                        placeholder = "Escriba aquí su respuesta."))
      }),
      div(class = "lp-cierre-zona",
        p(class = "lp-tenue",
          "Sus respuestas se guardan solas a medida que las escribe.
           Al enviar se cierra el examen y no podrá volver a entrar."),
        actionButton("enviar", "Enviar el examen", class = "btn btn-primary lp-boton"))))
}

pantalla_cierre <- function(hora, respondidos, total, motivo = "enviado") {
  div(class = "lp-centro",
    div(class = "lp-tarjeta",
      div(class = paste("lp-cabecera", if (motivo == "tiempo") "lp-tiempo" else "lp-ok"),
        h1(icon(if (motivo == "tiempo") "hourglass-end" else "circle-check"), " ",
           if (motivo == "tiempo") "Se acabó el tiempo" else "Examen recibido"),
        p(if (motivo == "tiempo")
            "Su examen se cerró y se guardó con lo que había respondido."
          else "Puede cerrar esta ventana.")),
      div(class = "lp-cuerpo",
        tags$dl(class = "lp-resumen",
          tags$dt("Hora de cierre"), tags$dd(hora),
          tags$dt("Respuestas registradas"), tags$dd(sprintf("%d de %d", respondidos, total))),
        p(class = "lp-tenue",
          "La calificación no se muestra aquí: el ejercicio de sustentación se
           revisa a mano y la nota se publica después.")))
  )
}

pantalla_desplazado <- function() {
  div(class = "lp-centro",
    div(class = "lp-tarjeta",
      div(class = "lp-cabecera lp-alerta",
        h1(icon("triangle-exclamation"), " Sesión abierta en otro lugar"),
        p("Este examen se abrió desde otro equipo o pestaña.")),
      div(class = "lp-cuerpo",
        p("Sus respuestas están guardadas. Continúe en la ventana que abrió de
           última; si no fue usted, avise al docente de inmediato."),
        p(class = "lp-tenue", "Esta ventana ya no registra cambios.")))
  )
}

pantalla_problema <- function(texto) {
  div(class = "lp-centro",
    div(class = "lp-tarjeta",
      div(class = "lp-cabecera lp-alerta",
        h1(icon("circle-exclamation"), " Algo salió mal"),
        p("No es culpa suya.")),
      div(class = "lp-cuerpo",
        p(texto),
        p(class = "lp-tenue", "Avise al docente. Lo que ya había respondido está guardado.")))
  )
}

# ==========================================================================
# Servidor
# ==========================================================================
server <- function(input, output, session) {
  ## Una caída breve de la red no puede costar el examen: la sesión sobrevive
  ## al corte y el navegador se reengancha al mismo proceso.
  ##
  ## Va en "force" y no en TRUE a propósito. Con TRUE, Shiny solo habilita la
  ## reconexión cuando lo sirve Shiny Server o Connect; bajo `runApp()` —que es
  ## como se va a desplegar— no hace nada, y se comprobó: tras cortar el socket
  ## la app se quedaba desconectada indefinidamente. "force" la habilita igual.
  ## Es una opción pensada para pruebas y aquí se usa en producción a sabiendas.
  ##
  ## OJO al desplegar: exige UN SOLO proceso de R, o sesiones pegajosas en el
  ## proxy. Con varios trabajadores la reconexión caería en otro proceso, que
  ## no conoce la sesión, y el estudiante volvería a la pantalla de acceso —de
  ## donde puede reanudar igual, porque las respuestas están en disco.
  session$allowReconnect("force")

  st <- reactiveValues(fase = "acceso", sid = NULL, examen = NULL, aviso = NULL,
                       cierre = NULL, cedula = "", token = NULL,
                       cat = NULL, reanudado = FALSE, observando = FALSE)

  # --- tiempo -------------------------------------------------------------
  ## El reloj es del servidor. El del cliente no se consulta nunca: adelantarlo
  ## sería la forma más fácil de darse tiempo extra.
  restante <- function() {
    s <- sesion_estado(st$sid)
    if (is.null(s)) return(NA_real_)
    limite <- (s$minutos * 60) + (s$extra_segundos %||% 0)
    limite - (epoch() - as.numeric(s$inicio_epoch))
  }

  output$reloj <- renderUI({
    req(st$fase == "examen")
    invalidateLater(1000, session)
    r <- restante()
    if (is.na(r)) return(NULL)
    r <- max(0, r)
    clase <- if (r <= 300) "lp-reloj lp-reloj-poco" else "lp-reloj"
    span(class = clase, icon("clock"), " ",
         sprintf("%02d:%02d", floor(r / 60), floor(r %% 60)))
  })

  # --- guardado -----------------------------------------------------------
  guardar_uno <- function(id, tipo) {
    if (is.null(st$sid) || !identical(st$fase, "examen")) return(invisible(NULL))
    v <- normalizar_valor(tipo, input[[id]])
    try(guardar_respuesta(st$sid, id, v), silent = TRUE)
    invisible(NULL)
  }

  volcar_todo <- function() {
    if (is.null(st$cat) || is.null(st$sid)) return(invisible(NULL))
    for (it in st$cat) guardar_uno(it$id, it$tipo)
    invisible(NULL)
  }

  ## Un observador por ítem, creados una sola vez al abrirse el examen.
  ## `local()` es imprescindible: sin él, todos los observadores capturarían la
  ## última iteración del bucle y todo el examen se guardaría en un solo campo.
  armar_autoguardado <- function(ex) {
    if (isTRUE(st$observando)) return(invisible(NULL))
    for (it in catalogo(ex)) local({
      idl <- it$id; tipol <- it$tipo
      ms <- if (tipol %in% c("schoice", "mchoice")) REBOTE_OPCION else REBOTE_TEXTO
      valor <- debounce(reactive(input[[idl]]), ms)
      observeEvent(valor(), guardar_uno(idl, tipol),
                   ignoreInit = TRUE, ignoreNULL = FALSE)
    })
    st$observando <- TRUE
    invisible(NULL)
  }

  ## Al salir de un campo, sin esperar el rebote.
  observeEvent(input$lp_salida_campo, {
    id <- input$lp_salida_campo$id
    tipo <- Filter(function(z) identical(z$id, id), st$cat %||% list())
    if (length(tipo)) guardar_uno(id, tipo[[1]]$tipo)
  }, ignoreInit = TRUE)

  ## Red de seguridad: cada 20 s se vuelca todo, por si algún rebote se perdió.
  observe({
    req(st$fase == "examen")
    invalidateLater(INSTANTANEA, session)
    isolate(volcar_todo())
  })

  # --- entrega ------------------------------------------------------------
  ## Se califica lo GUARDADO, no lo que hay en pantalla: si el tiempo vence con
  ## el navegador cerrado, el examen se cierra igual y con lo que alcanzó a
  ## escribirse.
  entregar <- function(motivo) {
    sid <- st$sid; ex <- st$examen
    if (is.null(sid) || is.null(ex)) return(invisible(NULL))
    isolate(volcar_todo())
    resp <- leer_respuestas(sid)

    clave <- cargar_clave(sid)
    if (is.null(falla(clave))) {
      res <- tryCatch(calificar_examen(resp, clave), error = function(e) NULL)
      if (!is.null(res)) {
        nota_guardar(res)
        anotar(sid, "entrega", sprintf("%s · cloze %.2f/%.2f", motivo,
                                       res$puntos_cloze, res$puntos_cloze_max))
      } else anotar(sid, "entrega_sin_calificar", motivo)
    } else anotar(sid, "entrega_sin_clave", motivo)

    sesion_cerrar(sid, motivo)
    n_items <- length(catalogo(ex))
    respondidos <- sum(vapply(resp, function(v)
      !is.null(v) && length(v) > 0 && !identical(trimws(paste(v, collapse = "")), ""),
      TRUE))
    st$cierre <- list(hora = format(Sys.time(), "%H:%M:%S"),
                      respondidos = respondidos, total = n_items, motivo = motivo)
    st$fase <- "cierre"
  }

  observeEvent(input$enviar, entregar("enviado"))

  ## Vencimiento. Se concede la gracia del blueprint para que la última tecla
  ## alcance a guardarse antes de cerrar.
  observe({
    req(st$fase == "examen", st$examen)
    invalidateLater(1000, session)
    r <- isolate(restante())
    gracia <- st$examen$gracia_segundos %||% 30
    if (!is.na(r) && r <= -gracia) isolate(entregar("tiempo"))
  })

  # --- sesión única con relevo -------------------------------------------
  observe({
    req(st$fase == "examen", st$sid, st$token)
    invalidateLater(LATIDO_SESION, session)
    actual <- isolate(sesion_token(st$sid))
    if (!is.na(actual) && !identical(actual, isolate(st$token))) {
      anotar(isolate(st$sid), "desplazado", "otra ventana tomó la sesión")
      isolate({ st$fase <- "desplazado" })
    }
  })

  # --- acceso -------------------------------------------------------------
  observeEvent(input$entrar, {
    ced <- normalizar_cedula(input$cedula %||% "")
    cod <- trimws(input$codigo %||% "")
    st$cedula <- input$cedula %||% ""

    if (!nchar(ced)) { st$aviso <- "Escriba su número de documento."; return() }
    if (!identical(cod, CODIGO)) {
      anotar(NULL, "acceso_fallido", "código incorrecto")
      st$aviso <- "El código del día no es correcto."; return()
    }
    sid <- sid_de(ced)
    ex  <- cargar_examen(sid)
    if (identical(falla(ex), "ausente")) {
      anotar(sid, "acceso_fallido", "sin examen para ese documento")
      st$aviso <- "Ese documento no tiene un examen asignado. Avise al docente."
      return()
    }
    if (identical(falla(ex), "corrupto")) {
      anotar(sid, "examen_corrupto", ex$mensaje %||% "")
      st$aviso <- paste("Su examen existe pero el archivo está dañado.",
                        "Avise al docente: hay que regenerarlo.")
      return()
    }
    prev <- sesion_estado(sid)
    if (!is.null(prev) && isTRUE(prev$entregado == 1)) {
      st$aviso <- "Este examen ya fue entregado."; return()
    }

    st$token <- sesion_tomar(sid, ex$minutos)
    st$sid <- sid; st$examen <- ex; st$cat <- catalogo(ex); st$aviso <- NULL

    ## Si el tiempo ya venció mientras estaba fuera, no se abre el examen: se
    ## cierra con lo que había. Volver a entrar no puede regalar minutos.
    if (!is.na(restante()) && restante() <= -(ex$gracia_segundos %||% 30)) {
      anotar(sid, "acceso_fuera_de_tiempo", "")
      entregar("tiempo"); return()
    }

    guardadas <- leer_respuestas(sid)
    st$reanudado <- length(guardadas) > 0L
    anotar(sid, if (st$reanudado) "reanuda" else "acceso",
           sprintf("%d respuesta(s) recuperada(s)", length(guardadas)))
    st$fase <- "examen"
  })

  ## Los observadores del autoguardado se arman cuando el examen ya está en
  ## pantalla, no antes: si se armaran contra campos inexistentes, el primer
  ## disparo guardaría NULL sobre lo que se acaba de recuperar.
  observeEvent(st$fase, {
    if (identical(st$fase, "examen")) armar_autoguardado(st$examen)
  })

  session$onSessionEnded(function() {
    isolate(if (!is.null(st$sid)) anotar(st$sid, "desconecta", st$fase))
  })

  # --- pintar -------------------------------------------------------------
  ## Ningún camino puede terminar en pantalla en blanco: si algo revienta al
  ## construir la interfaz, el estudiante ve un mensaje y el docente un evento.
  output$pantalla <- renderUI({
    tryCatch({
      switch(st$fase,
        acceso     = pantalla_acceso(st$aviso, st$cedula %||% ""),
        examen     = pantalla_examen(st$examen, leer_respuestas(st$sid), st$reanudado),
        cierre     = pantalla_cierre(st$cierre$hora, st$cierre$respondidos,
                                     st$cierre$total, st$cierre$motivo),
        desplazado = pantalla_desplazado(),
        pantalla_problema("No se pudo determinar el estado de su examen."))
    }, error = function(e) {
      anotar(st$sid, "error_interfaz", conditionMessage(e))
      pantalla_problema("No se pudo mostrar el examen.")
    })
  })
}

shinyApp(ui, server)
