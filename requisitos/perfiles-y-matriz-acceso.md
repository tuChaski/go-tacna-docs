# Perfiles de usuario y matriz de control de acceso

> **Estado:** En revisión
> **Responsable:** Todo el equipo
> **Relacionado:** [diccionario-datos.md](diccionario-datos.md), [../casos-de-uso/especificacion-casos-de-uso.md](../casos-de-uso/especificacion-casos-de-uso.md), [../contratos/jwt-claims.md](../contratos/jwt-claims.md), [../contratos/openapi.yaml](../contratos/openapi.yaml), [../contratos/eventos-websocket.md](../contratos/eventos-websocket.md), [../diseno/prototipo-administrador.md](../diseno/prototipo-administrador.md), [../arquitectura/modelo-de-datos.md](../arquitectura/modelo-de-datos.md)

## 1. Propósito y alcance

Este documento define formalmente los perfiles de usuario del sistema Go-Tacna y su **Matriz de Control de Acceso** (correspondiente a la tarea **T090**). Establece las responsabilidades, restricciones y alcance de datos para los cuatro roles autenticados en la tabla `usuarios` (`pasajero`, `conductor`, `admin_empresa` y `admin_general`) y para el visitante público no autenticado, alineando el diseño del panel administrativo ([../diseno/prototipo-administrador.md](../diseno/prototipo-administrador.md)) con las rutas reales implementadas en `gotacna-backend-core/routes/api.php` ([../contratos/openapi.yaml](../contratos/openapi.yaml)) y el servicio de tiempo real ([../contratos/eventos-websocket.md](../contratos/eventos-websocket.md)).

---

## 2. Definición formal de perfiles de usuario

El sistema contempla cuatro roles persistidos en la columna `usuarios.rol` más el actor visitante sin sesión autenticada:

### 2.1 Resumen de perfiles

| Perfil / Actor | Valor en `usuarios.rol` | Tabla de perfil adicional | Alcance de datos | Canal principal |
|---|---|---|---|---|
| **Visitante público** | *(Sin cuenta / sin token)* | Ninguna | Público (solo registros con `activo = true` o micros en operación) | Web pública / App móvil |
| **Pasajero** | `pasajero` | `suscripciones` (0..N para nivel `Premium`) | Público + autogestión de su propia cuenta y sus propias suscripciones | Web / App móvil |
| **Conductor** | `conductor` | `conductor_perfiles` (relación 1:1) | Su propio perfil laboral, su único micro asignado (`conductor_actual_id`) y su ruta | App móvil (**Modo Conductor**) |
| **Administrador de empresa** | `admin_empresa` | `administrador_empresa_perfiles` (relación N:M) | **Aislamiento multi-empresa:** exclusivamente las empresas vinculadas en `empresa_ids` y sus recursos hijos | Panel administrativo web |
| **Administrador general** | `admin_general` | Ninguna (alcance global) | **Global:** todas las empresas, rutas, micros, conductores, usuarios, planes, suscripciones y posiciones GPS | Panel administrativo web |

---

### 2.2 Detalle por perfil: descripción, responsabilidades, restricciones y alcance

#### A. Visitante público (Usuario no registrado)
- **Descripción:** Persona que accede al mapa de Go-Tacna sin iniciar sesión ni enviar token JWT.
- **Responsabilidades y capacidades permitidas:**
  - Consultar el catálogo público de rutas activas (`GET /api/v1/rutas`, `GET /api/v1/rutas/{ruta}`).
  - Consultar micros activos en estado `disponible` o `en_recorrido` (`GET /api/v1/micros/activos`, `GET /api/v1/micros/{micro}`).
  - Consultar el catálogo de planes activos (`GET /api/v1/planes`, `GET /api/v1/planes/{plan}`).
  - Suscribirse a salas WebSocket (`route:join`) y solicitar el **tiempo estimado de llegada (ETA)** (`eta:request`).
  - Registrarse como pasajero (`POST /api/v1/auth/register`) o iniciar sesión (`POST /api/v1/auth/login`).
- **Restricciones y alcance de datos:**
  - Solo recibe registros activos (`activo = true`). Si consulta una ruta o plan inactivo, el sistema devuelve `404 Not Found`.
  - No puede contratar suscripciones, guardar favoritos, emitir ubicaciones GPS ni acceder a endpoints administrativos (`401 Unauthorized`).

#### B. Pasajero (`rol = pasajero`)
- **Descripción:** Usuario registrado que consulta rutas, visualiza micros en tiempo real, estima tiempos de llegada y puede contratar un plan `Premium`.
- **Responsabilidades y capacidades permitidas:**
  - Todas las capacidades de lectura pública y eventos WebSocket en tiempo real (`route:join`, `route:leave`, `eta:request`).
  - Consultar su sesión y perfil (`GET /api/v1/auth/me`), renovar su token (`POST /api/v1/auth/refresh`) y cerrar sesión (`POST /api/v1/auth/logout`).
  - Listar sus propias suscripciones (`GET /api/v1/mis-suscripciones`), ver el detalle de una suscripción propia (`GET /api/v1/mis-suscripciones/{suscripcion}`), contratar un plan activo (`POST /api/v1/mis-suscripciones`) y cancelar su suscripción (`PATCH /api/v1/mis-suscripciones/{suscripcion}/cancelar`).
  - **Nivel Pasajero Premium (con suscripción `activa` vigente):** visualizar más de 2 micros simultáneamente en el mapa (`CU-14`), consultar el nivel de ocupación del micro (`CU-15`), recibir alertas de proximidad (`CU-16`), guardar múltiples rutas y paraderos favoritos (`CU-17`), acceder a historial y predicción avanzada (`CU-18`) y navegar sin publicidad (`CU-19`).
- **Restricciones y alcance de datos:**
  - Aislamiento estricto por `usuario_id`: en `/api/v1/mis-suscripciones` solo puede leer y cancelar suscripciones cuyo `usuario_id` coincida con el suyo (intentar acceder a la suscripción de otro pasajero devuelve `404`).
  - No tiene acceso a operaciones de conductor (`/api/v1/conductor/*`, `/api/v1/tracking/*`) ni a módulos administrativos (`403 Forbidden`).

#### C. Conductor (`rol = conductor`)
- **Descripción:** Operador de un micro perteneciente a una empresa de transporte que transmite la ubicación GPS de su unidad durante el recorrido desde el **Modo Conductor**.
- **Responsabilidades y capacidades permitidas:**
  - Iniciar sesión en Modo Conductor (`POST /api/v1/auth/login`) y consultar su perfil laboral y micro asignado (`GET /api/v1/conductor/perfil`).
  - Iniciar recorrido y reportar periódicamente (cada 3 a 5 segundos) la posición GPS y velocidad de su micro (`POST /api/v1/conductor/posicion` o su alias `POST /api/v1/tracking/position`), lo que actualiza automáticamente `micros.estado = en_recorrido` y `conductor_perfiles.estado_operativo = en_recorrido`.
  - Finalizar su recorrido (`POST /api/v1/conductor/finalizar` o su alias `POST /api/v1/tracking/stop`), dejando el micro en estado `disponible`, su perfil en `sin_conexion` y emitiendo `micro:stopped` a la sala de la ruta.
- **Restricciones y alcance de datos:**
  - Su cuenta y credenciales son creadas y administradas por su empresa (`admin_empresa`) o por el `admin_general`; no existe autorregistro público de conductores.
  - **Relación 1:1 operativa:** Un usuario tiene como máximo un perfil en `conductor_perfiles`, pertenece a una empresa (`empresa_id`) y solo puede estar asignado a **un micro a la vez** (`micros.conductor_actual_id` único).
  - Si el conductor no tiene un micro asignado (`micro_id = null`), cualquier intento de reportar posición o finalizar recorrido devuelve `404 Not Found`.
  - No puede modificar su asignación de micro ni acceder a los endpoints CRUD administrativos (`403 Forbidden`).

#### D. Administrador de empresa (`rol = admin_empresa`)
- **Descripción:** Responsable operativo de una o más empresas de transporte vinculadas a su cuenta mediante la tabla `administrador_empresa_perfiles`.
- **Responsabilidades y capacidades permitidas:**
  - Consultar y actualizar los datos y el estado (`activo`) de las empresas a las que está vinculado (`GET /api/v1/empresas`, `GET/PUT/PATCH /api/v1/empresas/{empresa}`, `PATCH /api/v1/empresas/{empresa}/estado`).
  - Ejecutar el CRUD completo y cambios de estado sobre las **rutas** (`rutas`), **micros** (`micros`) y **conductores** (`conductores`) que pertenezcan a sus empresas vinculadas.
  - Asignar rutas y conductores de su misma empresa a sus micros desde el módulo de Micros.
  - Supervisar en tiempo real las unidades de su empresa y consultar su historial de ubicaciones (`GET /api/v1/posiciones`, `GET /api/v1/posiciones/{posicion}`) y los vínculos administrativos de sus empresas (`GET /api/v1/administradores-empresa`, `GET /api/v1/administradores-empresa/{id}`).
- **Restricciones y alcance de datos:**
  - **Aislamiento multi-empresa obligatorio:** Todas las consultas y escrituras se filtran en el servidor según las empresas asociadas al usuario en `administrador_empresa_perfiles` (`empresa_ids`). Cualquier intento de leer, crear, editar, cambiar estado o eliminar recursos de otra empresa es rechazado con `403 Forbidden`.
  - No puede crear nuevas empresas (`POST /api/v1/empresas`) ni eliminar empresas (`DELETE /api/v1/empresas/{empresa}`).
  - No puede crear, editar ni eliminar vínculos en `/api/v1/administradores-empresa`, ni escribir o borrar registros manualmente en `/api/v1/posiciones`.
  - No tiene acceso a la gestión global de cuentas (`/api/v1/usuarios`), catálogo de planes (`POST/PUT/PATCH/DELETE /api/v1/planes`) ni gestión global de suscripciones (`/api/v1/suscripciones`).

#### E. Administrador general (`rol = admin_general`)
- **Descripción:** Superadministrador de la plataforma Go-Tacna con autoridad global sobre todas las empresas, usuarios, catálogo comercial y supervisión del sistema.
- **Responsabilidades y capacidades permitidas:**
  - Registrar nuevas empresas de transporte (`POST /api/v1/empresas`), editarlas, activarlas/desactivarlas (`PATCH /api/v1/empresas/{empresa}/estado`) y eliminarlas cuando no tengan dependencias (`DELETE /api/v1/empresas/{empresa}`).
  - Crear cuentas de cualquier rol y gestionar todos los usuarios del sistema (`/api/v1/usuarios`, `/api/v1/usuarios/{usuario}/estado`).
  - Asignar y revocar vínculos entre usuarios `admin_empresa` y empresas (`/api/v1/administradores-empresa`).
  - Gestionar de forma global las rutas, micros, conductores y posiciones GPS de cualquier empresa.
  - Administrar el catálogo comercial de planes (`/api/v1/planes`) y las suscripciones de todos los pasajeros (`/api/v1/suscripciones`).
- **Restricciones y alcance de datos:**
  - Alcance global sin filtro de `empresa_ids` (`empresa_ids = []` en el JWT indica sin restricción de empresa).
  - Por integridad operativa, el sistema le impide desactivar su propia cuenta (`422 Unprocessable Entity` en `PATCH /api/v1/usuarios/{id}/estado`) o eliminar su propio usuario autenticado (`409 Conflict` en `DELETE /api/v1/usuarios/{id}`).

---

## 3. Autenticación, claims JWT y verificación en servidor

1. **Emisión y vigencia del token:**
   - El endpoint `POST /api/v1/auth/login` (y `POST /api/v1/auth/register` para nuevos pasajeros) emite un token JWT firmado con `HS256` (`JWT_TTL = 60` minutos, ventana de renovación `JWT_REFRESH_TTL = 20160` minutos / 14 días).
   - El token incluye los claims de dominio `rol`, `micro_id`, `ruta_id` y `empresa_ids` (ver detalle en [../contratos/jwt-claims.md](../contratos/jwt-claims.md)).
2. **Autorización basada en base de datos (Zero-Trust sobre claims):**
   - `gotacna-backend-core` **no confía únicamente en los claims del JWT** para autorizar operaciones. En cada petición autenticada, el backend recarga el registro desde `usuarios`, comprueba que `activo = true`, verifica el rol mediante el middleware `CheckRole` y consulta en base de datos los vínculos vigentes en `administrador_empresa_perfiles` o `conductor_perfiles`.
3. **Endpoints de catálogo con token opcional:**
   - Las rutas `GET /api/v1/rutas`, `GET /api/v1/rutas/{ruta}`, `GET /api/v1/micros/activos`, `GET /api/v1/micros/{micro}`, `GET /api/v1/planes` y `GET /api/v1/planes/{plan}` son públicas, pero si reciben un token válido de `admin_general` o `admin_empresa`, amplían la respuesta para incluir también registros inactivos dentro del alcance empresarial del administrador.

---

## 4. Matriz de Control de Acceso (CRUD, ejecución y alcance multi-empresa)

### 4.1 Leyenda de operaciones y alcances

- **Operaciones:**
  - `C` (**Crear**): `POST`
  - `R` (**Leer**): `GET` (listar colección y consultar detalle)
  - `U` (**Actualizar**): `PUT` / `PATCH` (edición de datos)
  - `E` (**Estado / Baja lógica**): `PATCH /{recurso}/{id}/estado` o `PATCH .../cancelar` (activar, desactivar o cambiar estado operativo sin borrar el registro)
  - `D` (**Eliminar físico**): `DELETE` (sujeto a restricciones de integridad referencial `409 Conflict`)
  - `X` (**Ejecución / Evento**): Acción operativa de negocio o emisión/suscripción de eventos en tiempo real
- **Alcances:**
  - `Público (activos)`: Solo registros con `activo = true` (o micros `disponible` / `en_recorrido`).
  - `Propio`: Limitado exclusivamente a los registros donde el usuario autenticado es el titular (`usuario_id` o `conductor_actual_id`).
  - `Empresa (empresa_ids)`: Limitado estrictamente a las empresas asociadas al `admin_empresa` en `administrador_empresa_perfiles`.
  - `Global`: Acceso total a todos los registros del sistema sin restricción de empresa.
  - `—`: Acceso denegado (`401 Unauthorized` sin token o `403 Forbidden` por rol/alcance).

---

### 4.2 Matriz general por recurso y perfil

| Recurso / Funcionalidad | Endpoints / Eventos principales | Visitante (sin token) | `pasajero` | `conductor` | `admin_empresa` | `admin_general` |
|---|---|---|---|---|---|---|
| **Autenticación y Sesión** | `POST /auth/register`, `POST /auth/login`, `GET /auth/me`, `POST /auth/refresh`, `POST /auth/logout` | `X` (registro y login) | `R`, `X` (Propio: `me`, `refresh`, `logout`) | `R`, `X` (Propio: `me`, `refresh`, `logout`) | `R`, `X` (Propio: `me`, `refresh`, `logout`) | `R`, `X` (Propio: `me`, `refresh`, `logout`) |
| **Empresas** | `/api/v1/empresas`, `/api/v1/empresas/{id}`, `/api/v1/empresas/{id}/estado` | `—` | `—` | `—` | `R`, `U`, `E`<br>*(Alcance: `empresa_ids`)* | `C`, `R`, `U`, `E`, `D`*<br>*(Alcance: Global)* |
| **Rutas** | `/api/v1/rutas`, `/api/v1/rutas/{id}`, `/api/v1/rutas/{id}/estado` | `R`<br>*(Público: solo activas)* | `R`<br>*(Público: solo activas)* | `R`<br>*(Público: solo activas)* | `C`, `R` (incl. inactivas), `U`, `E`, `D`*<br>*(Alcance: `empresa_ids`)* | `C`, `R` (incl. inactivas), `U`, `E`, `D`*<br>*(Alcance: Global)* |
| **Micros (Catálogo público)** | `GET /api/v1/micros/activos`, `GET /api/v1/micros/{id}` | `R`<br>*(Público: `disponible` o `en_recorrido`)* | `R`<br>*(Público: `disponible` o `en_recorrido`)* | `R`<br>*(Público: `disponible` o `en_recorrido`)* | `R`<br>*(Incl. inactivos de `empresa_ids`)* | `R`<br>*(Global: todos los estados)* |
| **Micros (Gestión de flota)** | `/api/v1/micros`, `/api/v1/micros/{id}`, `/api/v1/micros/{id}/estado` | `—` | `—` | `—` | `C`, `R`, `U`, `E`, `D`*<br>*(Alcance: `empresa_ids`)* | `C`, `R`, `U`, `E`, `D`*<br>*(Alcance: Global)* |
| **Conductores (Gestión)** | `/api/v1/conductores`, `/api/v1/conductores/{id}`, `/api/v1/conductores/{id}/estado` | `—` | `—` | `—` | `C`, `R`, `U`, `E`, `D`*<br>*(Alcance: `empresa_ids`)* | `C`, `R`, `U`, `E`, `D`*<br>*(Alcance: Global)* |
| **Conductores (Modo Conductor / Tracking)** | `GET /conductor/perfil`, `POST /conductor/posicion` (`/tracking/position`), `POST /conductor/finalizar` (`/tracking/stop`) | `—` | `—` | `R`, `X`<br>*(Propio: perfil y micro asignado)* | `—` | `—` |
| **Usuarios (Cuentas globales)** | `/api/v1/usuarios`, `/api/v1/usuarios/{id}`, `/api/v1/usuarios/{id}/estado` | `—` | `—` | `—` | `—` | `C`, `R`, `U`, `E`*, `D`*<br>*(Alcance: Global)* |
| **Administradores de empresa** | `/api/v1/administradores-empresa`, `/api/v1/administradores-empresa/{id}` | `—` | `—` | `—` | `R`<br>*(Alcance: `empresa_ids`)* | `C`, `R`, `U`, `D`<br>*(Alcance: Global)* |
| **Planes comerciales** | `/api/v1/planes`, `/api/v1/planes/{id}`, `/api/v1/planes/{id}/estado` | `R`<br>*(Público: solo activos)* | `R`<br>*(Público: solo activos)* | `R`<br>*(Público: solo activos)* | `R`<br>*(Público: solo activos)* | `C`, `R` (incl. inactivos), `U`, `E`, `D`*<br>*(Alcance: Global)* |
| **Suscripciones (Administración)** | `/api/v1/suscripciones`, `/api/v1/suscripciones/{id}`, `/api/v1/suscripciones/{id}/estado` | `—` | `—` | `—` | `—` | `C`, `R`, `U`, `E`, `D`<br>*(Alcance: Global)* |
| **Suscripciones (Autogestión)** | `GET/POST /api/v1/mis-suscripciones`, `GET /api/v1/mis-suscripciones/{id}`, `PATCH /api/v1/mis-suscripciones/{id}/cancelar` | `—` | `C`, `R`, `E` (cancelar)<br>*(Alcance: Propio)* | `—` | `—` | `C`, `R`, `E` (cancelar)<br>*(Alcance: Propio)* |
| **Posiciones GPS (Historial)** | `/api/v1/posiciones`, `/api/v1/posiciones/{id}` | `—` | `—` | `—` | `R`<br>*(Alcance: micros de `empresa_ids`)* | `C`, `R`, `U`, `D`<br>*(Alcance: Global)* |
| **Salas WebSocket y ETA** | `route:join`, `route:leave`, `eta:request` ⇄ `route:joined`, `micro:position`, `micro:offline`, `micro:stopped`, `eta:response` | `X` (suscribir a `ruta:{id}` y pedir ETA; máx. 2 micros en UI) | `X` (suscribir a `ruta:{id}` y pedir ETA; sin límite de micros si es `Premium`) | `X` (origina `micro:position` y `micro:stopped` vía HTTP POST) | `X` (monitoreo en vivo de las rutas de sus empresas) | `X` (monitoreo en vivo de todas las rutas) |

> **Nota (`*`):** Las operaciones `D` (eliminar) y `E` (estado de usuario propio) están sujetas a reglas de bloqueo por integridad (`409 Conflict` o `422 Unprocessable Entity`) detalladas en la sección 5.

---

### 4.3 Detalle de permisos por endpoint de la API (`/api/v1`)

| Recurso | Método y ruta | Operación | Roles autorizados | Regla de alcance y validación |
|---|---|---|---|---|
| **Empresas** | `GET /empresas` | Listar empresas | `admin_general`, `admin_empresa` | `admin_empresa` solo recibe las empresas de su `empresa_ids`. |
| **Empresas** | `POST /empresas` | Crear empresa | `admin_general` | Exclusivo de `admin_general`. Valida `ruc` único de 11 dígitos. |
| **Empresas** | `GET /empresas/{empresa}` | Ver detalle | `admin_general`, `admin_empresa` | `admin_empresa` requiere pertenecer a `{empresa}` (`403` si es ajena). |
| **Empresas** | `PUT/PATCH /empresas/{empresa}` | Editar empresa | `admin_general`, `admin_empresa` | `admin_empresa` solo puede editar empresas de su `empresa_ids`. |
| **Empresas** | `PATCH /empresas/{empresa}/estado` | Baja lógica / reactivar | `admin_general`, `admin_empresa` | Cambia `activo` (`true`/`false`) conservando datos e historial. |
| **Empresas** | `DELETE /empresas/{empresa}` | Eliminar empresa | `admin_general` | Exclusivo de `admin_general`. Falla con `409` si tiene rutas, micros, conductores o administradores. |
| **Rutas** | `GET /rutas` y `GET /rutas/{ruta}` | Listar y ver ruta | Público / Todos | Sin token: solo `activo = true`. Con token admin: incluye inactivas de su alcance. |
| **Rutas** | `POST /rutas` | Crear ruta | `admin_general`, `admin_empresa` | `admin_empresa` solo puede crear en sus `empresa_ids`. Normaliza `trazado_ruta` GeoJSON/WKT. |
| **Rutas** | `PUT/PATCH /rutas/{ruta}` | Editar ruta | `admin_general`, `admin_empresa` | Requiere alcance sobre `ruta.empresa_id`. |
| **Rutas** | `PATCH /rutas/{ruta}/estado` | Baja lógica / reactivar | `admin_general`, `admin_empresa` | Activa o desactiva la ruta dentro del alcance de su empresa. |
| **Rutas** | `DELETE /rutas/{ruta}` | Eliminar ruta | `admin_general`, `admin_empresa` | Falla con `409` si la ruta tiene micros asignados. |
| **Micros** | `GET /micros/activos` y `GET /micros/{micro}` | Consultar micros | Público / Todos | Público para unidades `disponible` o `en_recorrido` (detalle incluye últimas 20 posiciones). |
| **Micros** | `GET /micros` | Listar flota | `admin_general`, `admin_empresa` | Incluye todos los estados (`disponible`, `en_recorrido`, `mantenimiento`, `inactivo`) dentro del alcance. |
| **Micros** | `POST /micros` | Crear micro | `admin_general`, `admin_empresa` | `ruta_id` y `conductor_actual_id` deben pertenecer a la misma `empresa_id`. |
| **Micros** | `PUT/PATCH /micros/{micro}` | Editar micro / asignar | `admin_general`, `admin_empresa` | Único punto de asignación de `conductor_actual_id` y `ruta_id`. |
| **Micros** | `PATCH /micros/{micro}/estado` | Cambiar estado | `admin_general`, `admin_empresa` | Sincroniza automáticamente el `estado_operativo` del conductor asignado. |
| **Micros** | `DELETE /micros/{micro}` | Eliminar micro | `admin_general`, `admin_empresa` | Falla con `409` si el micro está `en_recorrido`. |
| **Conductores** | `GET /conductores` y `GET /conductores/{id}` | Listar y ver conductor | `admin_general`, `admin_empresa` | Filtrado por `empresa_ids` para `admin_empresa`. |
| **Conductores** | `POST /conductores` | Crear conductor | `admin_general`, `admin_empresa` | Crea o vincula usuario con `rol = conductor` y su perfil en `conductor_perfiles`. |
| **Conductores** | `PUT/PATCH /conductores/{id}` | Editar conductor | `admin_general`, `admin_empresa` | Actualiza datos de licencia, empresa o usuario dentro del alcance. |
| **Conductores** | `PATCH /conductores/{id}/estado` | Cambiar estado operativo | `admin_general`, `admin_empresa` | Cambia `estado_operativo` (`disponible`, `en_recorrido`, `sin_conexion`). |
| **Conductores** | `DELETE /conductores/{id}` | Eliminar conductor | `admin_general`, `admin_empresa` | Falla con `409` si el conductor tiene un micro asignado actualmente. |
| **Tracking** | `GET /conductor/perfil` | Ver perfil propio | `conductor` | Devuelve perfil, empresa y micro asignado del conductor autenticado. |
| **Tracking** | `POST /conductor/posicion` (`/tracking/position`) | Reportar ubicación GPS | `conductor` | Requiere micro asignado. Inserta en `posiciones_gps` y pasa micro y conductor a `en_recorrido`. |
| **Tracking** | `POST /conductor/finalizar` (`/tracking/stop`) | Finalizar recorrido | `conductor` | Pasa el micro a `disponible` y el conductor a `sin_conexion`. |
| **Usuarios** | `GET/POST /usuarios`, `GET/PUT/PATCH/DELETE /usuarios/{id}`, `PATCH /usuarios/{id}/estado` | Gestión global de cuentas | `admin_general` | Exclusivo de `admin_general`. Impide auto-desactivación (`422`) y auto-eliminación o borrado con perfiles/suscripciones (`409`). |
| **Admin Empresa** | `GET /administradores-empresa`, `GET /administradores-empresa/{id}` | Consultar vínculos | `admin_general`, `admin_empresa` | `admin_empresa` solo visualiza los vínculos de sus propias empresas. |
| **Admin Empresa** | `POST /administradores-empresa`, `PUT/PATCH/DELETE /administradores-empresa/{id}` | Gestionar vínculos | `admin_general` | Exclusivo de `admin_general`. Vincula cuentas `admin_empresa` con empresas. |
| **Planes** | `GET /planes`, `GET /planes/{plan}` | Consultar planes | Público / Todos | Sin token: solo `activo = true`. `admin_general` visualiza también inactivos. |
| **Planes** | `POST /planes`, `PUT/PATCH/DELETE /planes/{plan}`, `PATCH /planes/{plan}/estado` | Administrar planes | `admin_general` | Exclusivo de `admin_general`. `DELETE` falla con `409` si el plan tiene suscripciones. |
| **Suscripciones** | `GET/POST /suscripciones`, `GET/PUT/PATCH/DELETE /suscripciones/{id}`, `PATCH /suscripciones/{id}/estado` | Administrar suscripciones | `admin_general` | Exclusivo de `admin_general`. En la creación, el `usuario_id` debe tener rol `pasajero`. |
| **Mis Suscripciones** | `GET/POST /mis-suscripciones`, `GET /mis-suscripciones/{id}`, `PATCH /mis-suscripciones/{id}/cancelar` | Autogestión de suscripción | `pasajero`, `admin_general` | Opera únicamente sobre las suscripciones cuyo `usuario_id` es el usuario autenticado. |
| **Posiciones GPS** | `GET /posiciones`, `GET /posiciones/{posicion}` | Consultar historial GPS | `admin_general`, `admin_empresa` | `admin_empresa` solo ve posiciones de los micros pertenecientes a sus `empresa_ids`. |
| **Posiciones GPS** | `POST /posiciones`, `PUT/PATCH/DELETE /posiciones/{posicion}` | Administrar registros GPS | `admin_general` | Escritura y borrado manual en `/posiciones` reservados a `admin_general`. |

---

## 5. Reglas de aislamiento multi-empresa, baja lógica y conciliación con el diseño (`T053`)

1. **Aislamiento por empresa (`empresa_ids`):**
   - Cada registro operativo (`rutas`, `micros`, `conductor_perfiles`, `administrador_empresa_perfiles`) contiene una clave foránea `empresa_id` (y `posiciones_gps` la hereda a través de `micros.empresa_id`).
   - Cuando un usuario con rol `admin_empresa` realiza una petición, el backend obtiene la lista de `empresa_id` asociados a su `usuario_id` en `administrador_empresa_perfiles` y restringe tanto los listados como las operaciones por ID.
   - Al registrar o actualizar un micro (`POST/PUT/PATCH /api/v1/micros`), el servidor comprueba que la `ruta_id` y el `conductor_actual_id` pertenezcan a la misma `empresa_id` del micro.

2. **Baja lógica frente a eliminación física:**
   - En concordancia con la sección 4 de [../diseno/prototipo-administrador.md](../diseno/prototipo-administrador.md) (*«La operación D del CRUD se representa como desactivación»*), la interfaz administrativa utiliza los endpoints `PATCH /{recurso}/{id}/estado` (o el cambio de `micros.estado` a `inactivo`) para desactivar y reactivar empresas, rutas, micros, conductores, usuarios y planes conservando sus relaciones e historial.
   - Adicionalmente, la API REST expone endpoints `DELETE` protegidos por reglas de integridad (`RESTRICT` y validaciones de negocio) que devuelven `409 Conflict` si el registro posee dependencias activas:
     - **Empresa:** no se elimina si tiene rutas, micros, conductores o administradores vinculados.
     - **Ruta:** no se elimina si tiene micros asignados.
     - **Micro:** no se elimina si se encuentra en estado `en_recorrido`.
     - **Conductor:** no se elimina si está asignado actualmente a un micro (`conductor_actual_id`).
     - **Plan:** no se elimina si tiene suscripciones registradas.
     - **Usuario:** no se elimina si tiene perfiles o suscripciones asociadas, o si coincide con el usuario en sesión.
