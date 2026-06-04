#!/bin/bash
# Installerer check.sh som pre-commit hook i et målprojekt.
#
# Brug: bash ~/projects/aiproj/scripts/install-hooks.sh <målprojekt-sti>
# Eksempel: bash ~/projects/aiproj/scripts/install-hooks.sh ~/projects/ipfs-apps
set -euo pipefail

AIPROJ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:?Brug: install-hooks.sh <målprojekt-sti>}"
TARGET="$(cd "$TARGET" && pwd)"

if [ ! -d "$TARGET/.git" ]; then
    echo "Fejl: '$TARGET' er ikke et git-projekt" >&2
    exit 1
fi

mkdir -p "$TARGET/scripts"
cp "$AIPROJ_DIR/scripts/check.sh" "$TARGET/scripts/check.sh"
chmod +x "$TARGET/scripts/check.sh"

cat > "$TARGET/.git/hooks/pre-commit" <<'EOF'
#!/bin/bash
exec "$(git rev-parse --show-toplevel)/scripts/check.sh" --staged
EOF
chmod +x "$TARGET/.git/hooks/pre-commit"

echo "✓ scripts/check.sh kopieret til $TARGET"
echo "✓ Pre-commit hook installeret"
echo ""
echo "Tilpas $TARGET/scripts/check.sh til projektet og commit den."
