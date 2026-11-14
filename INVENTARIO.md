# Inventario del repositorio de documentación

> **Estado:** En revisión
> **Responsable:** Todo el equipo
> **Relacionado:** [README.md](README.md), [CONTRIBUTING.md](CONTRIBUTING.md), [glosario.md](glosario.md), [guias/git.md](guias/git.md)

Este archivo es el **mapa del repositorio**: dice qué hay en la raíz, qué hay en cada carpeta y para qué sirve cada archivo. Se actualiza en el mismo Pull Request que crea, mueve o elimina un documento.

**Regla:** si un archivo no está en este inventario, no está en el repositorio. Si un archivo del inventario ya no existe, se borra la fila.

Los estados posibles son `Pendiente` (existe el archivo, vacío), `Borrador` (tiene contenido incompleto), `En revisión`, `Aprobado` y `Vigente`.

---

## 1. Raíz del repositorio

| Archivo | Qué es | Responsable | Estado |
|---|---|---|---|
| `README.md` | Índice: qué hay en cada carpeta y por qué la documentación vive aquí | Todo el equipo | Vigente |
| `CONTRIBUTING.md` | Guía de escritura: dónde va cada tema, identificadores, redacción, nombres de archivo y uso de Git | Todo el equipo | Aprobado |
| `glosario.md` | Términos oficiales del proyecto y los sinónimos prohibidos (`bus`, `chofer`, `tiempo exacto`...) | Todo el equipo | Aprobado |
| `INVENTARIO.md` | Este archivo. Mapa de todos los archivos y carpetas | Todo el equipo | En revisión |
| `INFRASTRUCTURE.md` | Host Contabo, proxy global, flujo multidominio y aislamiento de servicios | Royfrankly Navarro | Borrador |
| `CI-CD.md` | Estado de automatización y flujos locales y manuales de producción | Todo el equipo | Borrador |
| `CONTEXTO_PROYECTO_GO_TACNA.md` | Contexto general, stack, repositorios, diagrama Mermaid y estado del proyecto | Todo el equipo | Borrador |
| `gotacna-api-gateway.md` | Contexto y referencias del API Gateway | Todo el equipo | Borrador |
| `gotacna-backend-core.md` | Contexto y estado de Backend Core Laravel | Todo el equipo | Borrador |
| `go-tacna-location-service.md` | Contexto e integración del servicio GPS Node.js | Todo el equipo | Borrador |
| `go-tacna-frontend.md` | Contexto e integración de la plataforma web | Todo el equipo | Borrador |
| `go-tacna-movil.md` | Contexto e integración de la aplicación móvil | Todo el equipo | Borrador |
| `guias/git.md` | **Fuente de verdad de las reglas de Git** de los 5 repos: ramas, commits, PR, releases, GitHub | Royfrankly Navarro | Borrador |
| `general/` | Vista de control del proyecto: repos, configuración, checklist y decisiones abiertas | Royfrankly Navarro | Esqueleto |
| `.github/` | CODEOWNERS, plantilla de PR y validación del título | Royfrankly Navarro | Activa |

---

## 2. Carpetas

| Carpeta | Tipo | Qué contiene | Responsable | Estado |
|---|---|---|---|---|
| `general/` | Control | Vista de arriba del proyecto: repos, configuración, checklist y decisiones abiertas | Royfrankly Navarro | Esqueleto |
| `casos-de-uso/` | Fuente | Diagramas de casos de uso | Todo el equipo | Borrador |
| `arquitectura/` | Fuente | Modelo del sistema, despliegue de producción, modelo de datos y decisiones | David Montoya | Borrador |
| `requisitos/` | Fuente | Diccionario de datos y documentos de requisitos aprobados | Royfrankly | Borrador |
| `contratos/` | Fuente | API, WebSocket y JWT. **Los otros repos implementan lo de aquí** | Royfrankly y David | Esqueleto |
| `diseno/` | Fuente | Estilos, mapa del sitio, inventario de vistas y Figma | Alex Huaracha | Esqueleto |
| `planificacion/` | Fuente | Resumen de seis fases y cronograma detallado en ProjectLibre | Royfrankly | Borrador |
| `pruebas/` | Fuente | Plan de pruebas, trazabilidad e informes de campo | Edison Catari | Borrador |
| `manuales/` | Fuente | Guía del pasajero y manual del administrador | Alex y Royfrankly | Esqueleto |
| `diagramas/` | Fuente | Diagramas como código, en `fuente/` y `export/` | David Montoya | Esqueleto |
| `guias/` | Guía | Guías transversales del equipo | Royfrankly Navarro | Activa |
| `.github/` | Automatización | CODEOWNERS, plantilla de PR y workflow de título | Royfrankly Navarro | Activa |

> `informe/`, `plantillas/` y `assets/` no están creadas en el repositorio. `requisitos/` existe y por ahora contiene únicamente `diccionario-datos.md`; no debe tratarse como una carpeta completa de requisitos.

---

## 3. `general/` — la vista de control

No es el mapa de archivos (eso es este `INVENTARIO.md`): es la vista de arriba del proyecto. Resume y enlaza, no repite.

| Archivo | Qué resuelve | Estado |
|---|---|---|
| `general/README.md` | Índice de la carpeta y tabla "quiero hacer X, mira Y" | Borrador |
| `general/repos.md` | Ficha de los 5 repos: qué contienen, con qué stack, quién lo trabaja, qué consumen de `docs/` y en qué estado están | Borrador |
| `general/configuracion.md` | Vista de repos, ramas, GitHub, contratos, puertos, secretos, variables y HTTPS | Borrador |
| `general/checklist.md` | Lista de trabajo pendiente por bloques | Borrador |
| `general/decisiones-pendientes.md` | Decisiones abiertas con opciones, responsable y a qué desbloquean; y las ya cerradas | Borrador |

---

## 4. Informe del Trabajo Final

La carpeta `informe/` aún no existe. Sus capítulos y entregables no se incluyen como archivos disponibles hasta que se creen.

---

## 5. Carpetas de fuente

### Requisitos

La carpeta `requisitos/` existe, pero solo contiene el diccionario de datos. Los documentos de alcance, requerimientos funcionales, no funcionales y reglas de negocio todavía no están incorporados; no se deben enlazar como si existieran.

| Archivo | Contenido | Estado |
|---|---|---|
| `diccionario-datos.md` | Entidades, campos y relaciones del modelo de datos | Borrador |

### `casos-de-uso/` — Todo el equipo

| Archivo | Contenido | Estado |
|---|---|---|
| `diagrama_casos_uso_autenticacion.puml` | Casos de uso de autenticación | Borrador |
| `diagrama_casos_uso_modulo_administrador.puml` | Casos de uso del administrador | Borrador |
| `diagrama_casos_uso_modulo_conductor.puml` | Casos de uso del conductor | Borrador |
| `diagrama_casos_uso_modulo_pasajero.puml` | Casos de uso del pasajero | Borrador |
| `diagrama_casos_uso_modulo_planificacion_premium.puml` | Casos de uso de planificación premium | Borrador |

### `arquitectura/` — David Montoya

| Archivo | Contenido | Estado |
|---|---|---|
| `arquitectura.md` | Resumen de componentes, flujo de tráfico, estado del despliegue y enlaces a los diagramas | En revisión |
| `despliegue-produccion.md` | Topología real, red Docker, requisitos operativos, despliegue, verificación y limitaciones | En revisión |
| `despliegue-produccion.mmd` | Diagrama Mermaid general del VPS, Nginx, Compose y servicios | Borrador |
| `red-docker-produccion.mmd` | Diagrama Mermaid de la red Compose, puertos publicados y volúmenes | Borrador |
| `flujo-peticion-produccion.mmd` | Secuencia Mermaid de carga de SPA, API y WebSocket | Borrador |
| `requisitos-web-operativa.mmd` | Diagrama Mermaid de requisitos para que la web esté operativa | Borrador |
| `Diagrama-de-Arquitectura.mmd` | Diagrama de arquitectura del sistema | Borrador |
| `Diagrama-de-Contexto.mmd` | Diagrama de contexto | Borrador |
| `Diagrama-de-contenedores.puml` | Diagrama de contenedores | Borrador |
| `Diagrama-de-infraestructura-multidominio-independiente.mmd` | Diagrama Mermaid del VPS Contabo, Nginx global y los proyectos independientes | Borrador |
| `modelo-de-datos.md` | Resumen provisional del esquema implementado; debe revisarse junto con el ERD | Borrador |
| `decisiones/001-node-separado-de-laravel.md` | Por qué el tiempo real es un servicio aparte | Pendiente |
| `decisiones/002-expo-y-maplibre.md` | Por qué Expo y MapLibre | Pendiente |
| `decisiones/003-gps-por-http-post.md` | Por qué la posición llega por HTTP POST | Pendiente |

### `contratos/` — Royfrankly y David

| Archivo | Contenido | Estado |
|---|---|---|
| `openapi.yaml` | Esqueleto OpenAPI 3.1; `paths` está vacío aunque Backend Core ya expone rutas v1 | Borrador |
| `eventos-websocket.md` | Eventos de Socket.io con su payload y el uso de salas (T087) | Pendiente |
| `jwt-claims.md` | Diferencia entre claims JWT implementados y contrato objetivo pendiente de conciliar | Borrador |

### `diseno/` — Alex Huaracha

| Archivo | Contenido | Estado |
|---|---|---|
| `guia-de-estilos.md` | Paleta, tipografía, componentes y accesibilidad | Pendiente |
| `mapa-del-sitio.md` | Árbol de pantallas por perfil | Pendiente |
| `inventario-de-vistas.md` | Una fila por vista: ID, perfil, contenido y acciones | Pendiente |
| `figma.md` | Enlaces a los prototipos | Pendiente |
| `prototipo-administrador.md` | T053: perfiles administrativos, matriz CRUD, navegación, estados, evidencia y límites del prototipo | En revisión |

### `planificacion/` — Royfrankly

| Archivo | Contenido | Estado |
|---|---|---|
| `README.md` | Resumen breve del objetivo y resultado de cada una de las seis fases | Borrador |
| `Planificacion_ProjectLibre_go-tacna.xml.pod` | Cronograma detallado de ProjectLibre, con tareas y dependencias | Borrador |

### `pruebas/` — Edison Catari

| Archivo | Contenido | Estado |
|---|---|---|
| `plan-de-pruebas.md` | Tipos de prueba, ambientes, datos y criterios de entrada y salida | Pendiente |
| `matriz-de-trazabilidad.md` | Cada RF y RNF contra el PRB que lo verifica | Pendiente |
| `informes/` | Resultados de las pruebas de campo en Tacna | Vacía (`.gitkeep`) |

### `manuales/` — Alex y Royfrankly

| Archivo | Contenido | Estado |
|---|---|---|
| `guia-de-usuario.md` | Qué puede hacer un pasajero, paso a paso | Pendiente |
| `manual-de-administracion.md` | Gestión de empresas, rutas, micros y conductores | Pendiente |

### `diagramas/` — David Montoya

| Archivo | Contenido | Estado |
|---|---|---|
| `fuente/arquitectura.mmd` | Diagrama de componentes (Mermaid `flowchart`) | Borrador |
| `fuente/secuencia-autenticacion.mmd` | Secuencia del login y refresh (Mermaid `sequenceDiagram`) | Borrador |
| `fuente/secuencia-gps-eta.mmd` | Secuencia de posición del micro y ETA (Mermaid `sequenceDiagram`) | Borrador |
| `fuente/erd.mmd` | Entidades y relaciones (Mermaid `erDiagram`) | Borrador |
| `export/` | PNG o SVG exportado de cada fuente, con el mismo nombre | Vacía (`.gitkeep`) |

> Hay fuentes `.mmd` y `.puml` en el repositorio. Antes de convertir o eliminar diagramas, confirmar la convención acordada y comparar los contenidos para evitar perder información.

### `guias/` — Todo el equipo

| Archivo | Contenido | Estado |
|---|---|---|
| `guias/git.md` | Reglas de Git de los 5 repos | Borrador |

`plantillas/` no existe todavía. Las referencias a moldes o scripts se deben tratar como propuestas, no como archivos disponibles.

### `.github/` — Royfrankly Navarro

Esta tabla enumera los archivos presentes en este repositorio. Los workflows y reglas de los otros repos deben verificarse en sus propios árboles; no se asume que tengan archivos idénticos.

| Archivo | Qué es | Estado |
|---|---|---|
| `.github/CODEOWNERS` | Revisores automáticos: `@royfrankly` y `@EdCatari` | Activo |
| `.github/pull_request_template.md` | Formulario del Pull Request | Activo |
| `.github/workflows/pr-title.yml` | Valida el título con `tipo(alcance): descripción` | Activo |

---

## 6. Documentación relacionada que aún requiere sincronización

| Tema / ubicación conocida | Destino en este repo | Estado / acción pendiente |
|---|---|---|---|
| Arquitectura técnica | `arquitectura/arquitectura.md` | El archivo ya resume componentes, flujo y estado del despliegue; mantenerlo sincronizado con [arquitectura/despliegue-produccion.md](arquitectura/despliegue-produccion.md). |
| Contrato de API | `contratos/openapi.yaml` | El archivo existe, pero `paths` está vacío; declarar las rutas implementadas y separar las planificadas. |
| Diagramas del sistema | `diagramas/fuente/` | Mantener los diagramas fuente aquí y enlazarlos desde las guías, evitando copias por repositorio. |
| Tablero de GitHub Projects y cronograma | `planificacion/` | Revisar que el cronograma ProjectLibre refleje las tareas y fases vigentes. |

---

## 7. Problemas abiertos de la documentación

| # | Problema | Dónde se resuelve |
|---|---|---|
| 1 | Hay dos numeraciones de requerimientos (hasta RF-45 en un borrador, RF-01 a RF-20 en la guía TF) | Resuelto: gana la guía TF, ver [CONTRIBUTING.md](CONTRIBUTING.md) §3 |
| 2 | Tres nombres para lo mismo: micro, bus y unidad | Resuelto por [glosario.md](glosario.md) |
| 3 | El contrato OpenAPI aún no refleja rutas ni nombres del Backend Core | Pendiente: actualizar `contratos/openapi.yaml` desde las rutas verificadas |
| 4 | La difusión WebSocket/Socket.IO y el almacenamiento de posiciones no están documentados como un flujo integrado | Pendiente: especificar el contrato y verificar la integración con Location Service |
| 5 | El informe final no existe | Pendiente: `informe/capitulo-1/` |
| 6 | Hay un cronograma ProjectLibre y un tablero de GitHub; falta confirmar que ambos reflejen el mismo plan | Pendiente: `planificacion/` |
| 7 | No están confirmadas las 6 fases ni el reparto de T001 a T109 | Pendiente: Royfrankly |

---

## 8. Cómo se mantiene este inventario

1. Al crear un archivo en la raíz, se agrega en la sección 1; los archivos de una carpeta se agregan en la subsección correspondiente de la sección 5. Si se crea una carpeta nueva, también se agrega en la sección 2.
2. Al mover o renombrar un archivo, se actualiza su fila y los enlaces que lo apuntan.
3. Al eliminar un archivo, se elimina su fila y se busca quién lo enlazaba (`Ctrl+Shift+F` en GitHub).
4. El responsable de la carpeta es quien mantiene las filas de sus documentos.
