# Eventos WebSocket (Socket.IO)

> **Estado:** Aprobado
> **Responsable:** David Montador
> **Relacionado:** [openapi.yaml](openapi.yaml), [jwt-claims.md](jwt-claims.md), [payload-gps.md](payload-gps.md), [../diagramas/fuente/secuencia-gps-eta.mmd](../diagramas/fuente/secuencia-gps-eta.mmd)


## 1. Visión general

Este documento define el protocolo y contrato de eventos WebSocket para la difusión de posiciones GPS en tiempo real entre conductores y pasajeros.

- **Transporte:** Socket.IO sobre WebSocket (con fallback a polling)
- **Autenticación:** JWT en endpoints HTTP (`/tracking/*`); WebSocket sin auth directo (filtrado por salas)
- **Salas:** `ruta:{rutaId}` — cada pasajero solo recibe eventos de su ruta
- **Frecuencia GPS:** Conductor envía cada 3–5 segundos
- **Timeout offline:** 120 segundos sin señal → estado `desconectado`
- **Checker offline:** Timer cada 15 segundos

---

## 2. Eventos: Cliente → Servidor

### 2.1 `route:join`
Une al pasajero a la sala de una ruta para recibir posiciones.

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `rutaId` | integer | ✓ | ID de la ruta a suscribirse |

**Ejemplo:**
```json
1
3
Respuesta: route:joined (ver 3.1)
2.2 route:leave
Sale de la sala de una ruta.
Campo	Tipo	Requerido	Descripción
rutaId	integer	✓	ID de la ruta a desuscribirse
Ejemplo:
3
Respuesta: Ninguna (solo sale de la sala)
2.3 eta:request
Solicita tiempo estimado de llegada (ETA) para un micro desde la posición del pasajero.
Campo	Tipo	Requerido	Descripción
microId	integer	✓	ID del micro objetivo
lat	number	✓	Latitud del pasajero [-90, 90]
lng	number	✓	Longitud del pasajero [-180, 180]
Ejemplo:
{
  "microId": 12,
  "lat": -18.0146,
  "lng": -70.2536
}
Respuesta: eta:response (ver 3.4) — vía callback (preferido) o evento
3. Eventos: Servidor → Cliente
3.1 route:joined
Confirmación de unión a ruta con lista actual de micros.
Campo	Tipo	Descripción
rutaId	integer	ID de la ruta
micros	array[Micro]	Array de micros activos en la ruta
Ejemplo:
{
  "rutaId": 3,
  "micros": [
    {
      "microId": 12,
      "rutaId": 3,
      "lat": -18.0146,
      "lng": -70.2536,
      "speed": 8.5,
      "status": "moviendo",
      "lastSeen": 1700000000000
    },
    {
      "microId": 15,
      "rutaId": 3,
      "lat": -18.0201,
      "lng": -70.2600,
      "speed": 0,
      "status": "detenido",
      "lastSeen": 1699999950000
    }
  ]
}
3.2 micro:position
Broadcast de nueva posición GPS de un micro (cada 3–5 seg).
Campo	Tipo	Descripción
microId	integer	ID del micro
rutaId	integer	ID de la ruta
lat	number	Latitud [-90, 90]
lng	number	Longitud [-180, 180]
speed	number	Velocidad en m/s (≥0)
status	string	"moviendo" | "detenido" | "desconectado"
lastSeen	integer	Timestamp ms (Date.now())
Ejemplo:
{
  "microId": 12,
  "rutaId": 3,
  "lat": -18.0150,
  "lng": -70.2540,
  "speed": 8.2,
  "status": "moviendo",
  "lastSeen": 1700000005000
}
Destino: Sala ruta:{rutaId} (todos los pasajeros suscritos a esa ruta)
3.3 micro:offline
Broadcast cuando un micro supera el timeout sin enviar GPS (120 seg por defecto).
Campo	Tipo	Descripción
microId	integer	ID del micro desconectado
lastSeen	integer	Timestamp ms del último GPS recibido
Ejemplo:
{
  "microId": 12,
  "lastSeen": 1699999880000
}
Destino: Sala ruta:{rutaId}  
Trigger: Timer interno cada 15s detecta now - lastSeen > OFFLINE_AFTER_MS
3.4 micro:stopped
Broadcast cuando el conductor finaliza el recorrido (POST /tracking/stop).
Campo	Tipo	Descripción
microId	integer	ID del micro detenido
Ejemplo:
{
  "microId": 12
}
Destino: Sala ruta:{rutaId}  
Estado interno: Micro pasa a status: "detenido"
3.5 eta:response
Respuesta a eta:request con tiempo estimado de llegada.
Campo	Tipo	Descripción
microId	integer	ID del micro consultado
etaSeconds	integer	Segundos estimados hasta llegada
estimated	boolean	Siempre true (no considera tráfico ni recorridos)
Ejemplo éxito:
{
  "microId": 12,
  "etaSeconds": 180,
  "estimated": true
}
Ejemplo error:
{
  "error": "Micro no encontrado"
}
Entrega: Vía callback del eta:request (preferido) o evento eta:response si no hay callback
3.6 error
Errores de validación en eventos de entrada.
Campo	Tipo	Descripción
message	string	Descripción del error
Ejemplos:
{ "message": "rutaId inválido" }
{ "message": "Parámetros inválidos: microId, lat, lng requeridos" }
4. Modelo Micro (común en route:joined y micro:position)
interface Micro {
  microId: number;           // ≥1
  rutaId: number;            // ≥1
  lat: number;               // -90 a 90
  lng: number;               // -180 a 180
  speed: number;             // ≥0 (m/s)
  status: 'moviendo' | 'detenido' | 'desconectado';
  lastSeen: number;          // timestamp ms (Date.now())
}
Estados:
- moviendo: Recibiendo GPS activo
- detenido: Conductor llamó POST /tracking/stop
- desconectado: Sin GPS > OFFLINE_AFTER_MS (default 120s)
5. Endpoints HTTP relacionados (Conductor)
Ver openapi.yaml (openapi.yaml) para schemas completos.
Endpoint	Auth	Body	Respuesta
POST /tracking/position	JWT Bearer	{lat, lng, speed}	202 {ok} / 400 / 401 / 429
POST /tracking/stop	JWT Bearer	{}	200 {ok} / 401 / 429
JWT Claims requeridos: role=conductor, microId, rutaId  
Ver jwt-claims.md (jwt-claims.md)
6. Parámetros de configuración
Variable	Default	Descripción
OFFLINE_AFTER_MS	120000	Ms sin GPS para marcar desconectado
CHECK_INTERVAL_MS	15000	Intervalo del timer offline checker
SPEED_SAMPLES_MAX	60	Máximo muestras de velocidad para promedio ETA
MIN_SPEED_MS	2	Velocidad mínima para cálculo ETA (m/s)
7. Secuencia típica
Ver diagrama: secuencia-gps-eta.mmd (../diagramas/fuente/secuencia-gps-eta.mmd)
1. Conductor → POST /tracking/position (cada 3–5s)
2. Servidor → Valida JWT, guarda en memoria, emite micro:position a sala ruta:{id}
3. Pasajero → route:join (rutaId) → recibe route:joined con micros actuales
4. Pasajero → eta:request {microId, lat, lng} → recibe eta:response
5. Conductor → POST /tracking/stop → emite micro:stopped
6. Timer 15s → Si micro sin GPS > 120s → emite micro:offline
8. Validación y testing
- Payloads: Ver payload-gps.md (payload-gps.md) para JSON Schemas
- Ejemplos: Todos los ejemplos arriba son válidos y probados
- Pruebas manuales: Conectar con socket.io-client, emitir eventos, verificar respuestas