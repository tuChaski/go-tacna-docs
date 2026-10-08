# Carpeta general

> **Estado:** Pendiente
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [../README.md](../README.md), [../INVENTARIO.md](../INVENTARIO.md), [../guias/git.md](../guias/git.md), [../CONTRIBUTING.md](../CONTRIBUTING.md)

Esta es la **vista de control del proyecto**: una sola mirada a los 5 repositorios, a la configuración que hay que dejar lista y a lo que todavía falta.

Sirve para dos momentos distintos:

- **Cuando no sabes a qué carpeta entrar.** Cada archivo de abajo responde una pregunta general.
- **Cuando estás configurando el proyecto.** [checklist.md](checklist.md) y [decisiones-pendientes.md] son los dos que se van marcando.

> **No duplica el detalle.** El detalle de un documento concreto está en su carpeta y en el README de su repositorio. Acá solo va el resumen y el enlace. El mapa de todos los archivos del repo es [../INVENTARIO.md](../INVENTARIO.md).

---

## Los 5 repositorios

No es un monorepo: son 5 repositorios independientes, cada uno con su propio README, sus ramas y sus despliegues. [repos.md](repos.md) tiene la ficha de cada uno.

| Repositorio | Qué es | Dueño principal |
|---|---|---|
| `go-tacna-docs` | Este. Informe, requisitos, contratos, cronograma | Royfrankly y Edison |
| `go-tacna-backend` | API Laravel y servidor de tiempo real (Node.js) | Royfrankly y David |
| `go-tacna-frontend` | Web pública y panel de administración | Alex |
| `go-tacna-movil` | App Android: Pasajero y Modo Conductor | Alex y David |
| `go-tacna-infraestructura` | Docker Compose, gateway y despliegue | Royfrankly |

## La regla que ordena todo

**El contrato se escribe primero en este repositorio y después se implementa.** Backend, web y móvil no inventan endpoints ni payloads: los consumen.

```
docs/contratos/  ──►  backend/  ──►  frontend/  y  movil/
     (se define)      (se aplica)     (se consumen)
```

Si un contrato cambia, el PR va primero en `docs/`. Ver [../CONTRIBUTING.md](../CONTRIBUTING.md) y la sección 8 de [../guias/git.md](../guias/git.md).

---

## Dónde está cada cosa

| Quiero... | Mira |
|---|---|
| Saber qué hace cada repositorio | [repos.md](repos.md) |
| Saber qué hay que configurar: ramas, puertos, secretos, contratos | [configuracion.md](configuracion.md) |
| Consultar el VPS Contabo, el proxy global y el despliegue multidominio | [../INFRASTRUCTURE.md](../INFRASTRUCTURE.md) |
| Saber qué falta | [checklist.md](checklist.md) |
| Desbloquear una decisión que está frenando el trabajo | [decisiones-pendientes.md](decisiones-pendientes.md) |
| Cambiar las reglas de Git | [../guias/git.md](../guias/git.md) |
| Escribir o corregir un requerimiento | [../requisitos/](../requisitos/) y `plantillas/requerimiento.md` |
| Cambiar la API, los eventos o el token | [../contratos/](../contratos/) |
| Armar el informe | [../informe/capitulo-1/](../informe/capitulo-1/) |
| Saber qué archivo falta o sobra | [../INVENTARIO.md](../INVENTARIO.md) |

---

## Convenciones que no se negocian

| Convención | Regla |
|---|---|
| Nombre de los vehículos | **micro**. Nunca `bus` ni `combi`. Ver [../glosario.md](../glosario.md) |
| Diagramas | **Mermaid** (`.mmd`) en `diagramas/fuente/`, se exporta la imagen a `diagramas/export/` |
| Requerimientos | Numeración de la guía TF: RF-01 a RF-20, RNF-01 a RNF-07. **No se renumera ni se reutiliza un ID** |
| Tareas | ID del cronograma en el nombre de la rama: `feature/T033-...` |
| Secretos | Nunca se suben `.env`. Solo `.env.example` |
| Cambios | Todo entra por Pull Request con 1 aprobación |
| Documentación | Una fuente de verdad por tema. Si ya está escrito, se enlaza |

---

## Contenido

| Archivo | Qué resuelve |
|---|---|
| [repos.md](repos.md) | Ficha de los 5 repos: qué contienen, con qué stack, quién lo trabaja y qué consumen de `docs/` |
| [configuracion.md](configuracion.md) | Toda la configuración en una vista: repos, ramas, GitHub, contratos, puertos, secretos y variables |
| [checklist.md](checklist.md) | Qué falta para tener el proyecto configurado, con casillas por bloque |
| [decisiones-pendientes.md](decisiones-pendientes.md) | Decisiones abiertas que están frenando el trabajo, con responsable y opciones |