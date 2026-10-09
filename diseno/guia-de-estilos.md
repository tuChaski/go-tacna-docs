# Guía de estilos

> **Estado:** Pendiente
> **Responsable:** Alex Huaracha
> **Relacionado:** [../informe/capitulo-1/1.8-arquitectura-de-contenido.md](../informe/capitulo-1/1.8-arquitectura-de-contenido.md), [figma.md](figma.md)

## Qué va aquí

# ENLACE DE FIGMA:

# https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/Sin-t%C3%ADtulo?node-id=49-13539&t=YIsGkgn0fEphLjXX-1

# RutaTacna — Guía de estilos UI/UX

> Sistema visual base para la aplicación de monitoreo de transporte público en tiempo real RutaTacna.

| Campo | Detalle |
| --- | --- |
| Proyecto | RutaTacna |
| Tarea | T049 — Definir guía de estilos UI/UX: paleta, tipografía y componentes base |
| Versión | 1.0 |
| Documento | UI/UX Style Guide · Design System Foundation |
| Plataforma principal | Android |
| Reutilización prevista | Panel administrativo web |
| Contexto | Transporte público urbano de Tacna, Perú |
| Página de Figma | 01 - UI Style Guide |
| Frame principal | RutaTacna - UI/UX Style Guide |

## Índice

- [0. Presentación y alcance](#0-presentación-y-alcance)
- [1. Identidad y principios](#1-identidad-y-principios)
- [2. Paleta de colores](#2-paleta-de-colores)
- [3. Tipografía](#3-tipografía)
- [4. Espaciado](#4-espaciado)
- [5. Radios de borde](#5-radios-de-borde)
- [6. Elevación](#6-elevación)
- [7. Iconografía](#7-iconografía)
- [8. Fundamentos de componentes](#8-fundamentos-de-componentes)
- [9. Fundamentos del mapa](#9-fundamentos-del-mapa)
- [10. Design Tokens](#10-design-tokens)
- [11. Accesibilidad](#11-accesibilidad)
- [12. Ejemplos de uso](#12-ejemplos-de-uso)
- [13. Organización en Figma](#13-organización-en-figma)
- [14. Criterios de aceptación y continuidad](#14-criterios-de-aceptación-y-continuidad)

## 0. Presentación y alcance

RutaTacna es una aplicación de monitoreo del transporte público urbano en tiempo real para Tacna, Perú.

Su objetivo es permitir que los pasajeros consulten:

- Qué ruta desean utilizar.
- Dónde se encuentra un micro de esa ruta.
- Cuánto tiempo aproximadamente falta para que llegue.

La ubicación aproximada del micro se obtiene mediante el GPS del teléfono del conductor.

La consulta principal debe seguir una secuencia sencilla:

**Ruta → Micro → Ubicación**

### Objetivo de T049

Establecer una identidad visual compartida que permita desarrollar posteriormente mockups, prototipos y componentes sin redefinir colores, tipografía, tamaños, espaciados o criterios de representación del mapa.

### Incluido

- Identidad, personalidad y principios de diseño.
- Paletas Primary y Neutral.
- Colores semánticos y roles de interfaz.
- Escala tipográfica.
- Espaciado, radios y elevación.
- Lenguaje visual de iconos.
- Muestras estáticas de botones, inputs, cards, badges y chips.
- Fundamentos de marcadores y recorridos del mapa.
- Nomenclatura de Design Tokens.
- Referencia para trasladar valores a variables CSS.
- Reglas de accesibilidad.
- Tres ejemplos pequeños de composición.

### Fuera de alcance

- Pantallas completas de Login y Registro.
- Pantallas completas de Pasajero, Conductor o Administrador.
- Prototipo navegable.
- Interacciones funcionales.
- Design System completo con todas sus variantes.
- Implementación del frontend.
- Implementación de la transmisión GPS.
- Pagos.
- Accidentes.
- Tráfico avanzado.
- Predicción avanzada basada en tráfico.

> Las muestras visuales no constituyen una especificación funcional completa. La lógica, las transiciones y las variantes definitivas se resolverán en tareas posteriores.

## 1. Identidad y principios

### Marca

**RutaTacna**

**Movilidad urbana en tiempo real**

RutaTacna busca ofrecer una experiencia digital sencilla y confiable para consultar rutas, visualizar micros y conocer tiempos aproximados de llegada en el transporte público urbano de Tacna.

### Personalidad de marca

| Inglés | Español | Aplicación visual |
| --- | --- | --- |
| Modern | Moderno | Composición limpia y recursos actuales, sin exceso decorativo. |
| Reliable | Confiable | Información clara, estados explícitos y coherencia visual. |
| Simple | Simple | Pocos elementos y acciones comprensibles. |
| Fast | Rápido | Ruta, micro y ETA fácilmente identificables. |
| Urban | Urbano | Lenguaje relacionado con transporte y desplazamiento. |
| Connected | Conectado | Comunicación visible de ubicación, GPS y conexión. |

### Principios de diseño

#### 1. Claridad

La información importante debe reconocerse inmediatamente.

La ruta, el micro seleccionado y el tiempo aproximado de llegada deben tener una jerarquía evidente.

#### 2. Rapidez

Las acciones principales deben requerir pocas interacciones.

El usuario debe llegar rápidamente a la información que necesita.

#### 3. Consistencia

Los colores, tamaños, espaciados y componentes deben seguir las mismas reglas.

No introducir valores nuevos sin una necesidad justificada.

#### 4. Accesibilidad

La información debe ser legible en diferentes condiciones de luz, movilidad y conexión.

Los estados no deben depender exclusivamente del color.

#### 5. Movilidad

El diseño debe permitir consultas rápidas mientras la persona se desplaza.

Priorizar lectura clara, controles cómodos y contenido esencial.

### Dirección visual

- Moderna.
- Minimalista.
- Tecnológica.
- Profesional.
- Limpia.
- Amigable.
- Orientada a movilidad urbana.
- Fácil de comprender.
- Altamente legible.

### Recursos visuales

- Espacio negativo generoso.
- Jerarquía visual clara.
- Esquinas suavemente redondeadas.
- Bordes discretos.
- Sombras leves.
- Una única familia tipográfica.
- Iconografía outline consistente.

### Evitar

- Decoración innecesaria.
- Saturación visual.
- Estética infantil.
- Futurismo exagerado.
- Glassmorphism excesivo.
- Gradientes excesivos.
- Mezcla de familias tipográficas.
- Mezcla de estilos de iconos.

## 2. Paleta de colores

**Primary 600 (`#2563EB`) es el color principal de RutaTacna.**

El azul define la identidad. El verde se reserva para estados semánticos y no debe reemplazar al azul como color principal.

### 2.1. Primary

| Token | HEX |
| --- | --- |
| `Color/Primary/50` | `#EFF6FF` |
| `Color/Primary/100` | `#DBEAFE` |
| `Color/Primary/200` | `#BFDBFE` |
| `Color/Primary/300` | `#93C5FD` |
| `Color/Primary/400` | `#60A5FA` |
| `Color/Primary/500` | `#3B82F6` |
| `Color/Primary/600` | `#2563EB` |
| `Color/Primary/700` | `#1D4ED8` |
| `Color/Primary/800` | `#1E40AF` |
| `Color/Primary/900` | `#1E3A8A` |

#### Uso

- Identidad de marca.
- Navegación.
- Acciones principales.
- Selección.
- Elementos destacados del mapa.

Los tonos claros pueden utilizarse como fondos de énfasis. No usar azul claro como texto pequeño sin comprobar contraste.

### 2.2. Neutral

| Token | HEX |
| --- | --- |
| `Color/Neutral/50` | `#F8FAFC` |
| `Color/Neutral/100` | `#F1F5F9` |
| `Color/Neutral/200` | `#E2E8F0` |
| `Color/Neutral/300` | `#CBD5E1` |
| `Color/Neutral/400` | `#94A3B8` |
| `Color/Neutral/500` | `#64748B` |
| `Color/Neutral/600` | `#475569` |
| `Color/Neutral/700` | `#334155` |
| `Color/Neutral/800` | `#1E293B` |
| `Color/Neutral/900` | `#0F172A` |

#### Uso

- Fondos.
- Superficies de apoyo.
- Bordes.
- Texto principal y secundario.
- Metadatos.
- Elementos deshabilitados.

### 2.3. Colores semánticos

| Token | Nombre | HEX | Significado |
| --- | --- | --- | --- |
| `Color/State/Success` | Success | `#16A34A` | Estado activo, conexión correcta y operación exitosa. |
| `Color/State/Warning` | Warning | `#F59E0B` | Advertencia o situación que requiere atención. |
| `Color/State/Error` | Error | `#DC2626` | Error, desconexión y acción destructiva. |
| `Color/State/Info` | Info | `#0284C7` | Información contextual. |

#### Regla de uso

Combinar:

**Color + icono o símbolo + texto**

Para Success y Warning, preferir fondos tintados con texto oscuro cuando el blanco pequeño no tenga contraste suficiente.

### 2.4. Roles de interfaz

| Rol | Valor | Referencia |
| --- | --- | --- |
| Background | `#F8FAFC` | Neutral 50 |
| Surface | `#FFFFFF` | Superficie blanca |
| Border | `#E2E8F0` | Neutral 200 |
| Text Primary | `#0F172A` | Neutral 900 |
| Text Secondary | `#64748B` | Neutral 500 |
| Text Disabled | `#94A3B8` | Neutral 400 |

#### Nombres de texto

- `Color/Text/Primary`
- `Color/Text/Secondary`
- `Color/Text/Disabled`

#### Referencia CSS para superficies

- `--color-background`
- `--color-surface`
- `--color-border`

### 2.5. Significado general

| Color | Función |
| --- | --- |
| Azul | Identidad, navegación y acciones principales. |
| Verde | Activo, conexión correcta y éxito. |
| Amarillo | Advertencias y atención. |
| Rojo | Errores, desconexiones y acciones destructivas. |
| Gris | Contenido secundario, fondos, bordes y deshabilitados. |

## 3. Tipografía

### Familia principal

**Inter**

### Fallback web

**Arial, sans-serif**

```css
font-family: "Inter", Arial, sans-serif;
```

Declarar la familia en CSS no descarga Inter automáticamente. La implementación posterior deberá proporcionar y cargar los recursos tipográficos correspondientes.

### Escala tipográfica

| Estilo | Nombre en Figma | Tamaño | Peso | Altura de línea |
| --- | --- | ---: | --- | ---: |
| Display | `Typography/Display` | 32 px | 700 · Bold | 40 px |
| H1 | `Typography/H1` | 28 px | 700 · Bold | 36 px |
| H2 | `Typography/H2` | 24 px | 600 · SemiBold | 32 px |
| H3 | `Typography/H3` | 20 px | 600 · SemiBold | 28 px |
| Body Large | `Typography/Body/Large` | 18 px | 400 · Regular | 28 px |
| Body | `Typography/Body/Regular` | 16 px | 400 · Regular | 24 px |
| Body Medium | `Typography/Body/Medium` | 16 px | 500 · Medium | 24 px |
| Small | `Typography/Small/Regular` | 14 px | 400 · Regular | 20 px |
| Small Medium | `Typography/Small/Medium` | 14 px | 500 · Medium | 20 px |
| Caption | `Typography/Caption` | 12 px | 400 · Regular | 16 px |

### Ejemplos de jerarquía

| Contenido | Estilo |
| --- | --- |
| ¿Dónde está mi micro? | H1 |
| Ruta 10 | H2 |
| Micro 04 | H3 |
| Llegada aproximada | Body |
| 6 min | Display |
| Ver ubicación | Body Medium |
| GPS activo | Small Medium |
| Actualizado hace 5 segundos | Caption |

### Reglas

- Mantener el cuerpo principal alrededor de 16 px.
- Usar Display para datos clave, como el ETA.
- Reservar Caption para metadatos.
- No convertir información esencial en texto diminuto.
- Mantener la relación entre tamaño, peso y altura de línea.
- No utilizar múltiples familias tipográficas.
- Evitar cambios arbitrarios de peso entre elementos equivalentes.

### Adaptación a Android

Los tamaños de la guía se documentan en px como referencia de diseño.

Durante la implementación nativa:

- Adaptar tipografía a `sp`.
- Adaptar geometría y áreas táctiles a `dp`.
- Respetar el escalado de texto configurado por el usuario.
- Validar que el contenido no se recorte al aumentar el tamaño de fuente.

### Categorías y estilos específicos

`Typography/Body` y `Typography/Small` son categorías de nomenclatura.

Sus estilos concretos son:

```text
Typography/Body/Large
Typography/Body/Regular
Typography/Body/Medium

Typography/Small/Regular
Typography/Small/Medium
```

## 4. Espaciado

La escala se basa en múltiplos de **4 px**.

| Token | Valor | Referencia CSS |
| --- | ---: | --- |
| `Spacing/1` | 4 px | `--spacing-1` |
| `Spacing/2` | 8 px | `--spacing-2` |
| `Spacing/3` | 12 px | `--spacing-3` |
| `Spacing/4` | 16 px | `--spacing-4` |
| `Spacing/6` | 24 px | `--spacing-6` |
| `Spacing/8` | 32 px | `--spacing-8` |
| `Spacing/10` | 40 px | `--spacing-10` |
| `Spacing/12` | 48 px | `--spacing-12` |
| `Spacing/16` | 64 px | `--spacing-16` |

### Uso recomendado

| Valor | Uso |
| --- | --- |
| 8 px | Separación pequeña, por ejemplo entre icono y etiqueta. |
| 16 px | Separación normal entre elementos. |
| 24 px | Separación entre grupos y padding de cards de fundamento. |
| 32–48 px | Separación entre secciones. |
| 64 px | Espacios amplios cuando la composición lo requiera. |

### Reglas

- Aplicar la escala a márgenes, padding y gaps.
- Mantener un ritmo consistente.
- Agrupar visualmente la información relacionada.
- Evitar valores arbitrarios como 13, 17 o 27 px si no existe una necesidad justificada.

## 5. Radios de borde

| Token | Valor | Uso sugerido |
| --- | ---: | --- |
| `Radius/Small` | 8 px | Inputs y controles pequeños. |
| `Radius/Medium` | 12 px | Botones. |
| `Radius/Large` | 16 px | Cards. |
| `Radius/XL` | 24 px | Bottom sheets y elementos destacados. |
| `Radius/Full` | 999 px | Badges, chips y formas tipo píldora. |

### Reglas

- Mantener radios consistentes por tipo de elemento.
- Evitar redondeados excesivos en todos los componentes.
- Para un círculo real, mantener ancho y alto iguales.
- Un radio Full no convierte por sí solo un rectángulo en un círculo.

## 6. Elevación

Las sombras son externas y discretas.

Color base:

**Neutral 900 — `#0F172A`**

| Token | X | Y | Blur | Spread | Opacidad nominal | HEX con alfa |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| `Elevation/Small` | 0 | 2 px | 6 px | 0 | 4 % | `#0F172A0A` |
| `Elevation/Medium` | 0 | 4 px | 12 px | 0 | 8 % | `#0F172A14` |
| `Elevation/Large` | 0 | 8 px | 24 px | 0 | 12 % | `#0F172A1F` |

Los porcentajes son valores nominales redondeados. Los HEX con alfa reproducen la cuantización de las muestras visuales.

### Uso

| Nivel | Aplicación |
| --- | --- |
| Small | Cards ligeramente elevadas. |
| Medium | Elementos flotantes sobre mapas. |
| Large | Modales y bottom sheets. |

### Referencia CSS

```css
--elevation-small: 0 2px 6px 0 #0f172a0a;
--elevation-medium: 0 4px 12px 0 #0f172a14;
--elevation-large: 0 8px 24px 0 #0f172a1f;
```

### Reglas

- Evitar sombras oscuras o fuertes.
- No añadir múltiples capas sin necesidad.
- Mantener los elementos visualmente ligeros.
- Priorizar superficies claras y jerarquía antes que efectos.

El nivel Large se documenta para uso futuro. No implica que existan modales o bottom sheets funcionales en T049.

## 7. Iconografía

### Lenguaje visual

- Outline.
- Simple.
- Moderno.
- Consistente.
- Siluetas reconocibles.
- Proporciones uniformes.

**Trazo de referencia: 2 px.**

No mezclar iconos filled, outline y decorativos dentro de una misma familia.

### Tamaños

| Token | Tamaño | Uso |
| --- | ---: | --- |
| `Icon/XS` | 16 px | Metadatos compactos. |
| `Icon/SM` | 20 px | Información secundaria y controles compactos. |
| `Icon/MD` | 24 px | Tamaño habitual. |
| `Icon/LG` | 32 px | Énfasis visual. |

### Muestra conceptual

- Bus
- Map Pin
- Navigation
- Route
- Clock
- User
- Search
- GPS
- Wi-Fi
- Alert
- Chevron
- Eye
- Lock
- Mail
- Settings

### Reglas

- Acompañar acciones y estados importantes con etiquetas.
- Mantener coherencia de trazo y proporción.
- No crear una librería enorme dentro de T049.
- No confundir el tamaño del dibujo con el área táctil del control.

## 8. Fundamentos de componentes

Esta sección define **apariencia estática**, no un kit completo ni comportamiento implementado.

### 8.1. Botones

#### Base visual

- Auto Layout horizontal.
- Altura mínima de referencia: **48 px**.
- Radio: `Radius/Medium`.
- Etiqueta legible.
- Espaciado consistente.
- Jerarquía clara.

| Tipo | Ejemplo | Intención visual |
| --- | --- | --- |
| Primary | Ver ubicación | Acción principal con protagonismo de Primary 600. |
| Secondary | Seleccionar ruta | Acción de apoyo con menor jerarquía. |
| Outline | Cancelar | Acción alternativa con borde discreto. |
| Danger | Finalizar recorrido | Acción destructiva o de cierre. |
| Disabled | Disabled | Acción no disponible y visualmente atenuada. |

#### Reglas

- Evitar varios botones Primary compitiendo en un mismo grupo.
- No depender solo del color para comunicar una acción destructiva.
- Mantener textos de acción claros.
- No utilizar botones pequeños para acciones frecuentes en movilidad.

La muestra Danger no define por sí sola una confirmación ni la lógica de finalización.

### 8.2. Inputs

#### Base visual

- Radio: `Radius/Small`.
- Label siempre visible.
- Superficie limpia.
- Texto de ayuda cuando corresponda.
- Estado de error comprensible.

| Estado | Ejemplo | Tratamiento |
| --- | --- | --- |
| Default | Correo electrónico · `nombre@correo.com` | Borde neutral y texto de ayuda. |
| Focus | Contraseña · `••••••••` | Borde azul de referencia de 2 px. |
| Error | Correo electrónico · `nombre@` | Símbolo y mensaje: «Ingresa un correo válido». |
| Disabled | Buscar ruta | Campo atenuado y no disponible. |

#### Reglas

- El placeholder no sustituye al label.
- No comunicar un error únicamente mediante el borde rojo.
- Mantener los mensajes breves y orientados a corregir el problema.
- No definir todas las validaciones dentro de esta tarea.

### 8.3. Cards

#### Base visual

- Superficie blanca.
- Radio: `Radius/Large`.
- Padding de referencia: **24 px**.
- Composición vertical.
- Borde suave.
- Contenido jerarquizado.

| Tipo | Ejemplo | Característica |
| --- | --- | --- |
| Default Card | Micro 04 | Contenido jerarquizado y borde neutral. |
| Selected Card | Ruta 10 | Borde azul y símbolo que refuerza la selección. |
| Information Card | Información de llegada | Mensaje contextual. |

Ejemplo de mensaje:

> Los tiempos de llegada son aproximados.

### 8.4. Status badges

#### Base visual

- Radio: `Radius/Full`.
- Color semántico.
- Símbolo o icono.
- Texto explícito.

| Estado | Símbolo de referencia | Tratamiento orientativo |
| --- | --- | --- |
| Activo | ● | Success |
| En recorrido | → | Info |
| GPS activo | ✓ | Success |
| Advertencia | ⚠ | Warning |
| Sin conexión | × | Error |
| Finalizado | ✓ | Estado concluido, diferenciado de Activo mediante texto y tratamiento neutral cuando corresponda. |

La nomenclatura y los significados definitivos de estados operativos se validarán al especificar cada flujo.

Un badge «Activo» no debe interpretarse automáticamente como garantía de precisión GPS.

### 8.5. Chips

Ejemplos:

- Ruta 10
- Ruta 14
- Ruta 30
- Cercanos
- Activos

#### Base visual

- Radio: `Radius/Full`.
- Espaciado consistente.
- Etiquetas breves.
- Selección identificable.

La guía no define todavía lógica de filtrado, selección múltiple ni interacciones.

## 9. Fundamentos del mapa

El soporte visual de la guía es un **esquema conceptual sin escala geográfica**.

No representa un mapa completo de Tacna ni coordenadas reales.

| Elemento | Leyenda | Criterio visual |
| --- | --- | --- |
| Passenger Location | Mi ubicación | Marcador propio, distinguible de micros y paraderos. |
| Bus Marker | Micro activo | Referencia de 32 px, contorno azul y elevación Small. |
| Selected Bus Marker | Micro seleccionado | Referencia de 48 px, relleno azul y elevación Medium. |
| Bus Stop Marker | Paradero | Símbolo sencillo y diferenciado del micro. |
| Route Path | Recorrido | Azul, con trazo de referencia de 4 px. |

### Jerarquía

El micro seleccionado debe tener mayor protagonismo que los demás mediante:

- Mayor tamaño.
- Relleno azul.
- Elevación.
- Diferenciación de forma o símbolo.

### Reglas

- No depender exclusivamente del color.
- Diferenciar pasajero, micro activo, micro seleccionado y paradero.
- Mantener marcadores legibles sobre fondos cartográficos variados.
- Conservar el azul como identidad dominante.
- Comprobar contraste, densidad y solapamientos sobre el mapa real en una tarea posterior.
- No presentar el ETA como una predicción exacta.
- Utilizar la etiqueta «Llegada aproximada».

### Nomenclatura

```text
Map/UserLocation
Map/Bus
Map/BusSelected
Map/Stop
```

## 10. Design Tokens

> Los Design Tokens permiten mantener consistencia entre el diseño realizado en Figma y la implementación posterior del frontend.

### Convenciones

#### Figma

Jerarquías separadas por `/`.

```text
Color/Primary/600
Spacing/4
Radius/Large
Typography/Body/Regular
```

#### CSS

Nombres en minúsculas separados por guiones.

```text
--color-primary-600
--spacing-4
--radius-large
--font-size-body
```

### Reglas

- Preferir roles semánticos para texto, superficies y estados.
- Mantener escalas primitivas para paleta y valores base.
- Revisar todos los usos cuando cambie un token.
- Evitar valores locales aislados.
- Documentar un token no implica que ya exista como variable nativa vinculada a todos los elementos de Figma.

### Correspondencia

| Figma | Referencia CSS |
| --- | --- |
| `Color/Primary/600` | `--color-primary-600` |
| `Color/Neutral/50` | `--color-neutral-50` |
| `Color/Text/Primary` | `--color-text-primary` |
| `Color/State/Success` | `--color-state-success` |
| `Spacing/4` | `--spacing-4` |
| `Radius/Large` | `--radius-large` |
| `Elevation/Small` | `--elevation-small` |
| `Icon/MD` | `--icon-md` |
| `Typography/Display` | Tamaño, peso y altura de línea de Display. |

### Referencia completa de variables CSS

Este bloque es una propuesta de traducción de los valores documentados.

No representa una implementación funcional de la aplicación.

```css
:root {
  /* Familia tipográfica */
  --font-family-base: "Inter", Arial, sans-serif;

  /* Primary */
  --color-primary-50: #eff6ff;
  --color-primary-100: #dbeafe;
  --color-primary-200: #bfdbfe;
  --color-primary-300: #93c5fd;
  --color-primary-400: #60a5fa;
  --color-primary-500: #3b82f6;
  --color-primary-600: #2563eb;
  --color-primary-700: #1d4ed8;
  --color-primary-800: #1e40af;
  --color-primary-900: #1e3a8a;

  /* Neutral */
  --color-neutral-50: #f8fafc;
  --color-neutral-100: #f1f5f9;
  --color-neutral-200: #e2e8f0;
  --color-neutral-300: #cbd5e1;
  --color-neutral-400: #94a3b8;
  --color-neutral-500: #64748b;
  --color-neutral-600: #475569;
  --color-neutral-700: #334155;
  --color-neutral-800: #1e293b;
  --color-neutral-900: #0f172a;

  /* Estados */
  --color-state-success: #16a34a;
  --color-state-warning: #f59e0b;
  --color-state-error: #dc2626;
  --color-state-info: #0284c7;

  /* Roles */
  --color-background: var(--color-neutral-50);
  --color-surface: #ffffff;
  --color-border: var(--color-neutral-200);
  --color-text-primary: var(--color-neutral-900);
  --color-text-secondary: var(--color-neutral-500);
  --color-text-disabled: var(--color-neutral-400);

  /* Espaciado */
  --spacing-1: 4px;
  --spacing-2: 8px;
  --spacing-3: 12px;
  --spacing-4: 16px;
  --spacing-6: 24px;
  --spacing-8: 32px;
  --spacing-10: 40px;
  --spacing-12: 48px;
  --spacing-16: 64px;

  /* Radios */
  --radius-small: 8px;
  --radius-medium: 12px;
  --radius-large: 16px;
  --radius-xl: 24px;
  --radius-full: 999px;

  /* Elevación */
  --elevation-small: 0 2px 6px 0 #0f172a0a;
  --elevation-medium: 0 4px 12px 0 #0f172a14;
  --elevation-large: 0 8px 24px 0 #0f172a1f;

  /* Iconos */
  --icon-xs: 16px;
  --icon-sm: 20px;
  --icon-md: 24px;
  --icon-lg: 32px;
  --icon-stroke: 2px;

  /* Display */
  --font-size-display: 32px;
  --font-weight-display: 700;
  --line-height-display: 40px;

  /* H1 */
  --font-size-h1: 28px;
  --font-weight-h1: 700;
  --line-height-h1: 36px;

  /* H2 */
  --font-size-h2: 24px;
  --font-weight-h2: 600;
  --line-height-h2: 32px;

  /* H3 */
  --font-size-h3: 20px;
  --font-weight-h3: 600;
  --line-height-h3: 28px;

  /* Body Large */
  --font-size-body-large: 18px;
  --font-weight-body-large: 400;
  --line-height-body-large: 28px;

  /* Body */
  --font-size-body: 16px;
  --font-weight-body: 400;
  --font-weight-body-medium: 500;
  --line-height-body: 24px;

  /* Small */
  --font-size-small: 14px;
  --font-weight-small: 400;
  --font-weight-small-medium: 500;
  --line-height-small: 20px;

  /* Caption */
  --font-size-caption: 12px;
  --font-weight-caption: 400;
  --line-height-caption: 16px;
}
```

### Consideraciones tipográficas

Body Regular y Body Medium comparten tamaño y altura de línea, pero no peso.

Lo mismo sucede con Small Regular y Small Medium.

No reducir cada estilo tipográfico a un único token de tamaño: conservar tamaño, peso y altura de línea.

## 11. Accesibilidad

### Reglas principales

1. Mantener alto contraste entre texto y fondo.
2. Evitar utilizar únicamente colores para transmitir información.
3. Mantener textos principales de aproximadamente 16 px.
4. Mantener botones suficientemente grandes para interacción táctil.
5. Evitar demasiado contenido en una sola pantalla.
6. Mantener jerarquías tipográficas claras.
7. Evitar texto gris demasiado claro sobre blanco.
8. Utilizar color + icono + texto para estados importantes.

### Ejemplos

```text
✓ GPS activo
⚠ Señal GPS débil
× Sin conexión
● Activo
```

### Contraste documentado

| Combinación | Contraste aproximado |
| --- | ---: |
| Text Primary `#0F172A` sobre blanco | 17,9:1 |
| Blanco sobre Primary 600 `#2563EB` | 5,2:1 |

### Criterio de implementación

Comprobar al menos:

- **4,5:1 para texto normal.**
- **3:1 para texto grande.**

Aplicar los criterios de WCAG que correspondan a cada elemento.

No asumir que una paleta garantiza por sí sola la conformidad de todas las pantallas.

### Área táctil

- Referencia de altura visual del botón: 48 px.
- En Android: utilizar como referencia mínima un área táctil de 48 × 48 dp.
- El área táctil puede ser mayor que el dibujo visible del icono.

### Validaciones posteriores

- Contraste de combinaciones reales.
- Escalado de texto sin recortes.
- Labels persistentes.
- Mensajes de error comprensibles.
- Indicador de foco visible en web.
- Navegación por teclado en el panel administrativo.
- Nombres accesibles para botones con iconos.
- Orden de lectura lógico.
- Significado claro de estados GPS y conexión.
- Antigüedad visible de la información.
- Marcadores legibles en diferentes fondos y niveles de zoom.

T049 no constituye una auditoría de accesibilidad de una aplicación terminada.

## 12. Ejemplos de uso

Los datos siguientes son contenido demostrativo, no telemetría real.

### 12.1. Card de micro

```text
Micro 04
Ruta 10

Llegada aproximada
6 min

● Activo                       32 km/h
Actualizado hace 5 s

[ Ver ubicación ]
```

| Elemento | Referencia visual |
| --- | --- |
| Micro 04 | H3: identificación del vehículo. |
| Ruta 10 | Etiqueta de ruta. |
| Llegada aproximada | Body: explicación del ETA. |
| 6 min | Display: dato destacado. |
| Activo | Badge con símbolo y tratamiento semántico. |
| 32 km/h | Dato secundario de la muestra. |
| Actualizado hace 5 s | Caption: antigüedad de la información. |
| Ver ubicación | Botón Primary. |

#### Composición

- Superficie blanca.
- `Radius/Large`.
- Padding de 24 px.
- Elevación Small.
- Jerarquía centrada en micro y llegada aproximada.

La presencia de velocidad en el ejemplo no define una funcionalidad adicional ni su mecanismo de cálculo.

### 12.2. Estado GPS

```text
GPS
✓ Activo
Transmitiendo ubicación correctamente.
```

#### Composición

- Título breve.
- Estado explícito.
- Mensaje de apoyo.
- Color semántico acompañado de símbolo y texto.

### 12.3. Selector de ruta

```text
Selecciona tu ruta

[ Ruta 10 ]  [ Ruta 14 ]  [ Ruta 30 ]
```

#### Composición

- Título claro.
- Chips con `Radius/Full`.
- Espaciado consistente.
- Selección identificable.

Los nombres de ruta son ejemplos de la guía, no un catálogo oficial validado del transporte de Tacna.

## 13. Organización en Figma

### Estructura

```text
01 - UI Style Guide
└── RutaTacna - UI/UX Style Guide
    ├── Section/Cover
    ├── Section/Brand
    ├── Section/Colors
    ├── Section/Typography
    ├── Section/Spacing
    ├── Section/Border Radius
    ├── Section/Elevation
    ├── Section/Iconography
    ├── Section/Component Foundation
    ├── Section/Map Foundation
    ├── Section/Design Tokens
    ├── Section/Accessibility
    └── Section/Usage Examples
```

### Auto Layout

| Contenedor | Organización |
| --- | --- |
| Frame principal | Vertical. |
| Secciones | Vertical. |
| Grupos de colores | Horizontal. |
| Cards | Vertical. |
| Botones | Horizontal. |

### Reglas de organización

- Mantener márgenes consistentes.
- Reutilizar los tokens de espaciado.
- Evitar posicionamiento manual innecesario.
- Permitir edición posterior del contenido.
- Separar claramente cada sección.
- Mantener títulos y descripciones con la misma estructura.

### Nomenclatura semántica

```text
Color/Primary/600

Text/H1
Text/Body
Text/Caption

Button/Primary
Button/Secondary

Card/Default

Status/Success
Status/Warning
Status/Error

Map/Bus
Map/BusSelected
Map/UserLocation
```

Evitar nombres genéricos como:

```text
Rectangle 345
Frame 128
Group 67
```

### Documentación y recursos nativos

- La guía contiene muestras visuales y nomenclatura de tokens.
- Se crearon los 10 estilos tipográficos nativos indicados en la sección 3.
- La existencia de estos estilos no implica que toda la composición esté vinculada a ellos.
- La documentación de tokens no equivale a una colección completa de variables nativas ya creada y enlazada.
- No se creó un conjunto exhaustivo de componentes funcionales o variantes.

## 14. Criterios de aceptación y continuidad

### Lista de revisión de T049

- [ ] La identidad de RutaTacna se reconoce de forma consistente.
- [ ] Primary 600 es el color principal.
- [ ] El verde no sustituye la identidad azul.
- [ ] Success, Warning y Error se distinguen mediante color, símbolo y texto.
- [ ] La familia Inter se utiliza consistentemente.
- [ ] Existe una jerarquía tipográfica clara.
- [ ] Los espaciados siguen la escala de múltiplos de 4.
- [ ] Los radios son consistentes por tipo de elemento.
- [ ] Las sombras corresponden a los niveles definidos.
- [ ] Los iconos mantienen el mismo lenguaje outline.
- [ ] Los elementos del mapa se diferencian.
- [ ] Los fundamentos de componentes reutilizan los mismos valores.
- [ ] El contenido es legible.
- [ ] La composición no está sobrecargada.
- [ ] La nomenclatura puede trasladarse a variables CSS.
- [ ] Los ejemplos son composiciones pequeñas, no pantallas completas.
- [ ] No se incorporaron funcionalidades fuera de alcance.

Las casillas son una plantilla de revisión del equipo. No representan una aprobación formal ni una certificación de accesibilidad.

### Trabajo posterior

1. Validar los fundamentos con el equipo de diseño y desarrollo.
2. Definir variables nativas y vinculaciones en una tarea independiente.
3. Crear componentes reutilizables.
4. Especificar estados y comportamientos completos.
5. Diseñar Login y Registro.
6. Diseñar las pantallas del Pasajero.
7. Aplicar la guía al mapa real, detalle del micro y ETA.
8. Diseñar Modo Conductor.
9. Diseñar el Panel Administrador.
10. Construir y evaluar prototipos cuando corresponda.
11. Validar accesibilidad y legibilidad en dispositivos reales.

### Mantenimiento

- Actualizar este documento cuando cambien valores aprobados.
- Mantener sincronizados Figma y la implementación.
- Registrar cambios de versión.
- Evitar modificaciones locales sin documentación.
- Revisar estados, contraste y jerarquía cuando cambie un token.

### Historial

| Versión | Descripción |
| --- | --- |
| 1.0 | Base visual T049: identidad, paleta, tipografía, espaciado, radios, elevación, iconografía, fundamentos de componentes y mapa, tokens, accesibilidad y ejemplos. |

---

**RutaTacna · UI/UX Style Guide · Design System Foundation · Version 1.0**

**Prioridades:** simplicidad · claridad · consistencia · legibilidad · movilidad · accesibilidad · reutilización.


## Contenido

_Pendiente de completar._
