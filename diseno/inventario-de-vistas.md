# Inventario de vistas

> **Estado:** En revisión
> **Responsable:** Alex Huaracha
> **Relacionado:** [mapa del sitio](mapa-del-sitio.md), [alcance por perfil](alcance-por-perfil.md), [Figma](figma.md), [casos de uso](../casos-de-uso/)

## 1. Cómo se lee

El inventario registra una fila por pantalla o panel con una función propia. Los estados de error, carga y confirmación se agrupan cuando comparten la misma vista; no se cuentan como pantallas diferentes por cada dato de ejemplo.

Se conservan WEB-01 a WEB-08 y MOV-01 a MOV-07 del mapa anterior. WEB-04, WEB-05 y WEB-06 mantienen su función y se corrigen a las rutas actuales del administrador de empresa.

**Estado de la interfaz:** **Código** significa que existe en el frontend revisado; no acredita una nueva prueba contra el servidor. **Figma** significa que está representada en las entregas documentadas del prototipo, sin implementación móvil acreditada en esta revisión. **Propuesta** identifica una ampliación que requiere diseño o desarrollo. Una misma fila puede tener una base en Figma y ampliaciones propuestas.

**Referencias:** los CU mantienen los números de los diagramas de [autenticación](../casos-de-uso/diagrama_casos_uso_autenticacion.puml), [administración](../casos-de-uso/diagrama_casos_uso_modulo_administrador.puml), [pasajero](../casos-de-uso/diagrama_casos_uso_modulo_pasajero.puml), [conductor](../casos-de-uso/diagrama_casos_uso_modulo_conductor.puml) y [Premium](../casos-de-uso/diagrama_casos_uso_modulo_planificacion_premium.puml). No se adoptan los RF antiguos que aparecen dentro de esos diagramas. Una referencia de CU no significa que su implementación esté completa.

## 2. Web pública y acceso

| ID | Vista y ruta web | Perfil | Contenido y acciones | Estado | Referencia |
|---|---|---|---|---|---|
| WEB-01 | Inicio de sesión — `/login` | Todos los perfiles con cuenta | Correo, contraseña, validación y entrada al destino del rol | Código | CU-02 |
| WEB-09 | Inicio público — `/` | Público | Presentación, rutas destacadas y acceso al mapa, registro y login | Código | CU-04, CU-05 |
| WEB-10 | Mapa público — `/mapa` | Público | Consulta de rutas y unidades representadas; selección y trazados | Código; la animación de micros es demostrativa, no seguimiento GPS acreditado | CU-04, CU-07, CU-10 |
| WEB-11 | Registro — `/registro` | Nuevo pasajero | Datos personales, correo y contraseña; crear cuenta de pasajero | Código | CU-01 |
| WEB-12 | Mi cuenta — `/cuenta` | Pasajero o conductor | Datos de la sesión y cerrar sesión; al conductor le indica usar la app para operar | Código; no es un panel de operación del conductor | CU-02, CU-20 |

## 3. Administración general

| ID | Vista y ruta web | Perfil | Contenido y acciones | Estado | Referencia |
|---|---|---|---|---|---|
| WEB-02 | Inicio general — entrada `/admin` | General | Resumen y accesos de plataforma; se propone ampliar indicadores | Figma; en código la entrada redirige al listado de Empresas | CU-25 |
| WEB-03 | Empresas — `/admin/empresas` | General | Listado, búsqueda, filtros, paginación y acceso a registro, detalle, edición y estado | Código y Figma | CU-25 |
| WEB-13 | Registrar empresa — `/admin/empresas/nuevo` | General | Razón social, RUC, teléfono y dirección; guardar o cancelar | Código y Figma; la cuenta administrativa se crea después | CU-25 |
| WEB-14 | Detalle de empresa — `/admin/empresas/:id` | General | Datos, estado, cuentas vinculadas y acceso a crear o editar una cuenta | Código y Figma | CU-25 |
| WEB-15 | Editar empresa — `/admin/empresas/:id/editar` | General | Modificar datos de la empresa y guardar o cancelar | Código y Figma | CU-25 |
| WEB-16 | Crear cuenta administrativa — `/admin/empresas/:id/cuentas/nueva` | General | Identidad, correo y contraseña inicial del administrador de esa empresa | Código; Figma representa credenciales junto con la empresa | CU-25; alcance por perfil |
| WEB-17 | Editar cuenta administrativa — `/admin/empresas/:id/cuentas/:usuarioId/editar` | General | Editar datos de la cuenta vinculada; contraseña nueva opcional | Código | CU-25; alcance por perfil |
| WEB-07 | Pasajeros — ruta propuesta `/admin/usuarios` | General | Listar y buscar cuentas; consultar identidad y estado; confirmar activación o desactivación | Propuesta; sin módulo web actual | CU-30 |
| WEB-08 | Supervisión general — ruta propuesta `/admin/monitoreo` | General | Filtro por empresa, micros y última ubicación; ampliar al detalle de una unidad | Propuesta; el monitor de Figma corresponde a la empresa | CU-29 |
| WEB-31 | Configuración de planes — ruta propuesta `/admin/planes` | General | Catálogo y panel de edición de beneficios, límites y disponibilidad | Propuesta futura; sin cobros | CU-31 |
| WEB-32 | Beneficios de pasajeros — ruta propuesta `/admin/suscripciones` | General | Listado y panel del estado del beneficio Premium, titular y vigencia | Propuesta futura; mecanismo de habilitación pendiente | CU-31 |

## 4. Administración de empresa

Las rutas comparten el prefijo `/admin/empresa`. La empresa se determina por la sesión y la selección entre vínculos autorizados; no se concede acceso al escribir otro identificador en una URL.

| ID | Vista y ruta web | Perfil | Contenido y acciones | Estado | Referencia |
|---|---|---|---|---|---|
| WEB-18 | Inicio de empresa — entrada `/admin/empresa` | Empresa | Selección de empresa y accesos; se propone dashboard de flota con indicadores | Selección en código y referencia en Figma; la entrada actual redirige a Rutas | CU-26 a CU-29 |
| WEB-04 | Rutas — `/admin/empresa/rutas` | Empresa | Listado, búsqueda y acceso a crear, consultar, editar y cambiar estado | Código y Figma | CU-26 |
| WEB-19 | Registrar ruta — `/admin/empresa/rutas/nuevo` | Empresa | Nombre, como 14 o 10B, y editor del trazado; guardar o cancelar | Código; Figma representa referencias de origen y destino | CU-26 |
| WEB-20 | Detalle de ruta — `/admin/empresa/rutas/:id` | Empresa | Nombre, estado y trazado; volver, editar o gestionar estado | Código y Figma | CU-26 |
| WEB-21 | Editar ruta — `/admin/empresa/rutas/:id/editar` | Empresa | Modificar nombre y trazado dentro de la misma empresa | Código; el editor geográfico completo no está representado en T053 | CU-26 |
| WEB-05 | Micros — `/admin/empresa/micros` | Empresa | Listado, filtros, estado, ruta y conductor; acceso a gestión de cada unidad | Código y Figma | CU-27 |
| WEB-22 | Registrar micro — `/admin/empresa/micros/nuevo` | Empresa | Placa, capacidad y asociaciones opcionales de ruta y conductor | Código y Figma; un micro incompleto no queda listo para iniciar recorrido | CU-27 |
| WEB-23 | Detalle de micro — `/admin/empresa/micros/:id` | Empresa | Placa, capacidad, estado, ruta y conductor actual; volver o editar | Código y Figma | CU-27 |
| WEB-24 | Editar micro y asignación — `/admin/empresa/micros/:id/editar` | Empresa | Modificar datos y cambiar ruta o conductor; bloquear reasignación en recorrido | Código y Figma; confirmación mejorada propuesta en WEB-30 | CU-27, CU-28 |
| WEB-06 | Conductores — `/admin/empresa/conductores` | Empresa | Listado, búsqueda, estado operativo y acceso a registro, detalle y edición | Código y Figma | CU-28 |
| WEB-25 | Registrar conductor — `/admin/empresa/conductores/nuevo` | Empresa | Identidad, contacto, correo, contraseña inicial y licencia; crear cuenta y perfil | Código y Figma; no asigna por sí solo un micro | CU-28 |
| WEB-26 | Detalle de conductor — `/admin/empresa/conductores/:id` | Empresa | Datos laborales, cuenta y micro actual; consultar o ir a edición | Código y Figma; nunca muestra contraseñas | CU-28 |
| WEB-27 | Editar conductor — `/admin/empresa/conductores/:id/editar` | Empresa | Modificar licencia; ampliar edición de identidad o credenciales requiere permisos y diseño | Código limitado a licencia; Figma representa una edición más amplia | CU-28 |
| WEB-29 | Monitoreo de empresa — ruta propuesta `/admin/empresa/monitoreo` | Empresa | Mapa de su flota, filtros, ruta, estado y última actualización de cada micro | Figma; pendiente de integración web en tiempo real | CU-29 |
| WEB-30 | Revisar reasignación — diálogo dentro de WEB-24, sin ruta propia | Empresa | Placa, ruta, conductor anterior y nuevo; confirmar o cancelar el cambio | Propuesta de mejora | CU-27, CU-28 |
| WEB-28 | Confirmaciones de gestión — diálogos de los módulos, sin ruta propia | General o empresa según recurso | Cambio de estado o eliminación; explicar dependencias, confirmar o cancelar | Código y Figma; sus políticas de baja no son idénticas | CU-25 a CU-28 |

En código existe eliminación definitiva sujeta a dependencias; en Figma la baja se representa como desactivación. Se mantienen diferenciadas. El estado operativo del conductor no equivale al estado de su cuenta. La política unificada de bajas y la edición de credenciales del conductor requieren coordinación con backend.

## 5. App Android: acceso y pasajero

Las ubicaciones de esta sección son conceptuales o paneles del prototipo; no se presentan como rutas implementadas de React Native. Los cupos numéricos y periodos de historial siguen pendientes.

| ID | Vista o ubicación conceptual | Perfil | Contenido y acciones | Estado | Referencia |
|---|---|---|---|---|---|
| MOV-01 | Registro — `/registro` | Nuevo pasajero | Datos y credenciales para crear su cuenta; volver al acceso | Figma | CU-01 |
| MOV-02 | Inicio de sesión — `/login` | Pasajero o conductor | Credenciales y entrada según el rol; continuar sin cuenta para consulta de pasajero | Figma | CU-02, CU-20 |
| MOV-03 | Consulta y selección de rutas — `/pasajero/rutas` | Invitado o pasajero | Buscar y elegir una ruta; ver sus micros y volver al mapa | Figma | CU-05, CU-06 |
| MOV-04 | Mapa de micros — `/pasajero/mapa` | Invitado o pasajero | Ubicación y micros seleccionados; elegir ruta o micro y abrir filtros | Figma; límites pendientes de actualización | CU-04, CU-07, CU-12 |
| MOV-05 | Detalle del micro y ETA — panel del mapa | Invitado o pasajero | Empresa, ruta, unidad, última actualización y tiempo estimado al punto de espera | Figma; el nuevo apartado del conductor se detalla en MOV-19 | CU-08, CU-09 |
| MOV-08 | Bienvenida — entrada de la app | Público | Acceder, registrarse o continuar como invitado | Figma | CU-01, CU-02, CU-04 |
| MOV-09 | Ver ubicación — vista del micro seleccionado | Invitado o pasajero | Ubicar el micro y consultar su actualización respecto al punto de espera | Figma | CU-07, CU-09 |
| MOV-10 | Punto de espera — selector del mapa | Invitado o pasajero | Elegir ubicación actual o punto de referencia; conservar el micro seleccionado | Figma | CU-11, CU-12 |
| MOV-11 | Filtros y trazado — panel del mapa | Invitado o pasajero | Seleccionar o quitar micros y mostrar sus rutas; indicar límites cuando se definan | Figma con cuota anterior; actualización pendiente | CU-06, CU-10, CU-14 |
| MOV-12 | Perfil — menú de la cuenta | Pasajero | Datos de cuenta, accesos personales y cerrar sesión | Figma; el acceso al historial se propone en MOV-18 | CU-02 |
| MOV-13 | Favoritos — lista y paneles de gestión | Pasajero | Consultar, guardar y quitar referencias frecuentes | Figma; cuota y separación de beneficios pendientes | CU-17, con alcance básico de T051 |
| MOV-14 | Ayuda y problemas — sección de estados | Invitado o pasajero | Información y recuperación ante falta de conexión, GPS, ETA o datos recientes | Figma | CU-07, CU-09, CU-12 |
| MOV-18 | Historial de búsquedas — sección de cuenta | Pasajero | Consultas recientes de rutas y micros; se propone volver a buscar y borrar entradas | Propuesta; periodos gratuito y Premium pendientes | Alcance por perfil; CU-18 requiere ajuste |
| MOV-19 | Conductor actual — apartado del detalle del micro | Invitado o pasajero según campos públicos por definir | Identidad visible acordada y vínculo con empresa, ruta y micro actuales | Propuesta; contenido público y disponibilidad de datos pendientes | Ampliación de CU-08 |
| MOV-20 | Beneficios Premium — sección informativa | Pasajero | Comparar funciones previstas y consultar su nivel, sin compra ni medio de pago | Propuesta futura | CU-14 a CU-19; alcance por precisar |

## 6. App Android: Modo Conductor

| ID | Vista o ubicación conceptual | Perfil | Contenido y acciones | Estado | Referencia |
|---|---|---|---|---|---|
| MOV-06 | Inicio del conductor — `/conductor/inicio` | Conductor | Micro y ruta asignados; revisar datos e iniciar salida del paradero | Figma; sin asignación válida se debe bloquear el inicio | CU-20, CU-21, CU-22 |
| MOV-15 | Confirmar inicio — diálogo del Modo Conductor | Conductor | Confirmar micro, ruta y comienzo de la transmisión; cancelar | Figma; navegación observada con fallos en T054 | CU-21, CU-22 |
| MOV-07 | Recorrido activo — `/conductor/recorrido` | Conductor | Estado del GPS, conexión, última transmisión y acción Finalizar | Figma; funcionamiento móvil no acreditado | CU-22, CU-24 |
| MOV-16 | Confirmar finalización — diálogo del recorrido | Conductor | Confirmar la finalización y mostrar si se recibió respuesta | Figma; navegación observada con fallos en T054 | CU-23 |
| MOV-17 | Recorrido finalizado — resultado de la operación | Conductor | Confirmación de cierre y regreso a la asignación; error recuperable si no se confirma | Figma; transición pendiente de verificar de nuevo | CU-23, CU-24 |

## 7. Estados que deben contemplar las vistas

Esta tabla indica cobertura necesaria para diseño e implementación; no declara que todas las combinaciones hayan sido probadas.

| Grupo | Estados y respuesta esperada |
|---|---|
| WEB-01, WEB-11, MOV-01, MOV-02 | Campos incompletos, credenciales incorrectas, correo duplicado, cuenta desactivada, envío pendiente y error de conexión |
| Listados administrativos y MOV-03 | Cargando, vacío inicial, búsqueda sin resultados, error con Reintentar y falta de permiso |
| Formularios administrativos | Validación por campo, envío pendiente, duplicado o conflicto de relaciones, error sin perder datos y cancelación |
| WEB-16, WEB-17, WEB-25, WEB-27 | Alta y edición con permisos diferenciados; credenciales fuera de listados y detalles; error al crear o vincular cuenta sin anunciar éxito |
| WEB-18 | Sin empresas vinculadas, selección de empresa autorizada y cambio de contexto sin conservar datos de otra empresa |
| WEB-24, WEB-30 | Conductor ocupado o inactivo, ruta inactiva, recorrido activo y asignación modificada por otra sesión |
| WEB-28 | Acción pendiente, bloqueo por dependencias, error de servidor y confirmación del resultado |
| WEB-08, WEB-29, MOV-04, MOV-05, MOV-09 | Sin micros activos, carga, desconexión, dato desactualizado, recorrido finalizado y ETA no disponible |
| MOV-10, MOV-11 | Permiso de ubicación denegado, selección vacía y cuota alcanzada cuando sus valores estén definidos |
| MOV-12, MOV-13, MOV-18 | Sesión caducada, lista vacía y error al consultar, guardar o borrar |
| MOV-06, MOV-15, MOV-07, MOV-16, MOV-17 | Sin micro o ruta, GPS deshabilitado, sin conexión, operación pendiente y fallo al confirmar inicio o finalización |
| WEB-31, WEB-32, MOV-20 | Funciones futuras: estado del beneficio y vigencia pendientes de especificar; sin flujo de compra |
| MOV-19 | Sin conductor asignado o información no vigente; no mostrar datos de una asignación anterior como actual |

## 8. Base de la revisión

El código web corresponde a [frontend/develop, commit 9d4a070](https://github.com/tuChaski/go-tacna-frontend/tree/9d4a070336ae60755f1642816075711a8bb5a641), especialmente [rutas de acceso](https://github.com/tuChaski/go-tacna-frontend/blob/9d4a070336ae60755f1642816075711a8bb5a641/src/modulos/autenticacion/RutasAcceso.tsx), [panel administrativo](https://github.com/tuChaski/go-tacna-frontend/blob/9d4a070336ae60755f1642816075711a8bb5a641/src/modulos/administracion/PanelAdministracion.tsx) y [formularios](https://github.com/tuChaski/go-tacna-frontend/blob/9d4a070336ae60755f1642816075711a8bb5a641/src/modulos/administracion/componentes/FormularioRegistro.tsx). Ese avance no está íntegramente en frontend/main.

Las referencias de Figma proceden de las entregas [T050](login-resgistro-figma.md), [T051](prototipo-pasajero.md), [T053](prototipo-administrador.md), [T093](flujo-navegacion-pasajero.md) y del [informe T054](../pruebas/informes/t054-pruebas-usabilidad-figma.md). No se realiza una nueva ejecución de Figma ni una prueba con personas como parte de este inventario.

Se registran **52 vistas y paneles: 32 web y 20 móviles**. El número no equivale al total de frames de Figma, porque se agrupan las variantes de datos y estados. La aprobación del contenido y su integración en el informe final quedan pendientes.
