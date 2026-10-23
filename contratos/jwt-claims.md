# Claims del JWT

> **Estado:** Aprobado
> **Responsable:** Royfrankly y David Montoya
> **Relacionado:** [eventos-websocket.md](eventos-websocket.md), [openapi.yaml](openapi.yaml)

## 1. Emisión y firma

- `POST /auth/login` entrega un token que sirve tanto para la API REST como para el servidor de tiempo real.
- El token se firma con **HS256** usando `JWT_SECRET`.
- La API y el servidor de tiempo real deben usar el mismo `JWT_SECRET`.
- El token se envía en el header `Authorization: Bearer <token>`.
- Los claims usan `camelCase` para coincidir con los payloads de la API (`microId`, `rutaId`, etc.).

## 2. Claims

| Claim | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `sub` | integer | Sí | ID de `USUARIO` |
| `role` | string | Sí | `pasajero`, `conductor`, `admin_general` o `admin_empresa` |
| `empresaId` | integer \| null | Según rol | Empresa del conductor o del administrador de empresa |
| `conductorPerfilId` | integer \| null | Solo conductor | ID de `CONDUCTOR_PERFIL` |
| `administradorPerfilId` | integer \| null | Solo admin_empresa | ID de `ADMINISTRADOR_EMPRESA_PERFIL` |
| `microId` | integer \| null | Solo conductor en turno | Micro asignado actualmente |
| `rutaId` | integer \| null | Solo conductor en turno | Ruta del micro asignado |
| `suscripcionId` | integer \| null | Opcional pasajero | Suscripción vigente del pasajero |
| `iat` | integer | Sí | Fecha de emisión (Unix segundos) |
| `exp` | integer | Sí | Fecha de expiración (Unix segundos) |
| `jti` | string | Sí | Identificador único del token |

## 3. Claims por rol

### Pasajero

```json
{
  "sub": 21,
  "role": "pasajero",
  "empresaId": null,
  "suscripcionId": 7,
  "iat": 1700000000,
  "exp": 1700003600,
  "jti": "f3b1c9a2-7d4e-4a91-9c1e-2b6a8d5f0c33"
}
```

- `suscripcionId` es opcional y solo debe incluirse si el pasajero tiene una suscripción activa.
- Si el producto exige suscripción para acceder al tracking, el servidor responde `403` cuando no existe una suscripción `activa`.

### Conductor

```json
{
  "sub": 15,
  "role": "conductor",
  "empresaId": 3,
  "conductorPerfilId": 8,
  "microId": 12,
  "rutaId": 4,
  "iat": 1700000000,
  "exp": 1700003600,
  "jti": "8a7f2e41-5c3d-4b6a-9e10-6f2d7c8b1a55"
}
```

- `microId` y `rutaId` representan la asignación vigente al momento de emitir el token.
- El servidor no debe confiar solo en el token: en cada `POST /tracking/position` y `POST /tracking/stop` debe validar que:
  - `conductorPerfilId` corresponde a un `CONDUCTOR_PERFIL` de `empresaId`.
  - `microId` existe, pertenece a `empresaId` y tiene `conductor_actual_id = conductorPerfilId`.
  - `rutaId` coincide con `MICRO.ruta_id`.
- Si la asignación cambió o ya no es válida, responde `403`.

### Administrador de empresa

```json
{
  "sub": 9,
  "role": "admin_empresa",
  "empresaId": 3,
  "administradorPerfilId": 2,
  "iat": 1700000000,
  "exp": 1700003600,
  "jti": "c1d2e3f4-a5b6-4c7d-8e9f-0a1b2c3d4e5f"
}
```

- Todas las consultas y mutaciones quedan limitadas a `empresaId`.
- El servidor no debe aceptar un `empresaId` distinto en el body o query string.

### Administrador general

```json
{
  "sub": 1,
  "role": "admin_general",
  "empresaId": null,
  "iat": 1700000000,
  "exp": 1700003600,
  "jti": "0f1e2d3c-4b5a-4968-8776-5a4b3c2d1e0f"
}
```

- No está asociado a una empresa y puede operar sobre todas.

## 4. Vigencia y renovación

- `exp` es obligatorio. Se recomienda una vigencia de 1 hora para el access token.
- `POST /auth/refresh` renueva el access token a partir de un refresh token vigente.
- El ERD no incluye una tabla para refresh tokens, por lo que la persistencia y rotación del refresh token queda pendiente de definición.
- `POST /auth/logout` cierra la sesión del cliente. Si se implementa revocación, se debe validar el `jti` contra una lista de tokens revocados.

## 5. Validación en el servidor de tiempo real

- El handshake del WebSocket debe validar la firma y `exp` del JWT.
- Los eventos de conductor solo se aceptan si `role=conductor` y la asignación `microId`/`rutaId` sigue vigente.
- Los eventos de pasajero solo se aceptan si el usuario tiene una suscripción activa, cuando el producto lo exija. El servidor debe consultar el estado actual de `SUSCRIPCION`; el claim `suscripcionId` no reemplaza esa validación.
- La ausencia de `role` o `conductorPerfilId` en un token de conductor produce `403`.
- Si faltan `microId` o `rutaId`, el conductor puede usar los endpoints generales, pero no puede emitir tracking hasta tener una asignación vigente.
