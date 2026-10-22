## T050 — Prototipo interactivo de Login y Registro

> **Estado:** En revisión
> **Responsable:** Alex Huaracha
> **Requisitos relacionados:** RF-01, RF-02, RF-14, RF-15, RN-02
> **Plataforma:** Aplicación móvil Android
> **Herramienta:** Figma

### 1. Descripción

Se diseñó un prototipo interactivo para los procesos de registro e inicio de sesión de Go Tacna.

El prototipo permite representar la creación de cuentas de pasajero, el acceso mediante credenciales y la navegación hacia las funcionalidades correspondientes a cada perfil autorizado.

El diseño utiliza como referencia la guía de estilos T049 y el kit de componentes UI desarrollado en T092.

### 2. Enlaces de Figma

**Prototipo de autenticación:**

[Ver pantallas Login y Registro](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=73-1147)

**Guía de pruebas y permisos:**

[Ver guía de pruebas T050](https://www.figma.com/design/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=179-222)

### 3. Pantallas diseñadas

| Código | Pantalla | Descripción |
|---|---|---|
| A01 | Bienvenido | Pantalla inicial con opciones de registro e inicio de sesión |
| A02 | Iniciar sesión | Formulario de correo electrónico y contraseña |
| A03 | Crear cuenta | Formulario de registro del pasajero |
| A04 | Registro exitoso | Confirmación del registro |
| A05 | Error de inicio de sesión | Mensaje de credenciales incorrectas |
| A06 | Error de registro | Mensajes de validación de los datos |
| A08 | Inicio Pasajero | Destino de demostración del pasajero autenticado |
| A09 | Inicio Conductor | Destino de demostración del conductor autorizado |

Se incorporaron escenarios independientes para demostrar el inicio de sesión del pasajero, del conductor autorizado y el rechazo de credenciales incorrectas.

### 4. Flujos de navegación

**Registro de pasajero:**

Bienvenido → Crear cuenta → Validación → Registro exitoso → Iniciar sesión.

Si los datos no son válidos, se presenta un estado de error que permite corregirlos.

**Inicio de sesión del pasajero:**

Iniciar sesión → Autenticación y autorización → Inicio Pasajero.

**Inicio de sesión del conductor:**

Iniciar sesión → Autenticación y autorización → Verificación del perfil autorizado → Inicio Conductor.

**Credenciales incorrectas:**

Iniciar sesión → Error de autenticación → Corregir datos o regresar.

### 5. Restricciones de acceso

El diseño considera las siguientes reglas:

- El registro público permite crear únicamente cuentas de pasajero.
- El perfil del usuario no puede seleccionarse libremente después de iniciar sesión.
- El sistema debe determinar y autorizar el perfil desde el servidor.
- El administrador gestiona los conductores y sus asociaciones con micros y rutas.
- Solo un conductor autenticado y autorizado para una unidad puede iniciar un recorrido y transmitir su ubicación.
- Las cuentas inactivas o sin autorización no deben acceder a funcionalidades restringidas.

### 6. Casos de prueba considerados

Se elaboró una guía de pruebas que contempla los siguientes escenarios:

- Registro válido e inválido de pasajero.
- Correo previamente registrado.
- Inicio de sesión de pasajero autorizado.
- Inicio de sesión de conductor autorizado.
- Credenciales incorrectas.
- Cuenta inactiva o bloqueada.
- Conductor sin unidad o ruta asignada.
- Intento de acceso a funcionalidades de otro perfil.
- Intento de operar una unidad no autorizada.
- Sesión caducada.
- Fallos de conexión o del servidor.
- Prevención de envíos duplicados.
- Accesibilidad y navegación de retorno.

### 7. Alcance del prototipo

Las conexiones de navegación se configuraron mediante las herramientas de prototipado de Figma.

El prototipo utiliza escenarios simulados para representar resultados de autenticación correctos e incorrectos.

No incluye autenticación real, persistencia de usuarios ni validación de permisos en un servidor. Estas funcionalidades deberán implementarse posteriormente en el backend y en la aplicación.

### 8. Resultado

El prototipo documenta las pantallas principales de Login y Registro, así como los recorridos de navegación de pasajeros y conductores autorizados.

Su propósito es servir como referencia para la implementación de RF-01 y RF-02 y para las siguientes tareas de diseño y desarrollo.

La aprobación definitiva queda sujeta a la revisión del equipo y la validación de los flujos interactivos.
