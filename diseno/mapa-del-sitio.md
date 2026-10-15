# Mapa del sitio

> **Estado:** En revision
> **Responsable:** Alex Huaracha
> **Relacionado:** [inventario-de-vistas.md](inventario-de-vistas.md), [guia-de-estilos.md](guia-de-estilos.md)

## 1. Introducción

La arquitectura de contenido de Go Tacna organiza las pantallas y funcionalidades del sistema según los perfiles de usuario y los requerimientos del proyecto. Su propósito es establecer una navegación clara y facilitar el acceso a las funcionalidades principales.

El mapa del sitio comprende el panel web de administración y la aplicación móvil Android, que incluye los modos Pasajero y Conductor.

## 2. Objetivo

Definir la organización jerárquica de las interfaces, los accesos y los flujos de navegación de Go Tacna, considerando los requerimientos funcionales y las restricciones de cada perfil.

## 3. Perfiles de usuario

**Pasajero:** consulta las rutas disponibles, visualiza los micros activos, obtiene información de ubicación y consulta el tiempo estimado de llegada.

**Conductor:** utiliza el Modo Conductor para gestionar el inicio y finalización de su recorrido, permitiendo la transmisión de su ubicación mientras el recorrido permanece activo.

**Administrador:** gestiona empresas, rutas, micros, conductores y usuarios, además de supervisar el estado de las unidades registradas.

## 4. Arquitectura de contenido del panel web

### 4.1. Estructura de navegación

- Inicio de sesión
  - Panel principal
    - Gestión de empresas
    - Gestión de rutas
    - Gestión de micros
    - Gestión de conductores
    - Gestión de usuarios
    - Supervisión de flota
      - Micros activos
      - Micros sin actualización reciente
      - Última ubicación registrada     

### 4.2. Pantallas y rutas

| ID | Pantalla | Ruta propuesta | Requisitos |
|---|---|---|---|
| WEB-01 | Inicio de sesión | `/login` | RF-02 |
| WEB-02 | Panel principal | `/admin` | RF-15, RF-16 |
| WEB-03 | Gestión de empresas | `/admin/empresas` | RF-15 |
| WEB-04 | Gestión de rutas | `/admin/rutas` | RF-15 |
| WEB-05 | Gestión de micros | `/admin/micros` | RF-15 |
| WEB-06 | Gestión de conductores | `/admin/conductores` | RF-15 |
| WEB-07 | Gestión de usuarios | `/admin/usuarios` | RF-15 |
| WEB-08 | Supervisión de flota | `/admin/monitoreo` | RF-16 |

Las rutas indicadas son propuestas de diseño y deberán validarse durante la implementación del frontend web.

## 5. Arquitectura de contenido de la aplicación móvil

### 5.1. Modo Pasajero

- Registro
- Inicio de sesión
- Pantalla principal
  - Consultar rutas disponibles
  - Seleccionar una ruta
  - Visualizar recorrido y paraderos
  - Visualizar micros activos en el mapa
    - Seleccionar un micro
    - Consultar información y última actualización
    - Consultar tiempo estimado de llegada (ETA)
  - Consultar micros cercanos mediante ubicación actual o punto seleccionado

### 5.2. Modo Conductor

- Inicio de sesión
- Pantalla principal del conductor
  - Consultar micro y ruta asignados
  - Iniciar recorrido
  - Recorrido activo
    - Transmisión GPS
    - Estado de conexión
  - Finalizar recorrido

### 5.3. Pantallas y rutas propuestas

| ID | Pantalla | Ruta conceptual | Perfil | Requisitos |
|---|---|---|---|---|
| MOV-01 | Registro | `/registro` | Pasajero | RF-01 |
| MOV-02 | Inicio de sesión | `/login` | Pasajero / Conductor | RF-02 |
| MOV-03 | Consulta de rutas | `/pasajero/rutas` | Pasajero | RF-05, RF-06 |
| MOV-04 | Mapa de micros | `/pasajero/mapa` | Pasajero | RF-07, RF-11, RF-12 |
| MOV-05 | Detalle de micro y ETA | Panel del mapa | Pasajero | RF-09, RF-10, RF-13 |
| MOV-06 | Inicio del conductor | `/conductor/inicio` | Conductor | RF-14 |
| MOV-07 | Recorrido activo | `/conductor/recorrido` | Conductor | RF-08, RF-14 |

Estas rutas representan la navegación conceptual y no implican que las pantallas ya estén implementadas.

## 6. Flujos principales de navegación

### 6.1. Pasajero

Inicio de sesión → Consultar rutas → Seleccionar ruta → Visualizar mapa → Seleccionar micro → Consultar información y ETA.

El pasajero también podrá utilizar su ubicación actual o seleccionar un punto del mapa para consultar micros cercanos.

### 6.2. Conductor

Inicio de sesión → Consultar micro y ruta asignados → Iniciar recorrido → Transmitir ubicación GPS → Finalizar recorrido.

### 6.3. Administrador

Inicio de sesión → Panel principal → Seleccionar módulo de administración → Consultar, registrar, modificar o desactivar registros.

Para la supervisión: Inicio de sesión → Panel principal → Supervisión de flota → Consultar estado y última ubicación de los micros.

## 7. Reglas y restricciones de navegación

- El acceso a las funcionalidades se restringe según el perfil de usuario.
- El conductor únicamente puede transmitir la ubicación del micro autorizado.
- La posición de un micro que ha dejado de transmitir no debe presentarse como actual.
- El tiempo de llegada se identifica siempre como estimado.
- El plan gratuito permite visualizar como máximo dos micros simultáneamente.
- La aplicación debe comunicar los problemas de GPS, conexión y ausencia de unidades disponibles.
- La actualización de ubicaciones no debe requerir que el pasajero refresque manualmente el mapa.

## 8. Funcionalidades futuras

No forman parte de la navegación obligatoria del MVP:

- Recuperación de cuentas.
- Acceso público sin cuenta, pendiente de decisión.
- Gestión de suscripciones Premium.
- Ocupación de los micros.
- Alertas de proximidad y favoritos.
- Historial de recorridos.
- Planificación avanzada de viajes.

Estas funcionalidades podrán incorporarse a la arquitectura de contenido en futuras versiones.

## 9. Consideraciones finales

La arquitectura de contenido propuesta permite organizar las funcionalidades del sistema de acuerdo con los perfiles definidos, manteniendo separados el panel web administrativo y los dos modos de la aplicación móvil.

El mapa del sitio constituye la referencia para el diseño de prototipos, el desarrollo de las interfaces y la posterior validación de navegación y accesibilidad.

## 10. Diagrama general de navegación


 ## Diagrama general de navegación

El siguiente diagrama representa la arquitectura de contenido
del panel administrativo web y de la aplicación móvil Go Tacna.

La aplicación móvil contempla dos perfiles: Pasajero y Conductor.

La fuente editable del diagrama se encuentra en
[mapa-del-sitio.mmd](../diagramas/fuente/mapa-del-sitio.mmd).

