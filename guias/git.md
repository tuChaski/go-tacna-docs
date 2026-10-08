# Flujo de trabajo con Git

> **Estado:** Borrador
> **Responsable:** Royfrankly Navarro
> **Relacionado:** [CONTRIBUTING.md](../CONTRIBUTING.md), T077, T088

Esta guía aplica a los **5 repositorios** del proyecto. Cada repo tiene un `CONTRIBUTING.md` corto que apunta aquí.

## 1. Resumen

- Dos ramas permanentes: `main` (producción) y `develop` (integración y staging).
- Todo el trabajo se hace en ramas cortas creadas desde `develop`, una por tarea.
- Nadie sube directo a `main` ni a `develop`: todo entra por **Pull Request** con una revisión.
- Los commits y los títulos de PR siguen **Conventional Commits**.

```
feature/T033-calculo-eta ──PR──► develop ──PR (release)──► main
                                    │                        │
                                 staging (T089)        producción (T108)
```

El repo `docs` trabaja solo con `main` (sin `develop`), porque no tiene entorno de staging.

## 2. Ramas

| Rama | Propósito | Se crea desde | Se une a | Vida |
|---|---|---|---|---|
| `main` | Código en producción, siempre estable | | | Permanente |
| `develop` | Integración de todo lo terminado; se despliega a staging | `main` | `main` | Permanente |
| `feature/T033-calculo-eta` | Una funcionalidad | `develop` | `develop` | Corta |
| `fix/T104-reconexion-gps` | Corrección de un error | `develop` | `develop` | Corta |
| `docs/requisitos` | Documentación | `develop` (o `main` en el repo docs) | igual | Corta |
| `hotfix/jwt-expirado` | Error urgente en producción | `main` | `main` y luego `develop` | Muy corta |

Reglas de nombres:

- Minúsculas, guiones, sin espacios ni tildes.
- Incluir el **ID de la tarea** del cronograma: `feature/T033-calculo-eta`.
- Si no existe tarea, usar un nombre descriptivo corto.
- Una rama = una tarea. Si crece demasiado, se divide.
- Se borra al hacer merge (activar el borrado automático en GitHub).

## 3. Ciclo de trabajo de una tarea

```bash
# 1. Partir siempre de develop actualizado
git switch develop
git pull

# 2. Crear la rama
git switch -c feature/T033-calculo-eta

# 3. Trabajar y hacer commits pequeños
git add .
git commit -m "feat(realtime): agrega cálculo de ETA con velocidad promedio"

# 4. Mantener la rama al día (sin rebase ni force push)
git fetch origin
git merge origin/develop

# 5. Subir y abrir el Pull Request hacia develop
git push -u origin feature/T033-calculo-eta
```

Después de que se apruebe y se una el PR, la rama se borra y se vuelve a empezar desde el paso 1.

## 4. Commits

Formato:

```
tipo(alcance): descripción corta en imperativo

Cuerpo opcional: qué cambia y por qué (no cómo).

Refs: T033
```

| Tipo | Cuándo se usa |
|---|---|
| `feat` | Funcionalidad nueva |
| `fix` | Corrección de un error |
| `docs` | Solo documentación |
| `style` | Formato sin cambiar el comportamiento (espacios, comas) |
| `refactor` | Reorganizar código sin cambiar el comportamiento |
| `perf` | Mejora de rendimiento |
| `test` | Agregar o corregir pruebas |
| `build` | Dependencias, Docker, configuración de compilación |
| `ci` | Pipelines de GitHub Actions |
| `chore` | Tareas de mantenimiento que no encajan en las otras |
| `revert` | Deshace un commit anterior |

Reglas:

1. El **tipo y el alcance van en minúsculas y sin tildes**; la descripción va en español.
2. La primera línea tiene **máximo 72 caracteres**, sin punto final, en imperativo ("agrega", "corrige", no "agregado").
3. Un commit = un cambio lógico. No mezclar una funcionalidad con un arreglo no relacionado.
4. La tarea del cronograma se anota en el pie: `Refs: T033`.
5. Un cambio que rompe compatibilidad lleva `!` y la explicación:

```
feat(api)!: cambia el formato del payload de posiciones

BREAKING CHANGE: el campo "velocidad" pasa de km/h a m/s.
Refs: T037
```

Ejemplos válidos:

- `feat(realtime): agrega detección de micro sin conexión`
- `fix(conductor): evita enviar GPS después de finalizar el recorrido`
- `docs(contratos): documenta los claims del JWT`
- `ci(web): agrega workflow de pruebas`

Ejemplos que se rechazan: `arreglos`, `Update file`, `feat: Cosas varias.`, `FIX: gps`.

### Alcances por repositorio

| Repo | Alcances permitidos |
|---|---|
| backend | `api`, `realtime`, `auth`, `rutas`, `micros`, `gps`, `eta`, `db`, `deps`, `ci` |
| web | `admin`, `public`, `login`, `map`, `ui`, `deps`, `ci` |
| mobile | `pasajero`, `conductor`, `mapa`, `gps`, `auth`, `ui`, `deps`, `ci` |
| infra | `k3s`, `compose`, `ingress`, `db`, `scripts`, `ci` |
| docs | `requisitos`, `contratos`, `arquitectura`, `diagramas`, `diseno`, `planificacion`, `pruebas`, `informe` |

El alcance es opcional, pero se recomienda siempre.

## 5. Pull Requests

1. **Destino:** `develop` (o `main` en el repo docs). Solo los releases y hotfixes van a `main`.
2. **Título:** sigue el mismo formato de commit (`feat(realtime): ...`). Un workflow lo valida y bloquea el merge si no cumple.
3. **Tamaño:** pequeño y enfocado. Si pasa de unas 400 líneas, conviene dividirlo.
4. **Descripción:** se completa la plantilla (qué cambia, tareas, cómo probarlo, checklist).
5. **Revisión:** mínimo **1 aprobación de otra persona**. Nadie aprueba su propio PR. Edison (QA) revisa los cambios con impacto en pruebas (T077).
6. **Estado de los checks:** los tests y la validación del título deben estar en verde.
7. **Tipo de merge:**
   - `feature`/`fix` → `develop`: **Squash and merge** (queda un solo commit limpio; el título del PR pasa a ser el mensaje).
   - `develop` → `main`: **Merge commit** (conserva el historial del release).
8. Quien abre el PR resuelve los comentarios; quien revisa marca "Approve" solo cuando está conforme.

Como se hace squash, **el título del PR es lo que queda en el historial**. Por eso se valida estrictamente.

### Formato del título

```
tipo(alcance): descripción en imperativo
```

Expresión regular usada por `.github/workflows/pr-title.yml`:

```
^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9-]+\))?!?: .{3,72}$
```

| Título | Válido |
|---|---|
| `feat(realtime): agrega ETA en el mapa` | Sí |
| `fix(auth)!: invalida tokens al cambiar de rol` | Sí (el `!` marca cambio incompatible) |
| `docs: agrega RF-21 sobre modo conductor` | Sí, el alcance es opcional |
| `Actualicé el readme` | No: sin tipo |
| `feat(realtime) agrega ETA` | No: falta el `:` |
| `feat: Cosas varias.` | No: no describe un solo cambio |

El título no lleva el ID de tarea: ese va en el campo **Tareas relacionadas** de la plantilla del PR.

### Revisores automáticos (CODEOWNERS)

Cada repositorio tiene `.github/CODEOWNERS` con un `*` que cubre todo el repo, para que GitHub asigne revisores al abrir el PR.

| Integrante | Usuario de GitHub | Repos donde es dueño |
|---|---|---|
| Royfrankly Navarro | `royfrankly` | `backend`, `infra`, `docs` |
| David Montoya Holgado | `DavidMontoyaHolgado` | `backend`, `mobile` |
| Alex Huaracha Bellido | `Alex-Huaracha-Bellido` | `web`, `mobile` |
| Edison Catari | `EdCatari` | `docs` |

Un `CODEOWNERS` con un usuario inexistente no asigna a nadie y el PR se queda sin revisión automática. Si se cambia el dueño de un repo hay que editar el archivo **y** las reglas de protección de la sección 10.

## 6. Hotfix (error urgente en producción)

```bash
git switch main && git pull
git switch -c hotfix/jwt-expirado
# corregir, commit "fix(auth): ..."
# PR hacia main  →  luego volver a unir main en develop
```

Después del merge a `main`, abrir otro PR de `main` hacia `develop` para que el arreglo no se pierda.

## 7. Releases y versiones

- Versionado semántico: `vMAYOR.MENOR.PARCHE` (por ejemplo `v1.0.0`, que coincide con el informe v1.0.0).
- Se publica un release cuando `develop` pasa a `main`: se crea una **etiqueta** (`git tag v1.0.0`) y un Release en GitHub.
- Los repos se versionan de forma independiente, pero la compatibilidad entre ellos la define la versión del **contrato** en `docs/contratos/`.

```bash
git switch main && git pull
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## 8. Cambios que afectan a varios repos

Pasa con los contratos (API, eventos WebSocket, claims del JWT):

1. Primero un PR en `docs` actualizando `contratos/` y se aprueba.
2. Luego, un PR en cada repo implementador, citando el PR de docs en la descripción.
3. Los cambios que rompen compatibilidad se marcan con `!` y se despliegan en orden: servidor primero, clientes después.

## 9. Qué nunca se hace

- Subir directo a `main` o `develop`.
- `git push --force` en ramas compartidas.
- Subir archivos `.env`, claves, tokens o contraseñas (si ocurre, se rotan de inmediato; borrar el commit no basta).
- Subir `node_modules/`, `vendor/`, `android/`, `dist/` y otros generados.
- Mezclar varias tareas en una misma rama o commit.
- Dejar un PR abierto sin atención más de 2 días.

## 10. Configuración de GitHub (la hace el coordinador una vez por repo)

**Settings → Branches → Branch protection rule**, para `main` y `develop`:

- Require a pull request before merging, con **1 aprobación**.
- Dismiss stale approvals when new commits are pushed.
- Require status checks to pass (las pruebas y `pr-title`).
- Block force pushes y Restrict deletions.
- Include administrators (el coordinador también sigue las reglas).
- Permitir *Squash merging* y *Merge commits*; desactivar *Rebase merging*.
- Activar *Automatically delete head branches*.

**Settings → General → Pull Requests:**

- Permitir *Squash merging* y *Merge commits*; desactivar *Rebase merging*.
- Activar *Automatically delete head branches*.

**Rama por defecto:** `develop` en los repos de código, para que los PR apunten ahí por defecto. En `docs` es `main`.

> El check `pr-title` solo puede exigirse **después** de que el workflow haya corrido al menos una vez. Por eso el orden es: primero un PR de prueba y, después, marcar `pr-title` como obligatorio en la regla de protección. Si se exige antes, GitHub rechaza la regla porque el check todavía no existe.

> Verifica que tu plan de GitHub permita protección de ramas en repos privados; si no, usa un repo público o el plan educativo de GitHub.

## 11. Lo que se automatiza en el repositorio

| Archivo | Qué hace |
|---|---|
| `.github/pull_request_template.md` | Formulario que aparece al abrir un PR |
| `.github/CODEOWNERS` | Revisores automáticos (sección 5) |
| `.github/workflows/pr-title.yml` | Valida el formato del título del PR |

Los tres archivos se crean con un solo comando, con `plantillas/setup-git-rules.sh` del repo `docs`:

```bash
bash setup-git-rules.sh "<nombre-repo>" "<alcances separados por coma>" "<@dueño1 @dueño2>"
```

```bash
bash setup-git-rules.sh "go-tacna-backend" "api, realtime, auth, rutas, micros, gps, eta, db, deps, ci" "@royfrankly @DavidMontoyaHolgado"
bash setup-git-rules.sh "go-tacna-frontend" "admin, public, login, map, ui, deps, ci" "@Alex-Huaracha-Bellido"
bash setup-git-rules.sh "go-tacna-movil" "pasajero, conductor, mapa, gps, auth, ui, deps, ci" "@Alex-Huaracha-Bellido @DavidMontoyaHolgado"
bash setup-git-rules.sh "go-tacna-infraestructura" "k3s, compose, ingress, db, scripts, ci" "@royfrankly"
bash setup-git-rules.sh "go-tacna-docs" "requisitos, contratos, arquitectura, diagramas, diseno, planificacion, pruebas, informe" "@royfrankly @EdCatari"
```

El script también genera un `CONTRIBUTING.md` corto **si no existe**. En `docs` ese archivo ya está escrito, así que el script solo crea `.github/`.

Pasos finales de cada repo de código:

```bash
git switch main && git switch -c develop && git push -u origin develop
git add .github CONTRIBUTING.md
git commit -m "ci: agrega plantilla de PR y validación de título"
```

En `docs` no se crea `develop`: ese repo trabaja solo con `main`.

### Hooks locales (T088)

Un hook en `.git/hooks/` puede avisar antes de hacer commit, pero **no bloquea nada**: cada persona tiene su propia configuración y `.git/hooks/` no se comparte por Git. Si se agrega uno (commitlint, husky), debe ser **advisory**: avisa, no bloquea. La validación que protege es la de CI, el check `pr-title`.

## 12. Errores frecuentes

| Situación | Qué hacer |
|---|---|
| El PR falla en `pr-title` | Edita el **título** del PR, no hace falta tocar los commits |
| El squash dejó `PR #12:` en el mensaje | GitHub lo agrega solo: hay que borrar ese prefijo del título **antes** de mergear |
| La rama quedó atrás con `develop` | `git fetch origin && git merge origin/develop` y push normal, sin `--force` |
| Se hizo push a `main` por error | No se borra el historial: se revierte con un PR nuevo (`revert: ...`) |
| El PR pide revisión de alguien que no responde | Reasigna el reviewer en la pestaña *Reviewers*; el owner del `CODEOWNERS` no bloquea el approve si ya hay 1 aprobación |
| Se borró un `.env` por error | Rotar el secreto primero; borrar el commit no basta (sección 9) |