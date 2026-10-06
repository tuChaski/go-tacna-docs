# Reglas de negocio

> **Estado:** Borrador
> **Responsable:** Royfrankly
> **Relacionado:** [../glosario.md](../glosario.md), [requerimientos-funcionales.md](requerimientos-funcionales.md)

## Qué va aquí

- RN-01 a RN-10.
- Cada regla con su origen y los requerimientos que la usan.

## Contenido

### RN-01 — Registro previo de micros

Solo los micros registrados por un administrador pueden aparecer en el sistema.

- **Requerimientos relacionados:** RF-07, RF-15.
- **Origen:** Propuesta de requerimientos, secciones 2.11 y 2.16.

### RN-02 — Conductor autorizado

Solo un conductor autenticado y autorizado para una unidad puede transmitir su ubicación.

- **Requerimientos relacionados:** RF-02, RF-08, RF-14, RF-15.
- **Origen:** Propuesta de requerimientos, secciones 2.9 y 2.16.

### RN-03 — Micro asociado a una ruta

Un micro debe estar asociado a una ruta para poder iniciar un recorrido.

- **Requerimientos relacionados:** RF-06, RF-14, RF-15.
- **Origen:** Propuesta de requerimientos, secciones 2.11 y 2.16.

### RN-04 — Estado sin transmisión

Un micro que no transmita ubicación durante el período definido debe identificarse como desconectado o sin actualización, y su última posición no debe presentarse como actual.

- **Requerimientos relacionados:** RF-09, RF-14, RF-16.
- **Origen:** Propuesta de requerimientos, secciones 2.10, 2.14 y 2.16.
- **Pendiente de decisión:** Duración sin transmisión para marcar el estado y tiempo que se conserva visible la última ubicación.

### RN-05 — Límite del plan gratuito

Un pasajero del plan gratuito puede visualizar como máximo dos micros simultáneamente. El límite ampliado del plan Premium debe definirse antes de ofrecerlo.

- **Requerimientos relacionados:** RF-07, RF-13.
- **Origen:** Propuesta de requerimientos, secciones 2.6, 2.7 y 2.16.

### RN-06 — Vigencia de Premium

Las funciones exclusivas del plan Premium solo están disponibles mientras la suscripción del pasajero esté activa.

- **Requerimientos relacionados:** RF-13, RF-17, RF-18, RF-19, RF-20.
- **Origen:** Propuesta de requerimientos, secciones 2.6 y 2.16.

### RN-07 — Disponibilidad del dato de ocupación

El sistema solo puede mostrar la ocupación de un micro cuando exista información disponible obtenida mediante un mecanismo definido.

- **Requerimientos relacionados:** RF-18.
- **Origen:** Propuesta de requerimientos, secciones 2.8 y 2.16.
- **Pendiente de decisión:** Método para capturar, actualizar y validar el dato de ocupación.

### RN-08 — El tiempo de llegada es estimado

El tiempo de llegada mostrado al pasajero debe presentarse como una estimación aproximada, nunca como una hora exacta o garantizada.

- **Requerimientos relacionados:** RF-10, RF-20.
- **Origen:** Propuesta de requerimientos, secciones 2.4, 2.13 y 2.16.

### RN-09 — Fin del recorrido

Cuando el conductor finaliza un recorrido, su micro deja de considerarse activo para la consulta de unidades en tiempo real.

- **Requerimientos relacionados:** RF-07, RF-09, RF-14, RF-16.
- **Origen:** Propuesta de requerimientos, secciones 2.9 y 2.16.

### RN-10 — Cobertura inicial administrada

La cobertura inicial del sistema comprende únicamente las empresas, rutas y micros incorporados por un administrador; la incorporación de nuevas entidades no debe requerir reconstruir completamente el sistema.

- **Requerimientos relacionados:** RF-05, RF-06, RF-15.
- **Origen:** Propuesta de requerimientos, secciones 2.11, 2.12 y 2.16.
