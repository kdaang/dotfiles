#!/usr/bin/env bash
# User's session-start hook wrapper
# Delegates to superpowers upstream — edit here to add logic before/after.
# Upstream: ~/.claude/3rd_party/superpowers/hooks/session-start

# USER PRE-HOOK: Add any logic to run before the superpowers session-start

exec "$HOME/.claude/3rd_party/superpowers/hooks/session-start"

# Note: nothing after exec runs — move pre-hook logic above if needed
