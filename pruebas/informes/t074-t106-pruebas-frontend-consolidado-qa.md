# T074 y T106 — Pruebas del frontend web y consolidado general de calidad (QA)

> **Estado:** Actualizado (en seguimiento activo)
> **Responsable:** Edison Catari
> **Última actualización:** 2026-11-27
> **Relacionado:** [plan-de-pruebas.md](../plan-de-pruebas.md), [matriz-de-trazabilidad.md](../matriz-de-trazabilidad.md), [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md), [t095-hallazgos-usabilidad.md](t095-hallazgos-usabilidad.md), [t070-t076-ejecucion-pruebas-backend-seguridad.md](t070-t076-ejecucion-pruebas-backend-seguridad.md)

## 1. Ejecución de pruebas sobre `go-tacna-frontend` (`T074` — `PRB-043`)

Se evaluó la aplicación web desplegada en `https://www.go-tacna.site` y el código fuente actualizado en la rama `develop` de `go-tacna-frontend` (`24b8a86`, tras la integración de `PR #132` y `PR #131`), cubriendo pruebas unitarias, compilación de producción, pruebas E2E automatizadas con Playwright, tiempos de carga de rutas SPA y accesibilidad:

### 1.1. Pruebas unitarias, análisis estático y empaquetado de producción
- **Suite unitaria completa (`node --test pruebas/autenticacion.test.mjs pruebas/sesion-http.test.mjs pruebas/rutas.test.mjs pruebas/consulta-publica.test.mjs`):** **`83 / 83` pruebas aprobadas (`0 fail`) en `621.6 ms`**:
  - `pruebas/autenticacion.test.mjs` (**`20 / 20`**): interpretación de los 4 roles confirmados, deduplicación de empresas, rechazo de cuentas inactivas, validación de longitudes, política de DNI de 8 dígitos numéricos, teléfono de 9 dígitos iniciando en `9` (`QA-01`) y destinos por rol.
  - `pruebas/sesion-http.test.mjs` (**`32 / 32`**): renovación anticipada de JWT, deduplicación de refrescos concurrentes, manejo de `401`/`403`/`422`/`429`/`500`, aislamiento de sesiones y exposición controlada del motivo de negocio del servidor ante `HTTP 409 Conflict` (`QA-03`).
  - `pruebas/rutas.test.mjs` (**`8 / 8`**): conversión GeoJSON `LineString`, rechazo de trazados con menos de 2 puntos o fuera de rango geográfico, recorridos circulares y límite de 180 caracteres.
  - `pruebas/consulta-publica.test.mjs` (**`23 / 23`**): contrato de consulta pública (`T057`, `PR #132`), filtrado de rutas/empresas inactivas, cancelación vía `AbortSignal`, ausencia de cabecera `Authorization` y manejo de errores públicos sin filtrar respuestas crudas.
- **Script de integración CRUD (`pruebas/integracion-crud.mjs`):** Verifica extremo a extremo contra la API la creación de empresas, aislamiento `HTTP 403` para `admin_empresa`, edición de trazados GeoJSON, bloqueo `HTTP 422` al asignar un mismo conductor a dos micros (`RN-03`), bloqueo `HTTP 409 Conflict` al intentar eliminar registros con dependencias o micros `en_recorrido`, y limpieza automática en bloque `finally`.
- **Compilación de producción (`npm run build` — `tsc -b && vite build`):** `2068` módulos transformados sin errores de tipos en **`2.05 s`**.

| Artefacto generado (`dist/`) | Tamaño minificado | Tamaño comprimido (`gzip`) | Observación QA |
|---|---|---|---|
| `dist/index.html` | `0.77 kB` | `0.43 kB` | Punto de entrada SPA con contenedor `id="root"`. |
| `dist/assets/RutasAcceso-*.css` | `37.67 kB` | `11.18 kB` | Estilos de acceso y panel administrativo. |
| `dist/assets/index-*.css` | `59.77 kB` | `11.86 kB` | Estilos base Tailwind CSS v4 y módulo de consulta pública (`T057`). |
| `dist/assets/RutasAcceso-*.js` | `244.89 kB` | `74.25 kB` | Módulo de autenticación y administración separado por ruta. |
| `dist/assets/index-*.js` | `345.96 kB` | `107.47 kB` | Núcleo React 19, enrutador, landing principal y consulta pública. |
| `dist/assets/MapaBuses3D-*.js` | `553.11 kB` | `138.49 kB` | Cargado de forma diferida (`React.lazy` en `MapaPublico.tsx`); supera los `500 kB` por incluir `three`. |

### 1.2. Verificación en vivo de rutas SPA, responsividad y accesibilidad (`https://www.go-tacna.site`)

| Ruta evaluada en producción | Estado HTTP | Latencia medida | Criterio verificado (`PRB-043`) |
|---|---|---|---|
| `/` (Landing pública e inicio) | `HTTP 200` | `1045 ms` (1.ª carga TLS) | Renderiza navegación, hero, mapa de unidades y catálogo de rutas públicas (`RF-04`, `RF-05`). |
| `/mapa` (Visor público 3D) | `HTTP 200` | `210 ms` | Carga diferida (`Suspense`) de `MapaBuses3D`, diseño adaptable (`min-h-[60svh]`, `lg:grid-cols-[minmax(0,1fr)_320px]`) y atributos ARIA (`aria-label`, `role="status"`). |
| `/login` y `/registro` | `HTTP 200` | `206 ms` / `206 ms` | Formularios de inicio de sesión y alta de pasajero conectados a `/api/v1/auth/*` (`RF-01`, `RF-02`). |
| `/admin`, `/admin/empresas`, `/admin/rutas`, `/admin/micros`, `/admin/conductores` | `HTTP 200` | `205 ms` a `212 ms` | Enrutamiento SPA de Nginx (`try_files`) operativo sin errores `404` al recargar subrutas administrativas (`RF-15`, `RF-16`). |

### 1.3. Auditoría E2E automatizada con Playwright y gestión de hallazgos (`PR #131`)

Se ejecutó una suite automatizada E2E en Chromium (`tests/e2e/auth.spec.ts` y `tests/e2e/admin-empresa.spec.ts`, en modo solo lectura contra la API desplegada) cubriendo **9 casos de prueba** (`TC-AUTH-01`..`02`, `TC-REG-01`..`05` y `TC-ADMIN-01`..`02`). Tras aplicar las correcciones en `tuChaski/go-tacna-frontend#131` (commit `adf1cf7`, fusionado en `develop` en `24b8a86`), la ejecución cerró con **`9 / 9` casos aprobados (`38.5 s`)**, **`0` errores de consola JS** y **`0` excepciones de página**.

**Hallazgos corregidos y verificados en Frontend (`go-tacna-frontend#131`):**

| ID | Severidad | Hallazgo detectado | Corrección aplicada y verificada | Estado |
|---|---|---|---|---|
| `QA-01` | Alta | `/registro` y formularios administrativos no validaban formato estricto de DNI ni teléfono celular peruano antes del envío. | Reglas `^\d{8}$` (`maxLength={8}`, `inputMode="numeric"`) y `^9\d{8}$` (`maxLength={9}`, `inputMode="tel"`) con alertas locales en `formulario-acceso.ts` y `FormularioRegistro.tsx`. | **Cerrado (`PR #131`)** |
| `QA-02` | Alta | Excepción `TypeError: Cannot read properties of undefined (reading '_leaflet_pos')` al abandonar el detalle de ruta durante la animación de `fitBounds`. | Desactivación de animación en `fitBounds` y limpieza de animaciones en el desmontaje de `MapaRuta.tsx` (`TC-ADMIN-02`: 6 navegaciones, 0 excepciones). | **Cerrado (`PR #131`)** |
| `QA-03` | Media | Botón **Eliminar** permanecía habilitado en registros con dependencias activas y los mensajes de negocio `409` no se mostraban al usuario. | Deshabilitación preventiva con `title` explicativo en conductores con micro asignado, micros `en_recorrido` y rutas con `micros_count > 0`; visualización de placa asignada en Conductores y exposición del `message` en `409 Conflict`. | **Cerrado (`PR #131`)** |
| `QA-05` | Media | Los mensajes de error de validación local en formularios de acceso carecían de rol accesible para lectores de pantalla. | Incorporación de `role="alert"` en alertas de validación de `InicioSesion.tsx`, verificado en `TC-REG-01`..`03`. | **Cerrado (`PR #131`)** |
| `QA-07` | Baja | Textos de aviso huérfanos en vistas de detalle tras la reorganización del panel en `PR #128`. | Retiro de avisos redundantes y restricción de la ayuda de edición del mapa únicamente al modo editable (`Avisos detalle: []`). | **Cerrado (`PR #131`)** |
| `QA-08` | Baja | Campos del formulario `/registro` sin atributos `name` ni `placeholder` consistentes. | Normalización de `name` y `placeholder` en los 7 campos de `/registro`, verificado en `TC-REG-05`. | **Cerrado (`PR #131`)** |

**Hallazgos derivados pendientes en Backend (`go-tacna-backend`):**

| ID | Severidad | Descripción pendiente en servidor | Issue en GitHub | Estado |
|---|---|---|---|---|
| `QA-01` (Backend) | Alta | Exigir validación estricta de formato DNI (`^\d{8}$`) y teléfono (`^9\d{8}$`) en `RegisterRequest`, `ConductorPerfilRequest`, `UsuarioRequest` y `MicroRequest`. | [go-tacna-backend#5](https://github.com/tuChaski/go-tacna-backend/issues/5) | **Abierto** |
| `QA-04` (Backend) | Media | Exponer `micros_count` (`withCount('micros')`) y soportar filtro `activo=0` en `RutaController::index()` para habilitar el bloqueo preventivo de eliminación en rutas con flota. | [go-tacna-backend#6](https://github.com/tuChaski/go-tacna-backend/issues/6) | **Abierto** |
| `QA-06` (Backend) | Alta | Restringir `PATCH /api/v1/empresas/{id}/estado` exclusivamente a `admin_general` (`HTTP 403`) y reforzar integridad referencial con `HTTP 409` en `DELETE` de micros y conductores. | [go-tacna-backend#7](https://github.com/tuChaski/go-tacna-backend/issues/7) | **Abierto** |

---

## 2. Consolidado general de resultados de pruebas (`T106`)

A la fecha de corte (`2026-11-27`), el aseguramiento de calidad registra **160 pruebas automatizadas de código en verde** (`68` en backend + `83` unitarias en frontend + `9` E2E en Playwright), **25 casos de usabilidad evaluados sobre prototipo** y **27 comprobaciones HTTP/RBAC/SPA ejecutadas contra el servidor de producción**, con trazabilidad activa de defectos cerrados y abiertos:

| Fase del Plan de Pruebas | Tareas cubiertas | Evidencia documental en `pruebas/` | Cobertura alcanzada | Estado de la fase |
|---|---|---|---|---|
| **Planificación y trazabilidad QA** | `T069` | [plan-de-pruebas.md](../plan-de-pruebas.md), [matriz-de-trazabilidad.md](../matriz-de-trazabilidad.md) | `RF-01` a `RF-20`, `RNF-01` a `RNF-07` y `DEC-001` a `DEC-003` vinculados a `PRB-001`..`PRB-045` | **Completada y en actualización continua (`PR #22`)** |
| **Usabilidad en prototipo e interfaz UI** | `T054`, `T095` | [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md), [t095-hallazgos-usabilidad.md](t095-hallazgos-usabilidad.md) | `25` casos (`PRB-001` a `PRB-025`); regla de **3 toques** cumplida en los 6 escenarios de pasajero; `6` hallazgos (`HLZ-001` a `HLZ-006`) documentados | **Completada (`PR #20`, `PR #23`)** |
| **Pruebas unitarias, API REST y WebSocket** | `T099`, `T070`, `T071` | [t070-t076-ejecucion-pruebas-backend-seguridad.md](t070-t076-ejecucion-pruebas-backend-seguridad.md) y `realtime/test/realtime.test.js` (`go-tacna-backend#4`) | `56` pruebas en Backend Core + `6` en Gateway + `6` en Realtime Node.js (`pass 6, fail 0`) | **Ejecutada (`PR #4` backend, `PR #25` docs); 3 issues QA abiertos (`#5`, `#6`, `#7`)** |
| **Integración, carga, seguridad y ramas** | `T072`, `T075`, `T076`, `T077` | [t070-t076-ejecucion-pruebas-backend-seguridad.md](t070-t076-ejecucion-pruebas-backend-seguridad.md) | `18` sondas en vivo (TLS/301, JWT 4 roles, RBAC `401`/`403`/`415`/`422`, ráfaga `10/10` en `989 ms` promedio) + fix JWT `HLZ-INT-001` | **Ejecutada (`PR #4` y `PR #25`); seguimiento de seguridad en `go-tacna-backend#7`** |
| **Pruebas de plataforma web (`go-tacna-frontend`)** | `T074` | Presente informe (`Sección 1`) y `go-tacna-frontend#131` | **`83 / 83`** pruebas unitarias (`0 fail`), **`9 / 9`** E2E Playwright (`0` errores consola/página), `vite build` (`2.05 s`), `6` hallazgos cerrados (`QA-01`..`08`) y `9` rutas SPA verificadas | **Verificada en `develop` (`PR #131`); pendiente ampliar E2E a consulta pública (`T057` / `PR #132`) y promover a producción** |
| **Pruebas móviles y de campo en Tacna** | `T103`, `T073`, `T104`, `T105` | Planificadas en `PRB-042` a `PRB-045` dentro de [plan-de-pruebas.md](../plan-de-pruebas.md) | `go-tacna-movil` cuenta con base UI/UX de Fase 2 fusionada (`PR #2`, `b2708aa`); pendiente integración con API/GPS y generación de APK | **En espera de integración móvil (Fase 3)** |