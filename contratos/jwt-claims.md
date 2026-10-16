# Claims del JWT

> **Estado:** Borrador; implementación y contrato objetivo aún difieren
> **Responsable:** Royfrankly y David Montoya
> **Relacionado:** [eventos-websocket.md](eventos-websocket.md), [openapi.yaml](openapi.yaml)

## Implementación actual en Backend Core

Según `User::getJWTCustomClaims()`, Backend Core agrega los claims personalizados:

| Claim | Origen / descripción |
|---|---|
| `name` | Nombre del usuario |
| `email` | Correo del usuario |
| `role` | Rol asignado: `pasajero`, `conductor` o `admin` |
| `activo` | Estado de la cuenta |

El token incluye además el `sub` estándar requerido por el contrato JWTSubject. La expiración y el algoritmo se controlan por la configuración del paquete JWT; verificar sus valores efectivos en el entorno antes de documentarlos como política garantizada.

## Diferencias pendientes

- El contrato objetivo requiere `micro_id` y `ruta_id` para tokens de conductores, pero no aparecen entre los claims personalizados actuales.
- No asumir que Location Service valida actualmente estos tokens o rechaza con `403` tokens sin esos campos; esa integración todavía debe definirse y probarse.
- No compartir el secreto JWT en documentación o código. La configuración debe inyectarse como secreto separado en cada entorno. Si el servicio en tiempo real valida tokens, definir primero un mecanismo de firma y rotación de claves compartido seguro.

Antes de considerar este contrato vigente, acordar si `micro_id` y `ruta_id` se agregarán al token o se obtendrán mediante una consulta autorizada al Backend Core. Después, alinear las pruebas de autorización y la documentación OpenAPI.
