# Diccionario de Datos
> **Estado:** En revisión
> **Responsable:** David Montador
> **Relacionado:** [T008]

## Sistema de Transporte Público — Tacna

---

### 1. USUARIO
Entidad base que almacena los datos comunes a los tres roles del sistema (pasajero, conductor, administrador).

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del usuario | PK | No |
| **nombre** | VARCHAR(100) | Nombre(s) del usuario | — | No |
| **apellido** | VARCHAR(100) | Apellido(s) del usuario | — | No |
| **correo** | VARCHAR(150) | Correo electrónico, usado para inicio de sesión | UNIQUE | No |
| **password_hash** | VARCHAR(255) | Contraseña del usuario, almacenada encriptada (hash) | — | No |

---

### 2. PASAJERO
Subtipo de Usuario con permisos de pasajero.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del registro | PK | No |
| **usuario_id** | INT | Referencia al usuario base correspondiente | FK → Usuario(id) | No |

---

### 3. CONDUCTOR
Subtipo de Usuario con permisos de conductor, vinculado a la empresa que lo emplea.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del registro | PK | No |
| **usuario_id** | INT | Referencia al usuario base correspondiente | FK → Usuario(id) | No |
| **empresa_id** | INT | Empresa de transporte a la que pertenece | FK → Empresa(id) | No |
| **estado** | VARCHAR(30) | Estado operativo del conductor (ej. disponible, en_recorrido, desconectado) | — | No |

---

### 4. ADMINISTRADOR
Subtipo de Usuario con permisos de gestión de la plataforma.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del registro | PK | No |
| **usuario_id** | INT | Referencia al usuario base correspondiente | FK → Usuario(id) | No |

---

### 5. EMPRESA
Empresa de transporte dueña de las rutas y empleadora de los conductores.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único de la empresa | PK | No |
| **ruc** | VARCHAR(11) | Registro Único de Contribuyente de la empresa | UNIQUE | No |
| **razon_social** | VARCHAR(150) | Nombre legal/comercial de la empresa | — | No |

---

### 6. RUTA
Línea de transporte fija, con su trazado georreferenciado.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único de la ruta | PK | No |
| **empresa_id** | INT | Empresa dueña de la ruta | FK → Empresa(id) | No |
| **administrador_id** | INT | Administrador que registró/gestiona la ruta | FK → Administrador(id) | No |
| **nombre_ruta** | VARCHAR(100) | Nombre o código de la ruta (ej. "16", "10-B") | — | No |
| **trazado_ruta** | GEOMETRY (LineString, PostGIS) | Trazado geográfico completo del recorrido | — | No |

---

### 7. MICRO
Unidad vehicular física que circula haciendo el recorrido de una ruta.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del micro | PK | No |
| **ruta_id** | INT | Ruta a la que está asignado actualmente | FK → Ruta(id) | No |
| **conductor_id** | INT | Conductor asignado actualmente a la unidad | FK → Conductor(id) | Sí |
| **placa** | VARCHAR(10) | Placa vehicular | UNIQUE | No |
| **estado** | VARCHAR(30) | Estado operativo (ej. activo, mantenimiento, inactivo) | — | No |

---

### 8. POSICION_GPS
Registro histórico de ubicaciones reportadas por cada micro, usado para el tracking en tiempo real y el cálculo de ETA.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del registro | PK | No |
| **micro_id** | INT | Micro que reportó esta posición | FK → Micro(id) | No |
| **latitud** | DECIMAL(9,6) | Coordenada de latitud | — | No |
| **longitud** | DECIMAL(9,6) | Coordenada de longitud | — | No |
| **fecha_hora** | DATETIME | Marca de tiempo exacta del reporte GPS | — | No |

---

### 9. PLAN
Catálogo de planes de suscripción (gratuito/Premium).

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único del plan | PK | No |
| **nombre_plan** | VARCHAR(50) | Nombre comercial del plan (ej. "Gratis", "Premium") | — | No |
| **costo** | DECIMAL(6,2) | Precio del plan | — | No |

---

### 10. SUSCRIPCION
Vigencia de un pasajero sobre un plan determinado.

| Campo | Tipo de dato | Descripción | Llave | Nulo |
| :--- | :--- | :--- | :---: | :---: |
| **id** | INT | Identificador único de la suscripción | PK | No |
| **pasajero_id** | INT | Pasajero suscrito | FK → Pasajero(id) | No |
| **plan_id** | INT | Plan contratado | FK → Plan(id) | No |
| **fecha_inicio** | DATE | Fecha de inicio de la vigencia | — | No |
| **fecha_vencimiento** | DATE | Fecha en que vence la vigencia | — | No |
| **estado** | VARCHAR(20) | Estado de la suscripción (ej. activo, vencido, cancelado) | — | No |

---

> **Nota sobre los tipos de dato:**
> Son sugerencias pensadas para **PostgreSQL** (dado que se usará PostGIS para `trazado_ruta`); ajustar los tamaños de `VARCHAR` o el tipo `GEOMETRY` si se utiliza otro motor de base de datos.
