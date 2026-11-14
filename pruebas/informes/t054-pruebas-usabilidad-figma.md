# T054 — Pruebas de usabilidad del prototipo de Go Tacna

> **Estado:** En revisión  
> **Responsable:** Alex Huaracha  
> **Relacionado:** [T054](https://github.com/tuChaski/go-tacna-frontend/issues/50), [T095](https://github.com/tuChaski/go-tacna-frontend/issues/51), [flujo de tres toques](../../diseno/flujo-navegacion-pasajero.md), [prototipo administrativo](../../diseno/prototipo-administrador.md)

## Cómo se hizo la prueba

Se recorrió el prototipo en el navegador el 14 de noviembre de 2026. La idea fue partir de encargos comunes, como encontrar un micro antes de salir a trabajar, cambiar el punto de espera o revisar el estado de una unidad. Se usaron situaciones ficticias de personas que toman micro desde Ciudad Nueva, Alto de la Alianza y Gregorio Albarracín. Las líneas, ubicaciones, cuentas y tiempos que aparecen en Figma son datos de demostración.

En el flujo principal se contó cada toque desde el mapa. Para entrar como invitado se pasó primero por «Consultar mapa sin cuenta» y el conteo empezó al ver el mapa. En los demás casos se anotó la pantalla a la que llevó la acción o lo que sucedió al pulsar el botón.

**Comprobado** significa que se hizo la acción y se observó el resultado en Figma. **Observado** indica que se pudo ver la pantalla avanzando con los controles del reproductor. **Por corregir** indica que la acción dejó el prototipo sin el avance esperado. Esta ronda fue simulada. La ficha de T054 pide sesiones con usuarios y métricas de usabilidad para el cierre. La ronda no aporta tiempos de personas, opiniones recogidas ni mediciones de GPS.

Entradas al reproductor para repetir los casos:

- [Mapa del pasajero](https://www.figma.com/proto/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?page-id=73%3A1148&node-id=70-16325)
- [Bienvenida y registro](https://www.figma.com/proto/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?page-id=73%3A1147&node-id=70-16109) y [caso de credenciales incorrectas](https://www.figma.com/proto/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?page-id=73%3A1147&node-id=179-163)
- [Inicio de Modo Conductor](https://www.figma.com/proto/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?node-id=70-16808)
- [Acceso al panel web](https://www.figma.com/proto/Lw9Pbwc65lMKyjsW5IWZaD/go-tacna?page-id=73%3A1150&node-id=70-17228)

En el reproductor se usó «Ajustar ancho y alto» para ver completos los marcos que quedaban recortados al 100 %. En el panel, los formularios se completan pulsando los campos para cargar sus datos de ejemplo.

## Resultados del pasajero

| Caso | Encargo o acción | Resultado |
| --- | --- | --- |
| PRB-001 | Desde el mapa del pasajero, encontrar el Micro 01 de la Línea 10. | **Comprobado.** Línea 10 → Micro 01 → Ver ubicación. Tres toques. El mapa mostró el Micro 01 y la llegada a Plaza de Armas en 3 min aprox. |
| PRB-002 | Cerrar sesión y seguir consultando como invitado. | **Comprobado.** Desde Perfil apareció una confirmación de cierre. Al confirmar se abrió «Consulta como invitado» y «Consultar mapa sin cuenta» llevó al mapa. |
| PRB-003 | Como invitado, encontrar el Micro 01. | **Comprobado.** Tres toques desde el mapa. Se mostró la ubicación y la llegada a Plaza de Armas en 3 min aprox. |
| PRB-004 | Como invitado, encontrar el Micro 02. | **Comprobado.** Tres toques desde el mapa. El marcador y el encabezado correspondieron al Micro 02. Se mostraron 6 min aprox. |
| PRB-005 | Como invitado, encontrar el Micro 03. | **Comprobado.** Tres toques desde el mapa. El marcador y el encabezado correspondieron al Micro 03. Se mostraron 9 min aprox. |
| PRB-006 | Esperar al Micro 01 en Av. Pinto en vez de Plaza de Armas. | **Comprobado.** «Cambiar punto de espera» abrió «¿Dónde esperas?». Al elegir Av. Pinto se mantuvo el Micro 01 y el ejemplo cambió de 3 a 4 min aprox. |
| PRB-007 | Consultar la Línea 30 cuando no tiene micros activos. | **Comprobado.** Apareció «Sin micros activos», con opciones para consultar otras rutas o volver al mapa. Se pudo volver al mapa. |
| PRB-008 | Guardar el Micro 01 como favorito sin cuenta. | **Comprobado.** «Guardar favorito» llevó al inicio de sesión. La pantalla ofreció «Continuar sin cuenta». |
| PRB-009 | Elegir un tercer micro con dos ya seleccionados. | **Comprobado.** Apareció «Máximo dos micros», indicó quitar uno y permitió volver a la selección. El listado y los marcadores del mapa representan cosas distintas. |
| PRB-010 | Revisar qué hacer si se pierde la conexión. | **Comprobado.** Desde «Ayuda y problemas» se abrió «Sin conexión». Avisó que los tiempos y la ubicación dejaron de actualizarse. «Reintentar» mostró la carga y «Cancelar carga» volvió al mapa. |
| PRB-011 | Revisar la ubicación de un micro con datos antiguos. | **Comprobado.** Desde Ayuda se abrió «Ubicación desactualizada». El ejemplo decía que habían pasado 2 minutos, omitía la llegada estimada y ofrecía actualizar o ver otras unidades. |

Los cuatro intentos del recorrido principal completaron los tres toques. Se cuentan las acciones dentro del prototipo, con el recorrido conocido. En la siguiente ronda interesa ver si alguien que abre la app por primera vez descubre el camino por su cuenta. El cronograma cita RNF-04 para los tres toques. [T093](../../diseno/flujo-navegacion-pasajero.md) deja anotada la diferencia con la numeración de los requisitos.

## Resultados de acceso y Modo Conductor

| Caso | Encargo o acción | Resultado |
| --- | --- | --- |
| PRB-012 | Crear una cuenta de pasajero con el ejemplo del prototipo. | **Comprobado.** «Crear cuenta» abrió el formulario. «Registrarme» llevó a «Registro exitoso» y desde allí se pudo abrir «Iniciar sesión». |
| PRB-013 | Entrar con el escenario de pasajero. | **Comprobado.** «Ingresar» abrió un mapa de demostración cuyo encabezado todavía dice «RutaTacna». |
| PRB-014 | Intentar ingresar en el escenario de credenciales incorrectas. | **Comprobado.** Se mostró «No pudimos iniciar sesión» y «Corregir datos» volvió al formulario. El aviso no confirma si el correo está registrado. |
| PRB-015 | Iniciar el recorrido del Micro 024 con GPS e internet disponibles. | **Por corregir.** Al pulsar «INICIAR RECORRIDO» desde «Todo listo para salir», el marco se mantuvo. La confirmación se abrió con «Próximo marco» de Figma. El botón de esa confirmación tampoco llevó a «Recorrido activo» al pulsarlo. |
| PRB-016 | Distinguir GPS desactivado de falta de internet. | **Observado.** Los marcos muestran avisos distintos. «GPS desactivado» ofrece abrir configuración. «Sin conexión» conserva «GPS activo» y muestra «Envío pendiente». |
| PRB-017 | Terminar el recorrido y volver al inicio. | **Por corregir.** «FINALIZAR RECORRIDO» en el marco activo y «Volver al inicio» en el marco final se quedaron en su pantalla. Los marcos de confirmación y «Recorrido finalizado» se pudieron ver con el control del reproductor. El último aviso dice que se dejó de compartir la ubicación. |

## Resultados del panel administrativo

| Caso | Encargo o acción | Resultado |
| --- | --- | --- |
| PRB-018 | Entrar al panel general y abrir Empresas. | **Comprobado.** Elegir «Go Tacna» e iniciar sesión abrió «Administración general». «Gestionar empresas» llevó al listado. |
| PRB-019 | Registrar una empresa de ejemplo. | **Comprobado.** El primer guardado con los campos vacíos quedó en el formulario. Al cargar los datos de ejemplo y guardar, apareció Sur Demo en el listado con un aviso de éxito. |
| PRB-020 | Entrar como administrador de empresa y encontrar sus módulos. | **Comprobado.** Tras cerrar sesión del panel general, «Empresa» abrió Andino Demo. Se pudo entrar a Rutas, Micros, Conductores y Monitoreo desde su menú. |
| PRB-021 | Registrar el Micro 025 sin conductor. | **Comprobado.** Con código, placa y Línea 10 se pudo guardar el micro con «Sin asignar». El registro apareció en el listado. |
| PRB-022 | Asignar una conductora al Micro 025. | **Comprobado.** Se creó la cuenta de ejemplo de Andrea Salas desde Conductores. Luego se editó el Micro 025 desde Micros, se guardó la asignación y se confirmó el nombre en su ficha. |
| PRB-023 | Cambiar el conductor del Micro 024 mientras está en recorrido. | **Comprobado con observación.** Se abrió un bloqueo al pulsar el campo de conductor. El formulario explica que primero debe finalizar el recorrido. El diálogo dice «No se puede desactivar ahora», aunque se intentó cambiar una asignación. |
| PRB-024 | Desactivar y reactivar el Micro 025. | **Comprobado.** El micro quedó en el listado como inactivo después de desactivarlo y volvió a activo al reactivarlo. La baja lógica conservó el registro. |
| PRB-025 | Ver el Micro 024 en Monitoreo y actualizar los datos. | **Comprobado con observación.** Se vio la unidad en recorrido y la antigüedad de su posición. «Actualizar datos» abrió «No se pudo actualizar». El aviso indica que la ubicación anterior perdió vigencia, pero la tarjeta detrás todavía muestra «GPS activo» y «hace 3 s». |

## Cambios que haría en Figma

| Prioridad | Qué cambiaría | Cómo comprobarlo |
| --- | --- | --- |
| Alta | Conectar el inicio, la confirmación, el recorrido activo, la confirmación de fin y el regreso en Modo Conductor. Conectar también «Cancelar» para que regrese al estado correcto. | Repetir PRB-015 y PRB-017 usando solo los botones del prototipo. |
| Alta | En el aviso de bloqueo, decir «No se puede cambiar el conductor mientras el micro está en recorrido». Al fallar Monitoreo, marcar la tarjeta como «Última ubicación conocida» e incluir el momento del dato. | Repetir PRB-023 y PRB-025. La persona debe poder decir qué acción está bloqueada y si la ubicación sigue vigente. |
| Media | Aclarar desde el mapa inicial qué línea se está mostrando. El botón azul de Línea 10 parece seleccionado y los marcadores ya se ven. Dar más contraste a «Actualizado hace…» y mantener visible el punto de espera junto a los minutos. | Dar la consigna de ubicar el micro sin señalar ningún botón. Anotar el primer toque y preguntar a qué punto corresponden los minutos. |
| Media | Usar «Go Tacna» también en el destino del login de pasajero. Añadir una entrada «Consultar sin cuenta» desde Bienvenido si esa pantalla será el primer acceso. | Repetir el acceso desde Bienvenido como alguien que solo quiere consultar un micro. |
| Media | En Micros, usar «Registro habilitado» y mostrar «Sin conductor asignado» cuando corresponda. En Estado, ofrecer la acción que aplica al estado actual. | Mostrar un micro recién registrado y preguntar si ya está circulando. La respuesta debe poder salir del listado o de la ficha. |

## Casos para la siguiente ronda

- **Pasajero.** Repetir el recorrido de tres toques como pasajero con los micros 02 y 03. Probar búsqueda vacía, rutas cercanas, permiso de ubicación rechazado, ubicación no disponible, servicio caído, micro fuera de recorrido, recorrido en mapa, ETA no disponible y favoritos de una cuenta iniciada (guardar, consultar, eliminar y recuperar un fallo). Volver a probar el reemplazo de un micro desde el filtro y confirmar cuáles quedan en el mapa.
- **Acceso y conductor.** Probar el acceso del conductor en su escenario, el registro inválido, correo duplicado, sesión caducada, conductor sin unidad asignada y las pantallas de señal inestable, batería baja y ubicación temporalmente no disponible. Repetir inicio, cancelación y fin cuando las conexiones del prototipo estén listas. Las cuentas inactivas, los permisos y el GPS en segundo plano se comprueban con la aplicación implementada.
- **Administración.** Probar el rechazo de acceso, duplicados, edición y baja de empresas, altas y edición de rutas, estados de conductores y bloqueo de bajas con registros vinculados. El aislamiento real entre empresas se comprueba con dos cuentas en la aplicación. Los escenarios de diseño registrados en T053 sirven como guía para ampliar esta ronda.

## Ficha para la sesión con una persona

Leer la consigna sin señalar controles. Para el pasajero, decir «Estás por salir a trabajar y quieres saber dónde está el Micro 01 de la Línea 10 y cuánto falta para que llegue a Plaza de Armas». Desde el mapa, contar todos los toques, incluidos los desvíos. Al terminar, preguntar qué haría si se queda sin internet o si decide esperar en Av. Pinto. Para los demás perfiles usar las consignas de iniciar y finalizar un recorrido, registrar una empresa, o asignar una conductora a un micro.

| Participante (código) | Caso | ¿Terminó? | Toques | Tiempo | ¿Pidió ayuda? | Qué pasó |
| --- | --- | --- | --- | --- | --- | --- |
| | | | | | | |

Enviar a T095 los problemas que aparezcan en las sesiones, con el paso donde ocurrieron. El criterio para cerrar T054 queda pendiente de registrar esas sesiones.
