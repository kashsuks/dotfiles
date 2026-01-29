#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/kashsuks/dotfiles"
DOTDIR="${DOTDIR:-$HOME/.dotfiles}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)}"

info()  { printf "\033[1;34m[info]\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m[warn]\033[0m %s\n" "$*"; }
err()   { printf "\033[1;31m[err ]\033[0m %s\n" "$*"; }
die()   { err "$*"; exit 1; }
have()  { command -v "$1" >/dev/null 2>&1; }
is_macos(){ [[ "$(uname -s)" == "Darwin" ]]; }

ensure_xcode_clt() {
  if xcode-select -p >/dev/null 2>&1; then
    info "Xcode Command Line Tools already installed."
    return
  fi
  info "Installing Xcode Command Line Tools..."
  xcode-select --install >/dev/null 2>&1 || true
  until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  info "Xcode Command Line Tools installed."
}

ensure_homebrew() {
  if have brew; then
    info "Homebrew already installed."
    return
  fi
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # add brew to PATH for this script run (Apple Silicon vs Intel)
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  have brew || die "Homebrew install failed or brew not on PATH."
  info "Homebrew installed."
}

clone_or_update_repo() {
  if [[ -d "$DOTDIR/.git" ]]; then
    info "Dotfiles repo already exists at $DOTDIR. Updating..."
    git -C "$DOTDIR" pull --rebase
    return
  fi

  if [[ -d "$DOTDIR" && ! -d "$DOTDIR/.git" ]]; then
    die "$DOTDIR exists but is not a git repo. Move it aside and retry."
  fi

  info "Cloning dotfiles into $DOTDIR..."
  git clone "$REPO_URL" "$DOTDIR"
}

backup_if_needed() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    info "Backing up $(basename "$target") -> $BACKUP_DIR"
    mv "$target" "$BACKUP_DIR/"
  fi
}

link_dir_to_config() {
  local name="$1"
  local src="$DOTDIR/$name"
  local dst="$HOME/.config/$name"

  [[ -d "$src" ]] || { warn "Skipping missing folder: $name"; return; }

  mkdir -p "$HOME/.config"

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [[ "$cur" == "$src" ]]; then
      info "Already linked: $dst -> $src"
      return
    fi
  fi

  backup_if_needed "$dst"
  ln -s "$src" "$dst"
  info "Linked: $dst -> $src"
}

install_packages() {
  info "Installing core packages for your setup (yabai/skhd/sketchybar/kitty/nvim/spicetify)..."
  brew update

  brew install neovim

  brew install koekeishiya/formulae/yabai
  brew install koekeishiya/formulae/skhd
  brew install sketchybar

  brew install --cask kitty
  brew install spicetify-cli || brew install spicetify

  info "Packages installed (or already present)."
}

post_notes() {
  cat <<'EOF'

Next steps / notes:
- yabai + skhd require Accessibility permissions:
  System Settings → Privacy & Security → Accessibility → enable for:
    - skhd
    - yabai
  (and usually your terminal app too)

- If you use scripting additions (older yabai setups), SIP changes are manual and NOT done by this script.

- sketchybar typically needs to be started (brew services is optional):
    brew services start yabai
    brew services start skhd
    brew services start sketchybar

- spicetify requires Spotify installed + its own apply step:
    spicetify backup apply

EOF
}

main() {
  is_macos || die "This installer is for macOS only."

  info "Starting Kashyap's dotfiles install."
  ensure_xcode_clt
  have git || die "git not found (should come with Xcode CLT)."

  ensure_homebrew

  if ! have brew; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  clone_or_update_repo
  install_packages

  info "Symlinking config folders into ~/.config ..."
  link_dir_to_config "kitty"
  link_dir_to_config "nvim"
  link_dir_to_config "sketchybar"
  link_dir_to_config "skhd"
  link_dir_to_config "spicetify"
  link_dir_to_config "yabai"

  info "Done."
  if [[ -d "$BACKUP_DIR" ]]; then
    warn "Backups stored in: $BACKUP_DIR"
  fi

  post_notes
}

main "$@"
