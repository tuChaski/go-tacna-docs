# Guía de contexto: gotacna-backend-core

> **Propósito:** orientar cambios en la API y la lógica central del dominio de Go-Tacna.

## Ubicación y responsabilidad

- Repositorio: `go-tacna-backend`
- Componente: `gotacna-backend-core/`
- Stack actual: Laravel 13.17, PHP 8.3+, `tymon/jwt-auth`, PostgreSQL 16 + PostGIS y SQLite para pruebas.
- Responsabilidad: API REST versionada, autenticación JWT, autorización por roles y alcance por empresa, validación, persistencia y reglas de negocio de usuarios, empresas, rutas, micros, conductores, posiciones, planes y suscripciones.
- No es el proxy de entrada ni el servicio de WebSocket. En local, la entrada pública es el Nginx de infraestructura (`:8001`) y el proxy Laravel `gotacna-api-gateway`; el core escucha en `:8000`.

Este componente concentra las reglas del dominio. Mantén la separación: el gateway reenvía, el Location Service difunde tiempo real y el core decide permisos y persistencia.

## Topología de entrada

```text
Frontend / app móvil
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

El core confía en los proxies (`trustProxies` en `bootstrap/app.php`) para conservar el host y el esquema originales. El gateway envía `X-Forwarded-Host`, `X-Forwarded-Proto`, `X-Forwarded-Port` y `X-Forwarded-For`; el Nginx público los conserva. Gracias a eso, los enlaces de paginación y el `iss` del JWT usan el dominio público y no `backend:8000`.

## Estado implementado

- 9 migraciones de dominio: `usuarios`, `empresas`, `administrador_empresa_perfiles`, `conductor_perfiles`, `rutas`, `micros`, `posiciones_gps`, `planes` y `suscripciones`.
- Se conservan las migraciones base de Laravel (`users`, `cache`, `jobs`). La API **no** usa `users`; la autenticación se resuelve contra `usuarios`.
- Modelos Eloquent, factories, `DatabaseSeeder`, Resources, FormRequests, la regla `GeoJsonLineString` y el middleware `CheckRole`.
- 67 rutas de API registradas; el contrato OpenAPI enumera 76 operaciones porque las rutas `PUT|PATCH` se documentan por separado.
- CRUD administrativo completo de empresas, usuarios, administradores de empresa, conductores, rutas, micros, posiciones GPS, planes y suscripciones.
- Endpoints de conductor para perfil, reporte de posición y finalización de recorrido, más los alias `/tracking/position` y `/tracking/stop`.
- Endpoints de pasajero para listar, contratar, consultar y cancelar sus propias suscripciones.
- Lectura pública de rutas, micros activos y planes, con token opcional para administradores.
- Suite Feature con cobertura de autenticación, catálogo, CRUD, alcance de `admin_empresa`, GeoJSON, tracking y suscripciones.

## Superficie de API

Todas las rutas llevan el prefijo `/api/v1`. El detalle de parámetros, cuerpos y respuestas está en [`contratos/openapi.yaml`](contratos/openapi.yaml).

| Grupo | Prefijo | Acceso |
|---|---|---|
| Autenticación | `/auth/*` | Público en registro/login; JWT en sesión, refresh y logout |
| Catálogo público | `/rutas`, `/micros/activos`, `/planes` | Público con token opcional |
| Empresas | `/empresas` | `admin_general`; `admin_empresa` limitado a sus empresas |
| Usuarios | `/usuarios` | `admin_general` |
| Administradores de empresa | `/administradores-empresa` | Lectura para administradores; escritura para `admin_general` |
| Conductores | `/conductores` | Administradores con alcance por empresa |
| Operación del conductor | `/conductor/*`, `/tracking/*` | `conductor` |
| Posiciones GPS | `/posiciones` | Administradores con alcance por empresa |
| Planes | `/planes` | Lectura pública; escritura para `admin_general` |
| Suscripciones | `/suscripciones` | `admin_general` |
| Mis suscripciones | `/mis-suscripciones` | `pasajero` y `admin_general` (solo las propias) |

### Reglas de autorización

- `admin_general` gestiona todo el sistema.
- `admin_empresa` solo ve y modifica las empresas vinculadas en `administrador_empresa_perfiles`. El alcance se aplica a empresas, rutas, micros, conductores, posiciones y administradores de empresa.
- `conductor` accede a su perfil y a los endpoints de tracking. Debe tener un `conductor_perfiles` y un micro asignado para reportar posiciones.
- `pasajero` accede a sus propias suscripciones. `admin_general` también puede usar `/mis-suscripciones`, pero solo ve sus propios registros; la gestión global está en `/suscripciones`.
- En las rutas de catálogo, un administrador autenticado ve también registros inactivos; sin token solo se devuelven registros activos.
- El backend no autoriza a partir de los claims del JWT: recarga el usuario y el alcance desde la base de datos en cada petición.

## Autenticación

- Login canónico: `POST /api/v1/auth/login` con `correo` y `password`. Se aceptan `email` y `contrasena` como alias de entrada.
- La contraseña se guarda en `password_hash`; el modelo expone esa columna como password de autenticación.
- El token es JWT HS256 con TTL de 60 minutos. `POST /auth/refresh` renueva el token y `POST /auth/logout` lo invalida.
- Claims y ejemplos: [`contratos/jwt-claims.md`](contratos/jwt-claims.md).
- Un usuario inactivo no puede iniciar sesión (`403`). Un token ausente, inválido o expirado devuelve `401`.

## GeoJSON y PostGIS

- `rutas.trazado_ruta` es `geometry(LineString, 4326)` en PostgreSQL, con índice GiST, y JSON en SQLite/otros motores para pruebas.
- La API expone `trazado_ruta` como GeoJSON `LineString`. El orden de cada coordenada es `[longitud, latitud]`.
- `Ruta::guardarTrazado()` abstrae la escritura en PostGIS y SQLite. `RutaRequest` acepta GeoJSON o WKT `LINESTRING` y lo normaliza.
- Las posiciones GPS se guardan en `posiciones_gps` con `latitud`, `longitud`, `velocidad` y `fecha_hora`. La difusión en vivo corresponde al Location Service.

## Paginación y respuestas

- Los listados usan `paginate($request->integer('per_page', 15))`. Los endpoints de micros activos y posiciones usan 50 por defecto.
- La respuesta paginada es `{ data, links, meta, success }`. Los recursos individuales son `{ data, success }` y pueden incluir `message`.
- Los borrados exitosos devuelven `200` con `{ success, message }`.
- Los errores de validación devuelven `422` con `{ success: false, message, errors }`; los conflictos de negocio, `409`.
- Los enlaces de paginación se generan con el host público gracias a los proxies de confianza.

## Persistencia

El detalle de columnas, claves, índices y relaciones está en [`arquitectura/modelo-de-datos.md`](arquitectura/modelo-de-datos.md). Resumen:

- `usuarios`: cuentas y rol (`pasajero`, `conductor`, `admin_general`, `admin_empresa`).
- `empresas`: empresas de transporte.
- `administrador_empresa_perfiles`: vínculo N:M entre `admin_empresa` y empresas, con `cargo`.
- `conductor_perfiles`: perfil laboral del conductor, empresa y estado operativo.
- `rutas`: recorrido de una empresa, con trazado geoespacial y estado activo.
- `micros`: vehículo, empresa, ruta, conductor actual y estado operativo.
- `posiciones_gps`: historial de ubicaciones por micro.
- `planes`: catálogo de planes con costo y estado.
- `suscripciones`: contrato de un pasajero con un plan.

Todas las tablas de dominio tienen `created_at` y `updated_at`. No se usan soft deletes.

## Variables de entorno relevantes

| Variable | Uso |
|---|---|
| `APP_URL` | URL pública usada por Laravel cuando no hay proxy |
| `APP_LOCALE`, `APP_FALLBACK_LOCALE`, `APP_FAKER_LOCALE` | Locale de la API y datos de prueba (`es`, `es_PE`) |
| `DB_CONNECTION`, `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` | Conexión PostgreSQL/PostGIS |
| `JWT_SECRET` | Firma y validación de tokens |
| `CORS_ALLOWED_ORIGINS` | Orígenes permitidos, separados por coma |
| `LOG_CHANNEL` | En contenedores se recomienda `stderr` |

## Comandos de desarrollo

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Pruebas y estilo:

```bash
php artisan test --testsuite=Feature
vendor/bin/pint --dirty --format agent
```

Las pruebas usan SQLite en memoria (`phpunit.xml`) y no requieren PostGIS. Para validar el camino PostgreSQL/PostGIS hay que levantar el Compose de infraestructura y ejecutar `php artisan migrate:fresh --seed` contra la base real.

## Credenciales del seeder (solo desarrollo)

| Rol | Correo | Contraseña |
|---|---|---|
| `admin_general` | `admin@gotacna.pe` | `admin123` |
| `admin_empresa` | `admin.empresa@gotacna.pe` | `empresa123` |
| `conductor` | `conductor1@gotacna.pe` | `conductor123` |
| `conductor` | `conductor2@gotacna.pe` | `conductor123` |
| `pasajero` | `pasajero@gotacna.pe` | `pasajero123` |

No reutilices estas cuentas ni secretos en producción.

## Archivos clave

- `routes/api.php`: contrato real de rutas.
- `app/Http/Controllers/Api/V1/`: controladores, filtros y respuestas.
- `app/Http/Resources/`: forma exacta de las respuestas.
- `app/Http/Requests/`: validación de entrada.
- `app/Models/`: relaciones y reglas de persistencia.
- `database/migrations/2026_*.php`: esquema de dominio.
- `database/seeders/DatabaseSeeder.php`: datos de demostración.
- `tests/Feature/Api/`: pruebas de la API.

## Flujo de trabajo para cambios

1. Lee `routes/api.php`, el controlador, el Resource, el FormRequest y las pruebas del recurso.
2. Si cambia el contrato, actualiza primero [`contratos/openapi.yaml`](contratos/openapi.yaml) y, si aplica, [`contratos/jwt-claims.md`](contratos/jwt-claims.md).
3. Para cambios de esquema, agrega una migración nueva; no edites migraciones ya aplicadas en entornos compartidos.
4. Agrega o actualiza pruebas Feature para el comportamiento y sus modos de fallo.
5. Ejecuta `php artisan test --testsuite=Feature` y `vendor/bin/pint --dirty --format agent`.
6. No guardes `.env`, secretos ni tokens en Git.

## Contratos compartidos

- Contrato REST: [`contratos/openapi.yaml`](contratos/openapi.yaml).
- Claims del token: [`contratos/jwt-claims.md`](contratos/jwt-claims.md).
- Modelo de datos: [`arquitectura/modelo-de-datos.md`](arquitectura/modelo-de-datos.md).
- Eventos de tiempo real: [`contratos/eventos-websocket.md`](contratos/eventos-websocket.md).

No cambies nombres de campos, rutas públicas ni claims de forma aislada: actualiza el contrato y coordina con el frontend, el gateway y el Location Service.
