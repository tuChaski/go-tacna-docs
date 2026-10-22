# Guía de contexto: go-tacna-location-service

> **Propósito:** orientar cambios en la recepción y distribución de ubicación GPS en tiempo real.

## Ubicación y responsabilidad

- Repositorio: `go-tacna-backend`
- Componente: `go-tacna-location-service/`
- Stack previsto: Node.js, Express y Socket.IO.
- Responsabilidad: recibir la posición enviada por el Modo Conductor y distribuir actualizaciones a los clientes conectados. La frecuencia objetivo reportada es cada 3 a 5 segundos.

Este servicio atiende conexiones y eventos en tiempo real; la API Laravel sigue siendo dueña de la lógica REST y los datos de negocio. No des por hecho que las posiciones se persisten en PostgreSQL: confirma la implementación vigente antes de modificar o documentar persistencia.

## Contratos e integración

- Eventos y payloads: [`contratos/eventos-websocket.md`](../../contratos/eventos-websocket.md).
- Autenticación y claims: [`contratos/jwt-claims.md`](../../contratos/jwt-claims.md).
- Esquema REST asociado: [`contratos/openapi.yaml`](../../contratos/openapi.yaml).
- Arquitectura y separación de servicios: [`arquitectura/decisiones/001-node-separado-de-laravel.md`](../../arquitectura/decisiones/001-node-separado-de-laravel.md).

El secreto JWT usado para validar tokens debe coincidir con el de Backend Core, pero solo se configura en variables de entorno; nunca se copia a la documentación ni al código.

## Antes de implementar

1. Lee `README.md`, `package.json` y el `package-lock.json` del servicio para confirmar los scripts y versiones reales.
2. Revisa los handlers, middleware, servicios y pruebas existentes antes de cambiar el flujo de GPS o Socket.IO.
3. Al modificar eventos, coordina clientes web/móvil y actualiza primero el contrato compartido.
4. Ejecuta las pruebas y validaciones declaradas por `package.json`; no sustituyas los scripts existentes por comandos supuestos.

El estado en memoria, el tiempo de desconexión y cualquier persistencia se deben describir según el código y la configuración actuales.
