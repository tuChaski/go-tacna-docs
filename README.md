# go-tacna-docs

Documentación compartida del sistema Go-Tacna: arquitectura, contratos, decisiones, casos de uso, diagramas, diseño, pruebas y material del proyecto final.

## Empieza aquí

- [Contexto del proyecto](CONTEXTO_PROYECTO_GO_TACNA.md): panorama general, infraestructura, repositorios, estado y relaciones entre componentes. Léelo para entender cómo está armado el sistema.
- [Guías por componente](guias/proyectos/README.md): contexto práctico para trabajar con el API Gateway, Backend Core, Location Service, frontend o móvil.
- [Infraestructura del VPS](INFRASTRUCTURE.md): referencia del host, Nginx global y publicación multidominio.
- [Contribuir a la documentación](CONTRIBUTING.md): dónde va cada tema y convenciones para nuevos documentos.

## Guías por componente

| Componente | Guía |
|---|---|
| API Gateway Laravel | [gotacna-api-gateway.md](guias/proyectos/gotacna-api-gateway.md) |
| Backend Core Laravel | [gotacna-backend-core.md](guias/proyectos/gotacna-backend-core.md) |
| Servicio GPS en tiempo real | [go-tacna-location-service.md](guias/proyectos/go-tacna-location-service.md) |
| Plataforma web | [go-tacna-frontend.md](guias/proyectos/go-tacna-frontend.md) |
| Aplicación móvil | [go-tacna-movil.md](guias/proyectos/go-tacna-movil.md) |

No se crea una guía separada para `go-tacna-infraestructura`: sus archivos de Compose, Nginx o Kubernetes deben documentar directamente la configuración que implementan. El contexto general y [INFRASTRUCTURE.md](INFRASTRUCTURE.md) explican el panorama del host.

## Documentación especializada

- [Arquitectura y decisiones](arquitectura/)
- [Casos de uso](casos-de-uso/)
- [Contratos API, WebSocket y JWT](contratos/)
- [Diagramas](diagramas/)
- [Diseño de interfaz](diseno/)
- [Control y configuración general](general/)
- [Manuales](manuales/)
- [Planificación](planificacion/)
- [Pruebas](pruebas/)
- [Glosario](glosario.md)
- [Inventario de documentos](INVENTARIO.md)

## Fuente de verdad

El contexto y las guías por componente orientan al lector, pero no reemplazan el código ni los contratos. Para cambiar un endpoint, evento WebSocket o claim JWT, actualizar primero el documento correspondiente en [`contratos/`](contratos/) y luego implementar el cambio en los repos consumidores.

Las guías deben mantenerse concisas: describen responsabilidad, límites, estado y cómo orientarse en el código; no copian READMEs, contratos ni especificaciones completas. Verifica el código y sus manifiestos antes de asumir que algo está implementado.
