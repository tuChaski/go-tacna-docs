# Guía de contexto: gotacna-api-gateway

> **Propósito:** orientar cambios en la capa de entrada del backend sin mezclarla con la lógica de negocio de Backend Core.

## Ubicación y responsabilidad

- Repositorio: `go-tacna-backend`
- Componente: `gotacna-api-gateway/`
- Stack actual: Laravel 13.17 / PHP 8.3+, sin paquete JWT y sin base de datos propia.
- Responsabilidad: recibir `/api/*`, reenviar la petición al core, conservar método, ruta, query, cuerpo y cabeceras útiles, y devolver la respuesta del core con CORS.
- No contiene entidades, migraciones, reglas de negocio ni validación de dominio.

## Topología

```text
Cliente
  |
  v
Nginx público (:8001)
  |  /api/
  v
gotacna-api-gateway (Laravel, :8000)
  |  /api/v1/*
  v
gotacna-backend-core (Laravel, :8000)
  |
  v
PostgreSQL 16 + PostGIS
```

En Compose, el servicio se llama `gateway` y el Nginx público se llama `nginx`. En K3s, `gateway.yaml` define el Deployment/Service Laravel y `nginx.yaml` define la entrada pública NodePort `30081`. El Nginx del host en producción es otra capa, fuera de este repositorio.

## Comportamiento del proxy

- `routes/api.php` define un catch-all `Route::any('/{any?}')` bajo el prefijo `api`, por lo que acepta cualquier ruta `/api/*` y cualquier método.
- El destino se construye con `CORE_API_URL` + la ruta original + el query string.
- Se reenvían las cabeceras de entrada excepto las hop-by-hop o específicas del cliente: `Host`, `Content-Length`, `Connection`, `Accept-Encoding`, `Cookie`, `Origin`, `Referer` y `Transfer-Encoding`.
- El gateway agrega o reemplaza:
  - `X-Forwarded-For` con la IP del cliente.
  - `X-Forwarded-Host` con el host público.
  - `X-Forwarded-Port` con el puerto público.
  - `X-Forwarded-Proto` con el esquema público.
  - `X-Gateway: gotacna-api-gateway`.
- Rechaza `multipart/form-data` con `415`; la API usa JSON.
- Si el core no responde, devuelve `502` con `{ success: false, message }`. Si ocurre un error inesperado, devuelve `500`.
- Conserva el status code y las cabeceras del core, excepto `Transfer-Encoding`, `Connection`, `Content-Length`, `Content-Encoding` y cualquier `Access-Control-*`.
- Si el core no envía `Content-Type`, el gateway responde `application/json`.
- El CORS se resuelve en el gateway con `config/cors.php` y `CORS_ALLOWED_ORIGINS`. Las cabeceras CORS del core se descartan para no duplicarlas.

## Confianza en proxies

`bootstrap/app.php` configura `trustProxies(at: '*', headers: X_FORWARDED_FOR | X_FORWARDED_HOST | X_FORWARDED_PORT | X_FORWARDED_PROTO)`. Esto permite que el gateway lea correctamente el host y el esquema que le envía el Nginx público, y que a su vez los reenvíe al core.

En local, el Nginx de infraestructura usa mapas para conservar `X-Forwarded-Host` y `X-Forwarded-Proto` si ya vienen del proxy del host; si no, usa `$http_host` y `$scheme`.

## Configuración

`config/gateway.php`:

| Variable | Por defecto | Uso |
|---|---|---|
| `CORE_API_URL` | `http://127.0.0.1:8000` | URL interna del core; en Compose es `http://backend:8000` |
| `CORE_API_TIMEOUT` | `30` | Timeout de la petición al core, en segundos |
| `CORE_API_VERIFY_TLS` | `true` | Verificación TLS; en local con certificados autofirmados puede desactivarse |

Otras variables relevantes:

| Variable | Uso |
|---|---|
| `APP_URL` | URL pública de la aplicación |
| `GATEWAY_APP_KEY` | `APP_KEY` propia del gateway, distinta de la del core |
| `CORS_ALLOWED_ORIGINS` | Orígenes permitidos, separados por coma |
| `APP_LOCALE`, `APP_FALLBACK_LOCALE` | Locale de la aplicación |

En Compose, el gateway usa SQLite en memoria (`DB_DATABASE=:memory:`), `SESSION_DRIVER=array` y `CACHE_STORE=array`. No migra ni siembra: `APP_ROLE=gateway` hace que `docker/php/entrypoint.sh` solo instale dependencias y arranque el servidor.

## Rutas y healthcheck

- `ANY /api/{any?}`: proxy hacia el core.
- `GET /up`: healthcheck de Laravel.
- El Nginx público expone `GET /healthz` para su propio healthcheck.
- Las rutas de dominio no se declaran en el gateway; el contrato vigente es [`contratos/openapi.yaml`](contratos/openapi.yaml).

## Comandos de desarrollo

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan serve --host=0.0.0.0 --port=8000
```

Pruebas:

```bash
php artisan test
```

Las pruebas `ProxyTest` cubren el reenvío, la conservación de host/esquema, el rechazo de multipart, la respuesta ante errores del core y el CORS.

## Límites y decisiones

- No muevas reglas de negocio, entidades ni persistencia del dominio a esta capa.
- No valides JWT aquí: el core es quien autentica y autoriza.
- No agregues manejo de archivos mientras la API sea JSON; si se necesita carga de archivos, hay que diseñar el flujo (incluido multipart) de forma explícita.
- Mantén el prefijo `/api/v1` en el core y el catch-all `/api/*` en el gateway. Así el frontend sigue entrando por `http://localhost:8001/api/v1`.
- Si cambias la topología, actualiza también `docker/nginx/default.conf`, `docker-compose.yml`, los manifiestos de `k8s/` y este documento.

## Relación con otros componentes

- Contrato REST: [`contratos/openapi.yaml`](contratos/openapi.yaml).
- Claims JWT: [`contratos/jwt-claims.md`](contratos/jwt-claims.md).
- Backend core: [`gotacna-backend-core.md`](gotacna-backend-core.md).
- Infraestructura: [`INFRASTRUCTURE.md`](INFRASTRUCTURE.md) y [`k8s/README.md`](k8s/README.md).
- Tiempo real: [`contratos/eventos-websocket.md`](contratos/eventos-websocket.md).
