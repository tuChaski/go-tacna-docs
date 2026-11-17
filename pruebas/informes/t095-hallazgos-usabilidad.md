# T095 — Informe de hallazgos de usabilidad y ajustes UI post-prueba

> **Estado:** En revisión
> **Responsable:** Edison Catari
> **Relacionado:** [T095](https://github.com/tuChaski/go-tacna-frontend/issues/51), [T054](t054-pruebas-usabilidad-figma.md), [../plan-de-pruebas.md](../plan-de-pruebas.md), [../matriz-de-trazabilidad.md](../matriz-de-trazabilidad.md), [flujo de tres toques](../../diseno/flujo-navegacion-pasajero.md)

## 1. Resumen de la evaluación de calidad (QA)

A partir de la revisión recorrida en [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md) sobre los prototipos de **Go-Tacna** (ejecutada con 25 casos de prueba `PRB-001` a `PRB-025`), este informe consolida las métricas de cumplimiento navegacional, clasifica los defectos de interfaz detectados por severidad y define los ajustes UI requeridos en Figma, `go-tacna-frontend` y `go-tacna-movil` antes de las pruebas en dispositivos físicos (`T103`, `T074`).

| Indicador evaluado | Resultado obtenido | Meta de calidad |
|---|---|---|
| Casos de prueba evaluados (`PRB-001` a `PRB-025`) | 25 casos (11 Pasajero, 6 Acceso/Modo Conductor, 8 Panel Admin) | 100 % de flujos principales cubiertos |
| Casos comprobados sin observaciones | 20 de 25 (80 %) | >= 80 % en primera iteración |
| Casos con observación o visualización manual | 3 de 25 (`PRB-016`, `PRB-023`, `PRB-025`) | Corrección antes de cierre de fase |
| Casos por corregir (bloqueo de transición) | 2 de 25 (`PRB-015`, `PRB-017`) | 0 bloqueos en flujo operativo |
| Cumplimiento de la regla de máximo 3 toques (`Ruta -> Micro -> Ubicación`) | **3 toques exactos** en los 6 escenarios de pasajero e invitado (`PRB-001`, `PRB-003`, `PRB-004`, `PRB-005`) | Máximo 3 toques (`RNF-01`/`RNF-02` y `RNF-04` en cronograma) |

---

## 2. Matriz de hallazgos de usabilidad (`HLZ-001` a `HLZ-006`)

| ID Hallazgo | Caso origen | Perfil / Módulo | Severidad | Descripción del problema detectado | Ajuste UI requerido |
|---|---|---|---|---|---|
| `HLZ-001` | `PRB-015` (`RF-12`) | Conductor (Modo Conductor) | **Alta** | Al pulsar «INICIAR RECORRIDO» desde «Todo listo para salir», el prototipo no avanza al diálogo de confirmación ni transiciona a «Recorrido activo» sin usar los controles del reproductor. | Vincular el evento *On tap* de «INICIAR RECORRIDO» al modal de confirmación y conectar su botón de aceptación hacia el marco «Recorrido activo». Conectar también «Cancelar» para retornar al estado previo. |
| `HLZ-002` | `PRB-017` (`RF-14`) | Conductor (Modo Conductor) | **Alta** | Los botones «FINALIZAR RECORRIDO» (en recorrido activo) y «Volver al inicio» (en recorrido finalizado) no ejecutan la transición entre marcos al pulsarlos. | Conectar la secuencia completa `Recorrido activo -> Confirmar fin -> Recorrido finalizado -> Todo listo para salir` usando únicamente botones interactivos de la interfaz. |
| `HLZ-003` | `PRB-023` (`RF-16`) | Administrador (Panel Web) | **Alta** | Al intentar cambiar el conductor asignado al `Micro 024` mientras está en recorrido, el modal de bloqueo muestra el título «No se puede desactivar ahora», generando confusión respecto a la acción solicitada. | Sustituir el título del diálogo por **«No se puede cambiar el conductor mientras el micro está en recorrido»**, manteniendo la indicación de finalizar primero el servicio. |
| `HLZ-004` | `PRB-025` (`RF-17`) | Administrador (Monitoreo) | **Alta** | Cuando falla «Actualizar datos» en Monitoreo, el aviso informa que la posición perdió vigencia, pero la tarjeta inferior sigue mostrando «GPS activo» y «hace 3 s». | Cambiar el estado visual de la tarjeta en segundo plano a **«Última ubicación conocida»** con el tiempo transcurrido (>= 2 minutos según `RN-04`) y ocultar el indicador verde de transmisión activa. |
| `HLZ-005` | `PRB-001`, `PRB-006`, `PRB-011` (`RF-06`, `RF-08`) | Pasajero / Invitado (Mapa) | **Media** | En el mapa inicial el botón azul de `Línea 10` aparenta estar ya seleccionado y los marcadores son visibles desde el inicio; además, el texto «Actualizado hace…» tiene bajo contraste y conviene mantener visible el paradero junto al tiempo estimado de llegada (ETA). | Diferenciar el estilo de botón en reposo frente a línea activa, elevar el contraste de la antigüedad del dato (mínimo relación 4.5:1) y fijar la etiqueta del paradero (ej. `Plaza de Armas · 3 min aprox.`). |
| `HLZ-006` | `PRB-013`, `PRB-021` (`RF-02`, `RF-16`) | Acceso Pasajero y Panel Micros | **Media** | Tras iniciar sesión como pasajero (`PRB-013`), el encabezado del mapa conserva la denominación antigua «RutaTacna». En el listado de micros (`PRB-021`), falta explicitar «Sin conductor asignado» y «Registro habilitado». | Actualizar el encabezado a **«Go-Tacna»**, agregar acceso directo «Consultar sin cuenta» desde la bienvenida inicial y mostrar etiquetas explícitas de asignación y estado en la tabla de micros. |

---

## 3. Ajustes UI verificados en diseño y web

En coordinación con el área de UI/UX (`T093` y `T056`/`T059`), se registran los siguientes ajustes ya incorporados sobre las vistas del proyecto:

1. **Simplificación del flujo de 3 toques (`T093`):** Se depuraron pantallas redundantes en Figma dejando un único `Flow 1` con 50 pantallas alcanzables, ordenando el selector de paraderos con la acción `Cancelar` al final y vinculando `Cambiar punto de espera` al micro activo (`Micro 01`, `Micro 02` o `Micro 03`).
2. **Claridad en el tiempo estimado de llegada (`RN-08`):** Los textos de las tarjetas de pasajero expresan el cálculo en minutos aproximados (`3 min aprox.`, `4 min aprox.`) vinculados explícitamente al punto de espera elegido (`Plaza de Armas` o `Av. Pinto`), evitando presentarlo como una hora garantizada.
3. **Validación de formularios en `go-tacna-frontend` (`T056`, `T059`):** En la plataforma web desplegada se integró la validación de campos vacíos, mensajes de credenciales inválidas sin exponer existencia de correos (`PRB-014`) y confirmación modal antes de dar de baja registros administrativos.

---

## 4. Criterio de verificación para el cierre de usabilidad (`T103` y `T074`)

Para dar por cerrados los hallazgos `HLZ-001` a `HLZ-006` en la siguiente iteración, QA comprobará:

1. **Re-ejecución de `PRB-015` y `PRB-017`:** Completar el inicio y la finalización del recorrido del `Micro 024` en el Modo Conductor sin utilizar las flechas del reproductor de Figma.
2. **Re-ejecución de `PRB-023` y `PRB-025`:** Confirmar que los textos de bloqueo en Micros y el estado de tarjeta vencida en Monitoreo coincidan con la acción ejecutada.
3. **Sesiones con usuarios y prueba en Android físico (`T074`, `T103`):** Completar la tabla de participantes prevista en [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md) midiendo número de toques, desvíos y tiempo en segundos con usuarios que abren la interfaz por primera vez.