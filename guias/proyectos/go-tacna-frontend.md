# Guía de contexto: go-tacna-frontend

> **Propósito:** ofrecer a desarrolladores y agentes de IA una referencia práctica sobre el objetivo, la arquitectura, el estado real y los siguientes pasos de la plataforma web Go-Tacna.
> **Estado:** la landing visual está implementada; los módulos de consulta, autenticación y administración todavía requieren integración y validación.

## 1. Objetivo y alcance

Go-Tacna permite consultar rutas del transporte público de Tacna, seguir micros en tiempo real y estimar sus llegadas. La plataforma web contempla una experiencia pública para pasajeros y funciones de gestión para administradores. El conductor transmite su ubicación principalmente desde la aplicación móvil; no asumir que el flujo de conductor web está definido.

La web es un cliente del sistema. El backend es responsable de persistencia, reglas de negocio, autenticación y autorización. El frontend debe consumir contratos confirmados y no inventar endpoints, payloads, claims JWT ni eventos WebSocket.

Para el panorama general, roles y arquitectura entre repositorios, consultar [Contexto del proyecto](../../CONTEXTO_PROYECTO_GO_TACNA.md). Para objetivos por rol, consultar los diagramas en [`casos-de-uso/`](../../casos-de-uso/).

## 2. Stack actual

Las versiones declaradas pueden cambiar; verificar siempre `go-tacna-frontend/package.json` antes de actualizar esta lista.

| Área | Tecnología declarada | Estado |
|---|---|---|
| UI | React 19, React DOM 19, TypeScript 6 | Base de la aplicación |
| Desarrollo y compilación | Vite 8 | Scripts `dev`, `build` y `preview` |
| Estilos | Tailwind CSS 4 con `@tailwindcss/vite` | Plugin configurado en `vite.config.ts`; `src/index.css` importa Tailwind |
| Escena visual | Three.js | Usado por la landing para generar la escena WebGL |
| Iconos | lucide-react | Usado por la interfaz |
| HTTP | Axios | Cliente configurado en `src/services/api.ts` |
| Navegación | React Router DOM | Dependencia instalada; verificar rutas y montaje actuales antes de usarla |
| Mapas | Leaflet y React Leaflet | Dependencias instaladas; módulo funcional aún por implementar/verificar |
| Tiempo real | socket.io-client | Dependencia instalada; integración web aún por implementar/verificar |

No hay evidencia de un sistema de componentes o biblioteca de UI independiente. Reutilizar primero los componentes que existan en `src/` y seguir las decisiones del diseño compartido.

## 3. Estructura existente

Estructura verificada en el repositorio al actualizar esta guía:

```text
go-tacna-frontend/
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
├── tsconfig.app.json
└── src/
	├── App.tsx
	├── App.css
	├── index.css
	├── main.tsx
	├── assets/
	│   ├── hero.png
	│   ├── react.svg
	│   └── vite.svg
	├── context/
	│   └── AuthContext.tsx
	├── hooks/
	│   └── useAuth.ts
	├── services/
	│   ├── api.ts
	│   └── authService.ts
	└── types/
		└── auth.ts
```

Confirma el árbol actual antes de añadir módulos. No presupongas que las carpetas `components/`, `utils/` o las vistas ya existen. `src/hooks/useAuth.ts` existe, pero estaba vacío al revisar esta guía.

## 4. Estado de implementación

### Landing pública

`src/App.tsx` contiene una landing promocional con una escena WebGL creada directamente con Three.js:

- Nube visual de 4,000 partículas, un icosaedro wireframe y dos anillos de radar.
- Animación continua, respuesta al movimiento del puntero y ajuste del renderer al tamaño de ventana.
- Capas visuales de grano y rejilla, cabecera tipo HUD, navegación visual, formulario y bloques descriptivos.
- Iconos de lucide-react y estilos utilitarios de Tailwind.

La escena es decorativa: las partículas no representan ubicaciones reales. El contador de nodos y la latencia que aparecen en pantalla son valores fijos. Las pestañas solo cambian el estado visual; no navegan ni filtran contenido. El formulario muestra una confirmación local y no registra correos en un servicio. No presentar estas piezas como telemetría, suscripción o navegación funcional.

### Autenticación y API

- `src/services/api.ts` crea un cliente Axios, usa `VITE_API_BASE_URL` (con fallback local) y agrega el token Bearer almacenado en `localStorage`.
- El interceptor de respuesta elimina token y usuario ante HTTP 401 y redirige a `/login`, excepto cuando ya está en esa ruta.
- `src/services/authService.ts` contiene llamadas para login, registro, logout y perfil.
- `src/context/AuthContext.tsx` mantiene usuario, token, carga, login y logout.
- `src/types/auth.ts` declara las formas locales de `User`, `AuthResponse` y `LoginCredentials`.

Estos archivos son infraestructura parcial, no una experiencia de autenticación terminada. Antes de conectar formularios, rutas protegidas o roles, confirma la forma real de las respuestas y los endpoints del backend. Revisa también que el proveedor de contexto y el router estén montados en la aplicación actual.

### Mapa y tiempo real

Leaflet, React Leaflet y Socket.IO están declarados como dependencias, pero no se identificó una integración activa en la landing actual. El mapa, las rutas reales, los marcadores GPS y la recepción de eventos siguen pendientes de implementación y contrato confirmado.

## 5. Variables de entorno

Las variables `VITE_*` se incorporan al bundle y son visibles en el navegador. Solo deben contener configuración pública; nunca claves privadas, secretos JWT ni credenciales.

Ejemplo de configuración local:

```dotenv
VITE_API_BASE_URL=http://localhost:8001/api/v1
VITE_WS_URL=http://localhost:8001
```

`VITE_API_BASE_URL` es consumida por `src/services/api.ts`; `VITE_WS_URL` es una variable prevista para tiempo real y no se identificó su consumo en la implementación revisada. Verifica el host, puerto y ruta que expone el gateway para cada entorno. No subir `.env` con valores locales o secretos; mantener ejemplos sin credenciales en `.env.example` si el equipo adopta ese archivo.

## 6. Contratos y diseño

- API REST: [contrato OpenAPI](../../contratos/openapi.yaml).
- Eventos Socket.IO: [contrato de eventos WebSocket](../../contratos/eventos-websocket.md).
- Autenticación: [claims JWT](../../contratos/jwt-claims.md).
- Navegación y pantallas: [`diseno/`](../../diseno/), especialmente [mapa del sitio](../../diseno/mapa-del-sitio.md) e [inventario de vistas](../../diseno/inventario-de-vistas.md).
- Estilo visual: [guía de estilos](../../diseno/guia-de-estilos.md) y [referencia Figma](../../diseno/figma.md).

Al actualizar esta guía, OpenAPI todavía tenía `paths` vacío y los documentos de WebSocket y JWT estaban pendientes. El mapa del sitio, el inventario de vistas y la guía de estilos también estaban pendientes. Trátalos como fuentes incompletas: verifica el código de backend/realtime y coordina la actualización del contrato antes de integrar una función. No extrapoles los requisitos únicamente desde la landing.

## 7. Roadmap sugerido

1. **Base y entorno:** completar configuración reproducible, variables de ejemplo y verificación de los scripts del proyecto.
2. **Autenticación:** validar contratos de login, registro, perfil y logout; definir persistencia y expiración de sesión; integrar formularios, router, estados de carga/error y control de acceso por rol.
3. **Pasajero:** implementar catálogo y selección de rutas, mapa de Tacna con Leaflet, detalle de unidades y ETA. Mostrar estados vacíos, carga, error y pérdida de conexión.
4. **Tiempo real:** integrar Socket.IO según el contrato confirmado, suscripciones por ruta, actualización de marcadores y estados offline; no simular posiciones reales en producción.
5. **Administración:** definir navegación y vistas para empresas, rutas, micros, conductores y supervisión; implementar CRUD de acuerdo con API y permisos confirmados.
6. **Calidad y publicación:** validar accesibilidad, responsive, rendimiento del WebGL, seguridad de configuración y comportamiento de producción antes de afirmar que una función está desplegada.

El orden puede ajustarse al alcance priorizado del MVP y a los casos de uso aprobados. No se debe inferir que la aplicación está desplegada por la existencia de una landing.

## 8. Comandos y verificación

Ejecutar desde `go-tacna-frontend/`:

```bash
npm ci
npm run dev
npm run lint
npm run build
```

Los scripts declarados actualmente son `dev`, `build`, `lint` y `preview`. No hay un script `test` definido en `package.json`; no afirmar que la suite de pruebas pasó si no existe o no se ejecutó.

## 9. Guía para agentes y colaboradores

Antes de modificar código:

1. Lee este documento, `package.json`, el punto de entrada (`src/main.tsx`) y los módulos cercanos a la tarea.
2. Comprueba el estado real de implementación; distingue UI demostrativa, mocks, datos estáticos e integración de producción.
3. Confirma endpoints, payloads, roles y eventos en contratos y código backend/realtime. Si no están definidos, documenta la pregunta pendiente en vez de inventar el comportamiento.
4. Mantén separadas las responsabilidades de UI, servicios API, estado de sesión y lógica de dominio; respeta los patrones existentes.
5. Maneja carga, errores, datos vacíos, expiración de sesión y conexión interrumpida en los flujos que correspondan.
6. No leas, muestres ni publiques secretos del `.env`. Las variables Vite no son secretas una vez compiladas.
7. Ejecuta `npm run lint` y `npm run build` después de cambios que afecten al frontend. Informa qué verificaciones no pudieron ejecutarse.

Confirma también la ubicación del código y el estado de migración: algunos documentos históricos describen el frontend como parte de un monorepo, mientras que este repositorio contiene actualmente el código web independiente.
