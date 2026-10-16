# go-tacna-docs

Documentación compartida de Go-Tacna: contexto del sistema, guías por componente, contratos, arquitectura, planificación y estado del proyecto.

## Empieza aquí

- [Contexto del proyecto](CONTEXTO_PROYECTO_GO_TACNA.md): panorama del sistema y estado de los cinco repositorios.
- [CI/CD y despliegues](CI-CD.md): cómo trabajar en local con Docker y cuál es el estado y flujo previsto para producción.
- [Infraestructura del VPS](INFRASTRUCTURE.md): red, Nginx global, puertos y enrutamiento multidominio.

## Guías por componente

| Componente | Guía |
|---|---|
| API Gateway | [gotacna-api-gateway.md](gotacna-api-gateway.md) |
| Backend Core Laravel | [gotacna-backend-core.md](gotacna-backend-core.md) |
| Location Service | [go-tacna-location-service.md](go-tacna-location-service.md) |
| Frontend web | [go-tacna-frontend.md](go-tacna-frontend.md) |
| Aplicación móvil | [go-tacna-movil.md](go-tacna-movil.md) |

## Documentación por tema

- [Arquitectura y modelo de datos](arquitectura/)
- [Casos de uso](casos-de-uso/)
- [Contratos API, WebSocket y JWT](contratos/)
- [Diagramas](diagramas/)
- [Diseño](diseno/)
- [Planificación](planificacion/)
- [Pruebas](pruebas/)
- [Manuales](manuales/)
- [Guía para contribuir](CONTRIBUTING.md)
- [Glosario](glosario.md)
- [Inventario documental](INVENTARIO.md)
- [Reglas de Git](guias/git.md)

El [contexto general](CONTEXTO_PROYECTO_GO_TACNA.md) orienta sobre el sistema; las guías por componente orientan sobre cada aplicación; los contratos y documentos especializados son sus fuentes de detalle. No copies el mismo contenido entre ellos: resume y enlaza.
