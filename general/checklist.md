# Checklist de puesta en marcha

> **Estado:** Pendiente
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [configuracion.md](configuracion.md), [repos.md](repos.md), [decisiones-pendientes.md](decisiones-pendientes.md), [../guias/git.md](../guias/git.md)

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
- [ ] Dominio real apuntando al VPS Contabo y certificado TLS emitido/renovado desde el host
- [ ] Nginx global del host enruta el dominio al gateway de go-tacna publicado solo en `127.0.0.1:8001`

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

Hoy el código vive dentro de `go-tacna-frontend`.

- [ ] `backend/` (Laravel) → `go-tacna-backend/api/`
- [ ] `realtime/` (Node.js, ya funcional) → `go-tacna-backend/realtime/`
- [ ] `web/` (panel) → `go-tacna-frontend/`
- [ ] `mobile/` (Expo) → `go-tacna-movil/`
- [ ] `docker/` y `deploy/` → `go-tacna-infraestructura/`
- [ ] `docs/` → `go-tacna-docs/` (ver bloque 5)

---

## 5. Documentación

- [ ] Migrar `architecture.md`, `openapi.yaml` y `diagrams/architecture.mmd` desde el monorepo y borrarlos de ahí
- [ ] Revisar y aprobar los borradores de `requisitos/requerimientos-funcionales.md` (RF-01 a RF-20), `requerimientos-no-funcionales.md` (RNF-01 a RNF-07), `reglas-de-negocio.md` (RN-01 a RN-10) y `mvp.md`.
- [ ] Definir umbrales pendientes de GPS, tiempo de respuesta, disponibilidad, ubicación desactualizada, aforo y Premium antes de cerrar los requisitos.
- [ ] Escribir los casos de uso: `CU-01-iniciar-sesion.md` ya existe como formato
- [ ] Revisar que el cronograma de ProjectLibre en `planificacion/Planificacion_ProjectLibre_go-tacna.xml.pod` refleje las tareas y dependencias vigentes.
- [ ] Exportar los diagramas de `diagramas/fuente/` a `diagramas/export/`
- [ ] Escribir los 12 apartados de `informe/capitulo-1/`
- [ ] Completar `pruebas/plan-de-pruebas.md` y `pruebas/matriz-de-trazabilidad.md`

---

## 6. Código que no compila todavía

Detectado en los README de los repos. Cada punto bloquea a alguien.

- [ ] `api/` de Laravel sin `routes/api.php`, sin controladores y sin los paquetes de JWT, Magellan y Swagger
- [ ] Falta el `Dockerfile` de `api/`, así que el servicio `backend` no se puede construir
- [ ] `api/.env.example` sigue con SQLite: cambiar a `pgsql` para usar PostGIS
- [ ] Falta el `Dockerfile` de la web
- [ ] `docker-compose.yml` apunta a `../web-admin`, carpeta que no existe (la real es `web`)
- [ ] La CI busca `web-admin/package-lock.json` y por eso ese job nunca corre
- [ ] La app móvil no tiene `expo-location`, `expo-task-manager`, `expo-secure-store`, MapLibre ni `socket.io-client`
- [ ] `app.json` sin permisos de ubicación ni foreground service
- [ ] Sin `eas.json`: no hay perfiles de build ni firma

---

## 7. Decisiones

Las que faltan están en [decisiones-pendientes.md](decisiones-pendientes.md). Cada una necesita una respuesta escrita, no un acuerdo verbal.

- [ ] Fase y rango de IDs de las 6 fases del cronograma
- [ ] `bus` → `micro` en contratos y código
- [ ] Roles del token: `admin` o `administrador`
- [ ] Si el estado del tiempo real sigue en memoria o se persiste
- [x] Docker Compose independiente por proyecto y Nginx global compartido en el host (decisión documentada en [INFRASTRUCTURE.md](../INFRASTRUCTURE.md))
- [ ] Dominio real y emisión del certificado

---

## 8. Entrega

- [ ] Informe consolidado en `informe/final/` (`.docx` y `.pdf`, v1.0.0)
- [ ] Revisión de la matriz de trazabilidad: cada RF con su prueba
- [ ] README de cada repo con los comandos para ejecutarlo sin clonar los demás
- [ ] Release `v1.0.0` con etiqueta en los repos