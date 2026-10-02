# Ficha de los 5 repositorios

> **Estado:** Pendiente
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [configuracion.md](configuracion.md), [checklist.md](checklist.md), [../INVENTARIO.md](../INVENTARIO.md)

Cada repositorio es independiente: se clona solo, se ejecuta solo y tiene su propio README con el detalle. Acá está el resumen.

| Repo | Rama de trabajo | Raíz en GitHub | Clonar |
|---|---|---|---|
| `rutas-en-tiempo-real-docs` | `main` | [tuChaski/rutas-en-tiempo-real-docs](https://github.com/tuChaski/rutas-en-tiempo-real-docs) | `git clone https://github.com/tuChaski/rutas-en-tiempo-real-docs.git` |
| `rutas-en-tiempo-real-backend` | `develop` | [tuChaski/rutas-en-tiempo-real-backend](https://github.com/tuChaski/rutas-en-tiempo-real-backend) | `git clone https://github.com/tuChaski/rutas-en-tiempo-real-backend.git` |
| `rutas-en-tiempo-real-frontend` | `develop` | [tuChaski/rutas-en-tiempo-real-frontend](https://github.com/tuChaski/rutas-en-tiempo-real-frontend) | `git clone https://github.com/tuChaski/rutas-en-tiempo-real-frontend.git` |
| `rutas-en-tiempo-real-movil` | `develop` | [tuChaski/rutas-en-tiempo-real-movil](https://github.com/tuChaski/rutas-en-tiempo-real-movil) | `git clone https://github.com/tuChaski/rutas-en-tiempo-real-movil.git` |
| `rutas-en-tiempo-real-infraestructura` | `develop` | [tuChaski/rutas-en-tiempo-real-infraestructura](https://github.com/tuChaski/rutas-en-tiempo-real-infraestructura) | `git clone https://github.com/tuChaski/rutas-en-tiempo-real-infraestructura.git` |

Tablero de tareas: [Planificación rutas-en-tiempo-real](https://github.com/orgs/tuChaski/projects/1)

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

Todo lo que corre en el servidor: Docker Compose, proxy Nginx, scripts de despliegue y el diseño objetivo con k3s, Kustomize y Traefik.

| Pieza | Qué hace |
|---|---|
| `docker/docker-compose.yml` | Base de todos los servicios en local |
| `docker/docker-compose.prod.yml` | Se sobrepone al base para producción |
| `deploy/nginx/default.conf` | Único punto de entrada: `/api`, `/socket.io` y `/` |
| `deploy/scripts/` | `deploy.sh` y `certbot.sh` |
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