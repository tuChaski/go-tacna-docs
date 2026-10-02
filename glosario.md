# Glosario oficial

> **Estado:** Aprobado
> **Responsable:** Todo el equipo
> **Relacionado:** [CONTRIBUTING.md](CONTRIBUTING.md)

Usar siempre estos términos en la documentación.

| Término | Significado | No usar |
|---|---|---|
| **Micro** | Vehículo de transporte público que se rastrea | bus, combi |
| **Unidad** | Sinónimo formal de micro en textos técnicos | |
| **Ruta** | Línea de transporte con su trazado en el mapa | línea, recorrido |
| **Recorrido** | Viaje activo que el conductor inicia y finaliza | |
| **Paradero** | Punto de espera de una ruta | parada, checkpoint |
| **Pasajero** | Usuario que consulta rutas y micros | cliente, usuario final |
| **Conductor** | Persona que transmite la ubicación del micro | chofer |
| **Modo Conductor** | Sección de la app usada por el conductor | app de conductor |
| **Administrador** | Gestiona empresas, rutas, micros y conductores | admin |
| **Tiempo estimado de llegada (ETA)** | Cálculo aproximado, nunca una hora exacta | tiempo exacto |
| **Premium** | Plan de pago con funciones adicionales | |
| **MVP** | Primera versión funcional con lo mínimo indispensable | |

## Términos aún por definir

Estos términos aparecen en el proyecto pero todavía no tienen una decisión oficial. Hasta que se definan aquí, se evita usarlos en la documentación o se marcan como *(por definir)*.

| Término | Duda abierta | Responsable |
|---|---|---|
| **Salas** (`ruta:{id}`) | ¿Es parte del contrato público de WebSocket o un detalle de implementación? | David |
| **ID de unidad** | ¿`bus_id` del contrato actual pasa a ser `micro_id`? | Royfrankly |
| **Tiempo real** | ¿qué latencia máxima se considera aceptable? | Edison |