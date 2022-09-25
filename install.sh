#!/bin/bash

if [[ $SHELL != *"zsh" ]]; then
    if [[ -f "$(which zsh)" ]]; 
    then
        echo "Changing shell to zsh, please insert your password"
        chsh -s /usr/bin/zsh
    else
        echo "Failed to change the shell. zsh not installed."
    fi
fi

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
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Installing dotfiles with stow
rm -rf "$HOME/.p10k.zsh"
rm -rf "$HOME/.gitconfig"
rm -rf "$HOME/.zshrc"
rm -rf "$HOME/.zshenv"

rm -rf "$HOME/.config/libinput-gestures.conf"

# KDE configs
rm -rf "$HOME/.local/share/color-schemes/"
rm -rf "$HOME/.config/kdeglobals"
rm -rf "$HOME/.config/kglobalshortcutsrc"
rm -rf "$HOME/.config/kwinrc"

rm -rf "$HOME/.config/neofetch"

cd $clone_target
# stow kde # for kde only
stow libinput-gestures
stow zsh
stow git
stow p10k
stow neofetch
# stow fusuma # if OS uses fusuma for mouse gestures
stow gallery-dl