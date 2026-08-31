#!/usr/bin/env bash
# ============================================================================
# Simulacro · genera y arranca el ensayo general
#
#   export LPF_PEPPER="…"                  el MISMO del parcial
#   ./parcial/despliegue/simulacro.sh generar --roster roster.csv
#   ./parcial/despliegue/simulacro.sh arrancar
#
# Todo lo del simulacro vive en carpetas y base de datos APARTE. No es
# pulcritud: si el ensayo escribiera en la base del parcial, el día del examen
# treinta personas aparecerían como «ya entregó» y no podrían entrar.
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")/../.."

: "${LANG:=es_ES.UTF-8}"; export LANG
export LPF_SALIDA="$PWD/parcial/salida_simulacro"
export LPF_BD="$PWD/parcial/app/datos/simulacro.sqlite"
export LPF_BITACORA="$PWD/parcial/app/datos/eventos_simulacro.jsonl"
: "${LPF_CODIGO:=SIMULACRO}"; export LPF_CODIGO
: "${LPF_PANEL_CLAVE:=panel-simulacro}"; export LPF_PANEL_CLAVE

accion="${1:-arrancar}"; shift || true

case "$accion" in
  generar)
    echo "  Generando el simulacro en $LPF_SALIDA"
    Rscript parcial/generar.R --blueprint parcial/blueprint_simulacro.yml \
            --out "$LPF_SALIDA" "$@"
    ;;
  arrancar)
    echo "  ── Comprobación previa (simulacro) ──────────────────"
    Rscript parcial/despliegue/comprobar.R || {
      echo "  Revise lo anterior. En el simulacro puede continuar bajo su"
      echo "  responsabilidad; el día del parcial, no."
      exit 1; }
    echo "  ── Arrancando ───────────────────────────────────────"
    R -e "shiny::runApp('parcial/app', port=8080, host='0.0.0.0', launch.browser=FALSE)" \
      > parcial/app/datos/simulacro_examen.log 2>&1 &
    echo "  examen → http://0.0.0.0:8080   (pid $!)   código: $LPF_CODIGO"
    R -e "shiny::runApp('parcial/panel', port=8899, host='127.0.0.1', launch.browser=FALSE)" \
      > parcial/app/datos/simulacro_panel.log 2>&1 &
    echo "  panel  → http://127.0.0.1:8899 (pid $!)   clave:  $LPF_PANEL_CLAVE"
    wait
    ;;
  *)
    echo "  uso: $0 [generar|arrancar]"; exit 1 ;;
esac
