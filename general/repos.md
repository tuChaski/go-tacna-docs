# Ficha de los 5 repositorios

> **Estado:** Pendiente
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [configuracion.md](configuracion.md), [checklist.md](checklist.md), [../INVENTARIO.md](../INVENTARIO.md)

Cada repositorio es independiente: se clona solo, se ejecuta solo y tiene su propio README con el detalle. Acá está el resumen.

| Repo | Rama de trabajo | Raíz en GitHub | Clonar |
|---|---|---|---|
| `go-tacna-docs` | `main` | [go-tacna/go-tacna-docs](https://github.com/go-tacna/go-tacna-docs) | `git clone https://github.com/go-tacna/go-tacna-docs.git` |
| `go-tacna-backend` | `develop` | [go-tacna/go-tacna-backend](https://github.com/go-tacna/go-tacna-backend) | `git clone https://github.com/go-tacna/go-tacna-backend.git` |
| `go-tacna-frontend` | `develop` | [go-tacna/go-tacna-frontend](https://github.com/go-tacna/go-tacna-frontend) | `git clone https://github.com/go-tacna/go-tacna-frontend.git` |
| `go-tacna-movil` | `develop` | [go-tacna/go-tacna-movil](https://github.com/go-tacna/go-tacna-movil) | `git clone https://github.com/go-tacna/go-tacna-movil.git` |
| `go-tacna-infraestructura` | `develop` | [go-tacna/go-tacna-infraestructura](https://github.com/go-tacna/go-tacna-infraestructura) | `git clone https://github.com/go-tacna/go-tacna-infraestructura.git` |

Tablero de tareas: [Planificación go-tacna](https://github.com/orgs/go-tacna/projects/1)

---

## Qué hay dentro de cada uno

### `docs` — Royfrankly y Edison

Documentación e informe. Es la fuente de verdad de los contratos.

| Carpeta | Qué guarda |
|---|---|
| `requisitos/` | RF, RNF, reglas de negocio y alcance del MVP |
| `contratos/` | `openapi.yaml`, eventos WebSocket y claims del JWT. **Los otros repos los consumen** |
| `arquitectura/` | Modelo del sistema, modelo de datos y decisiones |
| `casos-de-uso/`, `diseno/`, `planificacion/`, `pruebas/`, `manuales/` | El resto del contenido del proyecto |
| `diagramas/` | Mermaid en `fuente/`, imágenes en `export/` |
| `informe/` | Los 12 apartados de `capitulo-1/` y el documento final |
| `guias/` | Reglas transversales, hoy solo `git.md` |

Ramas: solo `main`. No hay `develop` porque no hay staging.

### `backend` — Royfrankly y David

API REST y servidor de tiempo real. El detalle del stack está en su README.

| Componente | Qué hace |
|---|---|
| `api/` (Laravel + PostgreSQL/PostGIS) | Cuentas, empresas, rutas, micros, conductores y posiciones |
| `realtime/` (Node.js + Socket.IO) | Recibe el GPS del conductor, guarda las posiciones en memoria y empuja las actualizaciones a los pasajeros |

Stack principal: PHP 8.3, Laravel, PostgreSQL 16 con PostGIS, Node.js 24, Express, Socket.IO, jsonwebtoken.

Consume: [`contratos/openapi.yaml`](../contratos/openapi.yaml), [`contratos/eventos-websocket.md`](../contratos/eventos-websocket.md), [`contratos/jwt-claims.md`](../contratos/jwt-claims.md).

### `frontend` — Alex

Web pública y panel de administración.

| Componente | Qué hace |
|---|---|
| `web/` | Panel de administración (React + Vite) y web pública |
| `backend/`, `realtime/`, `mobile/`, `docker/`, `deploy/` | Hoy vive el código de los otros repos acá; hay que migrarlo |

Consume: los mismos contratos que `backend`, más los datos geográficos de la ruta.

### `movil` — Alex y David

App Android con dos modos: **Pasajero** (elige ruta, ve micros en el mapa, consulta el ETA) y **Modo Conductor** (inicia recorrido y envía el GPS).

Stack principal: Expo SDK 57, React Native, Expo Router, MapLibre React Native, socket.io-client, expo-location, expo-task-manager, expo-secure-store.

Consume: los contratos de `docs/` y los certificados HTTPS de `infraestructura`. **El GPS no funciona sobre HTTP**: Android lo bloquea fuera de `localhost`.

### `infraestructura` — Royfrankly

Compose, gateway de la aplicación y scripts de despliegue. El Nginx global y los certificados TLS son compartidos y se administran en el host VPS Contabo, no desde el Compose de go-tacna. Ver [infraestructura de go-tacna](../INFRASTRUCTURE.md).

| Pieza | Qué hace |
|---|---|
| `docker/docker-compose.yml` | Base de todos los servicios en local |
| `docker/docker-compose.prod.yml` | Se sobrepone al base para producción |
| `deploy/nginx/default.conf` | Gateway interno: enruta `/api`, `/socket.io` y `/` dentro de la aplicación |
| `deploy/scripts/` | Automatización del despliegue; los certificados del Nginx global se gestionan en el host |
| `.github/workflows/deploy.yml` | Despliegue automático al hacer push a `main` |

Consume: nada de `docs/`. **Los demás dependen de él** para publicarse.

---

## Estado actual de cada repositorio

| Repo | Estado | Lo que falta |
|---|---|---|
| `docs` | Esqueleto completo | Contenido: requerimientos, contratos e informe |
| `backend` | Repo vacío; el código vive en `frontend/` | Migrar `api/` y `realtime/` |
| `frontend` | Repo vacío; el código vive acá dentro | Migrar `web/` y sacar el resto de carpetas |
| `movil` | Repo vacío; la app vive en `frontend/mobile/` | Migrar la app de Expo |
| `infraestructura` | Repo vacío; la infraestructura vive en `frontend/` | Migrar `docker/` y `deploy/` |

> Resumen: **el código todavía no está donde debería.** La migración de cada repo a su destino está en [checklist.md](checklist.md).

---

## Dueños y revisores

| Repositorio | Owner en CODEOWNERS | Revisa además |
|---|---|---|
| `backend` | `royfrankly` `DavidMontoyaHolgado` | Edison cuando toca pruebas |
| `frontend` | `Alex-Huaracha-Bellido` | Royfrankly si toca contratos |
| `movil` | `Alex-Huaracha-Bellido` `DavidMontoyaHolgado` | Royfrankly si toca contratos |
| `infraestructura` | `royfrankly` | Quien va a desplegar |
| `docs` | `royfrankly` `EdCatari` | El resto del equipo |