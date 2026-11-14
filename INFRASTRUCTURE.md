# Infraestructura de go-tacna

## Propósito y estado

Go-Tacna se aloja en un VPS de **Contabo** con IP pública `13.140.174.64`. La aplicación está desplegada y verificada desde el **23 de octubre de 2026** en:

- `https://www.go-tacna.site/` — URL canónica.
- `https://go-tacna.site/` — redirige con `301` a `www`.

El despliegue vigente usa **Docker Compose** desde `go-tacna-infraestructura`, con el Nginx del host como terminador TLS y proxy hacia `127.0.0.1:8001`. K3s está instalado y activo en el VPS, pero **no participa** en esta aplicación.

El proyecto se organiza en cinco repositorios independientes:

| Repositorio | Responsabilidad |
|---|---|
| `go-tacna-backend` | API REST, gateway y servicio de tiempo real |
| `go-tacna-frontend` | Web pública y panel de administración |
| `go-tacna-infraestructura` | Docker Compose, Nginx interno y automatización |
| `go-tacna-docs` | Arquitectura, contratos y documentación |
| `go-tacna-movil` | Aplicación móvil Android |

La topología, los requisitos y el procedimiento completo están en [arquitectura/despliegue-produccion.md](arquitectura/despliegue-produccion.md).

## Flujo de tráfico

1. El DNS de `go-tacna.site` apunta a la IP pública del VPS y `www.go-tacna.site` resuelve al mismo destino.
2. El Nginx del host recibe el tráfico público en `80` y `443`, termina TLS y selecciona el dominio por `server_name`.
3. El Nginx del host reenvía el dominio al upstream de Compose en `127.0.0.1:8001`.
4. El Nginx interno de Compose enruta:
   - `/` al contenedor `frontend:80`.
   - `/api/` al contenedor `gateway:8000`.
   - `/socket.io/` al contenedor `websocket:3001`.
5. El gateway reenvía la API al backend en `http://backend:8000`.
6. PostgreSQL, el backend, el gateway y el websocket permanecen en la red Docker privada. No tienen puertos públicos.

```text
Internet
  └─ HTTPS :443 / HTTP :80
       └─ Nginx del host Contabo
            └─ 127.0.0.1:8001
                 └─ nginx de Compose
                      ├─ /            → frontend:80
                      ├─ /api/        → gateway:8000 → backend:8000
                      └─ /socket.io/  → websocket:3001
```

El puerto `8001` y el `5432` están publicados únicamente en `127.0.0.1`. Solo `80` y `443` quedan expuestos a Internet.

## Servicios y puertos

| Servicio | Contenedor | Puerto interno | Publicación en el host | Función |
|---|---|---:|---|---|
| `nginx` | `gotacna-local-nginx-1` | `80` | `127.0.0.1:8001` | Entrada de la aplicación y enrutamiento interno |
| `frontend` | `gotacna-local-frontend-1` | `80` | No publica | SPA React/Vite y panel |
| `gateway` | `gotacna-local-gateway-1` | `8000` | No publica | API Gateway Laravel |
| `backend` | `gotacna-local-backend-1` | `8000` | No publica | API REST Laravel |
| `websocket` | `gotacna-local-websocket-1` | `3001` | No publica | Node.js + Socket.IO |
| `postgres` | `gotacna-local-postgres-1` | `5432` | `127.0.0.1:5432` | PostgreSQL 16 + PostGIS |

Los seis servicios tienen healthcheck y `restart: unless-stopped`. Docker está habilitado al arranque del sistema.

## Publicación con Docker Compose

El Compose de producción es el mismo `go-tacna-infraestructura/docker-compose.yml`, con un `docker-compose.override.yml` local en el servidor que aplica `APP_ENV=production` y `APP_DEBUG=false`.

La publicación del gateway se define así:

```yaml
services:
  nginx:
    ports:
      - "127.0.0.1:8001:80"
    networks:
      - gotacna-net

networks:
  gotacna-net:
    driver: bridge
```

PostgreSQL se publica solo para mantenimiento:

```yaml
ports:
  - "127.0.0.1:5432:5432"
```

No se deben cambiar estos bindings a `0.0.0.0`. La API, el websocket y PostgreSQL no necesitan exposición pública.

### Volúmenes

| Volumen | Uso |
|---|---|
| `postgres_data` | Datos persistentes de PostgreSQL |
| `backend_vendor` | Dependencias PHP del backend |
| `gateway_vendor` | Dependencias PHP del gateway |
| `location_node_modules` | Dependencias Node del websocket |

No ejecutar `docker compose down -v` ni eliminar `postgres_data` si se quieren conservar los datos.

## Nginx del host

La configuración del dominio está en `/etc/nginx/sites-available/www.go-tacna.site` y el sitio habilitado en `/etc/nginx/sites-enabled/`. El upstream vigente es:

```nginx
location / {
    proxy_pass http://127.0.0.1:8001;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "Upgrade";
}
```

El certificado está en `/etc/letsencrypt/live/www.go-tacna.site/` y su SAN incluye `go-tacna.site` y `www.go-tacna.site`. La emisión y renovación se gestionan en el host con Certbot, no dentro del Compose.

### Redirección del dominio raíz

El bloque `server_name go-tacna.site` de `/etc/nginx/sites-available/default` responde con:

```nginx
location / {
    return 301 https://www.go-tacna.site$request_uri;
}
```

Antes de modificar la configuración se creó el respaldo `/etc/nginx/sites-available/default.bak.20261023130649`. Después de cualquier cambio:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## K3s: estado y relación con Compose

K3s está instalado y activo en el VPS, pero no se aplicaron los manifiestos de Go-Tacna para esta aplicación. Los manifiestos K3s/Kustomize del repositorio de infraestructura siguen siendo una **alternativa no desplegada**; definen un NodePort `30081`.

| Modalidad | Upstream | Estado |
|---|---|---|
| Docker Compose | `127.0.0.1:8001` | **Activo y verificado** |
| K3s | `127.0.0.1:30081` | Manifiestos presentes; no aplicado a la app |

No cambiar el `proxy_pass` del Nginx del host a `30081` sin desplegar, validar y comprobar el gateway K3s. Un `502 Bad Gateway` ya no describe el estado actual de producción.

## Operación

```bash
cd /home/reverb/go-tacna/go-tacna-infraestructura

docker compose ps
docker compose logs -f --tail=100
docker compose logs -f backend
docker compose exec backend php artisan migrate:status
docker compose exec backend php artisan route:list --path=api/v1
```

Para aplicar una actualización:

```bash
cd /home/reverb/go-tacna
git -C go-tacna-frontend pull --ff-only
git -C go-tacna-backend pull --ff-only
git -C go-tacna-infraestructura pull --ff-only
cd go-tacna-infraestructura
docker compose up -d --build --wait
```

No se configuró un pipeline de CD. El despliegue es manual y debe verificarse con `docker compose ps` y los endpoints públicos antes de darlo por terminado.

## Aislamiento entre proyectos

Cada proyecto mantiene su propio repositorio de infraestructura, Compose, red Docker, servicios y ciclo de despliegue. El Nginx del host y los puertos públicos `80`/`443` se comparten, pero no las redes ni los contenedores de las aplicaciones.

- **Aislamiento:** detener o recrear los contenedores de otro proyecto no debe detener Go-Tacna.
- **Despliegue independiente:** los comandos de Compose de un proyecto deben operar solo sobre sus servicios y su red.
- **Menor exposición:** solo el Nginx del host recibe tráfico público; los gateways de proyectos se enlazan a `127.0.0.1`.
- **Enrutamiento multidominio:** cada dominio tiene su propio `server_name` y apunta a un puerto local asignado a un gateway distinto.

## Consideraciones operativas

- Abrir en el firewall del VPS solo los puertos requeridos públicamente: SSH, `80` y `443`.
- Mantener `go-tacna.site` y `www.go-tacna.site` en el certificado TLS y en el DNS.
- Mantener secretos y credenciales fuera de Git; usar archivos `.env` no versionados con permisos restringidos.
- No reutilizar los puertos locales asignados a otros proyectos.
- Verificar el estado real del host antes de cambiar DNS, Nginx, certificados o puertos.
- El servicio websocket está desplegado, pero el frontend actual no consume Socket.IO; el mapa sigue usando unidades simuladas.

## Referencias

- [Despliegue de producción](arquitectura/despliegue-produccion.md)
- [Diagrama general de despliegue](arquitectura/despliegue-produccion.mmd)
- [Red Docker de producción](arquitectura/red-docker-produccion.mmd)
- [Flujo de una petición](arquitectura/flujo-peticion-produccion.mmd)
- [Requisitos para la web operativa](arquitectura/requisitos-web-operativa.mmd)
- [CI/CD y flujos de trabajo](CI-CD.md)
