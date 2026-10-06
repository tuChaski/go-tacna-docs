# Decisiones pendientes

> **Estado:** Pendiente
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [README.md](README.md), [checklist.md](checklist.md), [../CONTRIBUTING.md](../CONTRIBUTING.md), [../glosario.md](../glosario.md), [../arquitectura/decisiones/](../arquitectura/decisiones/)

Decisiones que **están frenando el trabajo**. Cada una dice qué se está suponiendo hoy, qué hay que decidir, quién decide y qué se desbloquea al decidir.

Cuando se toma una decisión, se escribe el archivo en `arquitectura/decisiones/` (DEC-XXX) o se actualiza el documento que le corresponde, y esta tabla pasa a la sección de abajo.

---

## Abiertas

### 1. ¿`bus` o `micro` en el contrato?

| | |
|---|---|
| **Qué está suponiendo** | El `openapi.yaml` usa `bus`/`buses` y `BusLocation`, pero todo el código y la documentación usan **micro** |
| **Opciones** | (a) Cambiar el contrato a `micro_id` / `MicroLocation`, (b) dejar `bus` en la API y traducir en el cliente, (c) declarar `bus` como alias oficial |
| **Recomendación** | (a) Un solo término. Ya está decidido en el glosario que el vehículo es **micro** |
| **Decide** | Royfrankly |
| **Desbloquea** | `contratos/openapi.yaml` (T086), el modelo de datos y el ERD |

### 2. ¿`admin` o `administrador` en el token?

| | |
|---|---|
| **Qué está suponiendo** | El código usa `role: "admin"` y el glosario dice **Administrador** |
| **Opciones** | (a) `admin` en el token y "Administrador" solo en el texto, (b) `administrador` en todas partes |
| **Recomendación** | (a): los valores de un token no son documentación, pueden ir en inglés si el código ya los usa. Lo que no puede pasar es que se mezclen |
| **Decide** | David |
| **Desbloquea** | `contratos/jwt-claims.md` y la validación de roles |

### 3. ¿El estado del tiempo real sigue en memoria?

| | |
|---|---|
| **Qué está suponiendo** | `realtime/` guarda las posiciones en memoria: si el proceso se reinicia, se pierde el mapa. Se aceptó para el MVP |
| **Opciones** | (a) Seguir en memoria en el MVP, (b) Persistir desde ahora en PostgreSQL o Redis |
| **Recomendación** | (a) El MVP no consulta historial, así que memoria alcanza. **Hay que dejarlo escrito como decisión consciente**, no como olvido |
| **Decide** | David |
| **Desbloquea** | `arquitectura/decisiones/`, requisito no funcional sobre disponibilidad |

### 4. ¿k3s con Traefik o Docker Compose en producción?

| | |
|---|---|
| **Qué está suponiendo** | El Compose con Nginx ya funciona; k3s con Kustomize y Traefik es el diseño objetivo y **todavía no ha empezado** |
| **Opciones** | (a) Quedarse en Compose para la entrega, (b) Migrar a k3s antes de presentar |
| **Recomendación** | Depende de la fecha. Si hay tiempo, (b) queda mejor; si no, (a) y documentar k3s como trabajo futuro |
| **Decide** | Royfrankly |
| **Desbloquea** | `planificacion/`, el despliegue y la sección de arquitectura del informe |

### 5. ¿Qué dominio y certificado se usan?

| | |
|---|---|
| **Qué está suponiendo** | El `.env.example` trae `rutas.example.com` y `DOMAIN` configurable |
| **Opciones** | (a) Dominio propio, (b) Subdominio de prueba, (c) IP con certificado autofirmado |
| **Recomendación** | Hace falta HTTPS real: sin eso el Modo Conductor no funciona en un celular físico |
| **Decide** | Royfrankly |
| **Desbloquea** | Pruebas de campo con el conductor y la app |

### 6. ¿El MVP incluye el panel de administración completo?

| | |
|---|---|
| **Qué está suponiendo** | El panel administra empresas, rutas, micros y conductores, pero no está claro qué entra en el MVP |
| **Opciones** | (a) Solo alta de rutas y micros en el MVP, (b) administración completa |
| **Recomendación** | (a): sin datos cargados no hay mapa que mostrar. La carga masiva puede ser un `.sql` inicial |
| **Decide** | Royfrankly y Alex |
| **Desbloquea** | `requisitos/mvp.md` y la planificación |

---

## Cerradas

| Decisión | Resultado | Dónde quedó escrita |
|---|---|---|
| Nombre del vehículo: micro, bus o unidad | **micro**; "unidad" es el sinónimo formal en textos técnicos | [../glosario.md](../glosario.md) |
| Numeración de los requerimientos | Gana la guía TF: RF-01 a RF-20, RNF-01 a RNF-07. La numeración hasta RF-45 se descarta | [../CONTRIBUTING.md](../CONTRIBUTING.md) §3 |
| Organización de las fases de planificación | Seis fases resumidas en `planificacion/README.md`; tareas y dependencias detalladas en el archivo ProjectLibre `.pod` | [../planificacion/README.md](../planificacion/README.md) |
| Flujo de Git | Gitflow simplificado, squash a `develop`, merge commit a `main`, sin ramas `release/` | [../guias/git.md](../guias/git.md) |
| Sintaxis de los diagramas | Solo Mermaid (`.mmd`), con la fuente en `diagramas/fuente/` | [../CONTRIBUTING.md](../CONTRIBUTING.md) §6 |
| Tiempo de llegada siempre estimado | El ETA se marca como estimado, nunca como hora exacta (RN-08) | [../glosario.md](../glosario.md), [../requisitos/reglas-de-negocio.md](../requisitos/reglas-de-negocio.md) |
| Arquitectura de 5 repositorios | Cinco repos independientes, no un monorepo. El código se migra desde `frontend/` | [README.md](README.md), [repos.md](repos.md) |

---

## Cómo se cierra una decisión

1. Se escribe el archivo con [../plantillas/decision.md](../plantillas/decision.md) en `arquitectura/decisiones/` si es de arquitectura, o se actualiza el documento que corresponda si es de contenido.
2. Se mueve la fila de **Abiertas** a **Cerradas** con un enlace al archivo.
3. Se actualiza el documento afectado: glosario, contratos, planificacion o el que sea.
4. Se avisa en el Pull Request a quien tenga pendiente trabajar con la decisión.