# Configuración general del proyecto

> **Estado:** En revisión
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [repos.md](repos.md), [checklist.md](checklist.md), [../guias/git.md](../guias/git.md), [../contratos/](../contratos/), [../arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md)

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
| API Laravel | 8000 | `/api/` | Gateway de go-tacna, solo red Docker |
| Gateway Laravel | 8000 | `/api/` | Nginx interno de Compose, solo red Docker |
| Servidor de tiempo real | 3001 | `/socket.io/` | Nginx interno de Compose, solo red Docker |
| Panel web | 80 | `/` | Nginx interno de Compose, solo red Docker |
| PostgreSQL + PostGIS | 5432 | — | Solo `127.0.0.1:5432` para mantenimiento |
| Nginx de Compose | 80 en el contenedor | — | Publicado solo en `127.0.0.1:8001` del VPS |
| Nginx global del host Contabo | — | 80 y 443 | Único punto de entrada público; TLS y selección por dominio |

El Nginx global del host reenvía el dominio de go-tacna al Nginx de Compose en `127.0.0.1:8001`. Ese Nginx enruta `/api/` al gateway, `/socket.io/` al servicio de tiempo real y `/` al frontend. `/socket.io/` necesita cabeceras de `Upgrade` y un `proxy_read_timeout` adecuado para conexiones de larga duración. K3s está instalado en el VPS, pero su NodePort `30081` no es la modalidad activa. Ver [INFRASTRUCTURE.md](../INFRASTRUCTURE.md) y [despliegue-produccion.md](../arquitectura/despliegue-produccion.md).

---

## 5. Secretos

Nunca se suben. Solo se versiona `.env.example`.

| Secreto | Dónde vive | Nota |
|---|---|---|
| `JWT_SECRET` | Secretos de GitHub y `.env` del servidor | **Idéntico en la API y en el servidor de tiempo real.** Si difieren, el conductor no puede enviar GPS |
| `APP_KEY` | `.env` de Laravel | Obligatoria: el arranque falla sin ella |
| `DB_PASSWORD` | `.env` y secretos de CI | Obligatoria |
| `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`, `DEPLOY_PATH` | Secretos del repositorio | Previstos para un futuro workflow de despliegue; hoy no hay CD automatizado |
| `DOMAIN`, `CERTBOT_EMAIL` | Configuración de despliegue | Dominio y correo para TLS; la emisión/renovación se gestiona en el host Contabo |

> Si un secreto se sube por error, **se rota primero**. Borrar el commit no alcanza (ver la sección 9 de `guias/git.md`).

---

## 6. Variables de entorno por repositorio

| Repo | Variables | Nota |
|---|---|---|
| `backend` | `APP_ENV`, `APP_DEBUG`, `APP_KEY`, `APP_URL`, `DB_*`, `JWT_SECRET`, `PORT`, `CORS_ALLOWED_ORIGINS`, `SEED_DEMO_DATA` | `APP_ENV=production` y `APP_DEBUG=false` en el VPS; `SEED_DEMO_DATA=true` solo para la demo |
| `gateway` | `APP_ENV`, `APP_DEBUG`, `APP_KEY`, `CORE_API_URL`, `CORS_ALLOWED_ORIGINS` | `CORE_API_URL=http://backend:8000` dentro de la red Docker |
| `websocket` | `PORT`, `CORS_ORIGIN` | `CORS_ORIGIN` restringido al dominio público |
| `frontend` | `VITE_API_BASE_URL`, `VITE_WS_URL` | Se compilan dentro del bundle; la web actual no consume Socket.IO |
| `movil` | `EXPO_PUBLIC_API_URL`, `EXPO_PUBLIC_REALTIME_URL` | El prefijo `EXPO_PUBLIC_` las expone al bundle: nunca un secreto ahí |
| `infraestructura` | `APP_*`, `DB_*`, `JWT_SECRET`, `CORS_*`, `VITE_*`, `SEED_DEMO_DATA` | El Nginx de Compose publica `127.0.0.1:8001:80`; `DOMAIN` y `CERTBOT_EMAIL` se configuran en el host, no en Compose |

Detalle y valores por defecto: el README de cada repositorio.

---

## 7. HTTPS

**No es opcional.** Android no permite enviar la ubicación del conductor sobre HTTP fuera de `localhost`, así que el Modo Conductor depende del certificado.

| Paso | Cómo |
|---|---|
| 1 | Configurar el dominio en DNS para que apunte a la IP pública del VPS Contabo |
| 2 | Configurar el `server_name` y el proxy del dominio en el Nginx global del host |
| 3 | Emitir el certificado TLS en el host para el dominio y habilitar el bloque HTTPS |
| 4 | Verificar con `nginx -t` y programar/confirmar la renovación automática del certificado |

El Nginx de Compose se publica solo en una interfaz local (`127.0.0.1:8001`). No ejecutar Certbot ni publicar 80/443 desde el Compose de go-tacna cuando esos puertos pertenecen al Nginx global. Para el ejemplo completo, consultar [INFRASTRUCTURE.md](../INFRASTRUCTURE.md).

Estado actual (23 de octubre de 2026): `https://www.go-tacna.site/` está desplegado con TLS de Let's Encrypt; el certificado cubre `go-tacna.site` y `www.go-tacna.site`; el dominio raíz redirige a `www`. El upstream del Nginx del host es `127.0.0.1:8001`.

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
| Contenido de la documentación | **En progreso**: arquitectura y despliegue actualizados; quedan contratos, pruebas e informe |
| Migración del código a los repos correctos | **Pendiente**: ver [repos.md](repos.md) |
| Dominio y certificado | **Desplegado** (sección 7) |
| Despliegue web en producción | **Desplegado** con Docker Compose en el VPS; sin CD automático |

El detalle accionable está en [checklist.md](checklist.md).