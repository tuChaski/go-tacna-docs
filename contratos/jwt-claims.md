# Claims del JWT

> **Estado:** Alineado con Backend Core y el servicio de tiempo real
> **Responsables:** Royfrankly y David Montoya
> **Relacionado:** [eventos-websocket.md](eventos-websocket.md), [openapi.yaml](openapi.yaml)

## Emisión y uso

`POST /api/v1/auth/login` entrega un JWT firmado con el `JWT_SECRET` compartido por Laravel y Node. El cliente lo envía como `Authorization: Bearer <token>`. El servidor Node acepta los claims actuales en `snake_case` y conserva compatibilidad con los nombres anteriores en `camelCase` (`role`, `microId`, `rutaId`).

## Claims actuales de Laravel

| Claim | Tipo | Uso |
| --- | --- | --- |
| `sub` | ID del usuario | Identidad estándar de JWTAuth |
| `rol` | string | `pasajero`, `conductor`, `admin_general` o `admin_empresa` |
| `nombre`, `apellido`, `correo` | string | Datos del usuario |
| `micro_id` | integer o null | Micro asignado al conductor cuando se emite el token |
| `ruta_id` | integer o null | Ruta del micro asignado |
| `empresa_ids` | array de integer | Empresas del `admin_empresa`; vacío para los demás roles |
| `iss`, `iat`, `exp`, `nbf`, `jti` | estándar JWTAuth | Emisor, emisión, expiración, vigencia e identificador del token |

`micro_id` y `ruta_id` pueden quedar desactualizados después de una reasignación. Por ello, Laravel consulta la asignación vigente en la base de datos antes de aceptar `POST /api/v1/tracking/position`. Al reenviar la posición a Node, Laravel genera un JWT con los claims actuales de ese usuario. Node verifica firma, expiración, rol y presencia de `micro_id` y `ruta_id`, y usa estos IDs para la sala de ruta. Node no consulta la base de datos por sí mismo.

El endpoint público del conductor es `/api/v1/tracking/position`; el endpoint `/tracking/position` de Node es interno en la configuración Docker. El pasajero se conecta a Socket.IO sin JWT en el handshake y se une a una sala mediante `route:join`, según [eventos-websocket.md](eventos-websocket.md).

No se emiten actualmente los claims `empresaId`, `conductorPerfilId`, `administradorPerfilId` ni `suscripcionId` de una propuesta anterior. Las comprobaciones de empresa, perfil y suscripción se realizan contra los datos actuales del Backend Core donde corresponda. Cambiar los claims públicos requiere actualizar este contrato, los emisores y los consumidores de JWT juntos.
