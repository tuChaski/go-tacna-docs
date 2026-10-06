# Requerimientos funcionales

> **Estado:** Borrador
> **Responsable:** Royfrankly
> **Relacionado:** [../CONTRIBUTING.md](../CONTRIBUTING.md), [plantillas/requerimiento.md](../plantillas/requerimiento.md), [mvp.md](mvp.md)

## Qué va aquí

- RF-01 a RF-20, con la numeración oficial de la guía TF.
- Actor, prioridad, descripción, criterio de aceptación, origen, tareas y pruebas.
- Los que dejen de aplicar se marcan como Descartado; no se renumeran.
- Los valores técnicos aún no acordados se identifican como pendientes de decisión, no se presuponen.

## Contenido

Los requisitos se consolidaron desde la propuesta compartida por el equipo. Las funciones que en esa propuesta excedían la numeración oficial RF-01 a RF-20 se agruparon por capacidad y se clasificaron como futuras cuando no forman parte del MVP. Los identificadores, tareas y pruebas conservan la trazabilidad pendiente de completar contra la guía del Trabajo Final y el tablero.

### RF-01 — Registro de pasajero

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir que una persona cree una cuenta de pasajero.
- **Criterio de aceptación:** Dado que una persona proporciona los datos obligatorios válidos, cuando envía el formulario de registro, entonces el sistema crea la cuenta o informa qué dato debe corregir.
- **Origen:** Propuesta de requerimientos, sección 2.3.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-02 — Inicio de sesión por perfil

- **Actor:** Pasajero, Conductor, Administrador
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir iniciar sesión a los usuarios registrados y autorizar las funciones correspondientes a su perfil.
- **Criterio de aceptación:** Dado un usuario activo con credenciales válidas, cuando inicia sesión, entonces accede a las funciones autorizadas para su perfil; con credenciales inválidas, el acceso es rechazado.
- **Origen:** Propuesta de requerimientos, secciones 2.3, 2.9 y 2.11.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-03 — Recuperación de cuenta

- **Actor:** Pasajero
- **Prioridad:** Futuro
- **Descripción:** El sistema debe permitir solicitar la recuperación de una cuenta mediante un enlace enviado al correo registrado y establecer una nueva contraseña.
- **Criterio de aceptación:** Dado un correo asociado a una cuenta, cuando el pasajero solicita recuperar el acceso, entonces recibe instrucciones para cambiar su contraseña; el enlace no permite reutilizar una recuperación ya completada.
- **Origen:** Propuesta de requerimientos, sección 2.3.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-04 — Consulta pública sin cuenta

- **Actor:** Pasajero
- **Prioridad:** Futuro
- **Descripción:** El sistema podrá permitir la consulta de rutas y micros disponibles sin iniciar sesión.
- **Criterio de aceptación:** Pendiente de decidir si la consulta básica será pública o requerirá una cuenta.
- **Origen:** Propuesta de requerimientos, sección 2.3.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-05 — Consulta de rutas disponibles

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe mostrar las rutas de transporte incorporadas y disponibles.
- **Criterio de aceptación:** Dado que existen rutas activas, cuando el pasajero abre la consulta de rutas, entonces ve las rutas disponibles; las rutas desactivadas no aparecen como opciones vigentes.
- **Origen:** Propuesta de requerimientos, secciones 2.4 y 2.17.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-06 — Selección de ruta

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir seleccionar una ruta para consultar sus micros y recorrido.
- **Criterio de aceptación:** Dada una ruta disponible, cuando el pasajero la selecciona, entonces el sistema presenta la información y las unidades asociadas a esa ruta.
- **Origen:** Propuesta de requerimientos, secciones 2.4 y 2.17.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-07 — Visualización y selección de micros en el mapa

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe mostrar en el mapa los micros activos de la ruta seleccionada y permitir al pasajero elegir cuáles desea consultar, sujeto al límite de su plan.
- **Criterio de aceptación:** Dada una ruta con micros transmitiendo, cuando el pasajero la consulta, entonces el mapa muestra las unidades disponibles y permite seleccionar las que no excedan el límite del plan.
- **Origen:** Propuesta de requerimientos, secciones 2.4, 2.6, 2.7 y decisión incluida al final del adjunto.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-08 — Transmisión de ubicación del micro

- **Actor:** Conductor
- **Prioridad:** MVP
- **Descripción:** El sistema debe recibir periódicamente la ubicación GPS del teléfono del conductor mientras el recorrido esté activo.
- **Criterio de aceptación:** Dado que el conductor inició un recorrido y el GPS y la conexión están disponibles, cuando el teléfono obtiene nuevas coordenadas, entonces el sistema recibe y publica la ubicación asociada al micro y ruta asignados. El intervalo de transmisión queda pendiente de definir.
- **Origen:** Propuesta de requerimientos, secciones 2.9, 2.10 y 2.17.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-09 — Consulta de información y vigencia de ubicación

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe mostrar el identificador del micro, su ruta, dirección del recorrido cuando esté disponible, estado y fecha u hora de la última ubicación recibida.
- **Criterio de aceptación:** Dado un micro seleccionado, cuando el pasajero consulta su información, entonces ve sus datos y la hora de la última actualización; si la ubicación está desactualizada, el sistema no la presenta como actual.
- **Origen:** Propuesta de requerimientos, secciones 2.4, 2.10, 2.14 y 2.17.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-10 — Estimación del tiempo de llegada

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe calcular una estimación aproximada de llegada a partir de la distancia y la velocidad disponible del micro, sin considerar tráfico o congestión en el MVP.
- **Criterio de aceptación:** Dado un micro con ubicación y velocidad válidas y un punto de interés, cuando el pasajero solicita el tiempo de llegada, entonces el sistema muestra un valor estimado; si faltan datos suficientes, informa que no es posible calcularlo.
- **Origen:** Propuesta de requerimientos, secciones 2.4 y decisión incluida al final del adjunto.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-11 — Consulta del recorrido de una ruta

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe mostrar sobre el mapa el recorrido y los puntos o paraderos registrados para la ruta seleccionada.
- **Criterio de aceptación:** Dada una ruta con recorrido configurado, cuando el pasajero la selecciona, entonces el sistema representa su recorrido y los puntos registrados; si no hay recorrido disponible, informa que la ruta no cuenta con esa información.
- **Origen:** Propuesta de requerimientos, secciones 2.4 y 2.11.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-12 — Ubicación del pasajero y búsqueda de micros cercanos

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir que el pasajero use su ubicación actual o seleccione un punto en el mapa para consultar micros cercanos.
- **Criterio de aceptación:** Dado que el pasajero concede permiso de ubicación o selecciona un punto manualmente, cuando solicita micros cercanos, entonces el sistema muestra las unidades disponibles alrededor de ese punto; si no hay permiso, GPS o unidades, informa la situación y permite continuar mediante selección manual cuando corresponda.
- **Origen:** Propuesta de requerimientos, secciones 2.4 y 2.14, y decisión incluida al final del adjunto.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-13 — Aplicación del límite de micros por plan

- **Actor:** Pasajero
- **Prioridad:** MVP
- **Descripción:** El sistema debe limitar la cantidad de micros visibles simultáneamente según el plan del pasajero.
- **Criterio de aceptación:** Dado un pasajero del plan gratuito, cuando intenta visualizar más de dos micros simultáneamente, entonces el sistema mantiene como máximo dos visibles y comunica el límite; el límite Premium queda pendiente de definición.
- **Origen:** Propuesta de requerimientos, secciones 2.6 y 2.7.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-14 — Inicio y finalización del recorrido por el conductor

- **Actor:** Conductor
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir al conductor iniciar y finalizar un recorrido desde el modo conductor de la misma aplicación, e informar si la ubicación no puede transmitirse.
- **Criterio de aceptación:** Dado un conductor autenticado y asociado a un micro con ruta, cuando inicia el recorrido, entonces comienza la transmisión; cuando lo finaliza, la transmisión se detiene. Si el GPS o la conexión fallan, la aplicación informa al conductor y el pasajero ve el estado o última actualización disponible.
- **Origen:** Propuesta de requerimientos, secciones 2.9, 2.10, 2.17 y decisión incluida al final del adjunto.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-15 — Administración de empresas, rutas, micros y conductores

- **Actor:** Administrador
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir al administrador registrar, modificar y desactivar empresas, rutas, micros, conductores y usuarios, así como asociar micros con empresas, rutas y conductores.
- **Criterio de aceptación:** Dado un administrador autenticado, cuando crea o modifica empresas, rutas, micros, conductores o usuarios y sus asociaciones, entonces el sistema guarda los datos válidos; no permite iniciar un recorrido con asociaciones obligatorias ausentes.
- **Origen:** Propuesta de requerimientos, secciones 2.11, 2.12 y 2.17.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-16 — Supervisión del estado de los micros

- **Actor:** Administrador
- **Prioridad:** MVP
- **Descripción:** El sistema debe permitir al administrador consultar qué micros transmiten, están fuera de recorrido o no tienen una actualización reciente, junto con su última ubicación recibida.
- **Criterio de aceptación:** Dada una flota registrada, cuando el administrador abre la supervisión, entonces puede distinguir las unidades activas de las que no transmiten y consultar la hora de su última ubicación.
- **Origen:** Propuesta de requerimientos, secciones 2.10 y 2.11.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-17 — Gestión de suscripciones Premium

- **Actor:** Administrador
- **Prioridad:** Futuro
- **Descripción:** El sistema podrá gestionar suscripciones Premium y su estado, fecha de inicio y vencimiento.
- **Criterio de aceptación:** Dada una suscripción, cuando el administrador consulta su registro, entonces puede identificar si está activa y su vigencia; integración con un proveedor de pago no forma parte del MVP.
- **Origen:** Propuesta de requerimientos, secciones 2.2, 2.6 y 2.11.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-18 — Consulta de ocupación del micro

- **Actor:** Pasajero
- **Prioridad:** Futuro
- **Descripción:** El sistema podrá mostrar el nivel de ocupación de un micro cuando exista un dato registrado o recibido mediante un mecanismo definido.
- **Criterio de aceptación:** Dado que existe un dato de ocupación vigente, cuando el pasajero consulta el micro, entonces se muestra la categoría disponible; si el dato no existe, no se presenta un aforo como si fuera conocido.
- **Origen:** Propuesta de requerimientos, secciones 2.6 y 2.8.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-19 — Alertas y elementos favoritos

- **Actor:** Pasajero
- **Prioridad:** Futuro
- **Descripción:** El sistema podrá enviar alertas cuando un micro esté próximo y permitir guardar rutas, micros o paraderos favoritos.
- **Criterio de aceptación:** Pendiente de definir los tipos de alerta, la condición de proximidad y los límites de favoritos por plan antes de implementar esta función.
- **Origen:** Propuesta de requerimientos, sección 2.6.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente

### RF-20 — Funciones Premium de historial y planificación avanzada

- **Actor:** Pasajero
- **Prioridad:** Futuro
- **Descripción:** El sistema podrá ofrecer a pasajeros Premium historial de recorridos y tiempos, comparación de micros, alternativas de viaje, planificación avanzada, estimaciones mejoradas con datos históricos y una experiencia sin publicidad.
- **Criterio de aceptación:** Pendiente de desglosar y definir cada función, sus datos requeridos y los límites del plan antes de implementarlas. Las estimaciones del MVP no consideran tráfico ni congestión.
- **Origen:** Propuesta de requerimientos, secciones 2.5 y 2.6 y decisión incluida al final del adjunto.
- **Tareas:** Por asignar.
- **Pruebas:** Por definir.
- **Estado:** Vigente
