export EDITOR="nano"

# Set the GPG_TTY to be the same as the TTY, either via the env var
# or via the tty command.
if [ -n "$TTY" ]; then
  export GPG_TTY=$(tty)
else
  export GPG_TTY="$TTY"
fi


# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

export PATH="/usr/local/bin:/usr/bin:$PATH"

if [ Darwin = `uname` ]; then
  source $HOME/.profile-macos
fi

autoload -Uz compinit && compinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

POSH_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/oh-my-posh/"
if [ ! -f "${POSH_HOME}oh-my-posh" ]; then
   mkdir -p "${POSH_HOME}"
   curl -Lo "${POSH_HOME}oh-my-posh" https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
   chmod +x "${POSH_HOME}oh-my-posh"

   "${POSH_HOME}oh-my-posh" font install meslo
   "${POSH_HOME}oh-my-posh" font install JetbrainsMono
fi
export PATH=$POSH_HOME:$PATH


eval "$(oh-my-posh init  zsh --config ~/.config/oh-my-posh/quick-term.omp.toml)"

zinit light ohmyzsh/ohmyzsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::rust
zinit snippet OMZP::command-not-found
zinit snippet OMZP::systemd
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::gcloud

zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

source $HOME/.profile

if [ Linux = `uname` ]; then
    if [ -f $HOME/.profile-linux ]; then
        source $HOME/.profile-linux
    fi
fi
setopt auto_cd


source <(kubectl completion zsh)


if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

zle_highlight=('paste:none')
