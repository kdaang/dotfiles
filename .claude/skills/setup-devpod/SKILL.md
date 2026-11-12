---
name: setup-devpod
description: Set up or refresh a Linux devpod from the kdaang/dotfiles repo (zsh, p10k, tmux, nvim, CLI tools, symlinks, Claude skills). Use when the user asks to set up a new devpod or machine, bootstrap or sync dotfiles on a devpod, or re-run the devpod setup. Pulls the repo, brings bin/setup-devpod.sh up to date with it, then runs the script.
---

# Set up a devpod

The work is done by `bin/setup-devpod.sh` in the dotfiles repo, the same repo this skill
lives in. The user always clones the repo by hand first, so it already exists: it's the
directory two levels above this skill's folder (`.claude/skills/setup-devpod/` → repo
root), usually `~/code/dotfiles`. Below, `$DOTFILES` means that repo root. This skill makes
sure the repo and the script are current before running it. The script is safe to re-run.

The repo is public. Never add anything sensitive to it, such as hostnames, IPs, usernames,
emails, tokens or keys. Anything machine-specific belongs in files outside the repo.

## 1. Get the latest repo

- Run `git -C "$DOTFILES" fetch` and look at `git status` and the incoming commits before
  pulling.
  - If local edits block the pull, check whether they're already identical to upstream
    (the user often makes the same change on their Mac and pushes it). Drop identical
    copies. For real local edits: stash, `git pull --ff-only`, pop, and resolve conflicts
    keeping both sides. Tell the user what you merged.
  - `.config/tmux/tmux.conf` is normally modified locally: the script uncomments
    `source-file -q ~/.tmux.devpod.conf` there. That line must stay commented in the repo,
    so never commit it.

## 2. Bring the script up to date with the repo

The script must match what's in the repo before it runs:

1. Run `"$DOTFILES"/bin/setup-devpod.sh --audit`. It lists top-level repo files,
   `.config/*` and `.claude/*` entries that the script neither links (`LINKS`) nor skips
   (`SKIP`). `bin/*` and `.claude/skills/*` are linked automatically.
2. For each item it reports, decide: if it's for macOS only (a Mac app's config, Homebrew,
   yabai, etc.), add it to `SKIP`. If it should exist on a devpod, add it to `LINKS`.
   If it's unclear, ask the user.
3. Read the commits since the script last changed
   (`git log --oneline $(git log -1 --format=%H -- bin/setup-devpod.sh)..HEAD`) and the
   README's Devpod section. If they need new packages, clones, or setup steps on devpods,
   add them to the script (`APT_PACKAGES`, the clones section, etc.).
4. Check the script with `bash -n` (and `shellcheck` if installed) and re-run `--audit`
   until it says everything is handled.

If the script changed, show the user the diff and offer to commit and push it. Don't commit
the uncommented tmux line or `.config/nvim/lazy-lock.json` with it.

## 3. Run it

```sh
"$DOTFILES"/bin/setup-devpod.sh
```

It does everything that doesn't need a password: clones Powerlevel10k, zsh-vi-mode, TPM and
nvm; installs node; symlinks the dotfiles, `bin/*` and the repo's Claude skills; and
installs tmux plugins. At the end it prints the steps that need sudo or a password:
apt packages, generating missing locales (SSH forwards `LC_ALL`, e.g. `en_CA.UTF-8`, which
the devpod may not have), and `chsh` to zsh.

You can't run those steps: `sudo` and `chsh` need a terminal to ask for the password, and
neither your Bash tool nor the user's `!` prefix gives them one. Ask the user to run
`"$DOTFILES"/bin/setup-devpod.sh --sudo` in a normal terminal (a second SSH session),
then run the script again yourself to finish anything that needed those packages, for
example tmux plugins.

## 4. Check the result

- `zsh -ic exit` starts with no errors or warnings (watch for `perl: warning: Setting locale failed`).
- `tmux -L check -f ~/.config/tmux/tmux.conf start-server \; kill-server` prints nothing.
- `ls -la ~/.claude/skills` shows a link for each skill in the repo, with none dangling.

Tell the user what changed and which steps are still waiting on them. The new shell, tmux
config and Claude skills take effect after `exec zsh`, reloading tmux and `/reload-skills`.

## Not handled by the script

- `~/.claude/settings.json` is a separate file on each machine and has drifted from the
  repo's `.claude/settings.json`. Don't overwrite it. Mention it if the repo copy has new
  settings the user might want.
- Claude plugins and MCP servers (claude-hud, chrome-devtools) are installed with
  `/plugin` and `claude mcp add`, not by the script.
- claude-hud: the script copies its display settings (`.claude/claude-hud/config.json` →
  `~/.claude/plugins/claude-hud/config.json`). It must be a copy, not a symlink: claude-hud
  reads it in a Node permission sandbox that can't follow a link out of `~/.claude`, and the
  status line then shows "config.json can't be read". If the user changes settings with
  `/hud`, copy the file back into the repo to save them. The status line itself is set per machine
  (it points at that machine's node or bun). On a new devpod, remind the user to install the
  plugin (`/plugin marketplace add jarrodwatts/claude-hud`, then `/plugin install claude-hud`)
  and run `/hud` to set up the status line.
