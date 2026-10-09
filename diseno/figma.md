# Figma

> **Estado:** En revisión
> **Responsable:** Alex Huaracha
> **Relacionado:** [guia-de-estilos.md](guia-de-estilos.md), [mapa-del-sitio.md](mapa-del-sitio.md), T092

## 1. Descripción

Go Tacna cuenta con un kit de componentes UI diseñado en Figma, orientado a mantener la consistencia visual de la aplicación móvil Android y el panel administrativo web.

El kit toma como referencia la guía de estilos de T049 y establece componentes que podrán reutilizarse en los prototipos de Pasajero, Conductor y Administrador.

## 2. Enlace al diseño

**Proyecto:** Go Tacna

**Tarea:** T092 — Diseñar el Kit de Componentes UI en Figma.

**Página:** `02 - UI Components Kit`

**Enlace:** [Abrir kit de componentes UI](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=96-2)

## 3. Componentes incluidos

| Categoría | Componentes |
|---|---|
| Botones | Primary, Secondary, Outline, Danger y Text, con estados y tamaños |
| Campos de entrada | Texto, correo electrónico, contraseña, búsqueda y selección |
| Tarjetas | Micro, ruta, ETA, información y resumen administrativo |
| Badges | Activo, en recorrido, GPS activo, advertencia, sin conexión y finalizado |
| Chips | Selección de rutas y filtros |
| Marcadores de mapa | Ubicación del pasajero, micros y paraderos, con representación de estados |
| Modales | Confirmación, información, peligro y error |
| Bottom Sheet | Panel inferior de información del micro y ETA |
| Navegación | Barras superiores, navegación inferior, elementos de menú y pestañas |
| Retroalimentación | Carga, estado vacío, error y confirmación |

## 4. Fundamentos visuales

El kit utiliza como referencia la identidad visual documentada en T049:

- Color principal: azul `#2563EB`.
- Familia tipográfica: Inter.
- Espaciado basado en múltiplos de 4 px.
- Radios consistentes según el tipo de componente.
- Colores semánticos para éxito, advertencia, error e información.
- Iconografía clara y consistente.

Los componentes priorizan la legibilidad, jerarquía visual, diferenciación de estados y facilidad de interacción.

## 5. Reutilización

La página de Figma contiene definiciones de componentes maestros e instancias utilizadas en las muestras visuales.

Se documentan estados, tamaños y variantes para facilitar la reutilización en las siguientes tareas de diseño.

La configuración de propiedades nativas de las variantes y la publicación como biblioteca compartida deben validarse desde el archivo de Figma antes de declarar la biblioteca publicada.

## 6. Ejemplos de uso

El kit incorpora ejemplos de composición para los perfiles:

**Pasajero:** consulta de rutas, información del micro y tiempo estimado de llegada.

**Conductor:** información de la unidad asignada, estado GPS, inicio y finalización del recorrido.

**Administrador:** indicadores de supervisión, búsqueda, estados y acciones de gestión.

Estos ejemplos ilustran cómo combinar componentes y no sustituyen los prototipos navegables de cada perfil.

## 7. Relación con otras tareas

| Tarea | Relación |
|---|---|
| T049 | Define los fundamentos visuales del kit |
| T083 | Define la arquitectura de contenido y navegación |
| T050 | Reutilización en Login y Registro |
| T051 | Reutilización en el prototipo de Pasajero |
| T052 | Reutilización en el prototipo de Conductor |
| T053 | Reutilización en el panel administrativo |

## 8. Estado y validación

El kit está diseñado en Figma y contiene las categorías principales solicitadas por T092.

Antes de su aprobación definitiva se comprobará:

- Acceso al archivo por parte del equipo.
- Edición y reutilización de instancias.
- Funcionamiento de variantes y propiedades.
- Integridad del diseño después de modificar etiquetas.
- Disponibilidad de los componentes para las siguientes tareas.

## 9. Recursos y exportaciones

Las fuentes editables se mantienen en Figma. Los recursos gráficos que requiera el desarrollo podrán exportarse posteriormente en formatos adecuados, como SVG para iconos y marcadores vectoriales.

Los recursos incorporados al repositorio deberán colocarse en `assets/`, siguiendo las reglas del equipo.

No se consideran exportados ni implementados los componentes hasta realizar dichas acciones.
