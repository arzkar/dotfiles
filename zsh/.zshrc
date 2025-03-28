# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
bindkey -e
bindkey '^ ' forward-word
setopt promptsubst
setopt appendhistory
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'
# zstyle ':completion:*' menu select

autoload -Uz compinit
compinit
# End of lines added by compinstall

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# User specific aliases and functions
alias ebook-convert-helper="pyenv activate ff-yt-dl; ebook-convert-helper"
alias rsync_books_android=/media/Data/Projects/Scripts/rsync/rsync_books_android.sh
alias rsync_kindle=/media/Data//Projects/Scripts/rsync/rsync_kindle.sh
alias fzf-books=/media/Data/Projects/Scripts/utils/fzf/fzf-books.sh
alias zshconfig="code ~/.zshrc"
alias ssh_pointo_ec2="ssh -i ~/.ssh/pointo ubuntu@13.235.198.184"
alias ssh_pointo_test_ec2="ssh -i ~/.ssh/pointo root@13.126.235.243"
alias ssh_pointo_iot_ec2="ssh -i ~/.ssh/pointo ubuntu@43.204.214.167"
alias ssh_pointo_iot_staging_v2_ec2="ssh -i ~/.ssh/pointo ubuntu@98.130.81.98"
alias ssh_pointo_iot_staging_db="ssh -i ~/.ssh/pointo ubuntu@40.192.54.142"
alias ssh_gitlab_runner_ec2="ssh -i ~/.ssh/pointo root@3.6.155.231"
alias ssh_pointo_jenkins_ec2="ssh -i ~/.ssh/pointo ubuntu@13.233.98.180"
alias ssh_pointo_pilot_prod_ec2="ssh -i ~/.ssh/pointo ubuntu@18.61.69.194"
alias ssh_pointo_pilot_test_ec2="ssh -i ~/.ssh/pointo ubuntu@18.60.216.235"
alias ssh_last_pulse_backend="ssh ubuntu@13.200.168.135 -i ~/.ssh/last_pulse_arbaaz"
alias ssh_last_pulse_frontend="ssh ubuntu@43.205.175.82 -i ~/.ssh/last_pulse_arbaaz"
alias cursor='/home/arbaaz/apps/cursor.AppImage "$PWD" &'

export HOST=localhost

# !! pyenv config !!
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# if which pyenv > /dev/null; then
#     eval "$(pyenv init --path)" # this only sets up the path stuff
#     eval "$(pyenv init -)"      # this makes pyenv work in the shell
# fi
# if which pyenv-virtualenv-init > /dev/null; then
#     eval "$(pyenv virtualenv-init - zsh)"
# fi


# python
export PATH="$HOME/.local/bin:$PATH"

export PATH="/usr/local/bin/:$PATH"

# cargo(rust)
source "$HOME/.cargo/env"

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# !! oh-my-zsh config !!

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# robbyrussell, classyTouch, spaceship, trapd00r,
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git docker docker-compose copybuffer copypath dirhistory sudo rust)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins
source ~/.zsh/zsh-z/zsh-z.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# golang
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$PATH"

# gem
# export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# adb
export PATH="$HOME/apps/adb-fastboot:$PATH"

# i3-battery-popup
export PATH="$HOME/apps/i3-battery-popup:$PATH"

# java
export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
export PATH=$PATH:$JAVA_HOME/bin

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi
# clang
export LIBCLANG_PATH=/usr/lib64
export PATH=$PATH:/home/arbaaz/.spicetify

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/arbaaz/apps/google-cloud-sdk/path.zsh.inc' ]; then . '/home/arbaaz/apps/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/arbaaz/apps/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/arbaaz/apps/google-cloud-sdk/completion.zsh.inc'; fi
