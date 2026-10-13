# Test Plan: APIs de caja negra (Karate)

## Objetivo
Validar el comportamiento de dos APIs por caja negra y automatizar los casos con Karate.

## Alcance
- Barista Bot: máquina de estados (técnica de transición de estados).
- Invernadero hidropónico: reglas de control (técnica de tabla de decisión).

## Entorno
- Base URL: https://taller-de-tecnicas-de-prueba-de-caja.onrender.com/api
- Herramientas: Karate 1.4.1, JUnit 5, Gradle, JDK 17 o 21, GitHub Actions.

## Estrategia
- Cada escenario reinicia el sistema antes de ejecutar.
- Cada escenario lleva tag `@Issue-N` ligado a un Issue de GitHub.
- Pipeline: push ejecuta `@smoketest`. Ejecución manual acepta cualquier tag.

## Casos
| Issue | Requisito | Caso | Técnica |
|---|---|---|---|
| 1 | REQ-BARISTA-01 | Iniciar pedido: En Espera a Moliendo | Transición |
| 2 | REQ-BARISTA-02 | Terminar molienda: a Calentando Agua | Transición |
| 3 | REQ-BARISTA-03 | Alcanzar temperatura: a Sirviendo | Transición |
| 4 | REQ-BARISTA-04 | Terminar llenado: vuelve a En Espera | Transición |
| 5 | REQ-BARISTA-05 | Sin ingredientes: a Error de Insumos | Transición |
| 6 | REQ-BARISTA-06 | Recargar y reiniciar: a En Espera | Transición |
| 7 | REQ-BARISTA-07 | Bloquear transiciones no permitidas | Transición |
| 8 | REQ-INVERNADERO-00 | Definición expone 3 condiciones y 4 reglas | Tabla de decisión |
| 9 | REQ-INVERNADERO-01 | Regla 1: helada activa calefactores, suspende riego | Tabla de decisión |
| 10 | REQ-INVERNADERO-02 | Regla 2: sustrato seco inicia riego estándar | Tabla de decisión |
| 11 | REQ-INVERNADERO-03 | Regla 3: seco con pH ácido bloquea riego y neutraliza | Tabla de decisión |
| 12 | REQ-INVERNADERO-04 | Regla 4: sin condiciones mantiene sistemas en espera | Tabla de decisión |

## Criterios
- Entrada: API disponible, proyecto compila.
- Salida: 12 escenarios en verde, reporte en `target/karate-reports`.

## Riesgos
- API en Render puede tardar en despertar: timeouts de 30 s configurados.
