#!/usr/bin/env bash
# ============================================================================
# El pepper: crearlo una vez, no perderlo nunca.
#
#   source ./parcial/despliegue/pepper.sh          # lo carga (lo crea si no existe)
#
# Por qué existe este guion en vez de un `export` a mano:
#
#   Si el día del parcial la app arranca con un pepper distinto del que generó
#   los exámenes, calcula otros identificadores y NO ENTRA NADIE — mientras
#   todo lo demás se ve perfectamente normal. Y si el pepper se pierde, los
#   exámenes ya generados quedan inservibles: no hay forma de recalcular a qué
#   estudiante corresponde cada archivo.
#
#   Así que se guarda una sola vez, fuera del repositorio, con permisos 600, y
#   este guion se niega a sobrescribirlo.
# ============================================================================
set -euo pipefail

ARCHIVO="${LPF_PEPPER_FILE:-$HOME/.config/lpf/pepper}"

if [ -f "$ARCHIVO" ]; then
  LPF_PEPPER="$(cat "$ARCHIVO")"
  export LPF_PEPPER
  echo "  pepper cargado de $ARCHIVO"
  echo "  huella: $(printf '%s' "$LPF_PEPPER" | shasum -a 256 | cut -c1-16)…"
else
  mkdir -p "$(dirname "$ARCHIVO")"
  umask 077
  openssl rand -hex 32 > "$ARCHIVO"
  chmod 600 "$ARCHIVO"
  LPF_PEPPER="$(cat "$ARCHIVO")"
  export LPF_PEPPER
  echo "  pepper NUEVO creado en $ARCHIVO (permisos 600)"
  echo "  huella: $(printf '%s' "$LPF_PEPPER" | shasum -a 256 | cut -c1-16)…"
  echo
  echo "  ⚠ Cópielo a un segundo lugar seguro AHORA — un gestor de contraseñas."
  echo "    Si este archivo se pierde, los exámenes generados con él no se"
  echo "    pueden volver a asociar con ningún estudiante."
fi
