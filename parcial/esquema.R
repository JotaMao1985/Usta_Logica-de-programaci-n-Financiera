# ============================================================================
# Esquema de la base de datos del parcial · fuente ÚNICA
#
# Lo comparten la app del examen y el panel docente. Estuvo duplicado durante
# media hora y el resultado fue inmediato: el panel consultaba `ts_epoch`, una
# columna que solo creaba la otra app, y se quedaba en blanco. Dos programas
# que hablan por una base de datos no pueden tener dos ideas de cómo es.
#
#   source("parcial/esquema.R"); con_bd(esquema)
# ============================================================================

asegurar_columna <- function(con, tabla, col, tipo, defecto = NULL) {
  cols <- DBI::dbGetQuery(con, sprintf("PRAGMA table_info(%s)", tabla))$name
  if (!col %in% cols) {
    DBI::dbExecute(con, sprintf("ALTER TABLE %s ADD COLUMN %s %s%s", tabla, col, tipo,
                                if (is.null(defecto)) "" else paste(" DEFAULT", defecto)))
  }
  invisible(NULL)
}

esquema <- function(con) {
  DBI::dbExecute(con, "PRAGMA journal_mode=WAL")
  DBI::dbExecute(con, "PRAGMA busy_timeout=8000")

  DBI::dbExecute(con, "CREATE TABLE IF NOT EXISTS sesiones (
    sid TEXT PRIMARY KEY, inicio TEXT NOT NULL, fin TEXT,
    entregado INTEGER NOT NULL DEFAULT 0, minutos INTEGER)")
  DBI::dbExecute(con, "CREATE TABLE IF NOT EXISTS respuestas (
    sid TEXT NOT NULL, item TEXT NOT NULL, valor TEXT, ts TEXT NOT NULL,
    PRIMARY KEY (sid, item))")
  DBI::dbExecute(con, "CREATE TABLE IF NOT EXISTS eventos (
    id INTEGER PRIMARY KEY AUTOINCREMENT, sid TEXT, tipo TEXT, detalle TEXT, ts TEXT)")
  DBI::dbExecute(con, "CREATE TABLE IF NOT EXISTS notas (
    sid TEXT PRIMARY KEY, puntos REAL, puntos_max REAL, nota REAL,
    provisional INTEGER, calculada TEXT, detalle TEXT)")
  DBI::dbExecute(con, "CREATE TABLE IF NOT EXISTS manuales (
    sid TEXT NOT NULL, item TEXT NOT NULL, puntos REAL, ts TEXT,
    PRIMARY KEY (sid, item))")

  ## Columnas añadidas después. Se migran en vez de recrear la tabla: durante
  ## el parcial, borrar una tabla para cambiarle una columna sería borrar el
  ## examen de alguien.
  ##
  ## NO se intenta deducir `inicio_epoch` de la cadena `inicio`: SQLite no
  ## parsea el desfase horario («-0500») y devolvía NULL en silencio, dejando
  ## la sesión sin cronómetro. Se vuelve a sellar en `sesion_tomar()`.
  asegurar_columna(con, "sesiones", "inicio_epoch", "REAL")
  asegurar_columna(con, "sesiones", "token", "TEXT")
  asegurar_columna(con, "sesiones", "extra_segundos", "INTEGER", "0")
  asegurar_columna(con, "sesiones", "motivo_cierre", "TEXT")
  asegurar_columna(con, "respuestas", "ts_epoch", "REAL")
  invisible(NULL)
}
