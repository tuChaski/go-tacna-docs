# Rutas en Tiempo Real — Documentación

Reúne el **informe, los requisitos, los diagramas, los contratos entre componentes y el cronograma** del proyecto.

> **Pregunta que responde el sistema:** "¿Dónde está mi micro y cuánto falta para que llegue?"

> **Antes de escribir cualquier documento**, lee [CONTRIBUTING.md](CONTRIBUTING.md) (guía de escritura), [glosario.md](glosario.md) (términos oficiales) e [INVENTARIO.md](INVENTARIO.md) (mapa de qué hay en cada carpeta). Las reglas de Git están en [guias/git.md](guias/git.md).

---

## ⚠️ Estado actual

**Este repositorio contiene la estructura documental y borradores de requisitos.** La arquitectura y el contrato de API implementados como documentación todavía están en el monorepo `rutas-en-tiempo-real-frontend/docs/`:

| Contenido | Ruta actual | Estado |
|---|---|---|
| Arquitectura | `docs/architecture.md` | borrador, 29 líneas |
| Contrato de la API | `docs/openapi.yaml` | **borrador**: 3 endpoints |
| Diagrama de componentes | `docs/diagrams/architecture.mmd` | esqueleto |
| Requisitos funcionales y no funcionales | `requisitos/` | borradores; falta revisión y completar umbrales |
| Informe final | Google Docs (fuera de este repositorio) | pendiente de elaboración y consolidación |
| Cronograma | — | vive en GitHub Projects, no en Markdown |

---

## 1. Por qué este repositorio es la fuente de verdad

**Regla del equipo: un contrato, un dueño.**

Los contratos —el `openapi.yaml`, los eventos WebSocket, los claims del JWT— **viven aquí**. Si algo cambia, se cambia primero en este repositorio y después se ajusta el código que lo consume.

```
rutas-tiempo-real-docs/          ← el contrato se define AQUÍ
        │
        ├──▶ rutas-tiempo-real-backend/     lo implementa
        ├──▶ rutas-tiempo-real-frontend/    lo consume
        └──▶ rutas-tiempo-real-mobile/      lo consume
```

Así ninguna persona implementa "lo que le pareció" y luego se descubren tres versiones distintas de la misma cosa.

---

## 2. Qué hay en cada carpeta

Este repositorio está dividido en dos tipos de carpeta: las **fuentes**, donde se trabaja el contenido completo, y la **salida** (`informe/`), que resume y enlaza. La estructura oficial y quién responde por cada carpeta están en [CONTRIBUTING.md](CONTRIBUTING.md) §2; el detalle archivo por archivo en [INVENTARIO.md](INVENTARIO.md).

### Raíz

| Archivo | Qué es |
|---|---|
| `README.md` | Índice: qué hay en cada carpeta y por qué la documentación vive aquí |
| `CONTRIBUTING.md` | Guía de escritura: dónde va cada tema, identificadores, redacción, nombres de archivo |
| `glosario.md` | Términos oficiales del proyecto |
| `INVENTARIO.md` | Mapa de todos los archivos y carpetas |
| `general/` | Vista de control: los 5 repos, la configuración general, el checklist y las decisiones abiertas |
| `general/` | Vista de control del proyecto: los 5 repos, la configuración, qué falta y qué decisiones están abiertas |

### Fuentes: aquí se trabaja el contenido

| Carpeta | Qué contiene | Detalle |
|---|---|---|
| `requisitos/` | RF-01 a RF-20, RNF-01 a RNF-07, RN-01 a RN-10 y el alcance del MVP | Alimenta la sección 1.6 |
| `casos-de-uso/` | Diagrama general y una especificación por caso de uso | Alimenta la sección 1.11 |
| `arquitectura/` | Modelo del sistema, modelo de datos y el "por qué" de cada decisión | Alimenta la sección 1.9 |
| `contratos/` | `openapi.yaml`, eventos WebSocket y claims del JWT. **Los demás repos implementan lo que está aquí** | Consumido por backend, web y móvil |
| `diseno/` | Guía de estilos, mapa del sitio, inventario de vistas y enlaces a Figma | Alimenta la sección 1.8 |
| `planificacion/` | Resumen de las seis fases y cronograma detallado en ProjectLibre (`.pod`) | Alimenta la sección 1.7 |
| `pruebas/` | Plan de pruebas, matriz de trazabilidad e informes de pruebas de campo | |
| `manuales/` | Guía del pasajero y manual del administrador | |
| `diagramas/` | `fuente/` con los `.mmd` editables (Mermaid) y `export/` con las imágenes | Alimenta la sección 1.12 |
| `assets/` | Logos, capturas y recursos compartidos | |

### Salida

| Carpeta | Qué contiene |
|---|---|
| `informe/capitulo-1/` | Un archivo por sección de la guía del Trabajo Final (1.1 a 1.12): resumen y enlaces, sin repetir el detalle |
| `informe/final/` | Documento consolidado exportado a `.docx` y `.pdf`, versionado (v1.0.0). Se arma al final |

### Guías y control

| Carpeta | Qué contiene |
|---|---|
| `general/` | Vista de control: ficha de los 5 repos, configuración general, checklist de puesta en marcha y decisiones pendientes. **Empieza por acá si no sabes dónde buscar** |
| `guias/` | Guías transversales del equipo. Hoy solo `git.md`, la fuente de verdad de las reglas de Git |
| `plantillas/` | Moldes para crear documentos (`requerimiento.md`, `caso-de-uso.md`, `decision.md`, `prueba.md`) y `setup-git-rules.sh` |

---

## 3. Herramientas

| Tecnología | Para qué |
|---|---|
| **Markdown** | Formato de toda la documentación |
| **OpenAPI** | Archivo que describe **todos** los endpoints; es la fuente de verdad para web y móvil |
| **Mermaid** | Única sintaxis de diagramas del proyecto: los diagramas se escriben como texto (`.mmd`), se versionan y se pueden revisar en un Pull Request |
| **Figma** | Diseño y prototipos de pantallas |
| **ProjectLibre** | Cronograma Gantt |

Escribir los diagramas **como código** y no como imágenes es deliberado: un `.png` no se puede revisar en un Pull Request, un `.mmd` sí.

---

## 4. Contrato de la API

`docs/openapi.yaml` — OpenAPI 3.1, prefijo `/api/v1`.

**Estado actual: es un borrador.** Solo declara:

| Endpoint | Método | Qué hace |
|---|---|---|
| `/health` | `GET` | Comprueba que la API responde |
| `/routes` | `GET` | Lista las rutas de transporte |
| `/buses/{busId}/location` | `GET` | Última ubicación conocida de un bus |

**Endpoints que faltan por documentar**, según lo que ya usa el código:

| Endpoint | Método | Lo usa |
|---|---|---|
| `/auth/login` | `POST` | web y móvil |
| `/auth/refresh` | `POST` | web y móvil |
| `/empresas`, `/rutas`, `/micros`, `/conductores` | CRUD | panel de administración |
| `/tracking/position` | `POST` | Modo Conductor |
| `/tracking/stop` | `POST` | Modo Conductor |

> `/tracking/*` ya está **implementado** en `realtime/`, pero no aparece en el `openapi.yaml`. Es el contrato más desalineado ahora mismo.

Schemas definidos: `Route` (`id`, `name`, `description`) y `BusLocation` (`bus_id`, `latitude`, `longitude`, `recorded_at`).

> **Ojo con la nomenclatura:** el contrato usa `bus`/`buses`, pero todo el código y la documentación usan **micro** (`micro_id`, `microId`). Hay que decidir un nombre y aplicarlo en todas partes.

---

## 5. Contrato de tiempo real

Todavía **no está escrito**. Debe documentarse aquí:

### Eventos del cliente al servidor

| Evento | Payload | Respuesta |
|---|---|---|
| `route:join` | `rutaId` | `{ units: [...] }` con las unidades de esa ruta |
| `route:leave` | `rutaId` | — |
| `eta:request` | `{ microId, lat, lng }` | `{ microId, meters, seconds, estimated, status, lastSeen }` |

### Eventos del servidor al cliente

| Evento | Payload |
|---|---|
| `micro:position` | `{ microId, rutaId, lat, lng, speed, status, lastSeen }` |
| `micro:offline` | `{ microId, lastSeen }` |
| `micro:stopped` | `{ microId }` |

Los pasajeros se agrupan en **salas** (`ruta:{rutaId}`): cada uno solo recibe posiciones de su ruta.

---

## 6. Contrato del JWT

El login entrega un token que se usa **tanto** contra la API como contra el servidor de tiempo real. El token del conductor **debe** incluir:

```json
{
  "role": "conductor",
  "micro_id": 12,
  "ruta_id": 3,
  "exp": 1767225600
}
```

`realtime/` rechaza el token (`realtime/src/middleware/auth.js:11`) si falta cualquiera de los tres primeros campos, respondiendo `403`. La firma es **HS256** y el `JWT_SECRET` **debe ser idéntico** en `api/` y `realtime/`.

Roles previstos: `conductor`, `pasajero`, `admin`.

---

## 7. Arquitectura

`docs/architecture.md` describe hoy el diseño objetivo, y su propio primer párrafo lo advierte: *"la estructura objetivo del monorepo... los directorios todavía deben incorporarse"*. Cuando este repositorio absorba la documentación, esa nota debe desaparecer.

Los 11 frentes de trabajo del proyecto, con su cronograma completo, están en el tablero de GitHub: [Planificación rutas-en-tiempo-real](https://github.com/orgs/tuChaski/projects/1).

---

## 8. Problemas conocidos

El detalle completo, con responsable y archivo destino, está en [INVENTARIO.md](INVENTARIO.md) §5. Resumen:

1. El `openapi.yaml` no cubre lo que ya existe: `realtime/` tiene `/health`, `/tracking/position` y `/tracking/stop`, y ninguno está en el contrato.
2. Faltan los contratos de WebSocket y de JWT por escrito.
3. No hay informe: no existen los capítulos del informe final, que es una de las entregas del proyecto.
4. Los requisitos funcionales y no funcionales están en borrador en `requisitos/`; falta validar el alcance, acordar umbrales y completar las pruebas asociadas.
5. Conflicto de nomenclatura `bus`/`micro` entre el contrato y el código.
6. El cronograma solo existe como tablero de GitHub, no como documento versionado.
7. Los documentos técnicos siguen en `rutas-en-tiempo-real-frontend/docs/` y hay que migrarlos.

---

## 9. Reglas de trabajo del equipo

1. **Un contrato, un dueño.** Si algo cambia, se cambia primero aquí.
2. **Cada repo funciona solo:** su README explica cómo ejecutarlo sin clonar los demás.
3. **Nunca se suban archivos `.env`.**
4. **Ramas y commits:** las reglas completas están en [guias/git.md](guias/git.md) (`develop` es staging, squash merge, `tipo(alcance): descripción`).
5. **Todo cambio entra por Pull Request** con revisión de otro integrante.
6. **Un solo tablero de tareas** en la organización para todo el equipo.

---

## 10. Equipo

| Integrante | Rol prioritario |
|---|---|
| Royfrankly Navarro | Coordinación general, Backend y DevOps |
| David Montoya | Arquitectura de software y módulo GPS en tiempo real |
| Alex Huaracha | Diseño UI/UX y desarrollo Frontend/Móvil |
| Edison Catari | Calidad (QA), pruebas y automatización |

Todos participan en todas las áreas; el rol prioritario indica quién lidera cada una.

---

## 11. Glosario

Los términos del proyecto (micro, ruta, paradero, pasajero, ETA...) están en [glosario.md](glosario.md) y son obligatorios. Los términos de documentación son:

- **Contrato:** acuerdo escrito sobre cómo se comunican dos componentes. Aquí vive la definición; en el código, solo la implementación.
- **OpenAPI:** formato de archivo que describe todos los endpoints de una API.
- **RF / RNF:** requisito funcional / requisito no funcional.
- **UML:** lenguaje estándar para modelar sistemas con diagramas.
- **Mermaid:** sintaxis para diagramas que se renderizan desde texto.
- **Gantt:** gráfico de barras que representa la duración de cada tarea y sus dependencias.
- **Claim:** dato que viaja dentro del token JWT.

---

## 12. Enlaces

| Repositorio | Propósito |
|---|---|
| `rutas-en-tiempo-real-docs` | Este repositorio. Informe, requisitos, contratos y cronograma. |
| `rutas-en-tiempo-real-backend` | API Laravel y servidor de tiempo real. |
| `rutas-en-tiempo-real-frontend` | Web pública y panel de administración. |
| `rutas-en-tiempo-real-movil` | App Android (Pasajero y Modo Conductor). |
| `rutas-en-tiempo-real-infraestructura` | Docker, k3s, Traefik y despliegue. |

Tablero de tareas: [Planificación rutas-en-tiempo-real](https://github.com/orgs/tuChaski/projects/1)