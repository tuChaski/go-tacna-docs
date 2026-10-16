# Modelo de datos

> **Estado:** Borrador basado en las migraciones actuales
> **Responsable:** David Montoya
> **Relacionado:** [../diagramas/fuente/erd.mmd](../diagramas/fuente/erd.mmd), [arquitectura.md](arquitectura.md)

## Estado implementado

Las tablas siguientes corresponden a las migraciones presentes en `go-tacna-backend/gotacna-backend-core/database/migrations/`. El modelo evoluciona; al cambiar una migración, actualizar este resumen y el ERD de [../diagramas/fuente/erd.mmd](../diagramas/fuente/erd.mmd).

| Tabla | Columnas de dominio | Relaciones y restricciones |
|---|---|---|
| `users` | `name`, `email`, `password`, `role`, `activo`, campos base Laravel | `role`: `pasajero`, `conductor` o `admin`; `activo` booleano |
| `empresas` | `nombre`, `activo` | Una empresa tiene rutas y micros |
| `rutas` | `empresa_id`, `nombre`, `descripcion`, `trazado` | Pertenece a empresa; `trazado` es `text` nullable |
| `paraderos` | `nombre`, `latitud`, `longitud` | Se asocia a rutas mediante `paradero_ruta` |
| `paradero_ruta` | `ruta_id`, `paradero_id`, `orden` | Relación N:M; unicidad de ruta/paradero y de ruta/orden |
| `micros` | `empresa_id`, `placa`, `activo` | Placa única; pertenece a empresa |
| `conductores` | `usuario_id`, `micro_id`, `ruta_id` | `usuario_id` único; micro y ruta pueden ser null |
| `posiciones` | `micro_id`, `latitud`, `longitud`, `velocidad`, `recorded_at` | Pertenece a micro; índice compuesto en `micro_id`, `recorded_at` |

### Geoespacialidad

PostGIS está habilitado en la base de datos del entorno Docker, pero el esquema migrado actualmente guarda el trazado como texto y las coordenadas como valores numéricos (`decimal`). No declarar que las columnas son `geometry(Point)` o `geometry(LineString)` hasta migrarlas explícitamente a esos tipos.

La API Laravel crea filas en `posiciones` cuando un conductor reporta una lectura. La difusión a clientes por Socket.IO corresponde al Location Service y es una integración aparte.

## Relaciones principales

```text
Empresa 1 ── N Ruta
Empresa 1 ── N Micro
Ruta N ── M Paradero (paradero_ruta.orden define secuencia)
User 1 ── 0..1 Conductor
Micro 1 ── N Posición
Micro 1 ── 0..N Conductor
Ruta 1 ── 0..N Conductor
```

El `DatabaseSeeder` crea datos de prueba de empresas, rutas, paraderos, micros y conductores para Tacna. Sus cuentas son solo para desarrollo; no reutilizar credenciales de seeders en producción.
