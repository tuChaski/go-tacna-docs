# T053 — Prototipo interactivo del panel administrativo

> Estado: En revisión
> Responsable: Alex Huaracha
> Relacionado: [Figma](figma.md), [guía de estilos](guia-de-estilos.md), [alcance del MVP](../requisitos/mvp.md), [requerimientos funcionales](../requisitos/requerimientos-funcionales.md), [cronograma](../planificacion/README.md).

## 1. Identificación y objetivo

| Dato | Detalle |
|---|---|
| Proyecto | Go Tacna |
| Tarea | T053 — Prototipo interactivo del Panel Administrador Web |
| Entregable | Diseño navegable en Figma del CRUD administrativo y su documentación |
| Responsable | Alex Huaracha |
| Dependencia formal | T049 — Guía de estilos UI/UX |
| Estimación del Gantt | 4 horas; no representa el tiempo real registrado |
| Página de Figma | 06 - Admin Web |
| Estado del diseño | Prototipo elaborado y revisado por el responsable |
| Estado de aprobación | Pendiente de revisión y aprobación del PR |

El objetivo es representar los recorridos de registro, listado, consulta, edición y desactivación de empresas, rutas, micros y conductores. El diseño diferencia la administración general de Go Tacna y la administración independiente de cada empresa.

T053 corresponde al diseño del prototipo. La persistencia, autenticación y autorización reales se implementan en las tareas de desarrollo correspondientes.

## 2. Alcance y perfiles acordados

| Perfil | Funciones representadas | Límite de acceso |
|---|---|---|
| Administrador general de Go Tacna | Registrar empresas, consultar y editar sus datos, gestionar su estado y representar la creación de sus credenciales administrativas | Gestión general de empresas y sus accesos |
| Administrador de empresa | Gestionar rutas, micros y conductores; registrar las credenciales del conductor y consultar el monitoreo | Solo información de su propia empresa |
| Conductor | Recibir credenciales de su empresa y utilizar el micro asignado en modo conductor | Su operación se diseña en T052; este prototipo representa su cuenta y asignación |

La empresa entrega las credenciales al conductor al incorporarlo. Se mantiene un conductor por micro y un solo micro asignado por conductor a la vez.

La separación por empresa es una decisión confirmada para el diseño de T053. Su formalización en requisitos, casos de uso, perfiles y modelo de datos corresponde a los responsables de esos documentos.

### Incluido

- Acceso administrativo y cierre de sesión representados en el prototipo.
- Panel general y panel de empresa con navegación diferenciada.
- CRUD de empresas, rutas, micros y conductores.
- Consulta de datos, asociaciones y estado del registro.
- Desactivación sin borrar el registro y reactivación.
- Formularios con ejemplos, comprobación de campos obligatorios y caso de identificador duplicado.
- Confirmaciones, cancelación y mensajes de recuperación.
- Monitoreo ilustrativo de una unidad en recorrido y consulta de una unidad nueva sin ubicación.
- Un único inicio de presentación: `Flow 1`.

### Fuera de esta entrega

- Implementación del frontend y backend, base de datos y endpoints reales.
- Autenticación efectiva, emisión de credenciales y control de acceso entre empresas en el servidor.
- Transmisión GPS, recepción de ubicaciones y cálculo de tiempos reales.
- Edición geográfica completa del trazado de rutas.
- Gestión general de pasajeros, suscripciones Premium y pagos.
- Pruebas con usuarios externos y validación de la aplicación implementada.

## 3. Organización del prototipo

| Bloque | Contenido | Cantidad |
|---|---|---:|
| 01 · Acceso | Inicio de sesión compartido | 1 |
| 02 · Administración general | Inicio y gestión de empresas | 5 |
| 03 · Empresa — Rutas | Inicio de empresa y gestión de rutas | 5 |
| 04 · Empresa — Micros | Gestión de micros y monitoreo | 5 |
| 05 · Empresa — Conductores | Gestión de conductores | 4 |
| 06 · Confirmaciones y errores | Cambios de estado y mensajes alternativos | 9 |
| Total | 20 pantallas y 9 cuadros de diálogo | 29 |

Las pantallas se agrupan en secciones del lienzo. Todas tienen acceso mediante las conexiones del prototipo. Los cuadros de diálogo se comparten entre registros del mismo módulo para reducir duplicados.

## 4. Matriz CRUD del diseño

| Entidad | Crear | Leer: listar y consultar | Actualizar | Baja lógica | Perfil |
|---|---|---|---|---|---|
| Empresa | Registrar empresa y datos de acceso de su administrador | Listado y detalle | Editar datos | Desactivar y reactivar | Administrador general |
| Ruta | Registrar ruta y referencias | Listado y detalle | Editar datos y referencias representadas | Desactivar y reactivar | Administrador de empresa |
| Micro | Registrar código, placa y asociaciones | Listado y detalle | Editar datos y asociaciones permitidas | Desactivar y reactivar | Administrador de empresa |
| Conductor | Registrar datos y credenciales de acceso | Listado y detalle | Editar datos | Desactivar y reactivar | Administrador de empresa |

La operación D del CRUD se representa como desactivación. Se conservan los datos y sus relaciones; no se ejecuta un borrado definitivo.

## 5. Contenido de los módulos

| Módulo | Datos representados en el formulario | Consideraciones |
|---|---|---|
| Empresas | Razón social, RUC, correo del administrador y contraseña inicial | El correo y la contraseña representan el acceso administrativo de la empresa |
| Rutas | Nombre, origen y destino, referencia inicial y referencia final | La empresa queda determinada por la sesión |
| Micros | Código, placa, ruta y conductor | El conductor puede quedar sin asignar al registrar la unidad |
| Conductores | Nombre completo, documento, correo y contraseña inicial | La asignación del micro se realiza desde Micros |

Los identificadores `DEMO`, nombres y correos son ficticios. El prototipo no comprueba documentos oficiales ni entrega contraseñas reales. La contraseña no aparece en las vistas de consulta.

### Referencias del recorrido

Los micros pueden recoger pasajeros a lo largo de su recorrido cuando estos lo solicitan. Los puntos o paraderos se presentan como referencias de orientación; no representan paradas obligatorias.

El mapa y el trayecto son ilustrativos. Los campos representan la configuración de referencias, pero no implementan el dibujo libre del recorrido, la geocodificación ni su validación oficial.

### Asignaciones

- La ruta y el conductor deben corresponder a la empresa de la sesión.
- El micro requiere una ruta activa para guardar la asociación representada.
- La asignación del conductor tiene un único punto de gestión: el módulo Micros.
- Registrar un micro no inicia un recorrido ni activa el GPS.
- Las asignaciones de la unidad que está en recorrido se presentan como bloqueadas.
- Los ejemplos de reactivación comprueban que las asociaciones requeridas estén habilitadas.

Los bloqueos son ejemplos del comportamiento previsto en el diseño. La política definitiva para cambios de empresa, reasignaciones y dependencias debe acordarse con los responsables del backend y del modelo de datos.

## 6. Recorridos de navegación

| Recorrido | Secuencia |
|---|---|
| Acceso general | Inicio de sesión → Go Tacna → Iniciar sesión → Administración general |
| Acceso de empresa | Inicio de sesión → Empresa → Iniciar sesión → Panel de Andino Demo |
| Crear un registro | Listado del módulo → Registrar → Completar campos → Guardar → Listado con confirmación |
| Consultar | Listado → Ver → Detalle → Volver |
| Editar | Listado o detalle → Editar → Modificar datos → Guardar → Listado |
| Desactivar o reactivar | Listado o detalle → Estado → Confirmar acción → Listado |
| Cancelar | Formulario → Cancelar → Listado, sin guardar |
| Monitorear | Panel o menú lateral → Monitoreo → Ver ficha del micro |
| Cerrar sesión | Menú lateral → Cerrar sesión → Inicio de sesión |

El selector Empresa / Go Tacna permite revisar los dos perfiles con datos de ejemplo. En la implementación, los permisos deben determinarse mediante la cuenta autenticada; el selector del prototipo no constituye un mecanismo de autorización.

## 7. Estados y excepciones

| Caso representado | Respuesta del prototipo |
|---|---|
| Credenciales inválidas | Muestra el rechazo de acceso y permite volver al formulario |
| Campos obligatorios incompletos | Informa que faltan datos y conserva el formulario |
| Identificador de ejemplo duplicado | Impide el segundo registro con el mismo identificador |
| Dependencias operativas | Bloquea la desactivación del ejemplo con relaciones que requieren resolución |
| Registro inactivo | Conserva el registro y muestra su estado |
| Reactivación con asociaciones inactivas | Bloquea la reactivación del micro en el escenario correspondiente |
| Error de actualización del monitoreo | Informa el fallo y permite cerrar el mensaje |
| Unidad nueva sin ubicación | Indica que está fuera de recorrido y no tiene ubicación recibida |

Los cuadros de diálogo pueden cerrarse mediante sus botones. Las acciones de guardar y cambiar estado vuelven al listado correspondiente.

## 8. Verificación y evidencia

### Verificación técnica del diseño

Se inspeccionan las conexiones de Figma y se evalúan sus acciones y condiciones mediante una simulación de los estados locales del prototipo. Esta verificación no equivale a ejecutar los 36 escenarios en un navegador, probar una API ni validar con usuarios.

| Comprobación | Resultado |
|---|---|
| Pantallas y cuadros de diálogo con acceso desde Flow 1 | 29 de 29 |
| Destinos inexistentes | 0 |
| Inicios de flujo administrativos | 1: Flow 1 |
| Escenarios de condiciones evaluados | 36 |
| Escenarios aprobados en esa evaluación | 36 |
| Tipografía y estructura | Inter; texto, vectores e instancias editables |

### Cobertura de los 36 escenarios

| Grupo | Casos evaluados | Cantidad |
|---|---|---:|
| Empresas | Campos obligatorios, creación, edición, baja lógica, reactivación, duplicado y bloqueo por dependencias | 7 |
| Rutas | Campos obligatorios, creación, edición, baja lógica, reactivación, duplicado y bloqueo por dependencias | 7 |
| Micros | Campos obligatorios, creación, edición, baja lógica, reactivación, duplicado y bloqueo por dependencias | 7 |
| Conductores | Campos obligatorios, creación, edición, baja lógica, reactivación, duplicado y bloqueo por dependencias | 7 |
| Acceso | Empresa, administrador general y rechazo de credenciales inválidas | 3 |
| Asociaciones | Asignar Andrea al Micro 025; bloquear baja de ruta y conductor vinculados; permitir baja del conductor después del micro; bloquear reactivación con conductor inactivo | 5 |
| Total | Evaluación de conexiones y estados del diseño | 36 |

### Revisión manual

Alex comunica que revisa el prototipo y solicita continuar con su documentación. No se adjunta un registro individual de resultados de los 36 escenarios en modo presentación. La revisión comunicada no se registra como prueba externa de usabilidad.

### Límites de la evidencia

- Los formularios cargan datos de ejemplo al pulsar los campos; no permiten ingreso libre equivalente a una aplicación.
- Se representa un registro inicial y un registro adicional por módulo. El segundo intento con el identificador del ejemplo demuestra el caso de duplicado.
- Los cambios se mantienen dentro de la sesión del prototipo; no existe persistencia en base de datos.
- La navegación diferenciada representa el aislamiento de cada empresa, pero no demuestra seguridad efectiva en el servidor.
- El mapa, el GPS y los estados operativos utilizan datos simulados.
- No se incluyen evidencias de rendimiento, accesibilidad completa, validaciones documentales ni funcionamiento en producción.
- La evaluación comprende los escenarios enumerados; no cubre todas las combinaciones posibles del sistema.

## 9. Inventario y enlaces de Figma

| Pantalla o diálogo | Enlace |
|---|---|
| Inicio de sesión — Flow 1 | [login](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-17228) |
| Inicio general | [generalHome](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18650) |
| Empresas — listado | [companyList](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-17520) |
| Empresas — registro | [companyForm](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18227) |
| Empresas — detalle | [companyDetail](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=415-229) |
| Empresas — edición | [companyEdit](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=415-159) |
| Inicio de empresa | [companyHome](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-17309) |
| Rutas — listado | [routeList](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-17625) |
| Rutas — registro | [routeForm](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18315) |
| Rutas — detalle | [routeDetail](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=415-659) |
| Rutas — edición | [routeEdit](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=415-522) |
| Micros — listado | [busList](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-17767) |
| Micros — registro | [busForm](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18446) |
| Micros — detalle | [busDetail](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=416-532) |
| Micros — edición | [busEdit](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=416-446) |
| Monitoreo | [monitor](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18059) |
| Conductores — listado | [driverList](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-17929) |
| Conductores — registro | [driverForm](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18548) |
| Conductores — detalle | [driverDetail](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=416-871) |
| Conductores — edición | [driverEdit](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=416-788) |
| Cambio de estado de empresa | [companyState](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-18727) |
| Cambio de estado de ruta | [routeState](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-864) |
| Cambio de estado de micro | [busState](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-889) |
| Cambio de estado de conductor | [driverState](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-914) |
| Datos incompletos | [validation](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-939) |
| Registro duplicado | [duplicate](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-950) |
| Dependencias operativas | [blocked](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-961) |
| Error de monitoreo | [network](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-972) |
| Rechazo de acceso | [denied](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=419-983) |

## 10. Trazabilidad y coordinación pendiente

El Gantt relaciona T053 con RF-15 a RF-17. Sin embargo, los documentos utilizan numeraciones diferentes:

| Capacidad | Referencia descriptiva de los PDF | Referencia del repositorio consultado |
|---|---|---|
| Empresas, rutas, micros y conductores | RF-33 a RF-36 | RF-15 — Administración |
| Supervisión de unidades y estados | RF-37 y RF-38 | RF-16 — Supervisión |
| Gestión Premium | RF-40 | RF-17 — Función futura, fuera de T053 en este incremento |

Las referencias de los PDF se conservan como equivalencias descriptivas; no se adoptan como nuevos identificadores oficiales del repositorio. La discrepancia del Gantt queda pendiente de resolución por sus responsables.

| Documento o tarea relacionada | Ajuste que requiere coordinación |
|---|---|
| T079 — Casos de uso | Diferenciar administrador general y administrador de empresa |
| T090 — Perfiles y matriz de acceso | Formalizar las operaciones permitidas y el aislamiento por empresa |
| T008 — Modelo de datos | Representar la cuenta administrativa de la empresa y revisar asociaciones y estados |
| Contratos de autenticación y CRUD | Definir el contexto de empresa y comprobarlo en el servidor |
| Requisitos y reglas de negocio | Consolidar numeración y políticas de baja, reasignación y reactivación |

Esta entrega documenta las decisiones de interfaz de T053. No modifica ni declara completadas las tareas asignadas a otros integrantes.

## 11. Conclusión de la entrega

El prototipo administrativo representa los recorridos CRUD acordados, diferencia los dos perfiles y organiza 29 pantallas y cuadros de diálogo en un único flujo. La evaluación técnica de los 36 escenarios enumerados no presenta fallos.

T053 queda elaborada en la etapa de diseño y su documentación permanece En revisión hasta la aprobación del PR. La aceptación del equipo no se sustituye por la revisión individual.

El primer incremento en código prioriza login y CRUD administrativo. El MVP completo también requiere la operación del conductor y la consulta del pasajero.

T059 depende formalmente de T055, T029, T030, T031 y T053. La integración con datos y permisos reales debe coordinarse con sus responsables antes de cerrar la implementación.

## 12. Fuentes

- `informacion-proyecto.pdf`: alcance administrativo, páginas 42–43; diagrama administrativo, página 56; T053, página 77; T054, página 78; dependencias de T059, página 85. La numeración corresponde a páginas del archivo PDF.
- `informe.web.pdf`: requerimientos y casos de uso del módulo administrativo.
- `GUIA TF.pdf`: Unidad I, diseño de interfaces, login y matriz CRUD; Unidad II, diseño navegacional, interfaces y trazabilidad.
- [Alcance del MVP](../requisitos/mvp.md) y [requerimientos funcionales](../requisitos/requerimientos-funcionales.md).
- [Diagrama administrativo del repositorio](../casos-de-uso/diagrama_casos_uso_modulo_administrador.puml).
- [Modelo de datos en revisión, PR #2](https://github.com/tuChaski/go-tacna-docs/pull/2).
- [Página 06 - Admin Web](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=73-1150).
- Decisiones de alcance confirmadas por Alex durante el diseño de T053.

