#!/usr/bin/env bash
set -e
titles=(
"[API] Barista Bot: Iniciar Pedido lleva a Moliendo|REQ-BARISTA-01"
"[API] Barista Bot: Terminar Molienda lleva a Calentando Agua|REQ-BARISTA-02"
"[API] Barista Bot: Alcanzar Temperatura lleva a Sirviendo|REQ-BARISTA-03"
"[API] Barista Bot: Terminar Llenado lleva a En Espera|REQ-BARISTA-04"
"[API] Barista Bot: Sin Ingredientes lleva a Error de Insumos|REQ-BARISTA-05"
"[API] Barista Bot: Recargar y Reiniciar lleva a En Espera|REQ-BARISTA-06"
"[API] Barista Bot: transiciones inválidas bloqueadas|REQ-BARISTA-07"
"[API] Invernadero: definición con 3 condiciones y 4 reglas|REQ-INVERNADERO-00"
"[API] Invernadero: Regla 1 helada|REQ-INVERNADERO-01"
"[API] Invernadero: Regla 2 riego estándar|REQ-INVERNADERO-02"
"[API] Invernadero: Regla 3 pH ácido|REQ-INVERNADERO-03"
"[API] Invernadero: Regla 4 en espera|REQ-INVERNADERO-04"
)
gh label create "status:passed" --color 0E8A16 --force
gh label create "status:failed" --color D93F0B --force
n=1
for item in "${titles[@]}"; do
  title="${item%%|*}"
  req="${item##*|}"
  body="**Requisito:** ${req}
**Tag del escenario:** @Issue-${n}
**Técnica:** caja negra
**Archivo:** src/test/resources/features"
  gh issue create --title "$title" --body "$body"
  n=$((n+1))
done
