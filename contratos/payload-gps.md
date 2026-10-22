## Esquemas JSON (Draft 7)

Todos los esquemas usan `$id` con versión semver para trazabilidad.

---

### 1. HTTP: POST /tracking/position (Request)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/tracking-position-request.json",
  "title": "Tracking Position Request",
  "type": "object",
  "required": ["lat", "lng", "speed"],
  "additionalProperties": false,
  "properties": {
    "lat": {
      "type": "number",
      "minimum": -90,
      "maximum": 90,
      "description": "Latitud en grados decimales (WGS84)"
    },
    "lng": {
      "type": "number",
      "minimum": -180,
      "maximum": 180,
      "description": "Longitud en grados decimales (WGS84)"
    },
    "speed": {
      "type": "number",
      "minimum": 0,
      "description": "Velocidad en metros por segundo (m/s)"
    }
  }
}
2. HTTP: POST /tracking/position (Response)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/tracking-position-response.json",
  "title": "Tracking Position Response",
  "type": "object",
  "required": ["ok"],
  "additionalProperties": false,
  "properties": {
    "ok": { "type": "boolean", "const": true }
  }
}
3. HTTP: POST /tracking/stop (Response)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/tracking-stop-response.json",
  "title": "Tracking Stop Response",
  "type": "object",
  "required": ["ok"],
  "additionalProperties": false,
  "properties": {
    "ok": { "type": "boolean", "const": true }
  }
}
4. HTTP: Errores comunes (400, 401, 403, 429)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/http-error.json",
  "title": "HTTP Error Response",
  "type": "object",
  "required": ["error"],
  "additionalProperties": false,
  "properties": {
    "error": { "type": "string" }
  }
}
5. WebSocket: route:join (Cliente → Servidor)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/route-join.json",
  "title": "Route Join Request",
  "type": "integer",
  "minimum": 1,
  "description": "ID de la ruta a suscribirse"
}
6. WebSocket: route:leave (Cliente → Servidor)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/route-leave.json",
  "title": "Route Leave Request",
  "type": "integer",
  "minimum": 1,
  "description": "ID de la ruta a desuscribirse"
}

7. WebSocket: route:joined (Servidor → Cliente)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/route-joined.json",
  "title": "Route Joined Response",
  "type": "object",
  "required": ["rutaId", "micros"],
  "additionalProperties": false,
  "properties": {
    "rutaId": { "type": "integer", "minimum": 1 },
    "micros": {
      "type": "array",
      "items": { "$ref": "https://tuchaski.org/schemas/micro.json" }
    }
  }
}

8. WebSocket: Micro (modelo común)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/micro.json",
  "title": "Micro",
  "type": "object",
  "required": ["microId", "rutaId", "lat", "lng", "speed", "status", "lastSeen"],
  "additionalProperties": false,
  "properties": {
    "microId": { "type": "integer", "minimum": 1 },
    "rutaId": { "type": "integer", "minimum": 1 },
    "lat": { "type": "number", "minimum": -90, "maximum": 90 },
    "lng": { "type": "number", "minimum": -180, "maximum": 180 },
    "speed": { "type": "number", "minimum": 0 },
    "status": { "type": "string", "enum": ["moviendo", "detenido", "desconectado"] },
    "lastSeen": { "type": "integer", "minimum": 0, "description": "Timestamp ms (Date.now())" }
  }
}


9. WebSocket: micro:position (Servidor → Cliente)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/micro-position.json",
  "title": "Micro Position Event",
  "$ref": "https://tuchaski.org/schemas/micro.json"
}


10. WebSocket: micro:offline (Servidor → Cliente)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/micro-offline.json",
  "title": "Micro Offline Event",
  "type": "object",
  "required": ["microId", "lastSeen"],
  "additionalProperties": false,
  "properties": {
    "microId": { "type": "integer", "minimum": 1 },
    "lastSeen": { "type": "integer", "minimum": 0, "description": "Timestamp ms del último GPS" }
  }
}
11. WebSocket: micro:stopped (Servidor → Cliente)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/micro-stopped.json",
  "title": "Micro Stopped Event",
  "type": "object",
  "required": ["microId"],
  "additionalProperties": false,
  "properties": {
    "microId": { "type": "integer", "minimum": 1 }
  }
}
12. WebSocket: eta:request (Cliente → Servidor)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/eta-request.json",
  "title": "ETA Request",
  "type": "object",
  "required": ["microId", "lat", "lng"],
  "additionalProperties": false,
  "properties": {
    "microId": { "type": "integer", "minimum": 1 },
    "lat": { "type": "number", "minimum": -90, "maximum": 90 },
    "lng": { "type": "number", "minimum": -180, "maximum": 180 }
  }
}
13. WebSocket: eta:response (Servidor → Cliente)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/eta-response.json",
  "title": "ETA Response",
  "oneOf": [
    {
      "type": "object",
      "required": ["microId", "etaSeconds", "estimated"],
      "additionalProperties": false,
      "properties": {
        "microId": { "type": "integer", "minimum": 1 },
        "etaSeconds": { "type": "integer", "minimum": 0 },
        "estimated": { "type": "boolean", "const": true }
      }
    },
    {
      "type": "object",
      "required": ["error"],
      "additionalProperties": false,
      "properties": {
        "error": { "type": "string" }
      }
    }
  ]
}
14. WebSocket: error (Servidor → Cliente)
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "https://tuchaski.org/schemas/ws-error.json",
  "title": "WebSocket Error",
  "type": "object",
  "required": ["message"],
  "additionalProperties": false,
  "properties": {
    "message": { "type": "string" }
  }
}

Headers requeridos:
  Authorization: Bearer <jwt_token>
  Content-Type: application/json

JWT Claims requeridos: role=conductor, microId, rutaId  
  Ver jwt-claims.md (jwt-claims.md)

Uso y validación
Instalar validador
  npm install ajv ajv-formats

Validar en Node.js
  import Ajv from 'ajv';
  import addFormats from 'ajv-formats';
  import fs from 'fs';

  const ajv = new Ajv({ allErrors: true, strict: false });
  addFormats(ajv);

  // Cargar schema remoto o local
  const schema = JSON.parse(fs.readFileSync('micro.json'));
  const validate = ajv.compile(schema);

  const data = { microId: 12, rutaId: 3, lat: -18.0146, lng: -70.2536, speed: 8.5, status: 'moviendo', lastSeen: Date.now() };

  if (validate(data)) {
    console.log('✅ Válido');
  } else {
    console.log('❌ Inválido:', validate.errors);
  }

Versionado y cambios
  - $id incluye versión semver implícita en la URL
  - Breaking change (campo requerido eliminado, tipo cambiado) → nueva versión mayor en URL
  - Cambio compatible (campo opcional agregado, enum extendido) → versión menor
  - Mantener historial en CHANGELOG.md del repo docs
Referencias
  - eventos-websocket.md (eventos-websocket.md) - Protocolo completo con ejemplos
  - openapi.yaml (openapi.yaml) - Endpoints HTTP REST
  - jwt-claims.md (jwt-claims.md) - Claims JWT para conductor
  - secuencia-gps-eta.mmd (../diagramas/fuente/secuencia-gps-eta.mmd) - Diagrama de secuencia