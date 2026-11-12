#!/usr/bin/env bash
# Set up a fresh Ubuntu devpod from this dotfiles repo. Safe to re-run.
#
#   bin/setup-devpod.sh            # everything that doesn't need sudo; prints the sudo steps still to do
#   bin/setup-devpod.sh --sudo     # also run the sudo steps (needs a real terminal for the password)
#   bin/setup-devpod.sh --audit    # only list repo files this script doesn't handle yet
#
# Keep this file in sync with the repo: when a dotfile that should exist on devpods is added,
# add it to LINKS (or to SKIP if it shouldn't), so --audit stays empty.
set -uo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUN_SUDO=false
AUDIT_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --sudo) RUN_SUDO=true ;;
    --audit) AUDIT_ONLY=true ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

APT_PACKAGES=(
  zsh tmux fzf fd-find bat eza zoxide git-delta jq direnv neovim
  zsh-autosuggestions zsh-syntax-highlighting build-essential unzip
)

# "<path in repo>:<path in $HOME>"
LINKS=(
  ".zshrc:.zshrc"
  ".p10k.zsh:.p10k.zsh"
  ".p10k.devpod.zsh:.p10k.devpod.zsh"
  ".tmux.devpod.conf:.tmux.devpod.conf"
  ".gitconfig:.gitconfig"
  ".vimrc:.vimrc"
  ".config/.alias_zshrc:.config/.alias_zshrc"
  ".config/nvim:.config/nvim"
  ".config/tmux:.config/tmux"
  ".config/bat:.config/bat"
)

# "<path in repo>:<path in $HOME>" — copied instead of linked, for tools that won't read through
# a symlink (claude-hud reads its config in a Node permission sandbox that only allows the
# path under ~/.claude). A copy that differs from the repo is left alone and reported.
COPIES=(
  ".claude/claude-hud/config.json:.claude/plugins/claude-hud/config.json"
)

# Repo paths deliberately not set up on devpods (macOS apps, unused tools, repo-only files, this script).
SKIP=(
  .git .gitmodules .gitignore README.md Brewfile Documents .ideavimrc
  .claude/settings.json .claude/hooks .claude/3rd_party
  .config/alacritty .config/borders .config/fish .config/gitui .config/hammerspoon .config/jqp
  .config/karabiner .config/lazygit .config/nivek .config/nnn .config/powerline .config/skhd
  .config/spotify-tui .config/spotifyd .config/starship.toml .config/tmuxp .config/yabai
  bin/hmw bin/yabaiw bin/scratch bin/setup-devpod.sh
)

TODO=()
log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

# ---------------------------------------------------------------- audit
audit() {
  local handled=() p
  for l in "${LINKS[@]}" "${COPIES[@]}"; do handled+=("${l%%:*}" "$(dirname "${l%%:*}")"); done
  handled+=("${SKIP[@]}" bin .claude .claude/skills .config)
  local missing=0
  while IFS= read -r p; do
    p="${p#./}"
    case " ${handled[*]} " in *" $p "*) continue ;; esac
    [[ "$p" == bin/* || "$p" == .claude/skills/* ]] && continue   # linked automatically
    echo "  not handled: $p"; missing=1
  done < <(cd "$DOTFILES" && find . -mindepth 1 -maxdepth 1 ! -name . -printf '%P\n'; \
           find .config .claude -mindepth 1 -maxdepth 1 2>/dev/null)
  return $missing
}

if $AUDIT_ONLY; then
  audit && echo "everything in the repo is handled"; exit $?
fi

# ---------------------------------------------------------------- sudo steps
missing_pkgs() {
  local p
  for p in "${APT_PACKAGES[@]}"; do dpkg -s "$p" &>/dev/null || echo "$p"; done
}

missing_locale() {
  local want norm
  for want in "${LC_ALL:-}" "${LANG:-}"; do
    [[ -z "$want" || "$want" == C* || "$want" == POSIX ]] && continue
    norm="$(echo "$want" | sed 's/UTF-8/utf8/I')"
    locale -a 2>/dev/null | grep -qix "$norm" || echo "$want"
  done | sort -u
}

sudo_steps() {
  local pkgs locales
  pkgs="$(missing_pkgs | tr '\n' ' ')"
  [[ -n "$pkgs" ]] && echo "sudo apt-get update && sudo apt-get install -y $pkgs"
  locales="$(missing_locale)"
  for l in $locales; do
    echo "sudo sed -i 's/^# *$l /$l /' /etc/locale.gen && sudo locale-gen"
  done
  [[ "$(getent passwd "$USER" | cut -d: -f7)" == */zsh ]] || echo "chsh -s \"\$(command -v zsh)\""
}

mapfile -t SUDO_STEPS < <(sudo_steps)
if ((${#SUDO_STEPS[@]})); then
  if $RUN_SUDO; then
    for step in "${SUDO_STEPS[@]}"; do log "$step"; bash -c "$step" || warn "failed: $step"; done
    mapfile -t SUDO_STEPS < <(sudo_steps)
  fi
  TODO+=("${SUDO_STEPS[@]}")
fi

# ---------------------------------------------------------------- clones
clone() { # url dest
  if [[ -d "$2/.git" ]]; then git -C "$2" pull -q --ff-only || warn "could not update $2"
  else log "clone $1"; git clone -q --depth=1 "$1" "$2"; fi
}
mkdir -p ~/.local/share/zsh ~/.tmux/plugins ~/bin ~/.local/bin ~/.config ~/.claude/skills
clone https://github.com/romkatv/powerlevel10k.git ~/.local/share/zsh/powerlevel10k
clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.local/share/zsh/zsh-vi-mode
clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

if [[ ! -s ~/.nvm/nvm.sh ]]; then
  nvm_tag="$(git ls-remote --tags --refs https://github.com/nvm-sh/nvm.git 'v*' | sed 's#.*/##' | sort -V | tail -1)"
  log "clone nvm $nvm_tag"
  git clone -q --depth=1 -b "$nvm_tag" https://github.com/nvm-sh/nvm.git ~/.nvm
fi
# shellcheck disable=SC1090
export NVM_DIR=~/.nvm; set +u; . ~/.nvm/nvm.sh
if ! nvm ls default &>/dev/null; then
  log "install latest node"; nvm install node >/dev/null && nvm alias default node >/dev/null
fi
set -u

# ---------------------------------------------------------------- links
link() { # src dest — backs up a real file/dir that's in the way
  local src="$1" dest="$2"
  [[ -e "$src" ]] || { warn "missing in repo: $src"; return; }
  [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]] && return
  if [[ -e "$dest" && ! -L "$dest" ]]; then mv "$dest" "$dest.bak.$(date +%s)"; warn "backed up $dest"; fi
  mkdir -p "$(dirname "$dest")"; ln -sfn "$src" "$dest"; log "link $dest"
}
for l in "${LINKS[@]}"; do link "$DOTFILES/${l%%:*}" "$HOME/${l#*:}"; done

copy() { # src dest
  local src="$1" dest="$2"
  [[ -e "$src" ]] || { warn "missing in repo: $src"; return; }
  [[ -L "$dest" ]] && rm "$dest"   # an older version of this script linked it
  if [[ ! -e "$dest" ]]; then
    mkdir -p "$(dirname "$dest")"; install -m 600 "$src" "$dest"; log "copy $dest"
  elif ! cmp -s "$src" "$dest"; then
    warn "$dest differs from the repo; to save it: cp '$dest' '$src'"
  fi
}
for c in "${COPIES[@]}"; do copy "$DOTFILES/${c%%:*}" "$HOME/${c#*:}"; done

skip_bin=" $(printf '%s ' "${SKIP[@]}") "
for f in "$DOTFILES"/bin/*; do
  [[ "$skip_bin" == *" bin/$(basename "$f") "* ]] && continue
  link "$f" ~/bin/"$(basename "$f")"
done
for d in "$DOTFILES"/.claude/skills/*/; do
  [[ -d "$d" ]] && link "${d%/}" ~/.claude/skills/"$(basename "$d")"
done
# Remove links to skills that were deleted from the repo.
find ~/.claude/skills -maxdepth 1 -xtype l -lname "$DOTFILES/*" -print -delete | sed 's/^/  removed dangling /'

# Ubuntu renames these binaries.
command -v fdfind &>/dev/null && ln -sfn "$(command -v fdfind)" ~/.local/bin/fd
command -v batcat &>/dev/null && ln -sfn "$(command -v batcat)" ~/.local/bin/bat

# ---------------------------------------------------------------- tmux
# The repo keeps the devpod override line commented out; enable it in this checkout only.
sed -i 's|^#\s*source-file -q ~/.tmux.devpod.conf|source-file -q ~/.tmux.devpod.conf|' "$DOTFILES/.config/tmux/tmux.conf"
if command -v tmux &>/dev/null; then
  ~/.tmux/plugins/tpm/bin/install_plugins >/dev/null && log "tmux plugins installed"
  # Remove plugins no longer listed for this machine (e.g. macOS-only tmux-fingers).
  ~/.tmux/plugins/tpm/bin/clean_plugins | grep -i 'removing' || true
fi

# ---------------------------------------------------------------- report
echo
audit >/dev/null || { warn "repo has files this script doesn't handle (run --audit):"; audit; }
if ((${#TODO[@]})); then
  warn "still to do — run these in a normal terminal (they need your password):"
  printf '    %s\n' "${TODO[@]}"
  echo "  or run: $DOTFILES/bin/setup-devpod.sh --sudo"
else
  log "done — open a new shell (exec zsh)"
fi
