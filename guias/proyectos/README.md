# Guías de los componentes de Go-Tacna

Lee primero el [contexto general del proyecto](../../CONTEXTO_PROYECTO_GO_TACNA.md). Después abre solo la guía del componente en el que vas a trabajar.

| Componente | Repositorio / ruta | Guía |
|---|---|---|
| API Gateway Laravel | `go-tacna-backend/gotacna-api-gateway/` | [gotacna-api-gateway.md](gotacna-api-gateway.md) |
| Backend Core Laravel | `go-tacna-backend/gotacna-backend-core/` | [gotacna-backend-core.md](gotacna-backend-core.md) |
| Servicio GPS en tiempo real | `go-tacna-backend/go-tacna-location-service/` | [go-tacna-location-service.md](go-tacna-location-service.md) |
| Plataforma web | `go-tacna-frontend/` | [go-tacna-frontend.md](go-tacna-frontend.md) |
| Aplicación móvil | `go-tacna-movil/` | [go-tacna-movil.md](go-tacna-movil.md) |

No hay una guía de contexto para `go-tacna-infraestructura`: inspecciona sus archivos de Compose, proxy o Kubernetes directamente. El panorama compartido del VPS está en [INFRASTRUCTURE.md](../../INFRASTRUCTURE.md).

## Cómo usar estas guías

1. Revisa el README y el código del componente antes de cambiarlo; el código actual prevalece sobre descripciones antiguas.
2. Comprueba los manifiestos (`composer.json`, `package.json`, configuración de Expo, etc.) antes de asumir versiones, comandos o dependencias.
3. Sigue los contratos compartidos de [`contratos/`](../../contratos/). No dupliques aquí sus payloads ni el contenido de los READMEs.
4. Mantén explícita la diferencia entre funcionalidad existente, objetivo acordado y trabajo pendiente.
5. No escribas secretos, tokens reales ni credenciales en la guía.
