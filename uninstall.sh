#!/usr/bin/env bash
# Reverses install.sh. Usage: ./uninstall.sh [claude_dir]   (default: $CLAUDE_CONFIG_DIR, else $HOME/.claude)
set -euo pipefail
W="$(cd "$(dirname "$0")" && pwd)"
C="${1:-${CLAUDE_CONFIG_DIR:-$HOME/.claude}}"
MARK="# agent-workflow (managed by install.sh)"
if [ -f "$C/CLAUDE.md" ] && grep -qxF "$MARK" "$C/CLAUDE.md"; then
  tmp="$(mktemp)"
  awk -v m="$MARK" 'skip==1 {skip=0; next} $0==m {skip=1; next} {print}' "$C/CLAUDE.md" > "$tmp"
  cat "$tmp" > "$C/CLAUDE.md"; rm -f "$tmp"; echo "removed import from $C/CLAUDE.md"
fi
unlink_ours() { [ -L "$1" ] && [[ "$(readlink "$1")" == "$W"/* ]] && rm "$1" && echo "unlinked $1" || true; }
for l in "$C"/skills/wf-* "$C"/agents/wf-*; do unlink_ours "$l"; done   # also catches links to removed skills
python3 "$W/bin/wf-lint" --remove-hook "$C"   # SessionStart drift check
echo "done ($C)."
