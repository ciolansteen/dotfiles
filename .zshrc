# -*- mode: sh -*-
# vim: filetype=sh
##### iadrian_zshrc #####

# Load mime info
autoload -U zsh-mime-setup compinit
zsh-mime-setup

# Settings
# Set ZSH theme (for some reasoun it has to be set before sourcing oh-my-zsh.sh
ZSH_THEME="funky"

# Default block cursor
#PROMPT_COMMAND="echo -e '\033[?112c'"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="%d/%m/%y %k:%M:%S"

# Remove history duplicates
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

# Default plugins are located in ~/.oh-my-zsh/plugins/*)
# Custom plugins are located in ~/.oh-my-zsh/custom/plugins/
# plugins=(rails git textmate ruby lighthouse)

# Install oh-my-zsh if not present
if [[ ! -d $ZSH ]]; then
  echo "### Oh-My-ZSH not found."
  echo "### After the prompt is back again, issue an exit command to complete the installation"
  echo "Installing..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ -f ~/.zshrc.pre-oh-my-zsh ]]; then
  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc
fi

# Install zsh-syntax-highlighting if not present
[[ -d $ZSH/plugins/zsh-syntax-highlighting ]] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting
# Install zsh-autosuggestions if not present
[[ -d $ZSH/plugins/zsh-autosuggestions ]] || git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions

plugins=(
    git
    helm
    vi-mode
    history-substring-search
    docker
    docker-compose
    ruby
    zsh-syntax-highlighting
    zsh-autosuggestions
    tmux
)

source $ZSH/oh-my-zsh.sh
# Load .profile file - Must be loaded before oh-my-zsh to override ls=ls_extend
[[ -e ~/.profile ]] && emulate sh -c 'source $HOME/.profile'

### Look and feel
# Use GNU dircolors
if [ -f ~/.dircolors ]; then
   eval `dircolors ~/.dircolors`
fi
# Use LS_COLORS 
if [ -f ~/.local/share/lscolors.sh ]; then
  source ~/.local/share/lscolors.sh
fi

## VimMode for ZSH
bindkey -v 
## Show Vim NORMAL/INSERT Status
function insert-mode () { echo "%{$fg_bold[yellow]$bg[#]%}-- INSERT -- %{$reset_color%}" }
function normal-mode () { echo "%{$fg_bold[white]$bg[#]%}-- NORMAL -- %{$reset_color%}" }

function set-prompt () {
    case ${KEYMAP} in
      (vicmd)      VI_MODE="$(normal-mode)" ;;
      (main|viins) VI_MODE="$(insert-mode)" ;;
      (*)          VI_MODE="$(insert-mode)" ;;
    esac
    RPS1="$VI_MODE"
    PS1="$PS1"
}

function zle-line-init zle-keymap-select {
    if [ $KEYMAP = vicmd ]; then
        # -- NORMAL -- mode block cursor 
        echo -ne "\e[2 q"
    else
        #  -- INSERT -- mode underscore cursor
        echo -ne "\e[1 q"
    fi
    set-prompt
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

## Saner KEYTIMEOUT (default = 40) to Kill <ESC> / I lag when switching -- INSERT -- / -- NORMAL -- in VimMode
export KEYTIMEOUT=5

# Prevent keeping Right PS info on that line after <CR>
setopt transientrprompt

# SpecialKeys override to work with Vi-Mode
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey -M viins "\e[1~" beginning-of-line                       # [Home] - Go to beginning of line
  bindkey -M vicmd "\e[1~" beginning-of-line
  bindkey -M viins "^[[H"  beginning-of-line
  bindkey -M vicmd "^[[H"  beginning-of-line
fi

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey -M viins "\e[4~" end-of-line      	                   # [End] - Go to end of line
  bindkey -M vicmd "\e[4~" end-of-line
  bindkey -M viins "^[[F"   end-of-line
  bindkey -M vicmd "^[[F"   end-of-line
fi

if [[ "${terminfo[kich1]}" != "" ]]; then
  bindkey -M viins "${terminfo[kich1]}" overwrite-mode      	   # [Insert] - Insert Mode (Overwrite-mode) 
  bindkey -M vicmd "${terminfo[kich1]}" overwrite-mode
fi

if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey -M viins "${terminfo[kdch1]}" delete-char      	   # [Delete] - Delete Character
  bindkey -M vicmd "${terminfo[kdch1]}" delete-char
fi

if [[ "${terminfo[kpp]}" != "" ]]; then
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history/          # [Page Up] - Up 1 Line or History Item 
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi

if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey -M viins "${terminfo[knp]}" down-line-or-history         # [Page Down] - Down 1 Line or History Item 
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

bindkey -M viins "^[[A" history-substring-search-up      	   # [UP] - Search History Backward Based on Entered Letters 
bindkey -M vicmd "^[[A" history-substring-search-up 

bindkey -M viins "^[[B" history-substring-search-down              # [DOWN] - Search History Forward Based on Entered Letters 
bindkey -M vicmd "^[[B" history-beginning-search-down 

# Other useful Vim Like Overrides
bindkey -M vicmd 'u' undo 					   # Undo in -- NORMAL -- Mode
bindkey -M vicmd '^r' redo 					   # Redo in -- NORMAL -- Mode
bindkey -M vicmd '/' history-incremental-search-backward           # Use / for Search

# END Zsh Vim Mode
# Bindings for Xterm Home/End/Insert keys when not in Vi Mode
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[2~" overwrite-mode

unset zle_bracketed_paste
