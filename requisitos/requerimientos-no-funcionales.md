# Requerimientos no funcionales

> **Estado:** Borrador
> **Responsable:** Royfrankly
> **Relacionado:** [../CONTRIBUTING.md](../CONTRIBUTING.md), [plantillas/requerimiento.md](../plantillas/requerimiento.md), [../pruebas/](../pruebas/)

## Qué va aquí

- RNF-01 a RNF-07 con la numeración oficial de la guía TF.
- Los valores medibles aún no acordados se marcan como pendientes de decisión.
- Cada RNF con su caso de prueba en pruebas/matriz-de-trazabilidad.md.

## Contenido

### RNF-01 — Usabilidad

- **Descripción:** La aplicación debe presentar las funciones principales con controles y mensajes comprensibles para personas sin conocimientos técnicos.
- **Criterio de aceptación:** En una prueba guiada, una persona puede identificar cómo consultar una ruta y una unidad, y comprender los mensajes de estado de ubicación sin asistencia técnica.
- **Origen:** Propuesta de requerimientos, sección 2.15.
- **Pruebas:** Por definir.
- **Pendiente de decisión:** Perfil y cantidad de participantes para la prueba de usabilidad.

### RNF-02 — Navegabilidad

- **Descripción:** La interfaz del pasajero debe permitir acceder al flujo de consulta de ruta, micro, ubicación y tiempo estimado desde la pantalla principal.
- **Criterio de aceptación:** El flujo principal puede recorrerse desde la pantalla principal hasta la consulta del tiempo estimado sin tener que actualizar manualmente la pantalla.
- **Origen:** Propuesta de requerimientos, sección 2.15.
- **Pruebas:** Por definir.
- **Pendiente de decisión:** Número máximo de acciones o pantallas para considerar aceptable el flujo.

### RNF-03 — Tiempo de respuesta

- **Descripción:** Las consultas de rutas y ubicación deben responder dentro de un límite de tiempo acordado.
- **Criterio de aceptación:** Pendiente de fijar un umbral de respuesta y las condiciones de medición (red, carga y ambiente); no se establece un número sin validación del equipo.
- **Origen:** Propuesta de requerimientos, sección 2.15.
- **Pruebas:** Por definir.

### RNF-04 — Actualización de ubicación

- **Descripción:** El sistema debe actualizar las posiciones de los micros de forma periódica mientras el conductor mantiene activo el recorrido, sin exigir que el pasajero refresque manualmente la pantalla.
- **Criterio de aceptación:** Durante un recorrido activo y con GPS y conexión disponibles, el pasajero recibe las nuevas ubicaciones automáticamente.
- **Origen:** Propuesta de requerimientos, secciones 2.9, 2.10 y 2.15.
- **Pruebas:** Por definir.
- **Pendiente de decisión:** Intervalo máximo de transmisión y actualización visible.

### RNF-05 — Disponibilidad

- **Descripción:** El servicio debe estar disponible durante los horarios de operación del transporte incluidos en el sistema.
- **Criterio de aceptación:** Pendiente de establecer el horario de operación y el porcentaje objetivo de disponibilidad para medir el servicio.
- **Origen:** Propuesta de requerimientos, sección 2.15.
- **Pruebas:** Por definir.

### RNF-06 — Seguridad y privacidad

- **Descripción:** El sistema debe autenticar a los usuarios, restringir las funciones según su perfil y utilizar la ubicación del conductor únicamente para el seguimiento del transporte durante un recorrido activo.
- **Criterio de aceptación:** Una persona no autenticada o sin permisos no puede iniciar una transmisión ni acceder a funciones administrativas; la ubicación deja de transmitirse al finalizar el recorrido.
- **Origen:** Propuesta de requerimientos, secciones 2.1, 2.9, 2.11 y 2.15.
- **Pruebas:** Por definir.

### RNF-07 — Compatibilidad, escalabilidad y mantenibilidad

- **Descripción:** La solución debe permitir incorporar más empresas, rutas, micros, usuarios y funcionalidades sin requerir una reconstrucción completa, y sus componentes deben poder modificarse o ampliarse sin afectar innecesariamente las demás partes. La aplicación móvil tendrá Android como plataforma inicial según la propuesta.
- **Criterio de aceptación:** La administración puede agregar una empresa, ruta y micro mediante las funciones previstas, y estos aparecen para consulta sin cambios de código específicos para esa entidad. Una revisión de arquitectura y cambios verifica que la organización permite modificar o ampliar componentes sin afectar innecesariamente los demás. La compatibilidad con iOS y otros clientes queda sujeta al alcance de versiones futuras.
- **Origen:** Propuesta de requerimientos, secciones 2.12 y 2.15.
- **Pruebas:** Por definir.
- **Pendiente de decisión:** Confirmar cómo se relaciona el alcance Android inicial con los clientes web y móvil contemplados en el proyecto.
