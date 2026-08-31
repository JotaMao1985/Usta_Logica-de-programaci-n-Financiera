# ============================================================================
# Ejercicios de traza (E1) del parcial
#
# La prueba de escritorio es el método central del capítulo 3 y NO cabe en un
# cloze: exige una tabla donde el estudiante reconstruye el estado de cada
# variable después de cada instrucción, y donde una celda vale por saber que
# una variable TODAVÍA NO tiene valor.
#
# Cada traza es una función de una semilla, igual que los ejercicios de
# R/exams: la misma persona recibe siempre la misma, y dos personas nunca la
# misma. Las cifras se eligen para que la prueba de escritorio dé números
# exactos: un desk-check con decimales periódicos evalúa la calculadora, no
# el razonamiento.
#
# `ocultas_desde` dice, por columna, en qué fila esa variable recibe su primer
# valor. A partir de ahí se ocultan TODAS las celdas de esa columna.
#
# Ocultar solo la primera dejaba el valor a la vista en la fila siguiente —la
# columna arrastra el mismo número— y el ejercicio se resolvía copiando hacia
# arriba, sin trazar nada. Las filas anteriores, las de «—», se dejan visibles:
# son información gratis y ahorran una decena de casillas.
#
# El arrastre trae su propio problema: si el estudiante se equivoca en la
# primera celda, las tres siguientes heredan el error y un solo desliz cuesta
# los quince puntos. Por eso la clave marca cada celda arrastrada con el
# `id` de la que la origina, y `calificar.R` da por buena la celda que sea
# coherente con la respuesta que el propio estudiante dio antes. Es lo que
# hace un corrector humano y se llama error de arrastre.
# ============================================================================

fmt <- function(x) formatC(x, format = "f", digits = 0, big.mark = ".", decimal.mark = ",")

TRAZAS <- list(

  # ------------------------------------------------------------------------
  liquidacion_nomina = function(seed) {
    set.seed(seed)
    ## Múltiplo de 300.000 para que sueldo/30 sea múltiplo de 10.000 y todas
    ## las cifras derivadas queden enteras.
    sueldo <- sample(seq(1200000, 4200000, by = 300000), 1)
    dias   <- sample(12:28, 1)
    aux    <- 162000

    devengado <- sueldo / 30 * dias
    salud     <- devengado * 0.04
    pension   <- devengado * 0.04
    neto      <- devengado + aux - salud - pension

    codigo <- list(
      pseudo = sprintf(
"Inicio
    sueldo    <- %s
    dias      <- %d
    aux       <- %s

    devengado <- sueldo / 30 * dias
    salud     <- devengado * 0.04
    pension   <- devengado * 0.04
    neto      <- devengado + aux - salud - pension

    Escribir neto
Fin", fmt(sueldo), dias, fmt(aux)),
      python = sprintf(
"sueldo = %d
dias = %d
aux = %d

devengado = sueldo / 30 * dias
salud = devengado * 0.04
pension = devengado * 0.04
neto = devengado + aux - salud - pension

print(neto)", sueldo, dias, aux),
      r = sprintf(
"sueldo <- %d
dias <- %d
aux <- %d

devengado <- sueldo / 30 * dias
salud <- devengado * 0.04
pension <- devengado * 0.04
neto <- devengado + aux - salud - pension

cat(neto)", sueldo, dias, aux),
      vba = sprintf(
"Dim sueldo As Double, dias As Integer, aux As Double
Dim devengado As Double, salud As Double, pension As Double, neto As Double

sueldo = %d
dias = %d
aux = %d

devengado = sueldo / 30 * dias
salud = devengado * 0.04
pension = devengado * 0.04
neto = devengado + aux - salud - pension

Debug.Print neto", sueldo, dias, aux))

    v <- "—"
    list(
      nombre = "liquidacion_nomina",
      titulo = "Prueba de escritorio · liquidación de nómina",
      enunciado = paste0(
        "<p>El área de nómina liquida el pago quincenal de un empleado con la rutina ",
        "secuencial de abajo. Los descuentos de <strong>salud</strong> y <strong>pensión",
        "</strong> son del 4 % cada uno y se calculan sobre lo devengado; el auxilio de ",
        "transporte <strong>no</strong> hace parte de la base de esos descuentos.</p>",
        "<p>Complete la tabla con el valor de cada variable <em>después</em> de ejecutar ",
        "la instrucción de esa fila. Escriba <code>—</code> si la variable todavía no ",
        "tiene valor. No use separadores de miles.</p>"),
      codigo = codigo,
      columnas = list(
        list(clave = "paso",        titulo = "#"),
        list(clave = "instruccion", titulo = "Instrucción"),
        list(clave = "devengado",   titulo = "devengado"),
        list(clave = "salud",       titulo = "salud"),
        list(clave = "pension",     titulo = "pension"),
        list(clave = "neto",        titulo = "neto")),
      filas = list(
        list(paso="1", instruccion="sueldo <- ...",    devengado=v, salud=v, pension=v, neto=v),
        list(paso="2", instruccion="dias <- ...",      devengado=v, salud=v, pension=v, neto=v),
        list(paso="3", instruccion="aux <- ...",       devengado=v, salud=v, pension=v, neto=v),
        list(paso="4", instruccion="devengado <- sueldo / 30 * dias",
             devengado=as.character(devengado), salud=v, pension=v, neto=v),
        list(paso="5", instruccion="salud <- devengado * 0.04",
             devengado=as.character(devengado), salud=as.character(salud), pension=v, neto=v),
        list(paso="6", instruccion="pension <- devengado * 0.04",
             devengado=as.character(devengado), salud=as.character(salud),
             pension=as.character(pension), neto=v),
        list(paso="7", instruccion="neto <- devengado + aux - salud - pension",
             devengado=as.character(devengado), salud=as.character(salud),
             pension=as.character(pension), neto=as.character(neto))),
      ocultas_desde = list(devengado = 4L, salud = 5L, pension = 6L, neto = 7L),
      tolerancia = 1)
  },

  # ------------------------------------------------------------------------
  interes_simple = function(seed) {
    set.seed(seed)
    capital  <- sample(seq(5, 40, by = 5), 1) * 1000000
    tasa_pct <- sample(c(1.0, 1.5, 2.0, 2.5), 1)
    plazo    <- sample(c(6, 12, 18, 24), 1)

    tasa    <- tasa_pct / 100
    interes <- capital * tasa * plazo
    total   <- capital + interes
    cuota   <- total / plazo

    codigo <- list(
      pseudo = sprintf(
"Inicio
    capital <- %s
    tasa    <- %s        // porcentaje MENSUAL
    plazo   <- %d        // meses

    interes <- capital * (tasa / 100) * plazo
    total   <- capital + interes
    cuota   <- total / plazo

    Escribir cuota
Fin", fmt(capital), format(tasa_pct, nsmall = 1), plazo),
      python = sprintf(
"capital = %d\ntasa = %s\nplazo = %d\n\ninteres = capital * (tasa / 100) * plazo\ntotal = capital + interes\ncuota = total / plazo\n\nprint(cuota)",
        capital, format(tasa_pct, nsmall = 1), plazo),
      r = sprintf(
"capital <- %d\ntasa <- %s\nplazo <- %d\n\ninteres <- capital * (tasa / 100) * plazo\ntotal <- capital + interes\ncuota <- total / plazo\n\ncat(cuota)",
        capital, format(tasa_pct, nsmall = 1), plazo),
      vba = sprintf(
"Dim capital As Double, tasa As Double, plazo As Integer\nDim interes As Double, total As Double, cuota As Double\n\ncapital = %d\ntasa = %s\nplazo = %d\n\ninteres = capital * (tasa / 100) * plazo\ntotal = capital + interes\ncuota = total / plazo\n\nDebug.Print cuota",
        capital, format(tasa_pct, nsmall = 1), plazo))

    v <- "—"
    list(
      nombre = "interes_simple",
      titulo = "Prueba de escritorio · crédito con interés simple",
      enunciado = paste0(
        "<p>Una entidad liquida un crédito de libre inversión con interés <strong>simple",
        "</strong>. La tasa se digita en <strong>porcentaje mensual</strong>, de modo que ",
        "la rutina la convierte dividiendo entre 100.</p>",
        "<p>Complete la tabla con el valor de cada variable <em>después</em> de ejecutar ",
        "la instrucción de esa fila. Escriba <code>—</code> si la variable todavía no ",
        "tiene valor. No use separadores de miles.</p>"),
      codigo = codigo,
      columnas = list(
        list(clave = "paso",        titulo = "#"),
        list(clave = "instruccion", titulo = "Instrucción"),
        list(clave = "interes",     titulo = "interes"),
        list(clave = "total",       titulo = "total"),
        list(clave = "cuota",       titulo = "cuota")),
      filas = list(
        list(paso="1", instruccion="capital <- ...", interes=v, total=v, cuota=v),
        list(paso="2", instruccion="tasa <- ...",    interes=v, total=v, cuota=v),
        list(paso="3", instruccion="plazo <- ...",   interes=v, total=v, cuota=v),
        list(paso="4", instruccion="interes <- capital * (tasa / 100) * plazo",
             interes=as.character(interes), total=v, cuota=v),
        list(paso="5", instruccion="total <- capital + interes",
             interes=as.character(interes), total=as.character(total), cuota=v),
        list(paso="6", instruccion="cuota <- total / plazo",
             interes=as.character(interes), total=as.character(total),
             cuota=as.character(cuota))),
      ocultas_desde = list(interes = 4L, total = 5L, cuota = 6L),
      tolerancia = 1)
  }
)
