# Guía de contexto: gotacna-api-gateway

> **Propósito:** orientar cambios en la capa de entrada del backend sin mezclarla con la lógica de negocio de Backend Core.

## Ubicación y responsabilidad

- Repositorio: `go-tacna-backend`
- Componente: `gotacna-api-gateway/`
- Stack previsto: Laravel 13 / PHP 8.3+, según la definición actual del proyecto.
- Responsabilidad: ser el punto de entrada de la aplicación y dirigir las solicitudes a los componentes que las atienden. El Nginx global del VPS es otra capa, administrada en el host.

Mantén la diferencia entre el Nginx global del host, este gateway de aplicación y `gotacna-backend-core`. No muevas reglas de negocio, entidades ni persistencia del dominio a esta capa sin una decisión explícita.

## Relación con otros componentes

- Las rutas API deben concordar con [`contratos/openapi.yaml`](../../contratos/openapi.yaml).
- Las conexiones de tiempo real deben conservar el encaminamiento y soporte WebSocket definidos para Location Service; consulta [`contratos/eventos-websocket.md`](../../contratos/eventos-websocket.md).
- En producción, el Nginx global enruta el dominio a un gateway ligado a loopback (puerto `8001` en el diseño documentado). La guía de host está en [INFRASTRUCTURE.md](../../INFRASTRUCTURE.md).

## Antes de implementar

1. Inspecciona `gotacna-api-gateway/README.md`, `composer.json`, `routes/` y la configuración que exista actualmente. Confirma si una responsabilidad se implementa en Laravel, Nginx u otro proxy; no infieras comportamiento solo por el nombre del directorio.
2. Identifica si la solicitud es de proxy/ruteo o si pertenece a las reglas de negocio de Backend Core.
3. Revisa pruebas y scripts disponibles en el componente antes de modificarlo; ejecuta los comandos declarados por su propio `composer.json`.
4. Mantén secretos y `.env` fuera del repositorio.

La topología y el estado del gateway pueden cambiar. Si esta guía contradice el código o la configuración efectiva, verifica la implementación y actualiza la guía en el mismo cambio.
