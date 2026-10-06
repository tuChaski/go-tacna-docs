# Alcance del MVP

> **Estado:** Borrador
> **Responsable:** Todo el equipo
> **Relacionado:** [requerimientos-funcionales.md](requerimientos-funcionales.md), [../planificacion/](../planificacion/)

## Qué va aquí

- Qué entra en el MVP y qué queda para Premium o para versiones futuras.
- Criterio de cierre del MVP: qué tiene que funcionar para presentarlo.
- Lista de lo descartado y por qué.

El siguiente alcance integra las funciones confirmadas en la propuesta del equipo. Los puntos aún no acordados aparecen al final como decisiones pendientes.

## Objetivo

Entregar una primera versión funcional que permita al pasajero consultar micros en tiempo real en rutas incorporadas al sistema, al conductor transmitir la ubicación desde su teléfono y al administrador gestionar la cobertura inicial.

## Incluido en el MVP

### Pasajero

- Consultar las rutas disponibles y seleccionar una.
- Ver en el mapa el recorrido configurado y los micros activos de esa ruta.
- Seleccionar micros para consultarlos, respetando el límite de dos unidades visibles del plan gratuito.
- Consultar información básica del micro, su estado y la hora de la última ubicación recibida.
- Consultar la ubicación propia mediante permiso del dispositivo o seleccionar manualmente un punto en el mapa para buscar micros cercanos.
- Obtener una estimación de llegada basada inicialmente en distancia y velocidad disponible, sin incorporar tráfico ni congestión.
- Ver un aviso cuando no existan unidades activas, la ubicación esté desactualizada o falten datos para calcular el tiempo estimado.

### Conductor

- Iniciar sesión en el modo conductor de la misma aplicación.
- Utilizar el micro y la ruta que le fueron asignados.
- Iniciar y finalizar el recorrido.
- Transmitir periódicamente la ubicación obtenida mediante el GPS del teléfono mientras el recorrido esté activo.
- Recibir una indicación cuando el GPS o la conexión impidan transmitir correctamente.

### Administrador

- Registrar, modificar y desactivar empresas, rutas, micros y conductores.
- Asociar micros con empresas, rutas y conductores.
- Supervisar las unidades activas, las que no transmiten y la última ubicación recibida.
- Incorporar progresivamente la cobertura inicial sin cambios de código específicos para cada nueva empresa, ruta o micro.

## Fuera del MVP

- Suscripciones, pagos y administración del plan Premium.
- Visualización de más de dos micros simultáneos.
- Aforo u ocupación, hasta definir cómo se obtiene y mantiene ese dato.
- Alertas de proximidad y favoritos.
- Historial de recorridos y tiempos.
- Comparación avanzada y recomendación de alternativas de viaje.
- Predicciones basadas en datos históricos y estimación que considere tráfico o congestión.
- Experiencia sin publicidad.
- Compatibilidad móvil con iOS, hasta definir su alcance.
- Consulta sin cuenta: se debe decidir si las consultas básicas requieren autenticación.

## Criterio de cierre

El MVP se considera presentable cuando:

1. El administrador puede registrar y asociar las entidades necesarias para una ruta operativa.
2. Un conductor autenticado puede iniciar el recorrido, transmitir ubicación desde el teléfono y finalizarlo.
3. Un pasajero puede seleccionar una ruta, ver los micros activos y sus últimas ubicaciones, consultar información básica y obtener un tiempo de llegada etiquetado como estimado cuando existan datos suficientes.
4. La aplicación informa los casos principales de GPS desactivado, pérdida de conexión, ausencia de micros y ubicación desactualizada, sin presentar datos antiguos como actuales.
5. Las pruebas funcionales de los flujos anteriores pasan en el ambiente de demostración.

## Decisiones pendientes para cerrar el alcance

- Frecuencia de transmisión GPS y umbral para marcar una unidad como desconectada.
- Duración durante la que se muestra la última ubicación después de perder conexión.
- Parámetros de exactitud y límites de validez para ubicación, velocidad y cálculo de ETA.
- Si las consultas básicas requieren cuenta o son públicas.
- Límites exactos y mecanismo de activación del plan Premium.
- Objetivos numéricos de rendimiento y disponibilidad.
- Relación entre el alcance inicial Android y los clientes web del proyecto.
