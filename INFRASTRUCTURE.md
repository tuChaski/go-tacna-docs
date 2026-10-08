# Infraestructura de go-tacna

## Propósito y estado

go-tacna se aloja en un VPS de **Contabo**. El proyecto se organiza en cinco repositorios independientes:

| Repositorio | Responsabilidad |
|---|---|
| `go-tacna-backend` | API REST y servicios de tiempo real |
| `go-tacna-frontend` | Web pública y panel de administración |
| `go-tacna-infraestructura` | Docker Compose, gateway, automatización y despliegue |
| `go-tacna-docs` | Arquitectura, contratos y documentación |
| `go-tacna-movil` | Aplicación móvil Android |

El diseño de esta página separa el proxy global del servidor de los servicios de cada proyecto. Contabo es el proveedor del VPS; los dominios definitivos, la IP pública y la configuración efectiva del servidor se deben completar al desplegar. Los dominios de los ejemplos son marcadores, no dominios contratados.

El diagrama editable está en [arquitectura/Diagrama-de-infraestructura-multidominio-independiente.mmd](arquitectura/Diagrama-de-infraestructura-multidominio-independiente.mmd).

## Flujo de tráfico

1. El DNS de cada dominio apunta a la IP pública del VPS Contabo.
2. El Nginx global instalado en el sistema operativo recibe el tráfico público en los puertos `80` y `443`. Maneja los certificados TLS del host y el enrutamiento por nombre de dominio.
3. Para el dominio de go-tacna, el Nginx global reenvía la solicitud a `127.0.0.1:8001`, el puerto local publicado por el gateway de go-tacna.
4. El gateway del proyecto enruta las solicitudes web, API y WebSocket a los servicios internos correspondientes.
5. La API, el servicio de tiempo real, la web y la base de datos no necesitan puertos públicos propios. Los servicios privados se comunican por la red Docker de go-tacna.

```text
Internet
  └─ HTTPS :443 / HTTP :80
       └─ Nginx global del VPS Contabo
            └─ 127.0.0.1:8001
                 └─ gateway del proyecto go-tacna
                      ├─ web: /
                      ├─ tiempo real: /socket.io/
                      └─ API: /api/
```

El puerto `8001` es un ejemplo reservado para go-tacna. Cada proyecto adicional debe usar otro puerto local libre (por ejemplo, `8002`) y su propio archivo `server` en el Nginx global.

## 1. Publicación del gateway en Docker Compose

En `go-tacna-infraestructura`, el gateway se enlaza solo a la interfaz local del VPS. No debe publicar directamente `80` ni `443`:

```yaml
services:
  api-gateway:
    image: nginx:alpine
    ports:
      - "127.0.0.1:8001:80"
    networks:
      - go-tacna-net

networks:
  go-tacna-net:
    driver: bridge
```

El puerto `80` del contenedor queda disponible en el puerto `8001` de loopback del host. La API, el servicio de tiempo real, PostgreSQL y los demás servicios de la aplicación deben quedar en la red Docker privada y no publicar sus puertos a Internet. Si hace falta acceder a un servicio para mantenimiento, hacerlo mediante un túnel SSH o una regla de acceso restringida, no con una publicación pública permanente.

## 2. Nginx global del host

Ejemplo de configuración para `/etc/nginx/sites-available/go-tacna.midominio.com` en el VPS. Sustituir el dominio de ejemplo por el dominio configurado en DNS y para el certificado:

```nginx
server {
    listen 80;
    server_name go-tacna.midominio.com;

    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name go-tacna.midominio.com;

    ssl_certificate /etc/letsencrypt/live/go-tacna.midominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/go-tacna.midominio.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
    }
}
```

El bloque HTTP redirige a HTTPS. Nginx debe tener habilitados los módulos/directivas SSL correspondientes y el certificado debe existir antes de activar la configuración TLS. Validar la configuración con `nginx -t` y recargar Nginx después de cada cambio. Gestionar la emisión y renovación de los certificados desde el host, no desde el contenedor de go-tacna.

El gateway de go-tacna sigue siendo responsable del enrutamiento interno de rutas. Debe reenviar `/`, `/api/` y `/socket.io/` a los servicios apropiados y habilitar WebSocket para el servicio de tiempo real. El proxy de `/socket.io/` debe permitir conexiones de larga duración, incluido un `proxy_read_timeout` adecuado.

## 3. Aislamiento entre proyectos

Cada proyecto mantiene su propio repositorio de infraestructura, Compose, red Docker, servicios y ciclo de despliegue. El Nginx global y los puertos públicos `80`/`443` se comparten en el host, pero no las redes ni los contenedores de las aplicaciones.

- **Aislamiento:** detener o recrear los contenedores de otro proyecto no debe detener go-tacna.
- **Despliegue independiente:** los comandos de Compose de un proyecto deben operar solo sobre sus servicios y su red. No ejecutar `down` sobre recursos compartidos ni administrar el Nginx global como si perteneciera a un proyecto.
- **Menor exposición:** solo el Nginx global recibe tráfico público. Los gateways de proyectos se enlazan a `127.0.0.1`; los servicios de aplicación y datos permanecen en redes privadas.
- **Enrutamiento multidominio:** cada dominio tiene su propio `server_name` y apunta a un puerto local asignado a un gateway distinto.

La instalación y administración del Nginx global, sus certificados y la asignación de puertos son responsabilidades del host. Los cambios a Compose y a los servicios propios de go-tacna pertenecen a `go-tacna-infraestructura`.

## Consideraciones operativas

- Abrir en el firewall del VPS solo los puertos requeridos públicamente, normalmente SSH y `80`/`443`.
- Confirmar que cada registro DNS resuelve a la IP pública del VPS y que los dominios están incluidos en sus certificados TLS.
- Mantener secretos y credenciales fuera de Git; usar el almacén de secretos de despliegue y archivos `.env` no versionados.
- No reutilizar puertos locales asignados a otros proyectos.
- Los ejemplos de esta página describen la arquitectura acordada; no afirman que el dominio, el certificado ni todas las aplicaciones ya estén desplegados.
