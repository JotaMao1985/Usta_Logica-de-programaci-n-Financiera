#!/usr/bin/env bash
# ============================================================================
# Arranque del parcial. Comprueba primero y arranca después.
#
#   ./parcial/despliegue/arrancar.sh
#
# Si la comprobación falla, NO arranca. Esa es toda la gracia: el día del
# parcial no se decide si un aviso importa o no.
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")/../.."

: "${LANG:=es_ES.UTF-8}"; export LANG
: "${LPF_PUERTO_EXAMEN:=8080}"
: "${LPF_PUERTO_PANEL:=8899}"

echo
echo "  ── Comprobación previa ──────────────────────────────"
if ! Rscript parcial/despliegue/comprobar.R; then
  echo "  No se arranca. Corrija lo anterior y vuelva a ejecutar."
  exit 1
fi

echo "  ── Arrancando ───────────────────────────────────────"
# El examen escucha en todas las interfaces; el panel SOLO en localhost.
# Al panel se llega por túnel:  ssh -N -L 8899:127.0.0.1:8899 usuario@servidor
R -e "shiny::runApp('parcial/app', port=${LPF_PUERTO_EXAMEN}, host='0.0.0.0', launch.browser=FALSE)" \
  > parcial/app/datos/examen.log 2>&1 &
echo "  examen  → http://0.0.0.0:${LPF_PUERTO_EXAMEN}   (pid $!)"

R -e "shiny::runApp('parcial/panel', port=${LPF_PUERTO_PANEL}, host='127.0.0.1', launch.browser=FALSE)" \
  > parcial/app/datos/panel.log 2>&1 &
echo "  panel   → http://127.0.0.1:${LPF_PUERTO_PANEL}  (pid $!)  [solo por túnel SSH]"
echo
echo "  Registros: parcial/app/datos/{examen,panel}.log"
echo "  Para detener: kill %1 %2"
wait
