# Ficha de los 5 repositorios

> **Estado:** En revisión
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [configuracion.md](configuracion.md), [checklist.md](checklist.md), [../INVENTARIO.md](../INVENTARIO.md)

Cada repositorio es independiente: se clona solo, se ejecuta solo y tiene su propio README con el detalle. Acá está el resumen.

| Repo | Rama de trabajo | Raíz en GitHub | Clonar |
|---|---|---|---|
| `go-tacna-docs` | `main` | [tuChaski/go-tacna-docs](https://github.com/tuChaski/go-tacna-docs) | `git clone https://github.com/tuChaski/go-tacna-docs.git` |
| `go-tacna-backend` | `develop` | [tuChaski/go-tacna-backend](https://github.com/tuChaski/go-tacna-backend) | `git clone https://github.com/tuChaski/go-tacna-backend.git` |
| `go-tacna-frontend` | `develop` | [tuChaski/go-tacna-frontend](https://github.com/tuChaski/go-tacna-frontend) | `git clone https://github.com/tuChaski/go-tacna-frontend.git` |
| `go-tacna-movil` | `develop` | [tuChaski/go-tacna-movil](https://github.com/tuChaski/go-tacna-movil) | `git clone https://github.com/tuChaski/go-tacna-movil.git` |
| `go-tacna-infraestructura` | `develop` | [tuChaski/go-tacna-infraestructura](https://github.com/tuChaski/go-tacna-infraestructura) | `git clone https://github.com/tuChaski/go-tacna-infraestructura.git` |

Tablero de tareas: [Proyectos de tuChaski](https://github.com/orgs/tuChaski/projects)

---

## Qué hay dentro de cada uno

### `docs` — Royfrankly y Edison

Documentación e informe. Es la fuente de verdad de los contratos.

| Carpeta | Qué guarda |
|---|---|
| `requisitos/` | Diccionario de datos y documentos de requisitos que se vayan aprobando |
| `contratos/` | `openapi.yaml`, eventos WebSocket y claims del JWT. **Los otros repos los consumen** |
| `arquitectura/` | Modelo del sistema, despliegue de producción, modelo de datos y decisiones |
| `casos-de-uso/`, `diseno/`, `planificacion/`, `pruebas/`, `manuales/` | El resto del contenido del proyecto |
| `diagramas/` | Mermaid en `fuente/`, imágenes en `export/` |
| `informe/` | Carpeta no creada; se organizará cuando inicie la preparación del informe |
| `guias/` | Reglas transversales, hoy solo `git.md` |

Ramas: `main` como base y `develop` para integración y trabajo documental. El repositorio de documentación no tiene despliegue.

### `backend` — Royfrankly y David

API REST y servidor de tiempo real. El detalle del stack está en su README.

| Componente | Qué hace |
|---|---|
| `gotacna-backend-core` (Laravel + PostgreSQL/PostGIS) | Cuentas, empresas, rutas, micros, conductores y posiciones |
| `gotacna-api-gateway` (Laravel) | Recibe `/api/` y reenvía al Backend Core |
| `go-tacna-location-service` (Node.js + Socket.IO) | Recibe el GPS del conductor, guarda las posiciones en memoria y empuja las actualizaciones a los pasajeros |

Stack principal: PHP 8.3, Laravel, PostgreSQL 16 con PostGIS, Node.js 24, Express, Socket.IO, jsonwebtoken.

Consume: [`contratos/openapi.yaml`](../contratos/openapi.yaml), [`contratos/eventos-websocket.md`](../contratos/eventos-websocket.md), [`contratos/jwt-claims.md`](../contratos/jwt-claims.md).

### `frontend` — Alex

Web pública y panel de administración.

| Componente | Qué hace |
|---|---|
| `src/` | Web pública y panel de administración (React + Vite + Tailwind CSS) |
| `public/` | Recursos estáticos |
| `pruebas/` | Pruebas del frontend |

Consume: los mismos contratos que `backend`, más los datos geográficos de la ruta.

### `movil` — Alex y David

App Android con dos modos: **Pasajero** (elige ruta, ve micros en el mapa, consulta el ETA) y **Modo Conductor** (inicia recorrido y envía el GPS).

Stack principal: Expo SDK 57, React Native, Expo Router, MapLibre React Native, socket.io-client, expo-location, expo-task-manager, expo-secure-store.

Consume: los contratos de `docs/` y los certificados HTTPS de `infraestructura`. **El GPS no funciona sobre HTTP**: Android lo bloquea fuera de `localhost`.

### `infraestructura` — Royfrankly

Compose, Nginx interno y manifiestos K3s. El Nginx global y los certificados TLS son compartidos y se administran en el host VPS Contabo, no desde el Compose de go-tacna. Ver [infraestructura de go-tacna](../INFRASTRUCTURE.md).

| Pieza | Qué hace |
|---|---|
| `docker-compose.yml` | Define PostgreSQL/PostGIS, backend, gateway, websocket, frontend y Nginx de Compose |
| `docker/nginx/default.conf` | Nginx interno: enruta `/`, `/api/` y `/socket.io/` dentro de la aplicación |
| `docker/php`, `docker/node`, `docker/frontend` | Imágenes de backend/gateway, websocket y frontend |
| `k8s/` | Manifiestos K3s/Kustomize alternativos; no están aplicados a la app en producción |
| `.env.example` | Variables de desarrollo; los valores reales viven en el `.env` del servidor |

Consume: nada de `docs/`. **Los demás dependen de él** para publicarse.

---

## Estado actual de cada repositorio

| Repo | Estado | Lo que falta |
|---|---|---|
| `docs` | Contenido en progreso | Completar requerimientos, contratos e informe |
| `backend` | API, gateway y websocket migrados a su repositorio | Completar pruebas e integración de Location Service |
| `frontend` | Web y panel en su repositorio; desplegados en producción | Integrar el cliente Socket.IO y completar vistas pendientes |
| `movil` | Repo creado; la app móvil sigue en desarrollo | Completar la migración y las funciones de GPS |
| `infraestructura` | Docker Compose desplegado en el VPS; K3s no aplicado | Configurar CD, respaldo y procedimiento de rollback |

> El despliegue actual usa Docker Compose. La presencia de manifiestos K3s no significa que estén aplicados. Ver [arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md).

---

## Dueños y revisores

| Repositorio | Owner en CODEOWNERS | Revisa además |
|---|---|---|
| `backend` | `royfrankly` `DavidMontoyaHolgado` | Edison cuando toca pruebas |
| `frontend` | `Alex-Huaracha-Bellido` | Royfrankly si toca contratos |
| `movil` | `Alex-Huaracha-Bellido` `DavidMontoyaHolgado` | Royfrankly si toca contratos |
| `infraestructura` | `royfrankly` | Quien va a desplegar |
| `docs` | `royfrankly` `EdCatari` | El resto del equipo |