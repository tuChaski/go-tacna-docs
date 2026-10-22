# T093: flujo directo de navegación del pasajero

> **Estado:** En revisión
> **Responsable:** Alex Huaracha
> **Relacionado:** [Figma](figma.md), [Inventario de vistas](inventario-de-vistas.md), [Requerimientos no funcionales](../requisitos/requerimientos-no-funcionales.md), T051

## Objetivo

Diseñar el acceso directo desde la pantalla principal hasta la ubicación del micro seleccionado en un máximo de tres toques: Ruta → Micro → Ubicación. El flujo debe ser comprensible para personas con poca experiencia tecnológica, de acuerdo con el alcance de T093 en el cronograma [1].

## Flujo implementado

| Toque | Acción | Resultado |
| --- | --- | --- |
| 0 | Iniciar `Flow 1` en el mapa principal | Inicio del conteo |
| 1 | Seleccionar `Línea 10` | Ver los micros de la línea |
| 2 | Seleccionar `Micro 01`, `Micro 02` o `Micro 03` | Abrir el detalle del micro elegido |
| 3 | Seleccionar `Ver ubicación` | Abrir su ubicación en vivo |

El recorrido se puede realizar como pasajero o invitado, sin iniciar sesión. Los tiempos iniciales del prototipo corresponden al punto de espera Plaza de Armas.

## Ajustes realizados

- Se simplificaron los textos para explicar la llegada aproximada y el punto al que corresponde.
- Se aclararon las acciones de los botones y los mensajes de recuperación ante errores.
- Se ordenaron las opciones del punto de espera y se colocó `Cancelar` al final.
- `Cambiar punto de espera` abre la selección correspondiente al micro elegido.
- Se retiraron pantallas redundantes. Quedaron 50 pantallas de la app, un solo `Flow 1` y dos referencias de lectura sin conexiones.

## Verificación del prototipo

Se revisaron las conexiones, los controles visibles y las condiciones del estado local de Figma. El resultado corresponde al diseño interactivo; no es una prueba con usuarios ni en dispositivos físicos.

| Acceso | Micro 01 | Micro 02 | Micro 03 |
| --- | --- | --- | --- |
| Pasajero | 3 toques; cumple | 3 toques; cumple | 3 toques; cumple |
| Invitado | 3 toques; cumple | 3 toques; cumple | 3 toques; cumple |

Controles adicionales: las 50 pantallas de la app son alcanzables desde `Flow 1` mediante las ramas correspondientes; no se detectaron destinos inexistentes ni conexiones con las referencias de lectura. En las seis combinaciones de acceso y micro, la acción de cambiar el punto de espera abre el selector del micro correcto. Las pantallas privadas conservan el requisito de iniciar sesión.

## Evidencia

- [Mapa principal e inicio de Flow 1](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-16325).
- [Línea 10 y selección del micro](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-16488).
- [Detalle del Micro 01](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-16584).
- [Ubicación del Micro 01](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-16670).
- [Página 04 Passenger App](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=73-1148).

## Cierre

T093 se da por completada en la etapa de diseño del prototipo: los seis casos representados cumplen la regla de tres toques. La validación en Android físico corresponde a T103 y las pruebas de usabilidad con personas, a T074 [1].

## Observación de trazabilidad

El cronograma fuente [1] llama RNF-04 al requisito de usabilidad y navegación en tres toques. En la versión actual de `requisitos/requerimientos-no-funcionales.md` de este repositorio, RNF-04 corresponde a actualización de ubicación, mientras usabilidad y navegabilidad figuran como RNF-01 y RNF-02. Se debe acordar la numeración con el responsable de requisitos antes de aprobar este documento. Esta diferencia de identificadores no cambia el resultado de diseño descrito arriba.

## Referencias

1. `web_bus (2)(1).pdf`: RNF-04, páginas 42–43 del PDF; T093 y dependencia T051, página 71; T103, página 82; T074, página 84.
2. `GUIA TF.pdf`: arquitectura de contenido 1.8, modelo navegacional 2.3, diseño de interfaces 2.4 y trazabilidad 2.8.