# Guía de contexto: gotacna-backend-core

> **Propósito:** orientar cambios en la API y la lógica central del dominio de Go-Tacna.

## Ubicación y responsabilidad

- Repositorio: `go-tacna-backend`
- Componente: `gotacna-backend-core/`
- Stack previsto: Laravel 13 / PHP 8.3+.
- Responsabilidad: API REST, autenticación JWT, autorización por roles, validación y operaciones de negocio para cuentas, empresas, rutas, micros, conductores y datos relacionados.
- Persistencia prevista: PostgreSQL 16 + PostGIS. La base es un servicio separado; sus secretos y parámetros de conexión vienen del entorno.

Este componente contiene las reglas del dominio y no es el proxy de entrada ni el servicio de WebSocket. Mantén las responsabilidades separadas al agregar rutas o lógica.

## Contratos compartidos

- Contrato REST: [`contratos/openapi.yaml`](../../contratos/openapi.yaml).
- Claims del token: [`contratos/jwt-claims.md`](../../contratos/jwt-claims.md).
- Eventos compartidos con tiempo real: [`contratos/eventos-websocket.md`](../../contratos/eventos-websocket.md).
- Modelo conceptual: [`arquitectura/modelo-de-datos.md`](../../arquitectura/modelo-de-datos.md).

No cambies nombres de campos, rutas públicas ni claims de forma aislada: actualiza primero el contrato compartido y coordina los clientes y Location Service que lo consumen.

## Flujo de trabajo para cambios

1. Lee el README, `composer.json`, las rutas, modelos, migraciones, servicios y pruebas actuales del componente.
2. Comprueba si el comportamiento ya existe y respeta las convenciones del Laravel instalado.
3. Para cambios de esquema, considera tanto migraciones como compatibilidad de datos existentes.
4. Usa las herramientas y scripts definidos por `composer.json` para instalar, probar y validar; no asumas versiones adicionales.
5. No guardes credenciales, tokens ni archivos `.env` en Git.

Los detalles de implementación y comandos son los del código actual. Esta guía da contexto y no reemplaza el README ni las pruebas.
