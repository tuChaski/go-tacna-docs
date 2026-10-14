## T051 — Prototipo interactivo del Pasajero

Estado: En revisión  
Responsable: Alex Huaracha  
Dependencia del Gantt: T049  
Referencias principales: RF-05 a RF-10  
Requisitos complementarios: RF-04 y RNF-04  
Plataforma: Android  
Herramienta: Figma

### DESCRIPCION

Documenta el prototipo T051 del Pasajero: mapa, rutas, detalle de unidades, ETA, puntos de espera, filtros, favoritos y consulta como invitado.

Incluye enlaces de Figma, restricciones del alcance, escenarios alternativos y verificación de las conexiones. Los resultados son simulados; quedan pendientes la prueba en presentación y la aprobación del equipo.

Relacionado con T051 del Gantt.

### 1. Objetivo

Representar la consulta de rutas, selección de micros, ubicación, recorrido y tiempo estimado de llegada de Go Tacna mediante un prototipo navegable.

Se reutilizan componentes del kit T092 y los fundamentos visuales de T049.

### 2. Enlaces

- [Pantallas del Pasajero](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=73-1148)
- [Guía de pruebas T051](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=208-848)
- [Inicio del recorrido de invitado](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=237-709)

Página del archivo: `04 - Passenger App`.

### 3. Funcionalidades representadas

| Área | Diseño incluido |
|---|---|
| Mapa | Ubicación del pasajero y micros seleccionados |
| Rutas | Catálogo, selección y escenario de rutas cercanas |
| Unidades | Detalle independiente de Micro 01, Micro 02 y Micro 03 |
| Información | Identificador, empresa, línea, sentido, distancia, velocidad y última actualización |
| ETA | Estimación hacia un punto de espera |
| Punto de espera | Plaza de Armas y Av. Pinto como ejemplos |
| Filtros | Selección y desmarcado de hasta dos unidades simultáneas |
| Recorrido | Trazado ilustrativo de la ruta seleccionada |
| Favoritos | Guardado, consulta, confirmación de eliminación y estados alternativos |
| Invitado | Consulta pública con acceso al login al intentar guardar favoritos |

### 4. Navegación principal

El recorrido configurado permite:

1. Seleccionar Línea 10 desde el mapa.
2. Seleccionar un micro.
3. Pulsar «Ver ubicación».

Este recorrido representa el acceso a la ubicación en tres toques. Su validación específica se documentará en T093.

Los recorridos de cambio de punto de espera conservan la unidad seleccionada.

### 5. Restricciones de alcance

- La cobertura de demostración corresponde a Tacna.
- La consulta básica no exige una cuenta.
- El registro público corresponde exclusivamente a pasajeros.
- El invitado debe pasar por el acceso antes de utilizar favoritos.
- El seguimiento gratuito representa un máximo de dos micros simultáneos.
- El catálogo puede listar más unidades que las seleccionadas en el mapa.
- Los favoritos básicos se incluyen por lo solicitado en T051; su cuota queda pendiente de definición.
- No se incluyen pagos, aforo, alertas Premium, tráfico en tiempo real ni planificación avanzada.

### 6. Estados y escenarios alternativos

Se representan:

- Carga de información.
- Búsqueda sin resultados.
- Ruta sin micros activos.
- Permiso de ubicación y ubicación no disponible.
- Desconexión y error del servicio.
- Ubicación desactualizada.
- Recorrido finalizado.
- ETA no disponible.
- Favoritos vacíos o no disponibles.
- Error al guardar un favorito.
- Confirmación de eliminación.
- Sesión caducada y cierre de sesión.
- Registro de pasajero y acceso con credenciales incorrectas.

Los estados de desconexión conservan la ausencia de información en vivo. El escenario de recorrido finalizado excluye la unidad finalizada de su catálogo activo.

### 7. Datos de demostración

Los nombres, unidades, empresas y recorridos son ficticios o ilustrativos.

Los ETA de ejemplo utilizan distancia sobre el recorrido y velocidad registrada:

`ETA en minutos = distancia en km / velocidad en km/h × 60`

Con una velocidad de 28 km/h, las distancias de 1.2, 2.8 y 4.1 km se representan mediante estimaciones redondeadas de 3, 6 y 9 minutos.

No se consideran tráfico, accidentes ni desvíos.

### 8. Diseño visual

Se actualizaron cabeceras, tarjetas, bordes, sombras y jerarquía visual, manteniendo la tipografía Inter y la identidad de Go Tacna.

Se eliminaron las dos adaptaciones antiguas de 360 y 412 px para evitar duplicaciones de diseño.

### 9. Verificación y límites

Se inspeccionaron las conexiones y capturas de las pantallas modificadas. La última comprobación no encontró destinos inexistentes ni conexiones del recorrido público hacia pantallas autenticadas, salvo el acceso explícito al login.

Figma representa resultados simulados. No implementa autenticación, GPS, permisos del sistema, cálculo real ni persistencia de favoritos.

La prueba en modo presentación y la aprobación del equipo quedan pendientes. La seguridad, accesibilidad y funcionamiento real deberán verificarse durante la implementación.