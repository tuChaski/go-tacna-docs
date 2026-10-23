# Decisiones pendientes

> **Estado:** En revisión
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

### 4. ¿El MVP incluye el panel de administración completo?

| | |
|---|---|
| **Qué está suponiendo** | El panel administra empresas, rutas, micros y conductores, pero no está claro qué entra en el MVP |
| **Opciones** | (a) Solo alta de rutas y micros en el MVP, (b) administración completa |
| **Recomendación** | (a): sin datos cargados no hay mapa que mostrar. La carga masiva puede ser un `.sql` inicial |
| **Decide** | Royfrankly y Alex |
| **Desbloquea** | El alcance del MVP y la planificación; `requisitos/` aún no existe |

---

## Cerradas

| Decisión | Resultado | Dónde quedó escrita |
|---|---|---|
| Nombre del vehículo: micro, bus o unidad | **micro**; "unidad" es el sinónimo formal en textos técnicos | [../glosario.md](../glosario.md) |
| Numeración de los requerimientos | Gana la guía TF: RF-01 a RF-20, RNF-01 a RNF-07. La numeración hasta RF-45 se descarta | [../CONTRIBUTING.md](../CONTRIBUTING.md) §3 |
| Organización de las fases de planificación | Seis fases resumidas en `planificacion/README.md`; tareas y dependencias detalladas en el archivo ProjectLibre `.pod` | [../planificacion/README.md](../planificacion/README.md) |
| Flujo de Git | Gitflow simplificado, squash a `develop`, merge commit a `main`, sin ramas `release/` | [../guias/git.md](../guias/git.md) |
| Sintaxis de los diagramas | Solo Mermaid (`.mmd`), con la fuente en `diagramas/fuente/` | [../CONTRIBUTING.md](../CONTRIBUTING.md) §6 |
| Tiempo de llegada siempre estimado | El ETA se marca como estimado, nunca como hora exacta (RN-08) | [../glosario.md](../glosario.md); `requisitos/reglas-de-negocio.md` aún no existe |
| Arquitectura de 5 repositorios | Cinco repos independientes, no un monorepo. El código se migra desde `frontend/` | [README.md](README.md), [repos.md](repos.md) |
| Dominio y certificado | `https://www.go-tacna.site/` con TLS Let's Encrypt para `go-tacna.site` y `www.go-tacna.site`; raíz redirige a `www` | [../INFRASTRUCTURE.md](../INFRASTRUCTURE.md), [../arquitectura/despliegue-produccion.md](../arquitectura/despliegue-produccion.md) |
| Modalidad de producción | **Docker Compose** en el VPS, upstream `127.0.0.1:8001`; K3s está instalado pero no se aplicaron sus manifiestos | [../INFRASTRUCTURE.md](../INFRASTRUCTURE.md), [../CI-CD.md](../CI-CD.md) |
| Despliegue de aplicaciones | Compose de producción desplegado y verificado; el despliegue es manual y no existe CD automatizado | [../CI-CD.md](../CI-CD.md), [../INFRASTRUCTURE.md](../INFRASTRUCTURE.md) |

---

## Cómo se cierra una decisión

1. Se escribe el archivo en `arquitectura/decisiones/` si es una decisión de arquitectura, o se actualiza el documento que corresponda si es de contenido. La plantilla `plantillas/decision.md` aún no existe.
2. Se mueve la fila de **Abiertas** a **Cerradas** con un enlace al archivo.
3. Se actualiza el documento afectado: glosario, contratos, planificacion o el que sea.
4. Se avisa en el Pull Request a quien tenga pendiente trabajar con la decisión.