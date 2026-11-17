# T070 a T077 — Informe de ejecución de pruebas de API, tiempo real, integración, carga y seguridad

> **Estado:** En revisión
> **Responsable:** Edison Catari
> **Relacionado:** [plan-de-pruebas.md](../plan-de-pruebas.md), [matriz-de-trazabilidad.md](../matriz-de-trazabilidad.md), [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md), [t095-hallazgos-usabilidad.md](t095-hallazgos-usabilidad.md), [despliegue-produccion.md](../../arquitectura/despliegue-produccion.md)

## 1. Alcance y resumen global de pruebas automatizadas

El presente informe documenta la ejecución verificable de las pruebas unitarias, funcionales, de integración, concurrencia, seguridad y auditoría de ramas correspondientes a las tareas **`T099`**, **`T070`**, **`T071`**, **`T072`**, **`T075`**, **`T076`** y **`T077`** sobre los repositorios de **Go-Tacna** y sobre el entorno desplegado en el VPS Contabo (`https://www.go-tacna.site`).

| Componente / Nivel evaluado | Tarea QA | Herramienta / Runner | Pruebas ejecutadas / verificadas | Resultado |
|---|---|---|---|---|
| **Backend Core (`gotacna-backend-core`)** | `T099`, `T070` | PHPUnit (`tests/Feature/Api/*.php`) + Sonda HTTP en vivo | **56 pruebas funcionales** en 9 suites (`AdminScope`, `Auth`, `Conductor`, `DemoSeeder`, `Micro`, `Plan`, `Ruta`, `Suscripcion`, `Unauthenticated`) | **56 / 56 cubiertas** y verificadas en producción |
| **API Gateway (`gotacna-api-gateway`)** | `T070`, `T072`, `T076` | PHPUnit (`tests/Feature/ProxyTest.php`) + Sonda HTTP | **6 pruebas funcionales** (reenvío GET/POST, cabecera `X-Gateway`, error `502`, bloqueo `415` multipart y CORS `204`) | **6 / 6 aprobadas** |
| **Tiempo Real (`go-tacna-backend/realtime`)** | `T099`, `T071` | Node.js Test Runner (`node --test` en PR #4) | **6 suites unitarias y de eventos** (`realtime/test/realtime.test.js`: Haversine, ETA, `fleetState`, JWT `authMiddleware`, `gpsRouter`, `passengerHandler`) | **6 / 6 aprobadas (`617 ms`)** |
| **Frontend Web (`go-tacna-frontend`)** | `T099`, `T074` | Node.js Test Runner (`pruebas/*.test.mjs`) | **26 pruebas unitarias** (`18` en `autenticacion.test.mjs` y `8` en `rutas.test.mjs`) | **26 / 26 aprobadas (`405 ms`)** |
| **Seguridad, RBAC y Carga en Producción** | `T072`, `T075`, `T076` | Sonda automatizada Node.js (`fetch` / TLS / concurrencia) contra `https://www.go-tacna.site` | **18 comprobaciones en vivo** (TLS/301, catálogo GeoJSON, 4 roles JWT, bloqueos `401`/`403`/`415`/`422`, handshake Socket.IO y ráfaga de 10 peticiones simultáneas) | **18 / 18 respuestas conformes** (con 3 hallazgos de integración documentados) |

---

## 2. Pruebas funcionales y de roles en API REST (`T070` y `T076`)

Se verificaron las 9 suites de `gotacna-backend-core/tests/Feature/Api/` y se contrastaron en vivo contra `https://www.go-tacna.site/api/v1`:

| Caso (`PRB-`) | Endpoint / Operación evaluada | Resultado esperado | Resultado obtenido en producción (`https://www.go-tacna.site`) | Latencia | Estado |
|---|---|---|---|---|---|
| `PRB-014` | `POST /api/v1/auth/login` (cuerpo vacío `{}`) | `HTTP 422` con mensajes de validación en español | `HTTP 422`: `"El campo correo es obligatorio."` y `"El campo contraseña es obligatorio."` | `325 ms` | Comprobado |
| `PRB-014` | `POST /api/v1/auth/login` (credenciales incorrectas) | `HTTP 401` sin revelar si el correo existe | `HTTP 401`: `{"success":false,"message":"Credenciales inválidas."}` | `283 ms` | Comprobado |
| `PRB-027` | `POST /api/v1/auth/login` para los 4 roles (`admin_general`, `admin_empresa`, `conductor`, `pasajero`) | `HTTP 200` con token JWT firmado y perfil de usuario | `HTTP 200` en los 4 perfiles; token JWT válido con expiración de 3600 s (`exp - iat = 3600`) | `546 ms` a `2076 ms` | Comprobado |
| `PRB-029`, `PRB-032` | `GET /api/v1/rutas` (consulta pública sin token) | `HTTP 200` con rutas activas y geometría GeoJSON `LineString` | `HTTP 200`: devuelve rutas activas (ej. línea `14`) con `"trazado_ruta":{"type":"LineString","coordinates":[...]}` | `1055 ms` | Comprobado |
| `PRB-029` | `GET /api/v1/micros/activos` y `GET /api/v1/planes` | `HTTP 200` con micros operativos y planes activos | `HTTP 200`: devuelve unidad `V1A-101` (`capacidad_pasajeros: 22`) y planes (`Plan Estudiante`, `costo: 3.5`) | `873 ms` / `446 ms` | Comprobado |
| `PRB-030` | `GET /api/v1/empresas` con rol `admin_general` vs `admin_empresa` | `admin_general` ve todas las empresas; `admin_empresa` solo ve las de su `empresa_ids` | `admin_general` visualiza todas las empresas (incluida `E.T. Viñani S.A. (La 10B)`); `admin_empresa` solo recibe `Transportes Tacna S.A.C.` (`id: 1`) | `295 ms` / `297 ms` | Comprobado |
| `PRB-033` | `GET /api/v1/conductor/perfil` con rol `conductor` | `HTTP 200` asociando al conductor con su micro y licencia (`RN-02`, `RN-03`) | `HTTP 200`: devuelve `licencia_conducir: "Q12345678"`, `estado_operativo: "disponible"` y relación con su micro | `366 ms` | Comprobado |
| `PRB-040` | `GET /api/v1/auth/me` y `GET /api/v1/empresas` sin token | `HTTP 401` en formato JSON | `HTTP 401`: `{"success":false,"message":"No autenticado."}` | `257 ms` / `263 ms` | Comprobado |
| `PRB-040` | `GET /api/v1/conductor/perfil` con token JWT adulterado (`Bearer token.adulterado.qa`) | `HTTP 401` rechazando firma inválida | `HTTP 401`: `{"success":false,"message":"No autenticado."}` | `348 ms` | Comprobado |
| `PRB-040` | Bloqueo cruzado RBAC (`admin_empresa` -> `/usuarios`, `conductor` -> `/empresas`, `pasajero` -> `/conductor/perfil`) | `HTTP 403 Forbidden` en los 3 intentos de escalamiento de privilegios | `HTTP 403`: `{"success":false,"message":"No tiene permisos para acceder a este recurso."}` en los 3 casos | `248 ms` a `274 ms` | Comprobado |
| `PRB-040` | `POST /api/v1/rutas` con `Content-Type: multipart/form-data` hacia el Gateway | `HTTP 415 Unsupported Media Type` | `HTTP 415`: `{"success":false,"message":"El gateway no admite cargas multipart. Envía la información en JSON."}` | `260 ms` | Comprobado |
| `PRB-040` | `GET https://go-tacna.site/` (dominio raíz sin `www`) | Redirección permanente `HTTP 301` hacia `https://www.go-tacna.site/` bajo TLS válido | `HTTP 301 Moved Permanently` emitido por Nginx con certificado Let's Encrypt activo | `913 ms` | Comprobado |

---

## 3. Pruebas unitarias y de eventos en el servidor de tiempo real (`T099` y `T071`)

En el Pull Request [`tuChaski/go-tacna-backend#4`](https://github.com/tuChaski/go-tacna-backend/pull/4) se implementó y ejecutó la suite `realtime/test/realtime.test.js` (`npm test` -> `pass 6, fail 0` en `617.6 ms`):

1. **`PRB-031` (Fórmula de Haversine en Tacna):** Comprueba distancia `0 m` en coordenadas idénticas y distancia geodésica real (`~1190 m`) entre la Plaza de Armas de Tacna (`-18.0146, -70.2536`) y la Av. Pinto (`-18.0065, -70.2462`).
2. **`PRB-031` (Cálculo de tiempo estimado de llegada — ETA):** Verifica que `calculateETA` aplique el piso mínimo de velocidad (`2 m/s`) cuando el micro está detenido (`speed: 0`), devuelva `estimated: true` (`RN-08`) y lance excepción controlada si el `microId` no existe.
3. **`PRB-035` y `PRB-038` (Estado de flota en memoria `fleetState.js`):** Comprueba la inserción y actualización en `moviendo`, el recorte de la ventana móvil a máximo `60` muestras (`speedSamples`), el filtrado por ruta (`getRuta`) y el cambio inmediato a `detenido` con `markStopped` (`RF-14`).
4. **`PRB-027` y `PRB-040` (Middleware JWT `auth.js`):** Comprueba rechazo `HTTP 401` sin cabecera Bearer, rechazo `HTTP 403` cuando el rol no es `conductor` y paso autorizado poblando `req.conductor`.
5. **`PRB-034` y `PRB-038` (Rutas HTTP GPS `gps.js`):** Comprueba rechazo `HTTP 400` ante latitudes fuera de `[-90, 90]`, respuesta `HTTP 202` en `POST /tracking/position` difundiendo `micro:position` a la sala `ruta:{rutaId}` y respuesta `HTTP 200` en `POST /tracking/stop` emitiendo `micro:stopped`.
6. **`PRB-035` (Eventos Socket.IO de pasajero `passenger.js`):** Comprueba validación de `rutaId` numérico en `route:join`, emisión de `route:joined`, respuesta de `eta:request` mediante *callback* y salida de sala con `route:leave`.

---

## 4. Pruebas de carga, concurrencia y disponibilidad (`T075` — `PRB-041`)

Se ejecutó una ráfaga concurrente de **10 peticiones simultáneas** (`Promise.all`) desde Tacna contra el endpoint público `GET https://www.go-tacna.site/api/v1/rutas` pasando por Nginx -> API Gateway -> Backend Core -> PostgreSQL/PostGIS:

- **Tasa de éxito:** `10 / 10` respuestas `HTTP 200 OK` (`100 %`, sin errores `502`/`504`).
- **Tiempo total de resolución de la ráfaga:** `1438 ms`.
- **Latencia mínima:** `313 ms`.
- **Latencia promedio:** `989 ms` (cumple el umbral `< 2000 ms` de `RNF-03`).
- **Latencia máxima (percentil 100):** `1433 ms` (cumple el umbral `< 2000 ms` de `RNF-03`).
- **Handshake de disponibilidad WebSocket (`/socket.io/?EIO=4&transport=polling`):** `HTTP 200 OK` en `331 ms` (`pingInterval: 25000`, `pingTimeout: 20000`).

---

## 5. Auditoría de integración entre servicios y ramas (`T072` y `T077`)

Como resultado de la inspección cruzada entre `go-tacna-backend`, `go-tacna-infraestructura` y el entorno de producción, se registran **3 hallazgos técnicos de integración (`HLZ-INT-001` a `HLZ-INT-003`)** que deben conciliarse para cerrar el flujo de tiempo real extremo a extremo:

| ID | Caso / Decisión | Severidad | Componente afectado | Descripción técnica del hallazgo | Acción correctiva requerida |
|---|---|---|---|---|---|
| `HLZ-INT-001` | `PRB-027`, `DEC-001` | **Alta** | `gotacna-backend-core` vs `realtime/src/middleware/auth.js` | Al iniciar sesión como conductor en Laravel (`POST /api/v1/auth/login`), el payload del JWT emitido contiene los claims en español y `snake_case`: `{"rol":"conductor","micro_id":1,"ruta_id":1}`. En cambio, `realtime/src/middleware/auth.js` valida `payload.role`, `payload.microId` y `payload.rutaId`, por lo que rechaza con `HTTP 403` los tokens reales emitidos por Laravel. | Actualizar `realtime/src/middleware/auth.js` para aceptar ambos esquemas (`const role = payload.rol ?? payload.role; const microId = payload.micro_id ?? payload.microId; const rutaId = payload.ruta_id ?? payload.rutaId;`). |
| `HLZ-INT-002` | `PRB-035`, `PRB-037`, `DEC-001` | **Alta** | `go-tacna-infraestructura` (`docker/node/bootstrap.cjs`) y `PosicionController.php` | El contenedor `websocket` en producción ejecuta `docker/node/bootstrap.cjs` (`mode: 'infrastructure-bootstrap'`) en lugar de montar `realtime/src/server.js`. Asimismo, `Conductor\PosicionController@store` en Laravel guarda la posición en `posiciones_gps` (`HTTP 201`), pero aún no la difunde al servidor Socket.IO. | Reemplazar `bootstrap.cjs` en el contenedor `websocket` por el servicio `realtime/` y conectar el envío de posición con la emisión del evento `micro:position`. |
| `HLZ-INT-003` | `T077` | **Media** | Ramas `origin/main` y `origin/develop` de `go-tacna-backend` | En `go-tacna-backend`, la rama `origin/main` contiene `gotacna-backend-core/`, `gotacna-api-gateway/` y `go-tacna-location-service/` (commits `6cbe163`..`6d7c4a9`), mientras que `origin/develop` contiene únicamente `realtime/` (PR #3 `0c57a40`). | Fusionar `main` hacia `develop` en `go-tacna-backend` unificando `realtime/` con `gotacna-backend-core/` y `gotacna-api-gateway/`. |