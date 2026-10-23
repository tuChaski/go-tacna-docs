# Guía de contexto: go-tacna-movil

> **Propósito:** orientar cambios en la aplicación móvil para Pasajero, Conductor y, según el alcance implementado, Administrador.

## Ubicación y responsabilidad

- Repositorio objetivo: `go-tacna-movil`.
- Stack previsto: React Native con Expo. Verifica las versiones y configuración nativas en los manifiestos del repositorio.
- Responsabilidad: experiencia móvil, consulta de rutas y posiciones, y modo Conductor para enviar GPS cuando esté implementado.

La obtención de ubicación en segundo plano puede requerir módulos nativos y un development build; confirma la configuración real de Expo y Android antes de asumir que Expo Go es suficiente.

## Integración y seguridad

- API REST: [`contratos/openapi.yaml`](contratos/openapi.yaml).
- Eventos de tiempo real: [`contratos/eventos-websocket.md`](contratos/eventos-websocket.md).
- Claims y sesión: [`contratos/jwt-claims.md`](contratos/jwt-claims.md).
- URLs de servicios en Expo deben usar únicamente variables `EXPO_PUBLIC_*` no secretas. Nunca incluyas JWT secrets, claves privadas ni credenciales en el bundle.
- En producción, usa HTTPS/WSS. Para desarrollo en un teléfono físico, `localhost` se refiere al propio dispositivo, no a la computadora de desarrollo.

## Antes de implementar

1. Lee README, `package.json`, `app.json`/`app.config.*` y perfiles EAS si existen.
2. Revisa la navegación y las pantallas actuales antes de crear rutas nuevas.
3. Para cambios de ubicación, valida permisos, ciclo de vida, ejecución en segundo plano y manejo de denegaciones en Android.
4. Si se cambia un endpoint o evento, actualiza el contrato compartido y coordina el backend.
5. Ejecuta lint, tests, TypeScript y diagnósticos Expo solo si esos scripts/herramientas están configurados en el proyecto.

Esta guía resume el contexto del componente; el código, manifiestos y README actuales definen el comportamiento disponible.
