# Arquitectura del sistema

> **Estado:** En revisión
> **Responsable:** David Montoya
> **Relacionado:** [despliegue-produccion.md](despliegue-produccion.md), [modelo-de-datos.md](modelo-de-datos.md), [decisiones/](decisiones/), [../INFRASTRUCTURE.md](../INFRASTRUCTURE.md), [../CI-CD.md](../CI-CD.md)

Go-Tacna es una plataforma de consulta de rutas y monitoreo de micros para Tacna. La arquitectura separa la web pública, el panel de administración, el gateway, la API, el servicio de tiempo real y la base de datos. La aplicación está desplegada en un VPS de Contabo con Docker Compose y un Nginx del host como entrada TLS.

## Componentes

| Componente | Tecnología | Responsabilidad |
|---|---|---|
| Web pública y panel | React + Vite + Tailwind CSS | Landing, consulta de rutas, mapa y administración según el rol |
| Nginx de Compose | Nginx 1.27 | Enrutar `/`, `/api/` y `/socket.io/` dentro de la red Docker |
| API Gateway | Laravel | Recibir `/api/` y reenviar al Backend Core |
| Backend Core | Laravel 13 + PHP 8.3 | API REST, JWT, RBAC, rutas, micros y posiciones |
| Location Service | Node.js + Express + Socket.IO | Recibir y difundir posiciones en tiempo real |
| Base de datos | PostgreSQL 16 + PostGIS | Persistencia relacional y geoespacial |
| Nginx del host | Nginx + Let's Encrypt | Terminar TLS, publicar `80`/`443` y proxy a `127.0.0.1:8001` |

## Flujo de tráfico

```text
Navegador
  └─ HTTPS :443 → Nginx del host
       └─ 127.0.0.1:8001 → Nginx de Compose
            ├─ /            → frontend:80
            ├─ /api/        → gateway:8000 → backend:8000 → postgres:5432
            └─ /socket.io/  → websocket:3001
```

El dominio canónico es `https://www.go-tacna.site/`; `https://go-tacna.site/` redirige con `301` a `www`. El certificado TLS cubre ambos nombres. Solo `80` y `443` son públicos; `8001` y `5432` quedan en loopback.

## Diagramas

- [Despliegue de producción](despliegue-produccion.md): documento operativo completo.
- [Vista general del despliegue](despliegue-produccion.mmd).
- [Red Docker y volúmenes](red-docker-produccion.mmd).
- [Flujo de una petición](flujo-peticion-produccion.mmd).
- [Requisitos para la web operativa](requisitos-web-operativa.mmd).
- [Diagrama de infraestructura multidominio](Diagrama-de-infraestructura-multidominio-independiente.mmd).
- [Diagrama de componentes](../diagramas/fuente/arquitectura.mmd).

## Estado del despliegue

La aplicación está operativa con Docker Compose. Los servicios `postgres`, `backend`, `gateway`, `websocket`, `frontend` y `nginx` están saludables. El Nginx del host apunta a `127.0.0.1:8001`.

K3s está instalado y activo en el VPS, pero **no se aplicaron los manifiestos de la aplicación**. El NodePort `30081` no es el upstream actual. Los manifiestos K3s/Kustomize quedan como alternativa no desplegada.

## Limitaciones conocidas

- El servicio websocket está desplegado, pero el frontend actual no tiene cliente Socket.IO; el mapa usa unidades simuladas sobre rutas reales.
- Los datos de demostración se cargan con `SEED_DEMO_DATA=true`. Para producción real debe cambiarse a `false` y decidir si se limpian.
- No hay CD automatizado ni respaldo automático de PostgreSQL.
- Los servicios PHP usan una imagen local `gotacna-php:local`; no hay registro de imágenes con etiquetas inmutables.
- El proyecto Compose conserva el nombre histórico `gotacna-local`.

## Referencias

- [Despliegue de producción](despliegue-produccion.md)
- [Infraestructura del VPS](../INFRASTRUCTURE.md)
- [CI/CD](../CI-CD.md)
- [Modelo de datos](modelo-de-datos.md)
- [Configuración general](../general/configuracion.md)
- [Checklist de puesta en marcha](../general/checklist.md)
