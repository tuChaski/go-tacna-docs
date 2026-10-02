# Guía de escritura de la documentación

> **Estado:** Aprobado
> **Responsable:** Todo el equipo
> **Relacionado:** [glosario.md](glosario.md), [INVENTARIO.md](INVENTARIO.md), [plantillas/](plantillas/)

## 1. Principios

1. **Una fuente de verdad por tema.** Si algo ya está escrito en otro archivo, se enlaza, no se copia. El informe (`informe/`) resume y enlaza; el detalle vive en su carpeta.
2. **Una idea por archivo.** Varios archivos cortos son mejores que uno enorme.
3. **Todo cambio entra por Pull Request** con revisión de otro integrante.

## 2. Dónde va cada cosa

| Tema | Carpeta | Responsable |
|---|---|---|
| Requisitos y reglas de negocio | `requisitos/` | Royfrankly |
| Casos de uso | `casos-de-uso/` | Todo el equipo |
| Arquitectura y decisiones | `arquitectura/` | David |
| Contratos (API, WebSocket, JWT) | `contratos/` | Royfrankly y David |
| Diseño UI/UX | `diseno/` | Alex |
| Planificación y cronograma | `planificacion/` | Royfrankly |
| Pruebas y calidad | `pruebas/` | Edison |
| Manuales de usuario y administrador | `manuales/` | Alex y Royfrankly |
| Diagramas como código | `diagramas/` | David |
| Imágenes y logos | `assets/` | Alex |
| Informe del Trabajo Final | `informe/` | Todo el equipo |

Hay dos tipos de carpeta y se mezclan fácil:

- **Fuentes** (`requisitos/`, `casos-de-uso/`, `arquitectura/`, `diseno/`, `planificacion/`, `pruebas/`, `manuales/`): aquí se trabaja el contenido completo.
- **Salida** (`informe/`): resume y enlaza lo que está en las fuentes, sin repetirlo.

`informe/capitulo-1/` sigue la guía del Trabajo Final sección por sección (1.1 a 1.12), así se ve de un vistazo qué falta. `informe/final/` guarda el documento consolidado exportado (.docx y .pdf) y nunca se escribe a mano.

Si dudas de dónde va algo, la tabla de esta sección es la respuesta. Antes de crear un archivo nuevo, revisa [INVENTARIO.md](INVENTARIO.md) para no duplicar un documento que ya existe.

## 3. Identificadores

| Prefijo | Significa | Ejemplo |
|---|---|---|
| `RF-` | Requerimiento funcional | RF-08 |
| `RNF-` | Requerimiento no funcional | RNF-04 |
| `RN-` | Regla de negocio | RN-08 |
| `CU-` | Caso de uso | CU-03 |
| `DEC-` | Decisión de arquitectura | DEC-001 |
| `PRB-` | Caso de prueba | PRB-012 |
| `T` | Tarea del cronograma | T033 |

Reglas:

- **Nunca se reutiliza ni se renumera un identificador.** Si algo deja de aplicar, se marca como `Descartado`. Renumerar rompe la trazabilidad con el cronograma y las pruebas.
- **La numeración oficial de RF y RNF es la de la guía TF** (RF-01 a RF-20, RNF-01 a RNF-07). La numeración anterior (hasta RF-45) está descartada.
- Los nuevos requerimientos continúan la numeración (RF-21, RF-22...).

## 4. Redacción

- Español, tercera persona, tiempo presente.
- Requisitos: **"El sistema debe..."** (obligatorio) o **"El sistema podrá..."** (opcional). Un requisito expresa una sola cosa verificable.
- Evitar palabras vagas ("rápido", "fácil", "adecuado") sin un número: 2 segundos, 3 toques, 99.5 %.
- El tiempo de llegada siempre se llama **estimado** (RN-08).
- Usar los términos de [glosario.md](glosario.md).

## 5. Encabezado de cada archivo

Todo archivo empieza con título y estas tres líneas:

```
# Título del documento
> **Estado:** Pendiente | Borrador | En revisión | Aprobado
> **Responsable:** Nombre
> **Relacionado:** [enlaces a otros archivos]
```

La fecha y el historial los registra Git; no se escriben a mano.

## 6. Diagramas, tablas y figuras

- El diagrama editable va en `diagramas/fuente/` (`.puml` o `.mermaid`) y su imagen exportada en `diagramas/export/`, con el mismo nombre. Se edita siempre la fuente.
- En los archivos se inserta la imagen con ruta relativa y una descripción.
- **La numeración "Figura 1.x" y "Tabla 1.x" se asigna solo al armar el informe final**, para no renumerar cada vez que se agrega una.

## 7. Nombres de archivo

Minúsculas, guiones, sin espacios ni tildes: `mapa-del-sitio.md`, `cu-03-consultar-eta.md`.

## 8. Git

Las reglas de Git del equipo viven en un solo archivo: [guias/git.md](guias/git.md). Ahí están el flujo de trabajo, los alcances por repositorio, los títulos de Pull Request, la configuración de GitHub y el script que deja cada repositorio listo.

Resumen: ramas `feature/T000-nombre` creadas desde `main` (**este repo no usa `develop`**), commits y título de PR con formato `tipo(alcance): descripción`, 1 aprobación por Pull Request y nunca se suben `.env` ni secretos.