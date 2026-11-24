# Especificación detallada de casos de uso

> **Estado:** En revisión
> **Responsable:** Todo el equipo
> **Relacionado:** [diagrama_casos_uso_autenticacion.puml](diagrama_casos_uso_autenticacion.puml), [diagrama_casos_uso_modulo_pasajero.puml](diagrama_casos_uso_modulo_pasajero.puml), [diagrama_casos_uso_modulo_planificacion_premium.puml](diagrama_casos_uso_modulo_planificacion_premium.puml), [diagrama_casos_uso_modulo_conductor.puml](diagrama_casos_uso_modulo_conductor.puml), [diagrama_casos_uso_modulo_administrador.puml](diagrama_casos_uso_modulo_administrador.puml), [../requisitos/perfiles-y-matriz-acceso.md](../requisitos/perfiles-y-matriz-acceso.md), [../contratos/openapi.yaml](../contratos/openapi.yaml), [../contratos/eventos-websocket.md](../contratos/eventos-websocket.md)

## 1. Propósito y alcance

Este documento desarrolla la especificación detallada de los **31 casos de uso (`CU-01` a `CU-31`)** modelados en los cinco diagramas PlantUML de la carpeta `casos-de-uso/` (correspondientes a la tarea **T080**). Cada ficha define actores, requisitos asociados, precondiciones, flujo principal, flujos alternativos o excepciones y postcondiciones, manteniendo trazabilidad con la API REST (`/api/v1/*`), el servicio de tiempo real (Socket.IO) y los perfiles de acceso definidos en [../requisitos/perfiles-y-matriz-acceso.md](../requisitos/perfiles-y-matriz-acceso.md).

> **Nota sobre identificadores de requerimientos:** Cada caso de uso conserva la referencia `RF-XX` declarada en su diagrama `.puml` de origen (`RF-01` a `RF-40`) e indica, en la tabla resumen, su correspondencia con la numeración consolidada de la guía del Trabajo Final (`RF-01` a `RF-20`).

---

## 2. Índice general de casos de uso

| Código | Nombre del caso de uso | Módulo | Requisito (`.puml`) | Equivalencia Guía TF | Actor(es) principal(es) |
|---|---|---|---|---|---|
| `CU-01` | Registrar Cuenta de Pasajero | 1. Autenticación y Cuentas | `RF-01` | `RF-01` | Usuario No Registrado, Pasajero |
| `CU-02` | Iniciar Sesión | 1. Autenticación y Cuentas | `RF-02` | `RF-02` | Pasajero, Conductor, Administrador |
| `CU-03` | Recuperar Contraseña | 1. Autenticación y Cuentas | `RF-03` | `RF-02` | Pasajero, Conductor, Administrador |
| `CU-04` | Consultar Rutas y Micros sin Cuenta | 1. Autenticación y Cuentas | `RF-04` | `RF-03`, `RF-04` | Usuario No Registrado |
| `CU-05` | Visualizar Rutas Disponibles | 2. Pasajero | `RF-05` | `RF-03` | Pasajero, Usuario No Registrado |
| `CU-06` | Seleccionar Ruta Específica | 2. Pasajero | `RF-06` | `RF-03` | Pasajero |
| `CU-07` | Visualizar Micros en Mapa en Tiempo Real | 2. Pasajero | `RF-07`, `RF-08` | `RF-04`, `RF-05` | Pasajero |
| `CU-08` | Consultar Información Detallada del Micro | 2. Pasajero | `RF-09` | `RF-06` | Pasajero |
| `CU-09` | Ver Estimación de Tiempo de Llegada | 2. Pasajero | `RF-10` | `RF-07` | Pasajero |
| `CU-10` | Visualizar Recorrido de la Ruta | 2. Pasajero | `RF-11` | `RF-08` | Pasajero, Usuario No Registrado |
| `CU-11` | Seleccionar Punto de Espera o Paradero | 2. Pasajero | `RF-12` | `RF-09` | Pasajero |
| `CU-12` | Consultar Micros Cercanos al Usuario | 2. Pasajero | `RF-13` | `RF-10` | Pasajero |
| `CU-13` | Consultar y Comparar Alternativas de Viaje | 3. Planificación y Premium | `RF-14`, `RF-15`, `RF-16` | `RF-11` | Pasajero, Pasajero Premium |
| `CU-14` | Visualizar Más de 2 Micros Simultáneamente | 3. Planificación y Premium | `RF-17` | `RF-18` | Pasajero Premium |
| `CU-15` | Consultar Nivel de Ocupación del Micro | 3. Planificación y Premium | `RF-18` | `RF-19` | Pasajero Premium |
| `CU-16` | Recibir Alertas de Micro Próximo | 3. Planificación y Premium | `RF-19` | `RF-20` | Pasajero Premium |
| `CU-17` | Guardar Múltiples Rutas y Paraderos Favoritos | 3. Planificación y Premium | `RF-20` | `RF-18` | Pasajero Premium |
| `CU-18` | Acceder a Historial y Predicción Avanzada | 3. Planificación y Premium | `RF-21`, `RF-22`, `RF-23`, `RF-24` | `RF-18` | Pasajero Premium |
| `CU-19` | Navegar Sin Publicidad | 3. Planificación y Premium | `RF-25` | `RF-18` | Pasajero Premium |
| `CU-20` | Iniciar Sesión Modo Conductor | 4. Conductor | `RF-26` | `RF-12` | Conductor |
| `CU-21` | Vincular y Confirmar Micro Asignado | 4. Conductor | `RF-27` | `RF-12` | Conductor |
| `CU-22` | Iniciar Recorrido y Transmitir Ubicación | 4. Conductor | `RF-28`, `RF-29` | `RF-13` | Conductor, Sistema GPS Móvil |
| `CU-23` | Finalizar Recorrido y Cambiar Estado | 4. Conductor | `RF-30`, `RF-31` | `RF-14` | Conductor |
| `CU-24` | Monitorear Estado de GPS y Conexión | 4. Conductor | `RF-32` | `RF-13` | Conductor, Sistema GPS Móvil |
| `CU-25` | Gestionar Empresas de Transporte | 5. Administración | `RF-33` | `RF-15` | Administrador (`admin_general`, `admin_empresa`) |
| `CU-26` | Gestionar Rutas y Paraderos | 5. Administración | `RF-34` | `RF-15` | Administrador (`admin_empresa`, `admin_general`) |
| `CU-27` | Gestionar Unidades Micros | 5. Administración | `RF-35` | `RF-15` | Administrador (`admin_empresa`, `admin_general`) |
| `CU-28` | Gestionar Cuentas de Conductores | 5. Administración | `RF-36` | `RF-15` | Administrador (`admin_empresa`, `admin_general`) |
| `CU-29` | Supervisar Unidades y Estados en Tiempo Real | 5. Administración | `RF-37`, `RF-38` | `RF-16` | Administrador (`admin_empresa`, `admin_general`) |
| `CU-30` | Gestionar Cuentas de Pasajeros | 5. Administración | `RF-39` | `RF-15` | Administrador (`admin_general`) |
| `CU-31` | Gestionar Suscripciones Premium | 5. Administración | `RF-40` | `RF-17` | Administrador (`admin_general`) |

---

## 3. Módulo 1: Autenticación y Cuentas

Fuente del diagrama: [diagrama_casos_uso_autenticacion.puml](diagrama_casos_uso_autenticacion.puml).

### CU-01 — Registrar Cuenta de Pasajero

| Atributo | Especificación |
|---|---|
| **Código** | `CU-01` |
| **Nombre** | Registrar Cuenta de Pasajero |
| **Requerimiento** | `RF-01` |
| **Actor(es)** | Usuario No Registrado (Visitante), Pasajero |
| **Precondición** | El visitante accede al formulario de registro y no posee una cuenta registrada con el mismo DNI o correo electrónico. |
| **Flujo principal** | 1. El usuario selecciona la opción de crear cuenta.<br>2. El usuario ingresa `dni`, `nombre`, `apellido`, `correo`, `telefono` y `password`.<br>3. El sistema valida el formato de los datos y la unicidad de `dni` y `correo` (`POST /api/v1/auth/register`).<br>4. El sistema crea el registro en `usuarios` con rol `pasajero` y estado `activo = true`.<br>5. El sistema emite un token JWT (`HS256`, vigencia de 60 minutos) y redirige al pasajero al mapa principal. |
| **Flujo alternativo / excepciones** | - **3a. Datos incompletos o con formato inválido:** El sistema responde `422 Unprocessable Entity` indicando los campos con error y conserva los datos ingresados.<br>- **3b. DNI o correo ya registrado:** El sistema rechaza el alta con `422` e informa que el identificador ya se encuentra en uso. |
| **Postcondición** | La cuenta de pasajero queda persistida y activa en la base de datos, y el usuario inicia sesión con su token JWT. |

### CU-02 — Iniciar Sesión

| Atributo | Especificación |
|---|---|
| **Código** | `CU-02` |
| **Nombre** | Iniciar Sesión |
| **Requerimiento** | `RF-02` |
| **Actor(es)** | Pasajero, Conductor, Administrador (`admin_empresa`, `admin_general`) |
| **Precondición** | El usuario cuenta con credenciales registradas en la tabla `usuarios`. |
| **Flujo principal** | 1. El usuario ingresa su `correo` y `password` en la pantalla de acceso.<br>2. El cliente envía las credenciales a `POST /api/v1/auth/login`.<br>3. El sistema verifica las credenciales contra `password_hash` y comprueba que `activo = true`.<br>4. El sistema genera el token JWT con los claims de dominio (`rol`, `micro_id`, `ruta_id`, `empresa_ids`).<br>5. El sistema redirige al usuario a la vista correspondiente a su perfil (mapa de pasajero, Modo Conductor, panel de empresa o panel de administración general). |
| **Flujo alternativo / excepciones** | - **3a. Credenciales incorrectas:** El sistema devuelve `401 Unauthorized` y muestra un mensaje de rechazo sin revelar cuál de los campos falló.<br>- **3b. Cuenta desactivada (`activo = false`):** El sistema devuelve `403 Forbidden` e impide la emisión del token.<br>- **4a. Olvido de contraseña:** El usuario invoca la extensión `CU-03` (Recuperar Contraseña). |
| **Postcondición** | El usuario recibe un token JWT válido para autenticar sus peticiones subsecuentes y queda ubicado en el entorno de su rol. |

### CU-03 — Recuperar Contraseña

| Atributo | Especificación |
|---|---|
| **Código** | `CU-03` |
| **Nombre** | Recuperar Contraseña |
| **Requerimiento** | `RF-03` |
| **Actor(es)** | Pasajero, Conductor, Administrador (extiende a `CU-02`) |
| **Precondición** | El usuario se encuentra en la pantalla de inicio de sesión (`CU-02`) y no recuerda su contraseña. |
| **Flujo principal** | 1. El usuario selecciona la opción «¿Olvidaste tu contraseña?» desde la vista de inicio de sesión.<br>2. El sistema solicita el correo electrónico asociado a la cuenta.<br>3. El usuario ingresa su `correo` y confirma la solicitud.<br>4. El sistema valida el formato del correo y gestiona las instrucciones de restablecimiento o canaliza el cambio de credencial según el perfil.<br>5. El usuario actualiza su contraseña y regresa al formulario de inicio de sesión (`CU-02`). |
| **Flujo alternativo / excepciones** | - **4a. Correo con formato inválido:** El sistema informa el error de validación y solicita corregir el correo.<br>- **4b. Cuenta administrada por empresa (Conductor):** Si el conductor requiere restablecimiento asistido, el administrador de su empresa o el administrador general actualiza la credencial desde la gestión de cuentas. |
| **Postcondición** | El usuario dispone de una nueva contraseña válida (`password_hash` actualizado) para autenticarse en `CU-02`. |

### CU-04 — Consultar Rutas y Micros sin Cuenta

| Atributo | Especificación |
|---|---|
| **Código** | `CU-04` |
| **Nombre** | Consultar Rutas y Micros sin Cuenta |
| **Requerimiento** | `RF-04` |
| **Actor(es)** | Usuario No Registrado (Visitante) |
| **Precondición** | El visitante abre la aplicación web o móvil sin iniciar sesión. |
| **Flujo principal** | 1. El visitante accede a la vista pública del mapa.<br>2. El sistema consulta el catálogo público de rutas activas (`GET /api/v1/rutas`) y micros activos (`GET /api/v1/micros/activos`) sin requerir encabezado `Authorization`.<br>3. El sistema muestra las rutas activas y hasta el límite gratuito de micros en circulación sobre el mapa.<br>4. El visitante explora el trazado básico y la posición de las unidades activas. |
| **Flujo alternativo / excepciones** | - **4a. Intento de usar funciones exclusivas de cuenta o Premium:** El sistema muestra un aviso invitando al visitante a registrarse (`CU-01`) o iniciar sesión (`CU-02`).<br>- **2a. Sin micros en recorrido:** El sistema muestra el trazado de las rutas activas e indica que no hay unidades transmitiendo en ese momento. |
| **Postcondición** | El visitante visualiza la información pública básica de rutas y micros sin haber creado una sesión autenticada. |

---

## 4. Módulo 2: Pasajero

Fuente del diagrama: [diagrama_casos_uso_modulo_pasajero.puml](diagrama_casos_uso_modulo_pasajero.puml).

### CU-05 — Visualizar Rutas Disponibles

| Atributo | Especificación |
|---|---|
| **Código** | `CU-05` |
| **Nombre** | Visualizar Rutas Disponibles |
| **Requerimiento** | `RF-05` |
| **Actor(es)** | Pasajero, Usuario No Registrado |
| **Precondición** | El sistema se encuentra operativo y existen rutas con `activo = true` registradas por empresas activas. |
| **Flujo principal** | 1. El actor abre el panel o buscador de rutas en el mapa.<br>2. El cliente solicita el listado paginado o filtrado a `GET /api/v1/rutas`.<br>3. El sistema devuelve las rutas activas junto con la razón social de su empresa operadora y su geometría GeoJSON.<br>4. La interfaz presenta la lista de rutas disponibles con su identificador o nombre comercial. |
| **Flujo alternativo / excepciones** | - **2a. Búsqueda sin coincidencias:** Si el usuario aplica un filtro `search` que no coincide con ninguna ruta activa, el sistema muestra una lista vacía con el mensaje «No se encontraron rutas».<br>- **2b. Error de red:** El sistema notifica el fallo de conexión y ofrece un botón para reintentar la carga. |
| **Postcondición** | El usuario visualiza el catálogo vigente de rutas activas de transporte público en Tacna. |

### CU-06 — Seleccionar Ruta Específica

| Atributo | Especificación |
|---|---|
| **Código** | `CU-06` |
| **Nombre** | Seleccionar Ruta Específica |
| **Requerimiento** | `RF-06` |
| **Actor(es)** | Pasajero (incluye `CU-05`) |
| **Precondición** | El pasajero visualiza el listado de rutas disponibles (`CU-05`). |
| **Flujo principal** | 1. El pasajero elige una ruta específica del listado o buscador.<br>2. El sistema consulta el detalle de la ruta (`GET /api/v1/rutas/{ruta}`).<br>3. El cliente centra el mapa en el trazado GeoJSON (`LineString`) de la ruta seleccionada.<br>4. El cliente se suscribe a la sala WebSocket de la ruta emitiendo el evento `route:join` con `{ rutaId }`. |
| **Flujo alternativo / excepciones** | - **2a. Ruta desactivada o inexistente (`404`):** El sistema informa que la ruta ya no está disponible y actualiza el listado de `CU-05`.<br>- **4a. Cambio de ruta:** Si el pasajero tenía otra ruta activa, el cliente emite primero `route:leave` de la ruta anterior antes de unirse a la nueva. |
| **Postcondición** | La ruta queda seleccionada en el mapa y el cliente queda suscrito a la sala `ruta:{rutaId}` para recibir actualizaciones en vivo. |

### CU-07 — Visualizar Micros en Mapa en Tiempo Real

| Atributo | Especificación |
|---|---|
| **Código** | `CU-07` |
| **Nombre** | Visualizar Micros en Mapa en Tiempo Real |
| **Requerimiento** | `RF-07`, `RF-08` |
| **Actor(es)** | Pasajero (incluye `CU-06`) |
| **Precondición** | El pasajero ha seleccionado una ruta (`CU-06`) y mantiene conexión activa con el servidor WebSocket. |
| **Flujo principal** | 1. Al unirse a la sala `ruta:{rutaId}`, el cliente recibe el evento `route:joined` con la lista inicial de micros activos en esa ruta.<br>2. El sistema dibuja los marcadores de los micros en el mapa según sus coordenadas (`lat`, `lng`) y estado (`moviendo` o `detenido`).<br>3. Cada 3 a 5 segundos, conforme los conductores reportan ubicación, el cliente recibe eventos `micro:position` y actualiza suavemente la posición de cada marcador en el mapa.<br>4. Si un pasajero estándar (no Premium) consulta la ruta, la interfaz limita la visualización simultánea al máximo del plan gratuito (2 micros). |
| **Flujo alternativo / excepciones** | - **3a. Pérdida de señal GPS de un micro (> 120 s):** El servidor emite `micro:offline`; el cliente cambia el indicador visual del micro a estado desconectado.<br>- **3b. Finalización de recorrido:** El servidor emite `micro:stopped`; el cliente retira o marca la unidad como fuera de servicio. |
| **Postcondición** | El pasajero observa en tiempo real la ubicación y el desplazamiento de los micros activos sobre la ruta seleccionada. |

### CU-08 — Consultar Información Detallada del Micro

| Atributo | Especificación |
|---|---|
| **Código** | `CU-08` |
| **Nombre** | Consultar Información Detallada del Micro |
| **Requerimiento** | `RF-09` |
| **Actor(es)** | Pasajero (extiende a `CU-07`) |
| **Precondición** | El pasajero visualiza al menos un micro activo en el mapa (`CU-07`). |
| **Flujo principal** | 1. El pasajero pulsa sobre el marcador de un micro en el mapa.<br>2. El cliente solicita los datos de la unidad a `GET /api/v1/micros/{micro}` y combina la respuesta con el estado en vivo de WebSocket.<br>3. El sistema despliega una tarjeta informativa con la `placa`, empresa operadora, nombre de la ruta, capacidad de pasajeros, velocidad actual, estado operativo y marca de tiempo del último reporte.<br>4. El pasajero revisa la ficha y puede cerrarla para continuar explorando el mapa. |
| **Flujo alternativo / excepciones** | - **2a. Unidad recién desconectada o fuera de servicio:** El sistema muestra los últimos datos conocidos e indica la hora del último reporte recibido. |
| **Postcondición** | El pasajero conoce el detalle identificatorio y operativo del micro seleccionado. |

### CU-09 — Ver Estimación de Tiempo de Llegada

| Atributo | Especificación |
|---|---|
| **Código** | `CU-09` |
| **Nombre** | Ver Estimación de Tiempo de Llegada |
| **Requerimiento** | `RF-10` |
| **Actor(es)** | Pasajero (extiende a `CU-07`) |
| **Precondición** | El pasajero visualiza un micro activo en el mapa (`CU-07`) y cuenta con coordenadas de referencia (su ubicación actual o un paradero seleccionado). |
| **Flujo principal** | 1. El pasajero selecciona un micro en el mapa para consultar su tiempo estimado de llegada (ETA).<br>2. El cliente emite el evento WebSocket `eta:request` con `{ microId, lat, lng }`.<br>3. El servicio de tiempo real calcula la distancia y la velocidad promedio reciente del micro (respetando la velocidad mínima `MIN_SPEED_MS = 2 m/s`).<br>4. El servidor responde mediante `eta:response` con `{ microId, etaSeconds, estimated: true }`.<br>5. La interfaz muestra el **tiempo estimado de llegada (ETA)** en minutos, aclarando siempre su carácter aproximado (`RN-08`). |
| **Flujo alternativo / excepciones** | - **3a. Micro no encontrado o sin señal vigente:** El servidor devuelve `{ error: "Micro no encontrado" }` y la interfaz indica que no es posible estimar la llegada en ese instante.<br>- **3b. Parámetros de ubicación inválidos:** El servidor emite el evento `error` y la app solicita habilitar el permiso de ubicación o elegir un punto en el mapa. |
| **Postcondición** | El pasajero visualiza el tiempo estimado de llegada (ETA) del micro hacia su punto de referencia. |

### CU-10 — Visualizar Recorrido de la Ruta

| Atributo | Especificación |
|---|---|
| **Código** | `CU-10` |
| **Nombre** | Visualizar Recorrido de la Ruta |
| **Requerimiento** | `RF-11` |
| **Actor(es)** | Pasajero, Usuario No Registrado |
| **Precondición** | Existe al menos una ruta activa con geometría `trazado_ruta` registrada en formato GeoJSON `LineString`. |
| **Flujo principal** | 1. El usuario selecciona una ruta del catálogo (`GET /api/v1/rutas` o `GET /api/v1/rutas/{ruta}`).<br>2. El sistema entrega el objeto `trazado_ruta_geojson` con la secuencia de coordenadas `[longitud, latitud]` (`EPSG:4326`).<br>3. El componente cartográfico renderiza la polilínea completa del recorrido sobre el mapa base de Tacna, diferenciando el inicio y el fin de la ruta.<br>4. El usuario aplica zoom o desplazamiento para inspeccionar las calles y avenidas por donde circula la ruta. |
| **Flujo alternativo / excepciones** | - **2a. Ruta sin trazado georreferenciado (`trazado_ruta = null`):** El sistema muestra los datos textuales de la ruta e informa que el trazado gráfico no se encuentra disponible. |
| **Postcondición** | El recorrido geográfico completo de la ruta se muestra trazado sobre el mapa. |

### CU-11 — Seleccionar Punto de Espera o Paradero

| Atributo | Especificación |
|---|---|
| **Código** | `CU-11` |
| **Nombre** | Seleccionar Punto de Espera o Paradero |
| **Requerimiento** | `RF-12` |
| **Actor(es)** | Pasajero |
| **Precondición** | El pasajero ha seleccionado una ruta activa y visualiza su recorrido en el mapa (`CU-10`). |
| **Flujo principal** | 1. El pasajero toca un paradero referencial o un punto sobre el trazado de la ruta en el mapa.<br>2. El sistema fija las coordenadas (`lat`, `lng`) de ese punto como ubicación de espera activa del pasajero.<br>3. La interfaz resalta el paradero o punto elegido y recalcula el tiempo estimado de llegada (ETA) de los micros en circulación hacia dicho punto (`CU-09`). |
| **Flujo alternativo / excepciones** | - **1a. Punto alejado del trazado de la ruta:** El sistema advierte que el punto seleccionado se encuentra fuera del recorrido habitual y sugiere el punto más cercano del trazado. |
| **Postcondición** | Queda establecido el paradero o punto de espera de referencia para las consultas de ETA y proximidad del pasajero. |

### CU-12 — Consultar Micros Cercanos al Usuario

| Atributo | Especificación |
|---|---|
| **Código** | `CU-12` |
| **Nombre** | Consultar Micros Cercanos al Usuario |
| **Requerimiento** | `RF-13` |
| **Actor(es)** | Pasajero |
| **Precondición** | El pasajero ha otorgado permisos de geolocalización en su dispositivo y existen micros en estado `en_recorrido`. |
| **Flujo principal** | 1. El pasajero pulsa la opción «Micros cercanos» o «Centrar en mi ubicación».<br>2. El cliente obtiene las coordenadas actuales del dispositivo del pasajero.<br>3. El sistema consulta los micros activos (`GET /api/v1/micros/activos`) y filtra aquellos cuya última posición reportada se encuentra dentro del radio de proximidad respecto al pasajero.<br>4. El mapa centra la vista en la posición del pasajero y resalta los micros próximos junto con su ruta y distancia aproximada. |
| **Flujo alternativo / excepciones** | - **2a. Permiso de ubicación denegado:** El sistema solicita habilitar el GPS del dispositivo o elegir manualmente un punto de espera (`CU-11`).<br>- **3a. Ningún micro dentro del radio cercano:** El sistema informa que no hay micros próximos en ese momento y permite ampliar el radio de visualización. |
| **Postcondición** | El pasajero visualiza los micros activos más próximos a su ubicación geográfica actual. |

---

## 5. Módulo 3: Planificación y Premium

Fuente del diagrama: [diagrama_casos_uso_modulo_planificacion_premium.puml](diagrama_casos_uso_modulo_planificacion_premium.puml).

### CU-13 — Consultar y Comparar Alternativas de Viaje

| Atributo | Especificación |
|---|---|
| **Código** | `CU-13` |
| **Nombre** | Consultar y Comparar Alternativas de Viaje |
| **Requerimiento** | `RF-14`, `RF-15`, `RF-16` |
| **Actor(es)** | Pasajero, Pasajero Premium |
| **Precondición** | Existen rutas activas con trazado georreferenciado y micros en operación. |
| **Flujo principal** | 1. El pasajero ingresa o selecciona en el mapa un punto de origen y un punto de destino.<br>2. El sistema identifica las rutas activas cuyo trazado pasa próximo al origen y al destino.<br>3. El sistema compara las alternativas mostrando para cada ruta la proximidad al paradero, la disponibilidad de micros activos y el tiempo estimado de llegada (ETA).<br>4. El pasajero selecciona la alternativa más conveniente para pasar al seguimiento en tiempo real (`CU-07`). |
| **Flujo alternativo / excepciones** | - **2a. Sin ruta directa entre origen y destino:** El sistema informa que no existe una ruta única directa y muestra las rutas más cercanas al área consultada. |
| **Postcondición** | El pasajero obtiene un cuadro comparativo de rutas candidatas con sus tiempos estimados de llegada (ETA). |

### CU-14 — Visualizar Más de 2 Micros Simultáneamente

| Atributo | Especificación |
|---|---|
| **Código** | `CU-14` |
| **Nombre** | Visualizar Más de 2 Micros Simultáneamente |
| **Requerimiento** | `RF-17` |
| **Actor(es)** | Pasajero Premium |
| **Precondición** | El pasajero está autenticado y posee una suscripción en estado `activa` asociada a un plan Premium (`GET /api/v1/mis-suscripciones` o `GET /api/v1/auth/me`). |
| **Flujo principal** | 1. El pasajero Premium selecciona una ruta con múltiples unidades en circulación.<br>2. El sistema verifica la vigencia de su suscripción Premium.<br>3. El sistema desbloquea la restricción del plan gratuito (máximo 2 unidades) y renderiza en el mapa la totalidad de los micros activos en la sala `ruta:{rutaId}`.<br>4. El pasajero Premium monitorea simultáneamente todas las unidades de la ruta. |
| **Flujo alternativo / excepciones** | - **2a. Suscripción vencida o cancelada:** El sistema aplica el límite estándar de 2 micros y muestra la opción para renovar el plan Premium (`POST /api/v1/mis-suscripciones`). |
| **Postcondición** | El mapa muestra sin recorte todos los micros activos que circulan en la ruta seleccionada. |

### CU-15 — Consultar Nivel de Ocupación del Micro

| Atributo | Especificación |
|---|---|
| **Código** | `CU-15` |
| **Nombre** | Consultar Nivel de Ocupación del Micro |
| **Requerimiento** | `RF-18` |
| **Actor(es)** | Pasajero Premium |
| **Precondición** | El pasajero cuenta con suscripción Premium activa y selecciona un micro en recorrido (`CU-08`). |
| **Flujo principal** | 1. El pasajero Premium abre la ficha de detalle de un micro en el mapa.<br>2. El sistema consulta la `capacidad_pasajeros` registrada para la unidad y el indicador de nivel de ocupación/aforo estimado.<br>3. La interfaz muestra el nivel de ocupación (bajo, medio o lleno) junto con la capacidad nominal del micro. |
| **Flujo alternativo / excepciones** | - **2a. Unidad sin dato de ocupación actualizado:** El sistema muestra únicamente la `capacidad_pasajeros` nominal de la unidad e indica «Aforo no reportado». |
| **Postcondición** | El pasajero Premium conoce la capacidad y el nivel de ocupación estimado del micro antes de abordarlo. |

### CU-16 — Recibir Alertas de Micro Próximo

| Atributo | Especificación |
|---|---|
| **Código** | `CU-16` |
| **Nombre** | Recibir Alertas de Micro Próximo |
| **Requerimiento** | `RF-19` |
| **Actor(es)** | Pasajero Premium |
| **Precondición** | El pasajero Premium tiene una suscripción activa, ha seleccionado una ruta (`CU-06`) y un punto de espera (`CU-11`). |
| **Flujo principal** | 1. El pasajero Premium activa una alerta de proximidad para su paradero o punto de espera, definiendo el umbral de anticipación (en minutos de ETA o distancia).<br>2. El cliente monitorea los eventos `micro:position` y `eta:response` de la sala `ruta:{rutaId}`.<br>3. Cuando el tiempo estimado de llegada (ETA) de un micro alcanza el umbral configurado, el sistema emite una notificación visual y sonora en el dispositivo.<br>4. El pasajero confirma la alerta y se prepara para abordar. |
| **Flujo alternativo / excepciones** | - **2a. El micro entra en estado `desconectado` (`micro:offline`):** El sistema avisa al pasajero que la unidad seguida perdió señal GPS y reevalúa la siguiente unidad activa en la ruta. |
| **Postcondición** | El pasajero Premium es notificado oportunamente de la cercanía del micro a su paradero de espera. |

### CU-17 — Guardar Múltiples Rutas y Paraderos Favoritos

| Atributo | Especificación |
|---|---|
| **Código** | `CU-17` |
| **Nombre** | Guardar Múltiples Rutas y Paraderos Favoritos |
| **Requerimiento** | `RF-20` |
| **Actor(es)** | Pasajero Premium |
| **Precondición** | El pasajero posee una suscripción Premium activa. |
| **Flujo principal** | 1. El pasajero Premium visualiza una ruta o un paradero de uso frecuente y pulsa «Guardar en favoritos».<br>2. El sistema verifica su condición Premium, que habilita almacenar múltiples rutas y paraderos sin el límite del plan básico.<br>3. El sistema registra el elemento en la lista de favoritos del pasajero.<br>4. El pasajero accede posteriormente a su listado de favoritos para cargar la ruta y el paradero en un solo toque. |
| **Flujo alternativo / excepciones** | - **2a. Elemento ya guardado:** El sistema informa que la ruta o paradero ya forma parte de sus favoritos o permite retirarlo de la lista. |
| **Postcondición** | Las rutas y paraderos frecuentes quedan almacenados para acceso directo desde el perfil del pasajero Premium. |

### CU-18 — Acceder a Historial y Predicción Avanzada

| Atributo | Especificación |
|---|---|
| **Código** | `CU-18` |
| **Nombre** | Acceder a Historial y Predicción Avanzada |
| **Requerimiento** | `RF-21`, `RF-22`, `RF-23`, `RF-24` |
| **Actor(es)** | Pasajero Premium |
| **Precondición** | El pasajero posee una suscripción Premium activa. |
| **Flujo principal** | 1. El pasajero Premium abre la sección de historial y predicción avanzada de su ruta.<br>2. El sistema consulta los registros históricos de paso y las métricas de frecuencia de la ruta.<br>3. La interfaz presenta el historial de viajes consultados y la estimación avanzada de frecuencias según franja horaria.<br>4. El pasajero utiliza esta información para planificar su horario de salida. |
| **Flujo alternativo / excepciones** | - **2a. Datos históricos insuficientes para la franja consultada:** El sistema muestra el tiempo estimado de llegada (ETA) estándar en vivo e indica que aún se están recopilando métricas históricas para ese horario. |
| **Postcondición** | El pasajero Premium visualiza las métricas históricas y la predicción avanzada de paso para sus rutas de interés. |

### CU-19 — Navegar Sin Publicidad

| Atributo | Especificación |
|---|---|
| **Código** | `CU-19` |
| **Nombre** | Navegar Sin Publicidad |
| **Requerimiento** | `RF-25` |
| **Actor(es)** | Pasajero Premium |
| **Precondición** | El pasajero ha iniciado sesión y cuenta con una suscripción en estado `activa` asociada a un plan Premium. |
| **Flujo principal** | 1. El pasajero inicia sesión o abre la aplicación.<br>2. El cliente consulta el perfil y las suscripciones del usuario (`GET /api/v1/auth/me` o `GET /api/v1/mis-suscripciones`).<br>3. Al detectar una suscripción Premium con `estado = activa` y fecha vigente, la interfaz suprime todos los espacios y banners publicitarios en el mapa y paneles laterales. |
| **Flujo alternativo / excepciones** | - **2a. Cancelación o vencimiento de la suscripción (`PATCH /api/v1/mis-suscripciones/{id}/cancelar`):** Cuando la suscripción pasa a `vencida` o `cancelada`, el sistema restablece el comportamiento del plan gratuito. |
| **Postcondición** | El pasajero Premium utiliza todas las vistas de la aplicación limpia de anuncios publicitarios. |

---

## 6. Módulo 4: Conductor

Fuente del diagrama: [diagrama_casos_uso_modulo_conductor.puml](diagrama_casos_uso_modulo_conductor.puml).

### CU-20 — Iniciar Sesión Modo Conductor

| Atributo | Especificación |
|---|---|
| **Código** | `CU-20` |
| **Nombre** | Iniciar Sesión Modo Conductor |
| **Requerimiento** | `RF-26` |
| **Actor(es)** | Conductor |
| **Precondición** | La empresa de transporte (o el administrador general) ha registrado previamente la cuenta del usuario con `rol = conductor` y su perfil en `conductor_perfiles`. |
| **Flujo principal** | 1. El conductor abre la aplicación móvil e ingresa su `correo` y `password`.<br>2. El cliente envía la petición a `POST /api/v1/auth/login`.<br>3. El sistema valida que la cuenta esté activa, verifica que `rol = conductor` y emite el token JWT incluyendo `micro_id` y `ruta_id` del micro asignado.<br>4. La aplicación ingresa directamente a la interfaz de **Modo Conductor**. |
| **Flujo alternativo / excepciones** | - **3a. Usuario con rol distinto a `conductor`:** Si el usuario autenticado no tiene perfil de conductor, el sistema impide el acceso a las operaciones de Modo Conductor (`403 Forbidden`).<br>- **3b. Credenciales inválidas o cuenta inactiva:** El sistema rechaza el acceso con `401` o `403` y muestra el mensaje correspondiente. |
| **Postcondición** | El conductor tiene una sesión autenticada con token JWT y visualiza el panel operativo del Modo Conductor. |

### CU-21 — Vincular y Confirmar Micro Asignado

| Atributo | Especificación |
|---|---|
| **Código** | `CU-21` |
| **Nombre** | Vincular y Confirmar Micro Asignado |
| **Requerimiento** | `RF-27` |
| **Actor(es)** | Conductor |
| **Precondición** | El conductor ha iniciado sesión en Modo Conductor (`CU-20`) y el administrador de su empresa le ha asignado un micro en la tabla `micros` (`conductor_actual_id`). |
| **Flujo principal** | 1. La aplicación consulta `GET /api/v1/conductor/perfil` con el token JWT del conductor.<br>2. El sistema devuelve los datos del perfil (`licencia_conducir`, `estado_operativo`), la empresa empleadora y el micro asignado actualmente (`placa`, `capacidad_pasajeros`, `estado` y `ruta`).<br>3. El conductor verifica en pantalla la placa del micro y la ruta asignada, y confirma que operará dicha unidad. |
| **Flujo alternativo / excepciones** | - **2a. Conductor sin micro asignado (`micro_id = null`):** El sistema muestra el aviso «No tienes un micro asignado actualmente» y deshabilita el botón de inicio de recorrido hasta que el administrador de su empresa realice la asignación.<br>- **2b. Perfil de conductor inexistente (`404`):** El sistema bloquea la operación e indica contactar al administrador. |
| **Postcondición** | El conductor confirma la unidad (`micro_id`) y la ruta (`ruta_id`) con las que realizará el recorrido. |

### CU-22 — Iniciar Recorrido y Transmitir Ubicación

| Atributo | Especificación |
|---|---|
| **Código** | `CU-22` |
| **Nombre** | Iniciar Recorrido y Transmitir Ubicación |
| **Requerimiento** | `RF-28`, `RF-29` |
| **Actor(es)** | Conductor, Sistema GPS Móvil (incluye `CU-21` y `CU-24`) |
| **Precondición** | El conductor ha confirmado su micro asignado (`CU-21`) y el servicio de GPS del dispositivo móvil está activo y con permisos concedidos (`CU-24`). |
| **Flujo principal** | 1. El conductor pulsa el botón «Iniciar recorrido» en el Modo Conductor.<br>2. El Sistema GPS Móvil obtiene las coordenadas (`latitud`, `longitud`) y la `velocidad` cada 3 a 5 segundos.<br>3. El cliente envía cada lectura mediante HTTP POST a `/api/v1/conductor/posicion` (o su alias `/api/v1/tracking/position`).<br>4. El backend registra la lectura en `posiciones_gps` y cambia automáticamente `micros.estado = en_recorrido` y `conductor_perfiles.estado_operativo = en_recorrido`.<br>5. El servicio de tiempo real actualiza el estado en memoria y difunde el evento `micro:position` a la sala WebSocket `ruta:{rutaId}`. |
| **Flujo alternativo / excepciones** | - **3a. Coordenadas fuera de rango o payload inválido (`422`):** El servidor rechaza la lectura defectuosa sin interrumpir el ciclo de transmisión siguiente.<br>- **3b. Conductor sin micro asignado (`404`):** El servidor rechaza el reporte e informa que no existe unidad vinculada.<br>- **3c. Exceso de frecuencia (`429 Too Many Requests`):** El cliente ajusta el intervalo al rango de 3 a 5 segundos. |
| **Postcondición** | El micro y el conductor figuran `en_recorrido`, las posiciones se persisten en `posiciones_gps` y los pasajeros suscritos a la ruta reciben las coordenadas en tiempo real. |

### CU-23 — Finalizar Recorrido y Cambiar Estado

| Atributo | Especificación |
|---|---|
| **Código** | `CU-23` |
| **Nombre** | Finalizar Recorrido y Cambiar Estado |
| **Requerimiento** | `RF-30`, `RF-31` |
| **Actor(es)** | Conductor |
| **Precondición** | El conductor mantiene un recorrido activo (`CU-22`). |
| **Flujo principal** | 1. Al concluir su vuelta o turno, el conductor pulsa el botón «Finalizar recorrido».<br>2. La aplicación detiene la captura periódica del GPS y envía `POST /api/v1/conductor/finalizar` (y/o `/api/v1/tracking/stop`).<br>3. El backend actualiza `micros.estado = disponible` y `conductor_perfiles.estado_operativo = sin_conexion`.<br>4. El servicio de tiempo real emite el evento `micro:stopped` con `{ microId }` a la sala `ruta:{rutaId}`.<br>5. La interfaz del Modo Conductor confirma que la transmisión se ha detenido. |
| **Flujo alternativo / excepciones** | - **2a. Fallo temporal de red al finalizar:** La aplicación detiene localmente el envío de coordenadas y reintenta la petición de cierre; en paralelo, si el servidor de tiempo real no recibe señal tras `120 s` (`OFFLINE_AFTER_MS`), emite automáticamente `micro:offline`. |
| **Postcondición** | La transmisión GPS cesa, el micro pasa a estado `disponible`, el conductor pasa a `sin_conexion` y la unidad deja de mostrarse en circulación a los pasajeros. |

### CU-24 — Monitorear Estado de GPS y Conexión

| Atributo | Especificación |
|---|---|
| **Código** | `CU-24` |
| **Nombre** | Monitorear Estado de GPS y Conexión |
| **Requerimiento** | `RF-32` |
| **Actor(es)** | Conductor, Sistema GPS Móvil |
| **Precondición** | El conductor se encuentra en la pantalla de Modo Conductor (`CU-20`). |
| **Flujo principal** | 1. El Sistema GPS Móvil supervisa de forma continua el estado del sensor de ubicación y la conectividad de red del teléfono.<br>2. La interfaz del Modo Conductor muestra indicadores claros del estado del GPS (activo / sin señal) y de la conexión con el servidor (conectado / reconectando), junto con la hora del último envío exitoso.<br>3. Si ambos indicadores están operativos, el envío periódico de `CU-22` continúa con normalidad. |
| **Flujo alternativo / excepciones** | - **1a. GPS desactivado por el usuario o pérdida de señal satelital:** La aplicación muestra una alerta destacada solicitando reactivar la ubicación y pausa el envío de coordenadas inválidas.<br>- **1b. Pérdida de conexión a internet (> 120 s):** La aplicación informa el estado «Sin conexión» al conductor y el servidor de tiempo real marca la unidad como `desconectado` (`micro:offline`) hasta que se restablezca el enlace. |
| **Postcondición** | El conductor conoce en todo momento si su dispositivo está transmitiendo ubicación correctamente al sistema. |

---

## 7. Módulo 5: Administración

Fuente del diagrama: [diagrama_casos_uso_modulo_administrador.puml](diagrama_casos_uso_modulo_administrador.puml).

### CU-25 — Gestionar Empresas de Transporte

| Atributo | Especificación |
|---|---|
| **Código** | `CU-25` |
| **Nombre** | Gestionar Empresas de Transporte |
| **Requerimiento** | `RF-33` |
| **Actor(es)** | Administrador (`admin_general` con control total; `admin_empresa` limitado a lectura, edición y estado de sus propias empresas) |
| **Precondición** | El administrador ha iniciado sesión con un token JWT válido con rol `admin_general` o `admin_empresa`. |
| **Flujo principal** | 1. El administrador accede al módulo de Empresas (`GET /api/v1/empresas`).<br>2. Para registrar una empresa nueva, el `admin_general` completa `ruc` (11 dígitos), `razon_social`, `telefono`, `direccion` y envía `POST /api/v1/empresas`, pudiendo vincular su cuenta administrativa en `/api/v1/administradores-empresa`.<br>3. Para actualizar datos de una empresa existente, el administrador autorizado envía `PUT/PATCH /api/v1/empresas/{empresa}`.<br>4. Para aplicar baja lógica o reactivación sin perder el historial, el administrador envía `PATCH /api/v1/empresas/{empresa}/estado` con `{ activo: false | true }`. |
| **Flujo alternativo / excepciones** | - **2a. RUC duplicado o formato inválido:** El sistema rechaza la operación con `422 Unprocessable Entity`.<br>- **2b. Intento de crear o eliminar empresa por un `admin_empresa`:** El backend rechaza la petición con `403 Forbidden`.<br>- **4a. Intento de eliminar (`DELETE /api/v1/empresas/{empresa}`) una empresa con rutas, micros, conductores o administradores asociados:** El sistema bloquea el borrado físico y responde `409 Conflict`. |
| **Postcondición** | Los datos y el estado de la empresa de transporte quedan actualizados en la tabla `empresas` respetando las reglas de integridad y alcance. |

### CU-26 — Gestionar Rutas y Paraderos

| Atributo | Especificación |
|---|---|
| **Código** | `CU-26` |
| **Nombre** | Gestionar Rutas y Paraderos |
| **Requerimiento** | `RF-34` |
| **Actor(es)** | Administrador (`admin_empresa` sobre sus empresas vinculadas; `admin_general` sobre todas las empresas) |
| **Precondición** | El administrador está autenticado y la empresa de transporte a la que pertenece la ruta se encuentra registrada. |
| **Flujo principal** | 1. El administrador consulta el listado de rutas de su alcance (`GET /api/v1/rutas`, que con token administrativo incluye activas e inactivas).<br>2. Para crear una ruta, ingresa `empresa_id`, `nombre_ruta`, el trazado georreferenciado `trazado_ruta` (GeoJSON `LineString` o WKT `LINESTRING` con sus puntos y referencias de recorrido) y envía `POST /api/v1/rutas`.<br>3. Para modificar el nombre o trazado, envía `PUT/PATCH /api/v1/rutas/{ruta}`.<br>4. Para desactivar o reactivar la ruta (baja lógica), envía `PATCH /api/v1/rutas/{ruta}/estado` con `{ activo: false | true }`. |
| **Flujo alternativo / excepciones** | - **2a. Nombre de ruta duplicado dentro de la misma empresa o GeoJSON inválido:** El sistema devuelve `422 Unprocessable Entity`.<br>- **2b. Intento de operar sobre una empresa ajena al `admin_empresa`:** El sistema devuelve `403 Forbidden`.<br>- **4a. Eliminación (`DELETE /api/v1/rutas/{ruta}`) de una ruta con micros asignados:** El sistema bloquea la operación con `409 Conflict`. |
| **Postcondición** | La ruta y su trazado geográfico quedan persistidos en PostGIS (`rutas`) y disponibles en el catálogo público si su estado es `activo = true`. |

### CU-27 — Gestionar Unidades Micros

| Atributo | Especificación |
|---|---|
| **Código** | `CU-27` |
| **Nombre** | Gestionar Unidades Micros |
| **Requerimiento** | `RF-35` |
| **Actor(es)** | Administrador (`admin_empresa` sobre sus empresas vinculadas; `admin_general` global) |
| **Precondición** | El administrador está autenticado y existen la empresa y, opcionalmente, la ruta y el conductor a vincular dentro de la misma empresa. |
| **Flujo principal** | 1. El administrador lista los micros de su alcance mediante `GET /api/v1/micros`.<br>2. Para registrar una unidad, ingresa `empresa_id`, `placa`, `capacidad_pasajeros`, `estado` y opcionalmente `ruta_id` y `conductor_actual_id`, enviando `POST /api/v1/micros`.<br>3. Para editar datos o reasignar la ruta o el conductor de la unidad, envía `PUT/PATCH /api/v1/micros/{micro}`.<br>4. Para cambiar el estado operativo (`disponible`, `en_recorrido`, `mantenimiento`, `inactivo`), envía `PATCH /api/v1/micros/{micro}/estado`, lo que sincroniza el `estado_operativo` del conductor asignado. |
| **Flujo alternativo / excepciones** | - **2a. Placa duplicada o conductor ya asignado a otro micro:** El sistema rechaza el registro con `422 Unprocessable Entity` (regla de un solo micro por conductor a la vez).<br>- **2b. Ruta o conductor perteneciente a otra empresa:** El sistema rechaza la asociación con `422` o `403`.<br>- **4a. Intento de eliminar (`DELETE /api/v1/micros/{micro}`) una unidad que está `en_recorrido`:** El sistema devuelve `409 Conflict`. |
| **Postcondición** | El micro, sus asociaciones (`ruta_id`, `conductor_actual_id`) y su estado operativo quedan actualizados en `micros`. |

### CU-28 — Gestionar Cuentas de Conductores

| Atributo | Especificación |
|---|---|
| **Código** | `CU-28` |
| **Nombre** | Gestionar Cuentas de Conductores |
| **Requerimiento** | `RF-36` |
| **Actor(es)** | Administrador (`admin_empresa` sobre sus empresas vinculadas; `admin_general` global) |
| **Precondición** | El administrador está autenticado y tiene acceso a la empresa empleadora. |
| **Flujo principal** | 1. El administrador consulta los conductores de su alcance en `GET /api/v1/conductores`.<br>2. Para incorporar un conductor, envía `POST /api/v1/conductores` indicando `empresa_id`, `licencia_conducir`, `estado_operativo` y los datos de cuenta nueva (`dni`, `nombre`, `apellido`, `correo`, `telefono`, `password`) o un `usuario_id` existente.<br>3. El sistema crea o vincula el usuario con `rol = conductor` y genera su registro en `conductor_perfiles`.<br>4. Para actualizar datos o licencia, envía `PUT/PATCH /api/v1/conductores/{conductor}`; para cambiar su estado operativo (`disponible`, `en_recorrido`, `sin_conexion`), envía `PATCH /api/v1/conductores/{conductor}/estado`. |
| **Flujo alternativo / excepciones** | - **2a. DNI o correo duplicado, o usuario que ya posee un perfil de conductor:** El sistema responde `422 Unprocessable Entity`.<br>- **4a. Intento de eliminar (`DELETE /api/v1/conductores/{conductor}`) un conductor que tiene un micro asignado:** El sistema bloquea el borrado con `409 Conflict` hasta que se desvincule del micro en `CU-27`. |
| **Postcondición** | La cuenta del conductor y su perfil laboral quedan registrados y habilitados para operar en el Modo Conductor. |

### CU-29 — Supervisar Unidades y Estados en Tiempo Real

| Atributo | Especificación |
|---|---|
| **Código** | `CU-29` |
| **Nombre** | Supervisar Unidades y Estados en Tiempo Real |
| **Requerimiento** | `RF-37`, `RF-38` |
| **Actor(es)** | Administrador (`admin_empresa` sobre su flota; `admin_general` sobre toda la flota) |
| **Precondición** | El administrador ha iniciado sesión en el panel administrativo web. |
| **Flujo principal** | 1. El administrador abre el módulo de Monitoreo de flota.<br>2. El sistema consulta las unidades (`GET /api/v1/micros` y `GET /api/v1/micros/activos`) y el historial de ubicaciones (`GET /api/v1/posiciones`), filtrando automáticamente por `empresa_ids` cuando el rol es `admin_empresa`.<br>3. La interfaz muestra en el mapa y en el listado el estado de cada micro (`en_recorrido`, `disponible`, `mantenimiento`, `inactivo`), su conductor asignado, velocidad y última posición reportada.<br>4. El administrador selecciona un micro para inspeccionar su ficha y sus últimas 20 posiciones GPS (`GET /api/v1/micros/{micro}`). |
| **Flujo alternativo / excepciones** | - **3a. Unidad nueva o sin ubicaciones recibidas:** El panel indica que el micro está fuera de recorrido y aún no registra coordenadas GPS.<br>- **2a. Error de actualización de red:** El panel informa el fallo de sincronización y permite reintentar la consulta sin cerrar la sesión. |
| **Postcondición** | El administrador visualiza el estado operativo actual y la trazabilidad GPS de las unidades de su alcance. |

### CU-30 — Gestionar Cuentas de Pasajeros

| Atributo | Especificación |
|---|---|
| **Código** | `CU-30` |
| **Nombre** | Gestionar Cuentas de Pasajeros |
| **Requerimiento** | `RF-39` |
| **Actor(es)** | Administrador (`admin_general`) |
| **Precondición** | El usuario autenticado posee el rol global `admin_general`. |
| **Flujo principal** | 1. El `admin_general` accede al módulo global de Usuarios (`GET /api/v1/usuarios?rol=pasajero`).<br>2. El administrador consulta el detalle de una cuenta (`GET /api/v1/usuarios/{usuario}`), crea una cuenta (`POST /api/v1/usuarios`) o actualiza sus datos personales (`PUT/PATCH /api/v1/usuarios/{usuario}`).<br>3. Para suspender o reactivar el acceso de un pasajero sin borrar su historial, envía `PATCH /api/v1/usuarios/{usuario}/estado` con `{ activo: false | true }`. |
| **Flujo alternativo / excepciones** | - **1a. Intento de acceso por `admin_empresa`, `conductor` o `pasajero`:** El middleware de rol rechaza la petición con `403 Forbidden`.<br>- **3a. Intento de desactivar o eliminar la propia cuenta del `admin_general` autenticado, o eliminar un usuario con suscripciones o perfiles vinculados:** El sistema rechaza la operación con `422` (auto-desactivación) o `409 Conflict` (dependencias o auto-eliminación). |
| **Postcondición** | Las cuentas de pasajeros quedan actualizadas o con su estado de acceso modificado en la tabla `usuarios`. |

### CU-31 — Gestionar Suscripciones Premium

| Atributo | Especificación |
|---|---|
| **Código** | `CU-31` |
| **Nombre** | Gestionar Suscripciones Premium |
| **Requerimiento** | `RF-40` |
| **Actor(es)** | Administrador (`admin_general`) |
| **Precondición** | El usuario autenticado posee el rol `admin_general` y existen planes registrados en `/api/v1/planes`. |
| **Flujo principal** | 1. El `admin_general` administra el catálogo de planes (`GET/POST /api/v1/planes`, `PUT/PATCH/DELETE /api/v1/planes/{plan}`, `PATCH /api/v1/planes/{plan}/estado`).<br>2. El `admin_general` consulta el listado global de suscripciones en `GET /api/v1/suscripciones` filtrando por usuario, plan o estado (`activa`, `vencida`, `cancelada`).<br>3. Para registrar o modificar una suscripción de un pasajero, envía `POST /api/v1/suscripciones` o `PUT/PATCH /api/v1/suscripciones/{suscripcion}` indicando `usuario_id` (con rol `pasajero`), `plan_id`, `fecha_inicio`, `fecha_vencimiento` y `estado`.<br>4. Para cambiar el estado de vigencia de una suscripción, envía `PATCH /api/v1/suscripciones/{suscripcion}/estado`. |
| **Flujo alternativo / excepciones** | - **3a. Usuario no es pasajero o `fecha_vencimiento` es anterior a `fecha_inicio`:** El sistema devuelve `422 Unprocessable Entity`.<br>- **1a. Intento de eliminar (`DELETE /api/v1/planes/{plan}`) un plan que posee suscripciones asociadas:** El sistema bloquea el borrado y devuelve `409 Conflict`.<br>- **1b. Acceso por otro rol distinto de `admin_general`:** El sistema devuelve `403 Forbidden` (los pasajeros gestionan únicamente sus propias suscripciones en `/api/v1/mis-suscripciones`). |
| **Postcondición** | Los planes comerciales y las suscripciones Premium de los pasajeros quedan actualizados en `planes` y `suscripciones`. |
