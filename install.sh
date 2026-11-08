#!/usr/bin/env bash
# Installs the workflow for Claude Code: one import line in the user CLAUDE.md + symlinks for wf-* skills and agents.
# Idempotent. Usage: ./install.sh [claude_dir]   (default: $CLAUDE_CONFIG_DIR, else $HOME/.claude)
# Run once per Claude config dir you use.
set -euo pipefail
W="$(cd "$(dirname "$0")" && pwd)"
C="${1:-${CLAUDE_CONFIG_DIR:-$HOME/.claude}}"
MARK="# agent-workflow (managed by install.sh)"
IMPORT="@$W/WORKFLOW.md"
mkdir -p "$C/skills" "$C/agents"
[ -e "$C/CLAUDE.md" ] || touch "$C/CLAUDE.md"
# Remove a managed block from any previous clone path, then add ours (CLAUDE.md may be a symlink; write through it).
if grep -qxF "$MARK" "$C/CLAUDE.md"; then
  tmp="$(mktemp)"
  awk -v m="$MARK" 'skip==1 {skip=0; next} $0==m {skip=1; next} {print}' "$C/CLAUDE.md" > "$tmp"
  cat "$tmp" > "$C/CLAUDE.md"; rm -f "$tmp"
fi
printf '%s\n%s\n' "$MARK" "$IMPORT" >> "$C/CLAUDE.md"
link() { # $1 source, $2 target
  if [ -e "$2" ] && [ ! -L "$2" ]; then echo "SKIP $2 exists and is not a symlink (yours?)"; return; fi
  ln -sfn "$1" "$2"; echo "linked $2"
}
# Remove dangling links to skills/agents that no longer exist in this repo (renamed or removed).
for l in "$C"/skills/wf-* "$C"/agents/wf-*; do
  if [ -L "$l" ] && [ ! -e "$l" ] && [[ "$(readlink "$l")" == "$W"/* ]]; then rm "$l"; echo "removed stale $l"; fi
done
for d in "$W"/skills/wf-*; do link "$d" "$C/skills/$(basename "$d")"; done
for f in "$W"/agents/*.md; do link "$f" "$C/agents/$(basename "$f")"; done
chmod +x "$W/bin/wf-lint"
python3 "$W/bin/wf-lint" --install-hook "$C"   # SessionStart drift check
echo "done ($C). Restart Claude Code sessions to load it."
