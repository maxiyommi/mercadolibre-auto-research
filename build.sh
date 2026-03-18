#!/bin/bash
# Regenera el archivo .skill desde SKILL.md
# Uso: ./build.sh

SKILL_NAME="mercadolibre-auto-research"
SKILL_FILE="${SKILL_NAME}.skill"

rm -f "$SKILL_FILE"
mkdir -p "/tmp/${SKILL_NAME}"
cp SKILL.md "/tmp/${SKILL_NAME}/SKILL.md"
(cd /tmp && zip -r - "${SKILL_NAME}/SKILL.md") > "$SKILL_FILE"
rm -rf "/tmp/${SKILL_NAME}"

echo "Generado: ${SKILL_FILE}"
