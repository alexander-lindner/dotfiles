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
  export ZSH_DISABLE_COMPFIX="true"
  source $HOME/.profile-macos
else
  autoload -Uz compinit && compinit
fi



ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

POSH_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/oh-my-posh/"
if [ ! -f "${POSH_HOME}oh-my-posh" ]; then
   mkdir -p "${POSH_HOME}"
   if [ Darwin = `uname` ]; then
    curl -Lo "${POSH_HOME}oh-my-posh" https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-darwin-arm64
   else
    curl -Lo "${POSH_HOME}oh-my-posh" https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64
  fi
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

if command -v helm &> /dev/null; then
  export HELM_PLUGINS="$(helm env HELM_PLUGINS)"


  targetDir="$HOME/.dotfiles/terraform"
  terraform_version="1.8.5"

  # Check if terraform is installed
  if [ ! -f "$targetDir/$terraform_version/terraform" ] ; then
    echo "Terraform not found. Downloading version $terraform_version..."

    # Ensure target directory exists
    mkdir -p "$targetDir/$terraform_version"

    # Download and extract Terraform
    curl -sSL "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_darwin_arm64.zip" -o /tmp/terraform.zip
    unzip -o /tmp/terraform.zip -d "$targetDir/$terraform_version"
    rm /tmp/terraform.zip

    echo "Terraform $terraform_version installed successfully."
  fi

  # Export the PATH
  export PATH="$targetDir/$terraform_version:$PATH"

  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /Users/b45212/.dotfiles/terraform/1.8.5/terraform terraform
else
    autoload -U +X bashcompinit && bashcompinit
fi



