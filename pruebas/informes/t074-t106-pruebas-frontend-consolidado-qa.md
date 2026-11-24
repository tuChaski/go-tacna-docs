# T074 y T106 — Pruebas del frontend web y consolidado general de calidad (QA)

> **Estado:** En revisión
> **Responsable:** Edison Catari
> **Relacionado:** [plan-de-pruebas.md](../plan-de-pruebas.md), [matriz-de-trazabilidad.md](../matriz-de-trazabilidad.md), [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md), [t095-hallazgos-usabilidad.md](t095-hallazgos-usabilidad.md), [t070-t076-ejecucion-pruebas-backend-seguridad.md](t070-t076-ejecucion-pruebas-backend-seguridad.md)

## 1. Ejecución de pruebas sobre `go-tacna-frontend` (`T074` — `PRB-043`)

Se evaluó la aplicación web desplegada en `https://www.go-tacna.site` y el código fuente en la rama `develop` de `go-tacna-frontend` (`9d4a070`), verificando pruebas unitarias, análisis estático, compilación de producción, tiempos de carga de rutas SPA y adaptabilidad responsive:

### 1.1. Pruebas unitarias, linter y empaquetado de producción
- **Suite de autenticación (`npm run test:auth` — `pruebas/autenticacion.test.mjs`):** `18 / 18` pruebas aprobadas en `231.5 ms` (interpretación de los 4 roles confirmados, deduplicación de empresas, rechazo de cuentas inactivas, validación de longitudes y destinos por rol).
- **Suite de geometría de rutas (`npm run test:rutas` — `pruebas/rutas.test.mjs`):** `8 / 8` pruebas aprobadas en `173.6 ms` (conversión GeoJSON `LineString`, rechazo de trazados con menos de 2 puntos o fuera de rango geográfico, soporte de recorridos circulares y límite de 180 caracteres).
- **Script de integración CRUD (`pruebas/integracion-crud.mjs`):** Verifica extremo a extremo contra la API la creación de empresas, aislamiento `HTTP 403` para `admin_empresa`, edición de trazados GeoJSON, bloqueo `HTTP 422` al asignar un mismo conductor a dos micros (`RN-03`), bloqueo `HTTP 409 Conflict` al intentar eliminar registros con dependencias o micros `en_recorrido`, y limpieza automática en bloque `finally`.
- **Análisis estático (`npm run lint` — `eslint .`):** `0` errores y `0` advertencias en todos los módulos TypeScript/React.
- **Compilación de producción (`npm run build` — `tsc -b && vite build`):** `2060` módulos transformados sin errores de tipos en **`1.37 s`**.

| Artefacto generado (`dist/`) | Tamaño minificado | Tamaño comprimido (`gzip`) | Observación QA |
|---|---|---|---|
| `dist/index.html` | `0.77 kB` | `0.43 kB` | Punto de entrada SPA con contenedor `id="root"`. |
| `dist/assets/RutasAcceso-*.css` | `35.94 kB` | `10.86 kB` | Estilos de acceso y panel administrativo. |
| `dist/assets/index-*.css` | `49.12 kB` | `9.19 kB` | Estilos base Tailwind CSS v4. |
| `dist/assets/RutasAcceso-*.js` | `238.04 kB` | `71.99 kB` | Módulo de autenticación y administración separado por ruta. |
| `dist/assets/index-*.js` | `328.17 kB` | `101.72 kB` | Núcleo React 19, enrutador y landing principal. |
| `dist/assets/MapaBuses3D-*.js` | `554.84 kB` | `139.16 kB` | Cargado de forma diferida (`React.lazy` en `MapaPublico.tsx`); supera los `500 kB` por incluir `three`. |

### 1.2. Verificación en vivo de rutas SPA, responsividad y accesibilidad (`https://www.go-tacna.site`)

| Ruta evaluada en producción | Estado HTTP | Latencia medida | Criterio verificado (`PRB-043`) |
|---|---|---|---|
| `/` (Landing pública e inicio) | `HTTP 200` | `1045 ms` (1.ª carga TLS) | Renderiza navegación, hero, mapa de unidades y catálogo de rutas públicas (`RF-04`, `RF-05`). |
| `/mapa` (Visor público 3D) | `HTTP 200` | `210 ms` | Carga diferida (`Suspense`) de `MapaBuses3D`, diseño adaptable (`min-h-[60svh]`, `lg:grid-cols-[minmax(0,1fr)_320px]`) y atributos ARIA (`aria-label`, `role="status"`). |
| `/login` y `/registro` | `HTTP 200` | `206 ms` / `206 ms` | Formularios de inicio de sesión y alta de pasajero conectados a `/api/v1/auth/*` (`RF-01`, `RF-02`). |
| `/admin`, `/admin/empresas`, `/admin/rutas`, `/admin/micros`, `/admin/conductores` | `HTTP 200` | `205 ms` a `212 ms` | Enrutamiento SPA de Nginx (`try_files`) operativo sin errores `404` al recargar subrutas administrativas (`RF-15`, `RF-16`). |

---

## 2. Consolidado general de resultados de pruebas (`T106`)

A la fecha de corte, el aseguramiento de calidad registra **94 pruebas automatizadas de código en verde**, **25 casos de usabilidad evaluados sobre prototipo** y **27 comprobaciones HTTP/RBAC/SPA ejecutadas contra el servidor de producción**:

| Fase del Plan de Pruebas | Tareas cubiertas | Evidencia documental en `pruebas/` | Cobertura alcanzada | Estado de la fase |
|---|---|---|---|---|
| **Planificación y trazabilidad QA** | `T069` | [plan-de-pruebas.md](../plan-de-pruebas.md), [matriz-de-trazabilidad.md](../matriz-de-trazabilidad.md) | `RF-01` a `RF-20`, `RNF-01` a `RNF-07` y `DEC-001` a `DEC-003` vinculados a `PRB-001`..`PRB-045` | **Completada y fusionada en `develop` (`PR #22`)** |
| **Usabilidad en prototipo e interfaz UI** | `T054`, `T095` | [t054-pruebas-usabilidad-figma.md](t054-pruebas-usabilidad-figma.md), [t095-hallazgos-usabilidad.md](t095-hallazgos-usabilidad.md) | `25` casos (`PRB-001` a `PRB-025`); regla de **3 toques** cumplida en los 6 escenarios de pasajero; `6` hallazgos (`HLZ-001` a `HLZ-006`) documentados | **Completada y fusionada en `develop` (`PR #20`, `PR #23`)** |
| **Pruebas unitarias, API REST y WebSocket** | `T099`, `T070`, `T071` | [t070-t076-ejecucion-pruebas-backend-seguridad.md](t070-t076-ejecucion-pruebas-backend-seguridad.md) y `realtime/test/realtime.test.js` (`go-tacna-backend#4`) | `56` pruebas en Backend Core + `6` en Gateway + `6` en Realtime Node.js (`pass 6, fail 0`) | **Ejecutada (`PR #4` en backend y `PR #25` en docs)** |
| **Integración, carga, seguridad y ramas** | `T072`, `T075`, `T076`, `T077` | [t070-t076-ejecucion-pruebas-backend-seguridad.md](t070-t076-ejecucion-pruebas-backend-seguridad.md) | `18` sondas en vivo (TLS/301, JWT 4 roles, RBAC `401`/`403`/`415`/`422`, ráfaga `10/10` en `989 ms` promedio) + fix de JWT `HLZ-INT-001` aplicado en `auth.js` | **Ejecutada (`PR #4` y `PR #25`)** |
| **Pruebas de plataforma web (`go-tacna-frontend`)** | `T074` | Presente informe (`Sección 1`) | `26` pruebas unitarias (`0 fail`), `eslint` (`0` errores), `vite build` (`1.37 s`) y `9` rutas SPA en producción (`~208 ms`) | **Ejecutada (`PR #25`)** |
| **Pruebas móviles y de campo en Tacna** | `T103`, `T073`, `T104`, `T105` | Planificadas en `PRB-042` a `PRB-045` dentro de [plan-de-pruebas.md](../plan-de-pruebas.md) | Pendiente de subida del código React Native / Expo en el repositorio `go-tacna-movil` | **Bloqueada por dependencia externa (`go-tacna-movil` sin código fuente)** |