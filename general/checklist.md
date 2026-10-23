# Checklist de puesta en marcha

> **Estado:** En revisión
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [configuracion.md](configuracion.md), [repos.md](repos.md), [decisiones-pendientes.md](decisiones-pendientes.md), [../guias/git.md](../guias/git.md), [../arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md)

Qué falta para que el proyecto quede configurado y se pueda trabajar sin bloqueos. Cada casilla se marca cuando está hecha, no cuando se dice que está hecha.

Los bloques están en orden: **primero lo que desbloquea a todos, después lo que solo importa a un área.**

---

## 1. GitHub (bloquea a todo el equipo)

- [ ] Publicar la rama `develop` en los 4 repos de código
- [ ] Hacer el primer commit de `.github/` y `CONTRIBUTING.md` en cada repo con el mensaje `ci: agrega plantilla de PR y validación de título`
- [ ] Abrir un PR de prueba en cada repo para que corra el workflow `pr-title`
- [ ] Configurar la protección de `main` y `develop`: PR obligatorio, 1 aprobación, checks en verde, sin force push
- [ ] Marcar `pr-title` como check obligatorio (después del PR de prueba, no antes)
- [ ] Activar squash y merge commit; desactivar rebase
- [ ] Activar el borrado automático de ramas
- [ ] Poner `develop` como rama por defecto en los 4 repos de código
- [ ] Revisar los `CODEOWNERS` con los nombres reales de GitHub

Comandos de arranque, en cada repo de código:

```bash
git switch main && git switch -c develop && git push -u origin develop
git add .github CONTRIBUTING.md
git commit -m "ci: agrega plantilla de PR y validación de título"
git switch -c ci/reglas-de-git
git push -u origin ci/reglas-de-git
```

Detalle: sección 10 de [../guias/git.md](../guias/git.md).

---

## 2. Secretos y entorno

- [ ] `JWT_SECRET` generado y guardado como secreto en GitHub
- [ ] El mismo `JWT_SECRET` en la API y en el servidor de tiempo real (si difieren, el GPS no funciona)
- [ ] `APP_KEY` de Laravel generada y versionada solo en `.env`
- [ ] `DB_PASSWORD` definida
- [ ] Secretos de despliegue: `DEPLOY_HOST`, `DEPLOY_USER`, `DEPLOY_SSH_KEY`, `DEPLOY_PATH`
- [ ] `.env.example` al día en cada repo, con los mismos nombres de variable
- [x] Dominio real apuntando al VPS Contabo y certificado TLS emitido/renovado desde el host
- [x] Nginx global del host enruta el dominio al Nginx de Compose publicado solo en `127.0.0.1:8001`

Detalle: [configuracion.md](configuracion.md) §5 y §6.

---

## 3. Contratos (bloquea a backend, web y móvil)

- [ ] Decidir `bus` → `micro` en todos los contratos y en el código (ver decisiones pendientes)
- [ ] `contratos/openapi.yaml`: declarar `/auth/login`, `/auth/refresh`, CRUD de empresas, rutas, micros y conductores, `/tracking/position` y `/tracking/stop`
- [ ] `contratos/eventos-websocket.md`: payload de `route:join`, `route:leave`, `eta:request`, `micro:position`, `micro:offline` y `micro:stopped`
- [ ] `contratos/jwt-claims.md`: `role`, `micro_id`, `ruta_id`, `exp`, firma HS256
- [ ] Corregir las referencias viejas al contrato de API en los README de los otros repos, enlazando `go-tacna-docs/contratos/openapi.yaml`
- [ ] Revisar que lo implementado en `realtime/` coincida con el contrato

---

## 4. Migración del código a los repos correctos

El backend, el gateway, el websocket, el frontend y la infraestructura ya se ejecutan desde repositorios independientes en el VPS. La app móvil sigue en desarrollo.

- [x] Backend, gateway y websocket en `go-tacna-backend`
- [x] Web y panel en `go-tacna-frontend`
- [x] Compose, Nginx y manifiestos en `go-tacna-infraestructura`
- [x] Documentación en `go-tacna-docs`
- [ ] Completar la migración y las funciones pendientes de `go-tacna-movil`

Ver el estado desplegado en [../arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md).

---

## 5. Documentación

- [ ] Migrar `architecture.md`, `openapi.yaml` y `diagrams/architecture.mmd` desde el monorepo y borrarlos de ahí
- [ ] Decidir si se creará `requisitos/` o si se mantendrán las reglas y necesidades cubiertas por los casos de uso y el contexto existentes; no revisar borradores que aún no están en el repositorio.
- [ ] Definir umbrales pendientes de GPS, tiempo de respuesta, disponibilidad, ubicación desactualizada, aforo y Premium antes de cerrar los requisitos.
- [ ] Escribir los casos de uso: `CU-01-iniciar-sesion.md` ya existe como formato
- [ ] Revisar que el cronograma de ProjectLibre en `planificacion/Planificacion_ProjectLibre_go-tacna.xml.pod` refleje las tareas y dependencias vigentes.
- [ ] Exportar los diagramas de `diagramas/fuente/` a `diagramas/export/`
- [ ] Escribir los 12 apartados de `informe/capitulo-1/`
- [ ] Completar `pruebas/plan-de-pruebas.md` y `pruebas/matriz-de-trazabilidad.md`

---

## 6. Estado de compilación y despliegue

El backend, el gateway, el websocket y el frontend construyen y se ejecutan con Docker Compose en el VPS. Los pendientes de compilación que tenía esta lista se resolvieron para el despliegue web.

- [x] Backend Laravel con Dockerfile y conexión PostgreSQL/PostGIS
- [x] Gateway con Dockerfile y proxy al Backend Core
- [x] Websocket Node.js con healthcheck
- [x] Frontend con Dockerfile, build de Vite y Nginx interno
- [x] `docker-compose.yml` con rutas de repositorios hermanos y variables de entorno
- [ ] App móvil: completar dependencias, permisos de ubicación, build y pruebas en dispositivo
- [ ] Integrar el cliente Socket.IO en la web para posiciones en vivo

Para revisar el estado real de los contenedores:

```bash
cd /home/reverb/go-tacna/go-tacna-infraestructura
docker compose ps
docker compose logs --tail=100
```

---

## 7. Decisiones

Las que faltan están en [decisiones-pendientes.md](decisiones-pendientes.md). Cada una necesita una respuesta escrita, no un acuerdo verbal.

- [ ] Fase y rango de IDs de las 6 fases del cronograma
- [ ] `bus` → `micro` en contratos y código
- [ ] Roles del token: `admin` o `administrador`
- [ ] Si el estado del tiempo real sigue en memoria o se persiste
- [x] Docker Compose independiente por proyecto y Nginx global compartido en el host (decisión documentada en [INFRASTRUCTURE.md](../INFRASTRUCTURE.md))
- [x] Dominio real y emisión del certificado

---

## 8. Entrega

- [ ] Informe consolidado en `informe/final/` (`.docx` y `.pdf`, v1.0.0)
- [ ] Revisión de la matriz de trazabilidad: cada RF con su prueba
- [ ] README de cada repo con los comandos para ejecutarlo sin clonar los demás
- [ ] Release `v1.0.0` con etiqueta en los repos

---

## 9. Despliegue web en producción (23 de octubre de 2026)

- [x] Docker Engine y Docker Compose instalados y habilitados al arranque
- [x] Repositorios de frontend, backend e infraestructura clonados en `/home/reverb/go-tacna`
- [x] `.env` de producción con dominio, CORS, WebSocket y base de datos, fuera de Git
- [x] `docker-compose.override.yml` con `APP_ENV=production` y `APP_DEBUG=false`
- [x] Stack levantado con `docker compose up -d --build --wait`
- [x] Migraciones y seed ejecutados; volumen `postgres_data` conservado
- [x] Los seis servicios (`postgres`, `backend`, `gateway`, `websocket`, `frontend`, `nginx`) están `healthy`
- [x] Nginx del host con TLS y proxy a `127.0.0.1:8001`
- [x] Redirección `https://go-tacna.site/` → `https://www.go-tacna.site/`
- [x] Landing, mapa, login, panel admin, API y handshake WebSocket verificados
- [ ] Integrar el cliente Socket.IO en el frontend; hoy el mapa usa unidades simuladas
- [ ] Cambiar `SEED_DEMO_DATA=false` y definir limpieza de datos demo para producción real
- [ ] Configurar respaldo automático de PostgreSQL
- [ ] Configurar un pipeline de CD o un procedimiento de despliegue automatizado
- [ ] Definir el procedimiento de rollback de base de datos y probarlo

Detalle: [../arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md).