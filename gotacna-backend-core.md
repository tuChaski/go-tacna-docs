# Guía de contexto: gotacna-backend-core

> **Propósito:** orientar cambios en la API y la lógica central del dominio de Go-Tacna.

## Ubicación y responsabilidad

- Repositorio: `go-tacna-backend`
- Componente: `gotacna-backend-core/`
- Stack previsto: Laravel 13 / PHP 8.3+.
- Responsabilidad: API REST, autenticación JWT, autorización por roles, validación y operaciones de negocio para cuentas, empresas, rutas, micros, conductores y datos relacionados.
- Persistencia prevista: PostgreSQL 16 + PostGIS. La base es un servicio separado; sus secretos y parámetros de conexión vienen del entorno.

Este componente contiene las reglas del dominio y no es el proxy de entrada ni el servicio de WebSocket. Mantén las responsabilidades separadas al agregar rutas o lógica.

## Avances de inicialización

- Se creó la base del proyecto `gotacna-backend-core` con Laravel y PHP 8.3 o superior.
- Se configuró PostgreSQL en Docker con la base `gotacna_db` y se reportó PostGIS habilitado. La migración inicial y las migraciones de dominio se ejecutaron desde el contenedor.
- Se añadieron modelos Eloquent y relaciones, un `DatabaseSeeder` con datos de prueba de Tacna, controladores de autenticación, consulta pública y conductor, y middleware por rol. El esquema completo está en [`arquitectura/modelo-de-datos.md`](arquitectura/modelo-de-datos.md).
- Se implementaron estos endpoints:
  - `GET /api/v1/rutas`, `GET /api/v1/rutas/{id}` y `GET /api/v1/micros/activos`.
  - `POST /api/v1/auth/register`, `POST /api/v1/auth/login`, `GET /api/v1/auth/me`, `POST /api/v1/auth/refresh` y `POST /api/v1/auth/logout`.
  - `GET /api/v1/conductor/perfil` y `POST /api/v1/conductor/posicion`.
- `POST /api/v1/conductor/posicion` valida latitud y longitud requeridas y velocidad opcional, asocia la lectura al micro asignado y la guarda en `posiciones`. El contrato OpenAPI sigue incompleto; ver [`contratos/openapi.yaml`](contratos/openapi.yaml).

El esquema actual guarda `rutas.trazado` como texto y las coordenadas como columnas numéricas; tener la extensión PostGIS activa no significa que las columnas ya sean tipos geométricos PostGIS. La API persiste cada posición en `posiciones`; la integración de difusión en vivo desde Location Service es una tarea separada.

La implementación visible incluye pruebas scaffold de Laravel, pero el resumen de avance no reporta una suite de pruebas funcionales del dominio ejecutada. No presentar los endpoints como cubiertos por pruebas hasta añadirlas y ejecutarlas.

## Contratos compartidos

- Contrato REST: [`contratos/openapi.yaml`](contratos/openapi.yaml).
- Claims del token: [`contratos/jwt-claims.md`](contratos/jwt-claims.md).
- Eventos compartidos con tiempo real: [`contratos/eventos-websocket.md`](contratos/eventos-websocket.md).
- Modelo de datos: [`arquitectura/modelo-de-datos.md`](arquitectura/modelo-de-datos.md).

No cambies nombres de campos, rutas públicas ni claims de forma aislada: actualiza primero el contrato compartido y coordina los clientes y Location Service que lo consumen.

## Flujo de trabajo para cambios

1. Lee el README, `composer.json`, las rutas, modelos, migraciones, servicios y pruebas actuales del componente.
2. Comprueba si el comportamiento ya existe y respeta las convenciones del Laravel instalado.
3. Para cambios de esquema, considera tanto migraciones como compatibilidad de datos existentes.
4. Usa las herramientas y scripts definidos por `composer.json` para instalar, probar y validar; no asumas versiones adicionales.
5. No guardes credenciales, tokens ni archivos `.env` en Git.

Los detalles de implementación y comandos son los del código actual. Esta guía da contexto y no reemplaza el README ni las pruebas.
