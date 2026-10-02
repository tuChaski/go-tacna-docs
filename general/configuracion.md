# Configuración general del proyecto

> **Estado:** Pendiente
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [repos.md](repos.md), [checklist.md](checklist.md), [../guias/git.md](../guias/git.md), [../contratos/](../contratos/)

Toda la configuración del proyecto en una sola vista. El detalle de cada variable está en el README del repositorio que la usa.

---

## 1. Repositorios

Cinco repositorios independientes. Ver [repos.md](repos.md) para la ficha de cada uno.

| Repo | Rol | Rama base | Owner |
|---|---|---|---|
| `docs` | Documentación, contratos e informe | `main` | Royfrankly, Edison |
| `backend` | API REST y tiempo real | `develop` | Royfrankly, David |
| `frontend` | Web y panel de administración | `develop` | Alex |
| `movil` | App Android | `develop` | Alex, David |
| `infraestructura` | Docker, proxy y despliegue | `develop` | Royfrankly |

---

## 2. Ramas y Git

Detalle completo en [../guias/git.md](../guias/git.md).

| Regla | Valor |
|---|---|
| Producción | `main` |
| Integración y staging | `develop` (los 4 repos de código) |
| Ramas de trabajo | `feature/T000-nombre`, `fix/T000-nombre`, `hotfix/nombre`, `docs/tema` |
| Merge a `develop` | Squash. El título del PR queda como mensaje del commit |
| Merge a `main` | Merge commit, para conservar el historial del release |
| Aprobaciones | 1, y nunca el propio autor |
| Push directo | Prohibido a `main` y a `develop` |
| Formato | `tipo(alcance): descripción` validado por el workflow `pr-title` |

### Qué se automatiza en cada repo

Estos archivos ya existen en los 5 repos:

| Archivo | Para qué |
|---|---|
| `.github/CODEOWNERS` | Asigna revisores al abrir un PR |
| `.github/pull_request_template.md` | Formulario del PR |
| `.github/workflows/pr-title.yml` | Bloquea el PR si el título no cumple el formato |

### Qué se configura en GitHub (no se guarda en archivos)

| Ajuste | Valor | Dónde |
|---|---|---|
| Rama por defecto | `develop` (código), `main` (docs) | Settings → General |
| Protección de ramas | PR obligatorio, 1 aprobación, checks, sin force push | Settings → Branches |
| Tipos de merge | Squash y merge commit; rebase desactivado | Settings → General |
| Borrado de ramas | Activado | Settings → General |
| Secrets | `JWT_SECRET`, `APP_KEY`, `DB_PASSWORD`, `DEPLOY_*` | Settings → Secrets and variables |

---

## 3. Contratos entre repos

Un contrato, un dueño: se define en `docs/` y se implementa en los demás.

| Contrato | Dónde se define | Quién lo implementa |
|---|---|---|
| API REST (OpenAPI 3.1, prefijo `/api/v1`) | `docs/contratos/openapi.yaml` | `backend` |
| Eventos WebSocket (Socket.IO) | `docs/contratos/eventos-websocket.md` | `backend` |
| Claims del JWT (`role`, `micro_id`, `ruta_id`, `exp`) | `docs/contratos/jwt-claims.md` | `backend` |
| Rutas del proxy (`/api`, `/socket.io`, `/`) | `docs/contratos/` + README de infraestructura | `infraestructura` |
| Formato de la posición del micro | `docs/contratos/openapi.yaml` | `backend`, `movil` |

Orden de un cambio de contrato:

1. PR en `docs` que actualiza `contratos/`.
2. PR en cada repo que lo implemente, citando el PR de `docs`.
3. Si rompe compatibilidad, se marca con `!` y se despliega servidor primero, clientes después.

---

## 4. Puertos y rutas

| Servicio | Puerto interno | Ruta pública | Quién lo publica |
|---|---|---|---|
| API Laravel | 8000 | `/api/` | Nginx |
| Servidor de tiempo real | 3001 | `/socket.io/` | Nginx |
| Panel web | 4173 | `/` | Nginx |
| PostgreSQL + PostGIS | 5432 | — | No se publica: solo red interna |
| Nginx | — | 80 y 443 | Único puerto público |

En Nginx, `/socket.io/` necesita `proxy_read_timeout 3600s` y cabeceras de `Upgrade`: sin eso, las conexiones de los pasajeros se cortan.

---

## 5. Secretos

Nunca se suben. Solo se versiona `.env.example`.

| Secreto | Dónde vive | Nota |
|---|---|---|
| `JWT_SECRET` | Secretos de GitHub y `.env` del servidor | **Idéntico en la API y en el servidor de tiempo real.** Si difieren, el conductor no puede enviar GPS |
| `APP_KEY` | `.env` de Laravel | Obligatoria: el arranque falla sin ella |
| `DB_PASSWORD` | `.env` y secretos de CI | Obligatoria |
| `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`, `DEPLOY_PATH` | Secretos del repositorio | Los usa el workflow de despliegue |
| `DOMAIN`, `CERTBOT_EMAIL` | `.env` | Necesarios para el certificado HTTPS |

> Si un secreto se sube por error, **se rota primero**. Borrar el commit no alcanza (ver la sección 9 de `guias/git.md`).

---

## 6. Variables de entorno por repositorio

| Repo | Variables | Nota |
|---|---|---|
| `backend` | `APP_KEY`, `DB_*`, `JWT_SECRET`, `PORT`, `CORS_ORIGIN`, `OFFLINE_AFTER_MS` | `OFFLINE_AFTER_MS` marca el micro sin conexión tras ese tiempo sin señal |
| `frontend` | `VITE_API_URL`, `VITE_REALTIME_URL` | Se compilan dentro del bundle |
| `movil` | `EXPO_PUBLIC_API_URL`, `EXPO_PUBLIC_REALTIME_URL` | El prefijo `EXPO_PUBLIC_` las expone al bundle: nunca un secreto ahí |
| `infraestructura` | `APP_*`, `DB_*`, `JWT_SECRET`, `HTTP_PORT`, `HTTPS_PORT`, `DOMAIN`, `CERTBOT_EMAIL` | Un solo `.env` alimenta todos los servicios |

Detalle y valores por defecto: el README de cada repositorio.

---

## 7. HTTPS

**No es opcional.** Android no permite enviar la ubicación del conductor sobre HTTP fuera de `localhost`, así que el Modo Conductor depende del certificado.

| Paso | Cómo |
|---|---|
| 1 | Configurar `DOMAIN` y `CERTBOT_EMAIL` en el `.env` |
| 2 | Apuntar el DNS al servidor y dejar libre el puerto 80 |
| 3 | `./deploy/scripts/certbot.sh` |
| 4 | Programar la renovación: `certbot renew` desde cron |

En el celular físico, `localhost` es el propio teléfono: hay que usar la IP de la computadora en la red local.

---

## 8. Convenciones de contenido

| Convención | Regla | Detalle |
|---|---|---|
| Nombre del vehículo | **micro** | [../glosario.md](../glosario.md) |
| Diagramas | Mermaid `.mmd` | `diagramas/fuente/` y `export/` |
| Requerimientos | RF-01 a RF-20, RNF-01 a RNF-07 | No se renumera ni se reutiliza un ID |
| Tareas | ID `T000` en la rama y en el pie del commit | [../planificacion/](../planificacion/) |
| Identidad | Un solo dueño por carpeta | [../CONTRIBUTING.md](../CONTRIBUTING.md) §2 |
| Documentación | Una fuente de verdad por tema | El informe resume y enlaza, no copia |

---

## 9. Qué está configurado y qué falta

| Área | Estado |
|---|---|
| `.github/` en los 5 repos | Listo |
| Ramas `develop` locales | Creadas, **falta publicarlas en GitHub** |
| Protección de ramas en GitHub | **Pendiente** (sección 2) |
| Secretos en GitHub | **Pendiente** (sección 5) |
| Contratos escritos | **Pendiente**: los 3 archivos de `docs/contratos/` están vacíos |
| Contenido de la documentación | **Pendiente**: todo el esqueleto |
| Migración del código a los repos correctos | **Pendiente**: ver [repos.md](repos.md) |
| Dominio y certificado | **Pendiente** (sección 7) |

El detalle accionable está en [checklist.md](checklist.md).