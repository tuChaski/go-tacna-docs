# Eventos WebSocket (Socket.IO)

> **Estado:** Pendiente
> **Responsable:** Royfrankly y David Montoya
> **Relacionado:** [openapi.yaml](openapi.yaml), [jwt-claims.md](jwt-claims.md), [../diagramas/fuente/secuencia-gps-eta.puml](../diagramas/fuente/secuencia-gps-eta.puml)

## Qué va aquí

- Eventos del cliente al servidor: route:join, route:leave, eta:request.
- Eventos del servidor al cliente: micro:position, micro:offline, micro:stopped.
- Payload de cada evento, campo por campo, con su tipo.
- Salas: cada pasajero solo recibe los eventos de su ruta (ruta:{rutaId}).
- Qué ocurre si el token expira o si la posición deja de llegar (lastSeen).

## Notas

Los nombres de los eventos y sus payloads no se inventan: se sacan del codigo de `realtime/` y se documentan aqui.

## Contenido

_Pendiente de completar._
