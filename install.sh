#!/bin/bash

# Check if the script is run as root
# if [ "$EUID" -ne 0 ]
# then
#     echo "Please run this script as root"
#     exit
# fi

# Check if the number of arguments is correct
if [ "$#" -ne 1 ]
then
    echo "Usage: $0 DE<arg1>"
    exit 1
fi

arg1=$1

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if Git, Stow, and Zsh are installed
check_dependencies() {
  local missing=0
  local missing_deps=()

  if ! command_exists git; then
    missing_deps+=("git")
    missing=1
  fi

  if ! command_exists stow; then
    missing_deps+=("stow")
    missing=1
  fi

  if ! command_exists zsh; then
    missing_deps+=("zsh")
    missing=1
  fi

  if [ $missing -eq 1 ]; then
    echo "The following dependencies are missing: ${missing_deps[*]}"
  fi

  return $missing
}

# Check dependencies
if ! check_dependencies; then
  exit 1
fi

# Common stuff
# Change shell to zsh
if [[ $SHELL != *"zsh" ]]; then
    if [[ -f "$(which zsh)" ]]; 
    then
        echo "Changing shell to zsh, please insert your password"
        chsh -s /usr/bin/zsh
    else
        echo "Failed to change the shell. zsh not installed."
    fi
fi

# clone dotfiles repo
clone_target="${HOME}/dotfiles"
git clone https://github.com/arzkar/dotfiles $clone_target

# Install zsh plugins
if [ ! -d $HOME/.zsh ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/zsh-syntax-highlighting
    git clone https://github.com/agkozak/zsh-z $HOME/.zsh/zsh-z
fi

# Setup omz
if [ ! -d $HOME/.oh-my-zsh ]; then
    git clone https://github.com/ohmyzsh/ohmyzsh $HOME/.oh-my-zsh
    # Install p10k theme
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Setup nvim
# Install vim-plug
# sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

setup_systemd_services () {
  # sudo chmod 644 ${HOME}/dotfiles/systemd-services/xidlehook.service
  sudo chmod 644 ${HOME}/dotfiles/systemd-services/lock.service

  # sudo ln -s ${HOME}/dotfiles/systemd-services/xidlehook.service /etc/systemd/system/xidlehook.service
  sudo ln -s ${HOME}/dotfiles/systemd-services/lock.service /etc/systemd/system/lock.service

  sudo systemctl daemon-reload
  # sudo systemctl start xidlehook
  sudo systemctl start lock
}

# Remove existing configs
rm -rf "$HOME/.p10k.zsh"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.zshrc"
rm -rf "$HOME/.zshenv"
rm -rf "$HOME/.config/neofetch"

# Stow common files
cd $clone_target
stow zsh
stow git
stow p10k
stow gallery-dl
stow fanficfare
stow neofetch


# Use arg1 and arg2 for different actions
echo "Syncing configs for $arg1"
if [ "$arg1" == "kde" ]
then
    rm -rf "$HOME/.local/share/color-schemes/"
    rm -rf "$HOME/.config/kdeglobals"
    rm -rf "$HOME/.config/kglobalshortcutsrc"
    rm -rf "$HOME/.config/kwinrc"
    rm -rf "$HOME/.config/libinput-gestures.conf"

    stow kde
    stow libinput-gestures
    stow fusuma
elif [ "$arg1" == "i3" ]
then
    rm -rf "$HOME/.config/i3"
    rm -rf "$HOME/.config/polybar"
    stow i3
    stow polybar
    stow xinput
    stow autostart
    stow gtk
    stow xfce
    # setup_systemd_services
else
    echo "Invalid argument: $arg1"
    exit 1
fi