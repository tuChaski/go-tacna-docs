# Inventario del repositorio de documentación

> **Estado:** En revisión
> **Responsable:** Todo el equipo
> **Relacionado:** [README.md](README.md), [CONTRIBUTING.md](CONTRIBUTING.md), [glosario.md](glosario.md), [guias/git.md](guias/git.md), [plantillas/](plantillas/)

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
| `guias/git.md` | **Fuente de verdad de las reglas de Git** de los 5 repos: ramas, commits, PR, releases, GitHub | Royfrankly Navarro | Borrador |
| `general/` | Vista de control del proyecto: repos, configuración, checklist y decisiones abiertas | Royfrankly Navarro | Esqueleto |
| `plantillas/` | Moldes para crear documentos + `setup-git-rules.sh` | Todo el equipo | Activa |
| `.github/` | CODEOWNERS, plantilla de PR y validación del título | Royfrankly Navarro | Activa |

---

## 2. Carpetas

| Carpeta | Tipo | Qué contiene | Responsable | Estado |
|---|---|---|---|---|
| `general/` | Control | Vista de arriba del proyecto: repos, configuración, checklist y decisiones abiertas | Royfrankly Navarro | Esqueleto |
| `requisitos/` | Fuente | RF-01 a RF-20, RNF-01 a RNF-07, RN-01 a RN-10 y alcance del MVP | Royfrankly | Borrador |
| `casos-de-uso/` | Fuente | Diagrama general y una especificación por caso de uso | Todo el equipo | Esqueleto |
| `arquitectura/` | Fuente | Modelo del sistema, modelo de datos y decisiones | David Montoya | Esqueleto |
| `contratos/` | Fuente | API, WebSocket y JWT. **Los otros repos implementan lo de aquí** | Royfrankly y David | Esqueleto |
| `diseno/` | Fuente | Estilos, mapa del sitio, inventario de vistas y Figma | Alex Huaracha | Esqueleto |
| `planificacion/` | Fuente | Resumen de seis fases y cronograma detallado en ProjectLibre | Royfrankly | Borrador |
| `pruebas/` | Fuente | Plan de pruebas, trazabilidad e informes de campo | Edison Catari | Esqueleto |
| `manuales/` | Fuente | Guía del pasajero y manual del administrador | Alex y Royfrankly | Esqueleto |
| `diagramas/` | Fuente | Diagramas como código, en `fuente/` y `export/` | David Montoya | Esqueleto |
| `assets/` | Fuente | Logos, capturas y recursos compartidos | Alex Huaracha | Vacía (`.gitkeep`) |
| `informe/` | Salida | Capítulos del Trabajo Final y documento consolidado | Todo el equipo | Esqueleto |
| `guias/` | Guía | Guías transversales del equipo | Royfrankly Navarro | Activa |

> Las carpetas con `.gitkeep` están creadas pero vacías. Las demás tienen archivos de arranque: al abrirlos se ve qué va en cada uno.

---

## 3. `general/` — la vista de control

No es el mapa de archivos (eso es este `INVENTARIO.md`): es la vista de arriba del proyecto. Resume y enlaza, no repite.

| Archivo | Qué resuelve | Estado |
|---|---|---|
| `general/README.md` | Índice de la carpeta y tabla "quiero hacer X, mira Y" | Pendiente |
| `general/repos.md` | Ficha de los 5 repos: qué contienen, con qué stack, quién lo trabaja, qué consumen de `docs/` y en qué estado están | Pendiente |
| `general/configuracion.md` | Toda la configuración en una vista: repos, ramas, GitHub, contratos, puertos, secretos, variables y HTTPS | Pendiente |
| `general/checklist.md` | Qué falta, con casillas, en 8 bloques ordenados por dependencia | Pendiente |
| `general/decisiones-pendientes.md` | Decisiones abiertas con opciones, responsable y a qué desbloquean; y las ya cerradas | Pendiente |

---

## 4. `informe/` — la salida

`informe/capitulo-1/` sigue la guía del Trabajo Final sección por sección, para que se vea de un vistazo qué falta. Cada archivo **resume y enlaza** a la carpeta de detalle, no copia contenido.

| Archivo | Sección de la guía | El detalle vive en | Estado |
|---|---|---|---|
| `1.1-contexto.md` | Contexto, justificación, objetivos y antecedentes | — | Pendiente |
| `1.2-proceso-as-is-to-be.md` | Proceso actual y proceso propuesto | `casos-de-uso/` | Pendiente |
| `1.3-definicion-del-sistema.md` | Definición, límites y stakeholders | `arquitectura/` | Pendiente |
| `1.4-cuadro-comparativo.md` | Cuadro comparativo AS-IS / TO-BE | `1.2-proceso-as-is-to-be.md` | Pendiente |
| `1.5-distribucion-de-roles.md` | Quién hizo qué | `planificacion/` | Pendiente |
| `1.6-requerimientos.md` | Tabla resumen de RF y RNF | `requisitos/` | Pendiente |
| `1.7-planificacion.md` | Cronograma y hitos | `planificacion/` | Pendiente |
| `1.8-arquitectura-de-contenido.md` | Mapa del sitio y jerarquía de pantallas | `diseno/` | Pendiente |
| `1.9-arquitectura-web.md` | Modelo del sistema y diagramas | `arquitectura/`, `diagramas/` | Pendiente |
| `1.10-perfiles-de-usuario.md` | Pasajero, Conductor y Administrador | `casos-de-uso/` | Pendiente |
| `1.11-casos-de-uso.md` | Índice de casos de uso | `casos-de-uso/` | Pendiente |
| `1.12-diagramas-de-secuencia.md` | Imágenes de secuencia con su descripción | `diagramas/export/` | Pendiente |
| `final/README.md` | Dónde va el `.docx` y el `.pdf` consolidados | — | Pendiente |

---

## 5. Carpetas de fuente

### `requisitos/` — Royfrankly

| Archivo | Contenido | Estado |
|---|---|---|
| `requerimientos-funcionales.md` | RF-01 a RF-20, con la numeración oficial de la guía TF | Borrador |
| `requerimientos-no-funcionales.md` | RNF-01 a RNF-07 | Borrador |
| `reglas-de-negocio.md` | RN-01 a RN-10, incluida RN-08 (el ETA siempre es estimado) | Borrador |
| `mvp.md` | Qué entra en el MVP y qué queda para Premium o para después | Borrador |

### `casos-de-uso/` — Todo el equipo

| Archivo | Contenido | Estado |
|---|---|---|
| `diagrama-general.mmd` | Diagrama del sistema completo (Mermaid) | Borrador |
| `especificaciones/CU-01-iniciar-sesion.md` | Un caso de uso por archivo: `CU-XX-nombre.md` | Pendiente |

### `arquitectura/` — David Montoya

| Archivo | Contenido | Estado |
|---|---|---|
| `arquitectura.md` | Componentes, stack, flujo de una posición y red/puertos | Pendiente |
| `modelo-de-datos.md` | Tablas, columnas y relaciones. Debe coincidir con el ERD | Pendiente |
| `decisiones/001-node-separado-de-laravel.md` | Por qué el tiempo real es un servicio aparte | Pendiente |
| `decisiones/002-expo-y-maplibre.md` | Por qué Expo y MapLibre | Pendiente |
| `decisiones/003-gps-por-http-post.md` | Por qué la posición llega por HTTP POST | Pendiente |

### `contratos/` — Royfrankly y David

| Archivo | Contenido | Estado |
|---|---|---|
| `openapi.yaml` | OpenAPI 3.1 con prefijo `/api/v1`. Faltan auth, CRUD y `/tracking/*` (T086) | Pendiente |
| `eventos-websocket.md` | Eventos de Socket.io con su payload y el uso de salas (T087) | Pendiente |
| `jwt-claims.md` | `role`, `micro_id`, `ruta_id`, `exp`, firma HS256 | Pendiente |

### `diseno/` — Alex Huaracha

| Archivo | Contenido | Estado |
|---|---|---|
| `guia-de-estilos.md` | Paleta, tipografía, componentes y accesibilidad | Pendiente |
| `mapa-del-sitio.md` | Árbol de pantallas por perfil | Pendiente |
| `inventario-de-vistas.md` | Una fila por vista: ID, perfil, contenido y acciones | Pendiente |
| `figma.md` | Enlaces a los prototipos | Pendiente |

### `planificacion/` — Royfrankly

| Archivo | Contenido | Estado |
|---|---|---|
| `README.md` | Resumen breve del objetivo y resultado de cada una de las seis fases | Borrador |
| `Planificacion_ProjectLibre_tuChaski.xml.pod` | Cronograma detallado de ProjectLibre, con tareas y dependencias | Borrador |

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

> **Mermaid es la única sintaxis de diagramas del proyecto.** Ya se absorbió el diagrama Mermaid que vivía en `rutas-en-tiempo-real-frontend/docs/diagrams/architecture.mmd`; ese archivo se elimina al migrar el resto de la documentación de ese repo (ver sección 5).

### `plantillas/` y `guias/` — Todo el equipo

| Archivo | Contenido | Estado |
|---|---|---|
| `plantillas/requerimiento.md` | Molde de RF, RNF o RN | Aprobado |
| `plantillas/caso-de-uso.md` | Molde de CU | Aprobado |
| `plantillas/decision.md` | Molde de DEC | Aprobado |
| `plantillas/prueba.md` | Molde de PRB | Aprobado |
| `plantillas/setup-git-rules.sh` | Deja un repo listo: plantilla de PR, CODEOWNERS, workflow y CONTRIBUTING | Aprobado |
| `guias/git.md` | Reglas de Git de los 5 repos | Borrador |

### `.github/` — Royfrankly Navarro

Los mismos archivos existen en los cinco repos del equipo.

| Archivo | Qué es | Estado |
|---|---|---|
| `.github/CODEOWNERS` | Revisores automáticos: `@royfrankly` y `@EdCatari` | Activo |
| `.github/pull_request_template.md` | Formulario del Pull Request | Activo |
| `.github/workflows/pr-title.yml` | Valida el título con `tipo(alcance): descripción` | Activo |

---

## 6. Documentos que están en otro repo y deben migrar acá

| Ubicación actual | Qué es | Destino oficial | Acción pendiente |
|---|---|---|---|
| `rutas-en-tiempo-real-frontend/docs/architecture.md` | Arquitectura del monorepo: componentes, puertos y flujo de ubicación (29 líneas) | `arquitectura/arquitectura.md` | Migrar y quitar la advertencia de "directorios pendientes" |
| `rutas-en-tiempo-real-frontend/docs/openapi.yaml` | OpenAPI con solo 3 endpoints | `contratos/openapi.yaml` | Migrar y completar con auth, CRUD y `/tracking/*` |
| `rutas-en-tiempo-real-frontend/docs/diagrams/architecture.mmd` | Diagrama de componentes en Mermaid | `diagramas/fuente/` + `export/` | Migrar |
| Tablero de GitHub Projects | Fuente de tareas para el cronograma | `planificacion/Planificacion_ProjectLibre_tuChaski.xml.pod` | Revisar que el cronograma ProjectLibre refleje las tareas vigentes |

---

## 7. Problemas abiertos de la documentación

| # | Problema | Dónde se resuelve |
|---|---|---|
| 1 | Hay dos numeraciones de requerimientos (hasta RF-45 en un borrador, RF-01 a RF-20 en la guía TF) | Resuelto: gana la guía TF, ver [CONTRIBUTING.md](CONTRIBUTING.md) §3 |
| 2 | Tres nombres para lo mismo: micro, bus y unidad | Resuelto por [glosario.md](glosario.md) |
| 3 | El `openapi.yaml` usa `bus`/`buses` y el código usa `micro` | Pendiente: DEC con Royfrankly |
| 4 | `/tracking/*` ya está implementado en `realtime/` y no está en el contrato | Pendiente: Royfrankly (T086) |
| 5 | El informe final no existe | Pendiente: `informe/capitulo-1/` |
| 6 | El cronograma solo existe como tablero de GitHub | Pendiente: `planificacion/` |
| 7 | No están confirmadas las 6 fases ni el reparto de T001 a T109 | Pendiente: Royfrankly |

---

## 8. Cómo se mantiene este inventario

1. Al crear un archivo, se agrega su fila en la sección 5 de este archivo, y también en la tabla de la sección 2 si es una carpeta nueva.
2. Al mover o renombrar un archivo, se actualiza su fila y los enlaces que lo apuntan.
3. Al eliminar un archivo, se elimina su fila y se busca quién lo enlazaba (`Ctrl+Shift+F` en GitHub).
4. El responsable de la carpeta es quien mantiene las filas de sus documentos.