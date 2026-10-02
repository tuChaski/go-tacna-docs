#!/usr/bin/env bash
# Configura las reglas de Git de un repositorio del equipo.
#
# Uso (Git Bash en Windows):
#   bash setup-git-rules.sh "<nombre-repo>" "<alcances separados por coma>" "<@dueño1 @dueño2>"
#
# Crea .github/pull_request_template.md, .github/CODEOWNERS,
# .github/workflows/pr-title.yml y CONTRIBUTING.md.
# La guía completa vive en rutas-en-tiempo-real-docs/guias/git.md.
set -euo pipefail

REPO="${1:?Falta el nombre del repo}"
SCOPES="${2:?Faltan los alcances}"
OWNERS="${3:?Faltan los dueños de código}"

mkdir -p .github/workflows

cat > .github/pull_request_template.md <<'EOF'
## ¿Qué cambia?
<!-- Descripción breve y clara -->

## Tareas relacionadas
Refs: T000

## Tipo de cambio
- [ ] feat (funcionalidad nueva)
- [ ] fix (corrección)
- [ ] docs / refactor / test / build / ci / chore

## ¿Cómo probarlo?
1.
2.

## Checklist
- [ ] El título sigue el formato `tipo(alcance): descripción`
- [ ] Las pruebas pasan
- [ ] No incluye `.env`, claves ni archivos generados
- [ ] Actualicé la documentación o los contratos si corresponde
- [ ] Adjunté capturas si hay cambios de interfaz
EOF

cat > .github/CODEOWNERS <<EOF
# Revisores automáticos de cada Pull Request
* $OWNERS
EOF

cat > .github/workflows/pr-title.yml <<'EOF'
name: pr-title
on:
  pull_request:
    types: [opened, edited, synchronize, reopened]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - name: Validar título del Pull Request
        env:
          TITLE: ${{ github.event.pull_request.title }}
        run: |
          pattern='^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9-]+\))?!?: .{3,72}$'
          if ! [[ "$TITLE" =~ $pattern ]]; then
            echo "Título inválido: $TITLE"
            echo "Formato esperado: tipo(alcance): descripción  (ej. feat(realtime): agrega ETA)"
            exit 1
          fi
EOF

# El CONTRIBUTING.md solo se genera si no existe: en docs ya hay una guía de
# escritura completa y sobrescribirla perdería el trabajo del equipo.
if [ -f CONTRIBUTING.md ] && [ "${FORCE:-0}" != "1" ]; then
  echo "AVISO: CONTRIBUTING.md ya existe, no se sobrescribe."
  echo "       Agrega a mano el resumen de la guía (ver g uias/git.md)."
  echo "       Usa FORCE=1 si de verdad quieres regenerarlo."
else
  cat > CONTRIBUTING.md <<'EOF'
# Cómo contribuir a __REPO__

Las reglas completas están en la guía de Git del repo `rutas-en-tiempo-real-docs`: `guias/git.md`.

## Resumen

- Ramas: `feature/T000-nombre`, `fix/T000-nombre`, `docs/tema`, creadas desde `develop`.
- Commits y título de PR: `tipo(alcance): descripción en imperativo`.
- Alcances de este repo: __SCOPES__.
- Todo entra por Pull Request con 1 aprobación. Nunca se sube directo a `main` ni a `develop`.
- Nunca se suben archivos `.env` ni secretos.
EOF
  sed -i "s/__REPO__/$REPO/g; s/__SCOPES__/$SCOPES/g" CONTRIBUTING.md
fi

echo "Listo en $REPO. Revisa CODEOWNERS y haz commit:"
echo "  git add .github CONTRIBUTING.md"
echo "  git commit -m \"ci: agrega plantilla de PR y validación de título\""