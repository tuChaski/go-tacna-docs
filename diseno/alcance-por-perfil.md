# Alcance de las interfaces por perfil

> **Estado:** En revisión
> **Responsable:** Alex Huaracha
> **Relacionado:** [mapa del sitio](mapa-del-sitio.md), [inventario de vistas](inventario-de-vistas.md), [prototipo administrativo](prototipo-administrador.md), [prototipo del pasajero](prototipo-pasajero.md)

## 1. Para qué sirve

Este documento recoge la idea de producto que Alex precisa para T091. Sirve para organizar las pantallas y distinguir las funciones actuales de las ampliaciones previstas. La autorización de cada operación se debe comprobar también en el servidor.

La entrega corresponde a arquitectura de contenido. No implementa nuevos módulos, modifica permisos de la API ni acredita pruebas de las funciones propuestas.

## 2. Administrador general

El administrador general organiza Go Tacna como plataforma. Registra las empresas de transporte y crea las cuentas de las personas que las administran. El registro público de pasajeros no permite elegir este rol ni el de administrador de empresa.

| Módulo | Contenido y acciones previstos | Situación de la interfaz |
|---|---|---|
| Empresas | Listar, registrar, consultar, editar y cambiar el estado de una empresa | Existe en el frontend revisado |
| Administradores de empresa | Crear la cuenta desde el detalle de la empresa; registrar identidad, correo y contraseña inicial; editar la cuenta vinculada | Existe en el frontend revisado |
| Inicio general | Resumen de empresas y accesos a los módulos disponibles | Hay una referencia en Figma; el acceso web actual redirige a Empresas |
| Pasajeros | Consultar cuentas, ver su estado y permitir su activación o desactivación con confirmación | Ampliación pendiente de interfaz; el alcance no incluye consultar búsquedas personales de cada pasajero |
| Planes y beneficios Premium | Configurar funciones y límites; consultar el estado del beneficio de un pasajero | Ampliación futura; no incluye cobros ni comprobantes de pago |
| Supervisión general | Consultar el estado de las flotas con filtro por empresa | Ampliación propuesta, separada del monitoreo de una empresa |

El alta de una empresa y el alta de su administrador se muestran como pasos separados. Si la empresa ya está guardada pero falla la creación de la cuenta, se permite reintentar ese segundo paso sin duplicar la empresa.

Las contraseñas iniciales se introducen en el formulario de alta. No se vuelven a mostrar en listados ni detalles. La forma de entrega al responsable y el cambio obligatorio en el primer acceso quedan pendientes de diseño; no se contempla un envío automático de credenciales en esta entrega.

## 3. Administrador de empresa

El administrador de empresa organiza sus rutas, micros y conductores. Solo accede a las empresas vinculadas a su cuenta. Si tiene más de una, elige la empresa que va a gestionar y el panel mantiene visible ese contexto.

| Módulo | Contenido y acciones previstos | Situación de la interfaz |
|---|---|---|
| Inicio de empresa | Resumen de flota, rutas y conductores; accesos a gestión y monitoreo | Hay una referencia en Figma; faltan el dashboard operativo y sus indicadores reales |
| Rutas | Registrar el nombre de la ruta, consultar y editar su trazado y gestionar su estado | Existe en el frontend revisado |
| Micros | Registrar placa y capacidad; asignar ruta y conductor; consultar, editar y gestionar el estado de la unidad | Existe en el frontend revisado |
| Conductores | Registrar al conductor y sus credenciales; consultar su información y su micro asignado | Existe en el frontend revisado; la edición actual se limita a la licencia |
| Monitoreo de la flota | Ver los micros de la empresa en el mapa, su ruta, estado y última actualización | Representado en Figma; pendiente de integración web en tiempo real |
| Reasignación | Cambiar el conductor de un micro desde su edición, sin crear otra cuenta ni otro micro | La selección existe; se propone mejorar la confirmación del cambio |

El nombre de una ruta admite referencias como **14, 10B, 1 u 11**. No se trata como un número entero, porque puede contener letras. Cada ruta mantiene su identificador interno y su pertenencia a una empresa. La política de nombres duplicados y los sentidos de ida y vuelta requieren definición con el responsable de requisitos.

### Cambio de conductor entre jornadas

La asignación representa quién utiliza el micro actualmente; no es una relación permanente. Por ejemplo, un micro puede estar asignado a un conductor en una jornada y a otro en la siguiente.

El flujo previsto es: Micros → Detalle → Editar → Seleccionar conductor → Revisar cambio → Guardar.

- El micro y el conductor pertenecen a la misma empresa.
- Un conductor tiene como máximo un micro asignado a la vez, y un micro tiene como máximo un conductor actual.
- Si el conductor ya tiene otro micro, se informa cuál es y se solicita resolver esa asignación antes de continuar.
- Si el micro está en recorrido, se bloquea el cambio de conductor o ruta hasta finalizarlo.
- Antes de guardar, se propone mostrar la placa, la ruta y los nombres del conductor anterior y del nuevo.
- El cambio solo se anuncia como guardado después de la respuesta del servidor. Si otra persona modifica la asignación al mismo tiempo, se informa el conflicto y se permite recargar los datos.
- El Modo Conductor debe consultar nuevamente su asignación antes de iniciar un recorrido.

Guardar un historial de asignaciones por fecha y turno es una mejora futura. La asignación actual no se presenta como si ya existiera ese historial.

### Contenido propuesto para el dashboard de empresa

| Indicador | Qué permite conocer |
|---|---|
| Micros registrados y en recorrido | Tamaño de la flota y unidades que están operando |
| Micros sin actualización reciente | Unidades cuyo dato no se debe presentar como ubicación en vivo |
| Micros sin ruta o sin conductor | Asignaciones pendientes antes de iniciar un recorrido |
| Rutas activas | Rutas habilitadas de la empresa seleccionada |

Cada indicador permite abrir su listado filtrado. El mapa muestra la hora de la última actualización y distingue una unidad detenida de una unidad sin conexión. El umbral para considerar una posición desactualizada queda pendiente de acuerdo con tiempo real y QA.

## 4. Conductor

La empresa crea sus credenciales. El conductor entra al Modo Conductor de la app, revisa el micro y la ruta asignados y activa su salida desde el paradero de inicio.

El flujo de diseño es: Iniciar sesión → Revisar asignación → Iniciar recorrido → Confirmar → Recorrido activo → Finalizar → Confirmar finalización.

- El conductor no elige libremente otro micro ni modifica su asignación.
- Sin un micro y una ruta válidos, la pantalla explica qué falta y remite al administrador de empresa.
- Antes del inicio se comprueban el permiso de ubicación y la conexión. Una falla ofrece una acción para resolverla.
- Durante el recorrido se muestran el micro, la ruta, el estado del GPS y la última transmisión.
- Al finalizar se solicita detener el seguimiento operativo del micro y se muestra si el servidor confirmó la finalización. Si falla, se conserva un aviso y una opción para reintentar.
- La posición antigua de un recorrido finalizado o sin señal no se presenta al pasajero como ubicación actual.

No se define todavía un cobro de pasaje, una liquidación ni un control automático que obligue a estar dentro de una zona geográfica para pulsar Iniciar.

## 5. Pasajero e invitado

El pasajero busca una ruta, selecciona un micro y consulta dónde se encuentra y cuánto podría tardar en llegar a su punto de espera. La consulta básica permite entrar sin cuenta.

| Nivel de acceso | Funciones previstas | Decisiones pendientes |
|---|---|---|
| Invitado | Consulta limitada de rutas y micros; detalle del micro y tiempo estimado de llegada, cuando hay datos válidos | Máximos definitivos de micros y trazados simultáneos |
| Cuenta gratuita | Mayor capacidad de consulta simultánea que el invitado; perfil, historial de búsquedas por un periodo limitado y favoritos básicos del diseño existente | Máximos simultáneos, duración del historial y cuota de favoritos |
| Premium | Mayor capacidad que la cuenta gratuita y conservación del historial por más tiempo | Máximos, duración y mecanismo de habilitación del beneficio |

Los límites numéricos definitivos quedan pendientes de definición. La idea inicial del invitado limitado a un micro y una ruta se conserva como antecedente para esa decisión.

Los límites de micros seguidos y trazados de rutas visibles se definen por separado. Tampoco equivalen al número de resultados del catálogo: una persona puede buscar entre varias rutas y seleccionar solo las que permita su nivel de acceso.

El historial se refiere a **búsquedas de rutas y micros**, no a registrar los desplazamientos personales del pasajero. Se propone permitir borrar búsquedas. Su almacenamiento y conservación quedan por definir.

### Información del conductor en el detalle del micro

Se incorpora como función prevista un apartado del conductor actualmente asignado al micro seleccionado. Como contenido inicial se propone su nombre de uso, la empresa y la identificación del micro y de la ruta. Los campos públicos definitivos quedan pendientes de acuerdo; la vista no necesita mostrar documentos de identidad, correo, teléfono personal ni credenciales.

Si todavía no hay conductor asignado o la consulta no tiene un dato vigente, se informa esa situación. No se reutiliza como actual el perfil del conductor de una jornada anterior.

## 6. Premium y ampliaciones

Premium queda contemplado en la arquitectura para una etapa posterior. Se prevén una vista informativa de beneficios, configuración por el administrador general y consulta del estado del beneficio. La activación administrativa, los periodos y el vencimiento requieren una definición posterior; no se inventa una compra para resolverlos.

El nivel de ocupación —por ejemplo, vacío, medio lleno o lleno— es una idea futura. Primero se debe definir quién aporta el dato, cómo lo actualiza y cuánto tiempo se considera vigente. La capacidad registrada del micro no permite saber por sí sola cuántas personas viajan en él.

Otras mejoras que se pueden evaluar después son el historial de asignaciones, alertas de proximidad y resúmenes operativos. No se muestran como módulos terminados ni como controles vacíos en el panel actual.

**No se incluyen medios de pago, venta de pasajes, cobro de pasajes ni procesamiento de pagos Premium.** Una posible integración futura se define en otra entrega.

## 7. Cambios que requieren coordinación

| Tema | Diferencia con documentos anteriores | Acción pendiente |
|---|---|---|
| Acceso sin cuenta | El mapa anterior lo dejaba pendiente; el prototipo del pasajero ya lo representa y Alex confirma su inclusión | Mantener una entrada visible como invitado |
| Límites gratuitos y Premium | T051 y la prueba PRB-009 de T054 describen un máximo de dos micros; ese número no es la nueva cuota definitiva | Acordar límites y después actualizar requisitos, Figma y pruebas; conservar los resultados históricos de T054 |
| Historial y datos del conductor | Se incorporan en la idea de producto precisada para T091 | Detallar los casos de uso, el contenido público y el modelo de datos antes de desarrollar |
| Administración | El mapa anterior agrupaba ambos administradores | Diferenciar navegación, permisos y alcance por empresa |
| Dashboard y monitoreo | Existen referencias de diseño; no hay un dashboard operativo ni monitoreo web conectado en la versión revisada | Diseñar indicadores y completar su integración en las tareas de implementación |
| Premium | Los casos de uso previos incluyen funciones adicionales y suscripciones | Acordar el incremento futuro y mantener fuera los pagos |

Las fichas de casos de uso y la matriz de permisos incorporadas al `develop` de documentación en el [PR #26](https://github.com/tuChaski/go-tacna-docs/pull/26) son referencias para esta coordinación. T091 no las reemplaza ni declara implementadas todas sus operaciones.

## 8. Referencias de la revisión

- Alcance comunicado por Alex para esta entrega: dos administradores, asignación variable de conductor, acceso sin cuenta, cuentas gratuitas y Premium futuro; límites numéricos diferidos.
- [T091 — Arquitectura de contenido e inventario](https://github.com/tuChaski/go-tacna-frontend/issues/52).
- [Panel administrativo revisado en frontend/develop](https://github.com/tuChaski/go-tacna-frontend/blob/9d4a070336ae60755f1642816075711a8bb5a641/src/modulos/administracion/PanelAdministracion.tsx) y [formulario de registros](https://github.com/tuChaski/go-tacna-frontend/blob/9d4a070336ae60755f1642816075711a8bb5a641/src/modulos/administracion/componentes/FormularioRegistro.tsx).
- [T053 — Diseño administrativo](prototipo-administrador.md), [T051 — Diseño del pasajero](prototipo-pasajero.md) y [T054 — Revisión del prototipo](../pruebas/informes/t054-pruebas-usabilidad-figma.md).
