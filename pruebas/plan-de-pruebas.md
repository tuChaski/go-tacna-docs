# Plan de pruebas

> **Estado:** En revisión
> **Responsable:** Edison Catari
> **Relacionado:** [matriz-de-trazabilidad.md](matriz-de-trazabilidad.md), [informes/t054-pruebas-usabilidad-figma.md](informes/t054-pruebas-usabilidad-figma.md), [../CONTEXTO_PROYECTO_GO_TACNA.md](../CONTEXTO_PROYECTO_GO_TACNA.md), [../arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md)

## 1. Objetivo y alcance

El presente plan define la estrategia, los ambientes, los criterios de aceptación y el catálogo de casos de prueba (`PRB-`) para verificar los requerimientos funcionales (`RF-01` a `RF-20`), los requerimientos no funcionales (`RNF-01` a `RNF-07`), las reglas de negocio (`RN-01` a `RN-10`) y las decisiones de arquitectura (`DEC-001` a `DEC-003`) del sistema **Go-Tacna**.

- **Dentro del alcance (v1.0.0):**
  - Consulta pública y autenticada de rutas, paraderos, ubicación de micros y cálculo del tiempo estimado de llegada (ETA) en la ciudad de Tacna.
  - Operación del Modo Conductor (inicio y finalización de recorrido, envío periódico de coordenadas GPS cada 3 a 5 segundos).
  - Gestión administrativa CRUD de empresas, rutas, micros, conductores y supervisión de flota.
  - Verificación de contratos OpenAPI, reclamos JWT y eventos Socket.IO entre `go-tacna-backend`, `go-tacna-frontend` y `go-tacna-movil`.
- **Fuera del alcance inicial:** hardware GPS dedicado en unidades, cobro digital de pasajes, integración de tráfico externo en vivo y versión para iOS.

---

## 2. Tipos de prueba y tareas asociadas

| Tipo de prueba | Tarea | Componente objetivo | Propósito verificable |
|---|---|---|---|
| **Usabilidad en prototipo e interfaz** | `T054`, `T095`, `T103`, `T074` | Figma, `go-tacna-frontend`, `go-tacna-movil` | Comprobar la regla de acceso en máximo 3 toques (`Ruta -> Micro -> Ubicación`) y la interfaz de baja distracción para el conductor. |
| **Unitaria de API y tiempo real** | `T099`, `T070`, `T071` | `gotacna-backend-core`, `go-tacna-location-service` | Verificar autenticación JWT, control de acceso por roles (RBAC), operaciones CRUD, cálculo de ETA y emisión/recepción de eventos en salas Socket.IO. |
| **Integración entre servicios y datos** | `T072` | Gateway, Backend Core, Location Service, PostgreSQL/PostGIS | Confirmar que las posiciones recibidas por HTTP POST persistan en la base de datos y se difundan a los clientes suscritos a la ruta. |
| **Seguridad e integridad** | `T076` | Nginx host/interno, Gateway, Backend Core | Verificar terminación TLS/HTTPS, políticas CORS, hash de contraseñas, firma y expiración de tokens JWT y bloqueo de rutas por rol. |
| **Carga, estrés y disponibilidad** | `T075` | Stack Docker Compose en VPS Contabo | Evaluar tiempos de respuesta de la API (< 2 segundos en consulta de catálogo), limitación de peticiones (*rate limiting*) y disponibilidad operativa del 99.5 %. |
| **Campo GPS, cobertura y consumo en Tacna** | `T073`, `T104`, `T105` | `go-tacna-movil` y servidor en producción | Medir en rutas reales de Tacna la latencia de actualización (3 a 5 segundos), el marcado de micro sin conexión tras 2 minutos sin señal, la reconexión 3G/4G y el consumo de batería y datos en recorridos continuos de 1 hora. |

---

## 3. Ambientes y datos de prueba

| Ambiente | Infraestructura / ubicación | Uso en pruebas | Estado actual |
|---|---|---|---|
| **Prototipo interactivo** | Figma (`Flow 1`, vistas de Pasajero, Modo Conductor y Panel Admin) | Ejecución de casos de usabilidad y navegación `PRB-001` a `PRB-025` (`T054`, `T095`). | Operativo |
| **Entorno local** | Equipos de desarrollo Windows/Linux con Docker Compose (`gotacna-local`) | Pruebas unitarias (`T099`, `T070`, `T071`) y depuración de integración (`T072`). | Operativo |
| **Entorno de producción / staging** | VPS Contabo (`13.140.174.64`), dominio `https://www.go-tacna.site/`, Nginx con TLS Let's Encrypt y 6 contenedores Docker (`postgres`, `backend`, `gateway`, `websocket`, `frontend`, `nginx`) | Pruebas de integración web, seguridad TLS/JWT (`T076`), carga (`T075`) y recepción de telemetría de campo (`T073`, `T104`). | Operativo (con datos semilla de prueba) |
| **Campo en Tacna** | Smartphones Android 8.0+ con GPS activo y red móvil 3G/4G circulando en líneas seleccionadas de Tacna | Pruebas reales de trazado, latencia de 3 a 5 segundos, corte de red y consumo durante 1 hora (`T073`, `T103`, `T104`, `T105`). | Pendiente de integración móvil en `go-tacna-movil` |

### Datos de prueba controlados
- **Cuentas semilla:** perfiles de `admin_general`, administrador de empresa, conductor asignado y pasajero (estándar y Premium).
- **Flota y rutas de demostración:** empresas registradas (ej. Sur Demo, Andino Demo), trazados de rutas urbanas de Tacna (Línea 10, Línea 30), paraderos de referencia (Plaza de Armas, Av. Pinto) y micros de prueba (`Micro 01`, `Micro 02`, `Micro 03`, `Micro 024`, `Micro 025`).

---

## 4. Criterios de entrada y de salida

| Fase de prueba | Criterio de entrada | Criterio de salida (Aceptación) |
|---|---|---|
| **1. Usabilidad y navegación (`T054`, `T095`, `T103`, `T074`)** | Prototipos en Figma o vistas en `go-tacna-frontend` / `go-tacna-movil` accesibles. | 100 % de los recorridos principales completados en máximo 3 toques; defectos de flujo altos corregidos y documentados en `pruebas/informes/`. |
| **2. Unitarias e integración (`T099`, `T070`, `T071`, `T072`)** | Contratos en `contratos/` definidos; contenedores `postgres`, `backend`, `gateway` y `websocket` en estado `healthy`. | Casos `PRB-026` a `PRB-038` ejecutados sin fallos críticos; persistencia y difusión Socket.IO conciliadas. |
| **3. Seguridad y carga (`T075`, `T076`)** | Dominio `https://www.go-tacna.site/` activo con TLS válido y endpoints protegidos por middleware JWT. | Redirección HTTP a HTTPS activa, rutas administrativas bloqueadas para roles no autorizados (`HTTP 401`/`403`) y tiempo de respuesta dentro del umbral bajo carga concurrente. |
| **4. Campo en Tacna (`T073`, `T104`, `T105`)** | APK de `go-tacna-movil` compilada con permisos de ubicación y conectada al VPS. | Latencia medida entre 3 y 5 segundos en condiciones normales de cobertura, transición a desconectado tras 2 minutos sin señal y reporte de consumo de batería/datos de 1 hora registrado en `T106`. |

---

## 5. Numeración y catálogo de casos de prueba (`PRB-`)

Cada caso de prueba conserva un identificador único `PRB-000` que no se reutiliza ni se renumera:

- **`PRB-001` a `PRB-011`:** Pruebas de flujo de pasajero e invitado (3 toques, cambio de paradero, ruta sin micros activos, límite de 2 micros en plan gratuito, pérdida de conexión y ubicación con antigüedad mayor a 2 minutos). Registradas en [informes/t054-pruebas-usabilidad-figma.md](informes/t054-pruebas-usabilidad-figma.md).
- **`PRB-012` a `PRB-017`:** Pruebas de registro, inicio de sesión, credenciales inválidas y operación del Modo Conductor (inicio/fin de recorrido, GPS apagado y falta de internet). Registradas en [informes/t054-pruebas-usabilidad-figma.md](informes/t054-pruebas-usabilidad-figma.md).
- **`PRB-018` a `PRB-025`:** Pruebas del panel administrativo (gestión de empresas, registro y baja lógica de micros, asignación de conductor, bloqueo de cambio de conductor en recorrido y monitoreo de unidades). Registradas en [informes/t054-pruebas-usabilidad-figma.md](informes/t054-pruebas-usabilidad-figma.md).
- **`PRB-026` a `PRB-034`:** Pruebas funcionales y unitarias de `gotacna-backend-core` (autenticación JWT, RBAC, catálogo público, CRUD administrativo, recepción HTTP de posiciones y cálculo de ETA). Detalladas en [matriz-de-trazabilidad.md](matriz-de-trazabilidad.md).
- **`PRB-035` a `PRB-039`:** Pruebas de `go-tacna-location-service` e integración con base de datos y clientes web/móvil (suscripción a salas de ruta, difusión de posición, umbral de desconexión de 2 minutos y cierre de recorrido). Detalladas en [matriz-de-trazabilidad.md](matriz-de-trazabilidad.md).
- **`PRB-040` a `PRB-045`:** Pruebas no funcionales de seguridad TLS/JWT, carga concurrente, precisión GPS en rutas de Tacna, reconexión móvil 3G/4G y consumo de batería/datos durante 1 hora. Detalladas en [matriz-de-trazabilidad.md](matriz-de-trazabilidad.md).

---

## 6. Responsables y seguimiento

| Rol | Integrante | Responsabilidad en el ciclo de pruebas |
|---|---|---|
| **Responsable de QA y Automatización** | Edison Catari (`@EdCatari`) | Diseño del plan y matriz (`T069`), revisión de Pull Requests con impacto en calidad (`T077`), informe de hallazgos UI (`T095`), ejecución de pruebas (`T070` a `T076`, `T099`, `T103` a `T105`) y consolidación final (`T106`). |
| **Backend y DevOps** | Royfrankly Navarro (`@royfrankly`) | Soporte en entorno Docker/VPS Contabo, corrección de defectos en `gotacna-backend-core` y `gotacna-api-gateway`. |
| **Arquitectura y Tiempo Real** | David Montoya (`@DavidMontoyaHolgado`) | Soporte en contratos Socket.IO, `go-tacna-location-service` y co-ejecución de la prueba de consumo en ruta (`T105`). |
| **UI/UX, Web y Móvil** | Alex Huaracha (`@Alex-Huaracha-Bellido`) | Ejecución inicial en Figma (`T054`) y aplicación de ajustes de interfaz en prototipos, `go-tacna-frontend` y `go-tacna-movil`. |