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
if [ ! -d "$clone_target" ]; then
    git clone https://github.com/arzkar/dotfiles $clone_target
else
    echo "Dotfiles directory already exists at $clone_target"
    echo "Using existing directory..."
fi

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

# Add this function to setup PPAs and dependencies
setup_dependencies() {
    # Add polybar PPA
    sudo add-apt-repository ppa:kgilmer/speed-ricer -y

    # Update package lists
    sudo apt update

    # Install polybar, picom and other dependencies
    sudo apt install -y \
        polybar \
        picom \
        cmake \
        cmake-data \
        pkg-config \
        python3-sphinx \
        python3-packaging \
        libuv1-dev \
        libcairo2-dev \
        libxcb1-dev \
        libxcb-util0-dev \
        libxcb-randr0-dev \
        libxcb-composite0-dev \
        python3-xcbgen \
        xcb-proto \
        libxcb-image0-dev \
        libxcb-ewmh-dev \
        libxcb-icccm4-dev \
        libxcb-xkb-dev \
        libxcb-xrm-dev \
        libxcb-cursor-dev \
        libasound2-dev \
        libpulse-dev \
        libjsoncpp-dev \
        libmpdclient-dev \
        libcurl4-openssl-dev \
        libnl-genl-3-dev
}

# Fix the qBittorrent theme installation
setup_qbittorrent_theme() {
    if [ -d "$HOME/apps/qBittorrentDarktheme" ]; then
        echo "Removing existing qBittorrent theme directory..."
        rm -rf "$HOME/apps/qBittorrentDarktheme"
    fi
    
    mkdir -p "$HOME/apps"
    git clone https://github.com/maboroshin/qBittorrentDarktheme.git "$HOME/apps/qBittorrentDarktheme"
}

# First define the setup_i3 function
setup_i3 () {
    # Install dependencies first
    setup_dependencies

    # Check if i3 is installed
    if ! command -v i3 &> /dev/null; then
        echo "Installing i3..."
        sudo apt install i3 i3-wm i3status i3lock
    fi

    # Check and install XFCE components
    if ! command -v xfce4-session &> /dev/null; then
        echo "Installing XFCE..."
        sudo apt install xfce4 xfce4-goodies
    fi

    # Check and install Polybar
    if ! command -v polybar &> /dev/null; then
        echo "Installing Polybar and dependencies..."
        sudo apt install \
            polybar \
            cmake \
            cmake-data \
            pkg-config \
            python3-sphinx \
            python3-packaging \
            libuv1-dev \
            libcairo2-dev \
            libxcb1-dev \
            libxcb-util0-dev \
            libxcb-randr0-dev \
            libxcb-composite0-dev \
            python3-xcbgen \
            xcb-proto \
            libxcb-image0-dev \
            libxcb-ewmh-dev \
            libxcb-icccm4-dev \
            libxcb-xkb-dev \
            libxcb-xrm-dev \
            libxcb-cursor-dev \
            libasound2-dev \
            libpulse-dev \
            libjsoncpp-dev \
            libmpdclient-dev \
            libcurl4-openssl-dev \
            libnl-genl-3-dev
    fi

    # Additional i3 utilities from your config
    sudo apt install \
        i3lock-fancy \
        rofi \
        dunst \
        picom \
        feh \
        arandr \
        xbacklight \
        network-manager-gnome \
        pasystray \
        xclip \
        maim \
        xdotool \
        xss-lock

    # Verify installations
    echo "Checking installations..."
    echo "i3 version: $(i3 --version)"
    echo "XFCE version: $(xfce4-session --version)"
    echo "Polybar version: $(polybar --version)"
}

# Then define other functions
setup_systemd () {
  sudo chmod 644 ${HOME}/dotfiles/systemd/i3lock-fancy.service
  sudo ln -s ${HOME}/dotfiles/systemd/i3lock-fancy.service /etc/systemd/system/i3lock-fancy.service

  sudo systemctl daemon-reload
  sudo systemctl enable i3lock-fancy
}

setup_cursor () {
  stow desktop
  update-desktop-database ~/.local/share/applications
}

setup_i3_apps () {
  mkdir $HOME/apps
  if [ ! -d $HOME/apps/i3lock-fancy ]; then
    git clone https://github.com/meskarune/i3lock-fancy.git  $HOME/apps/i3lock-fancy
    cd $HOME/apps/i3lock-fancy
    sudo make install
  fi
}

setup_battery_notify () {
  if [ ! -d $HOME/apps/i3-battery-popup ]; then
    git clone https://github.com/rjekker/i3-battery-popup.git  $HOME/apps/i3-battery-popup
  fi
}

# qbittorrent theme
mkdir $HOME/apps
git clone https://github.com/maboroshin/qBittorrentDarktheme.git $HOME/apps/qBittorrentDarktheme


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
setup_cursor

# Use arg1 and arg2 for different actions
echo "Syncing configs for $arg1"
if [ "$arg1" == "kde" ]
then``
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
    setup_i3
    setup_qbittorrent_theme
    rm -rf "$HOME/.config/i3"
    rm -rf "$HOME/.config/polybar"
    stow i3
    stow polybar
    stow xinput
    stow autostart
    stow gtk
    stow xfce
    setup_battery_notify
    # setup_systemd
else
    echo "Invalid argument: $arg1"
    exit 1
fi