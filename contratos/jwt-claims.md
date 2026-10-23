# Claims del JWT

> **Estado:** contrato vigente del backend core y del API Gateway Laravel.
> **Implementación:** `tymon/jwt-auth` con guard `api`.
> **Emisor:** `POST /api/v1/auth/login` (a través del gateway público).
> **Uso:** `Authorization: Bearer <token>`.

## Vigencia

| Parámetro | Valor por defecto | Variable |
|---|---|---|
| Algoritmo | HS256 | `JWT_ALGO` |
| Vida del access token | 60 minutos | `JWT_TTL` |
| Ventana de refresh | 20 160 minutos (14 días) | `JWT_REFRESH_TTL` |
| Renovación | `POST /api/v1/auth/refresh` con el token actual | — |
| Cierre de sesión | `POST /api/v1/auth/logout` invalida el token actual | — |

El token se firma y valida con `JWT_SECRET`. El core y cualquier servicio que
valide tokens deben compartir el mismo secreto. No publiques ese valor.

## Claims estándar

| Claim | Tipo | Descripción |
|---|---|---|
| `iss` | string | URL de la petición de login. Detrás del gateway refleja el host y esquema públicos, por ejemplo `https://go-tacna.site/api/v1/auth/login`. |
| `iat` | integer | Fecha de emisión en formato Unix. |
| `nbf` | integer | Inicio de validez en formato Unix. |
| `exp` | integer | Fin de validez en formato Unix. |
| `jti` | string | Identificador único del token. |
| `sub` | string | ID del usuario en `usuarios.id`. Se serializa como texto, no como número. |
| `prv` | string | Hash del proveedor de autenticación de `tymon/jwt-auth`. Es interno; no lo uses para autorizar. |

## Claims de dominio

| Claim | Tipo | Presente en | Descripción |
|---|---|---|---|
| `nombre` | string | Todos | Nombre del usuario. |
| `apellido` | string | Todos | Apellido del usuario. |
| `correo` | string | Todos | Correo canónico del usuario. |
| `rol` | string | Todos | `pasajero`, `conductor`, `admin_general` o `admin_empresa`. |
| `micro_id` | integer \| null | Todos | Micro asignado actualmente al conductor. `null` para pasajeros y administradores, o para un conductor sin micro. |
| `ruta_id` | integer \| null | Todos | Ruta del micro asignado al conductor. `null` si no hay micro o para otros roles. |
| `empresa_ids` | integer[] | Todos | Empresas vinculadas al usuario. Un `admin_empresa` recibe los IDs de sus perfiles; `admin_general` recibe `[]` porque su alcance es global; pasajeros y conductores reciben `[]`. |

## Ejemplos

### Administrador general

```json
{
  "iss": "https://go-tacna.site/api/v1/auth/login",
  "iat": 1792722709,
  "exp": 1792726309,
  "nbf": 1792722709,
  "jti": "yr2JMXdd54nKSk8e",
  "sub": "1",
  "prv": "5870863d4a62d791443faf936fc368031d110c4f",
  "nombre": "Administrador",
  "apellido": "General",
  "correo": "admin@gotacna.pe",
  "rol": "admin_general",
  "micro_id": null,
  "ruta_id": null,
  "empresa_ids": []
}
```

### Administrador de empresa

```json
{
  "sub": "2",
  "nombre": "Administrador",
  "apellido": "Empresa",
  "correo": "admin.empresa@gotacna.pe",
  "rol": "admin_empresa",
  "micro_id": null,
  "ruta_id": null,
  "empresa_ids": [1]
}
```

### Conductor

```json
{
  "sub": "3",
  "nombre": "Juan",
  "apellido": "Pérez",
  "correo": "conductor1@gotacna.pe",
  "rol": "conductor",
  "micro_id": 1,
  "ruta_id": 1,
  "empresa_ids": []
}
```

### Pasajero

```json
{
  "sub": "5",
  "nombre": "María",
  "apellido": "Quispe",
  "correo": "pasajero@gotacna.pe",
  "rol": "pasajero",
  "micro_id": null,
  "ruta_id": null,
  "empresa_ids": []
}
```

Los ejemplos omiten `iss`, `iat`, `exp`, `nbf`, `jti` y `prv` por brevedad;
el token real siempre los incluye.

## Respuesta del login

```json
{
  "success": true,
  "message": "Inicio de sesión correcto.",
  "data": {
    "usuario": {
      "id": 1,
      "dni": "70000001",
      "nombre": "Administrador",
      "apellido": "General",
      "correo": "admin@gotacna.pe",
      "telefono": "999111222",
      "rol": "admin_general",
      "activo": true
    },
    "token": "<jwt>",
    "tipo": "bearer"
  }
}
```

## Autorización

- El backend **no confía en los claims** para decidir permisos. En cada petición
  vuelve a cargar el usuario desde `usuarios` y aplica el rol y el alcance por
  empresa desde la base de datos.
- `admin_general` puede gestionar todos los recursos.
- `admin_empresa` solo ve y modifica empresas, rutas, micros, conductores,
  posiciones y administradores de sus `empresa_ids`.
- `conductor` accede a `/conductor/perfil`, `/conductor/posicion`,
  `/conductor/finalizar` y a las rutas públicas.
- `pasajero` accede a `/mis-suscripciones` y a las rutas públicas.
- Los endpoints públicos de catálogo (`/rutas`, `/micros/activos`, `/micros/{id}`,
  `/planes`, `/planes/{id}`) aceptan token opcional. Con un administrador
  autenticado muestran también registros inactivos y respetan el alcance por
  empresa; sin token, solo datos activos.

## Errores de autenticación

| Código | Cuándo |
|---|---|
| `401` | Token ausente, inválido, expirado o usuario inexistente/inactivo. |
| `403` | El usuario existe y está autenticado, pero su rol o empresa no permite la operación. |
| `422` | Credenciales con formato inválido o campos obligatorios ausentes. |

Formato:

```json
{
  "success": false,
  "message": "No autenticado.",
  "errors": {}
}
```

En producción, el Nginx del host debe enviar `Host`, `X-Forwarded-Host` y
`X-Forwarded-Proto https`. El gateway y el core confían en esos encabezados para
que `iss` y los enlaces de paginación conserven el dominio y el esquema
públicos.
