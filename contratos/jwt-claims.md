# Claims del JWT

> **Estado:** Pendiente
> **Responsable:** Royfrankly y David Montoya
> **Relacionado:** [eventos-websocket.md](eventos-websocket.md), [openapi.yaml](openapi.yaml)

## Qué va aquí

- El login entrega un token que sirve tanto para la API como para el servidor de tiempo real.
- Claims: role (conductor | pasajero | admin), micro_id, ruta_id, exp.
- El token del conductor debe incluir role, micro_id y ruta_id; el servidor de tiempo real responde 403 si falta alguno.
- Firma HS256 y JWT_SECRET idéntico en la API y en el servidor de tiempo real.
- Ejemplo del payload decodificado.

## Contenido

_Pendiente de completar._
