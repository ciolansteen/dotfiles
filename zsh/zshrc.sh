### Ciolansteen's ZSHrc

# Settings
# Load .profile file
[[ -e ~/.profile ]] && emulate sh -c 'source $HOME/.profile'
# Set ZSH theme (for some reasoun it has to be set before sourcing oh-my-zsh.sh
ZSH_THEME="funky"

# Default block cursor
PROMPT_COMMAND="echo -e '\033[?112c'"

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
HIST_STAMPS="%d/%m/%y %k:%M:%S"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Default plugins are located in ~/.oh-my-zsh/plugins/*)
# Custom plugins are located in ~/.oh-my-zsh/custom/plugins/
# plugins=(rails git textmate ruby lighthouse)
plugins=(
    git
    vi-mode
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

### Look and feel
# Use GNU dircolors
if [ -f ~/.dircolors ]; then
   eval `dircolors ~/.dircolors`
fi

# Zsh Syntax Highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Zsh Autosugestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

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

preexec () { echo -ne '\e[5 q' }

zle -N zle-line-init
zle -N zle-keymap-select

## Saner KEYTIMEOUT (default = 40) to Kill <ESC> / I lag when switching -- INSERT -- / -- NORMAL -- in VimMode
export KEYTIMEOUT=5
#vimInsMode="%{$fg_bold[yellow]$bg[#]%}-- INSERT --%{$reset_color%}"
#vimNormMode="%{$fg_bold[white]$bg[#]%}-- NORMAL --%{$reset_color%}"
#
#function zle-line-init zle-keymap-select {
#    RPS1="${${KEYMAP/vicmd/${vimNormMode} }/(main|viins)/${vimInsMode} }"
#    RPS2=$RPS1
#    zle reset-prompt
#}
#

## Don't use VimMode when inside MC to avoid mc hanging in ""-- NORMAL --" mode. 
#if ! ps $PPID |grep mc; then
#    bindkey -v 
#    zle -N zle-line-init
#    zle -N zle-keymap-select
#fi

# Prevent keeping Right PS info on that line after <CR>
setopt transientrprompt

# for linux console and RH/Debian xterm

# SpecialKeys override to work with Vi-Mode
if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey -M viins "\e[1~" beginning-of-line      # [Home] - Go to beginning of line
  bindkey -M vicmd "\e[1~" beginning-of-line
fi

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey -M viins "\e[4~" end-of-line      	   # [End] - Go to end of line
  bindkey -M vicmd "\e[4~" end-of-line
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
  bindkey -M viins "${terminfo[kpp]}" up-line-or-history     	   # [Page Up] - Up 1 Line or History Item 
  bindkey -M vicmd "${terminfo[kpp]}" up-line-or-history
fi

if [[ "${terminfo[knp]}" != "" ]]; then
  bindkey -M viins "${terminfo[knp]}" down-line-or-history      	   # [Page Down] - Down 1 Line or History Item 
  bindkey -M vicmd "${terminfo[knp]}" down-line-or-history
fi

#bindkey -M viins "^[[A" history-beginning-search-backward      	   # [UP] - Search History Backward Based on Entered Letters 
#bindkey -M vicmd "^[[A" history-beginning-search-backward 
#
#bindkey -M viins "^[[B" history-beginning-search-forward           # [DOWN] - Search History Forward Based on Entered Letters 
#bindkey -M vicmd "^[[B" history-beginning-search-forward 
#


bindkey -M viins "^[[A" history-substring-search-up      	   # [UP] - Search History Backward Based on Entered Letters 
bindkey -M vicmd "^[[A" history-substring-search-up 

bindkey -M viins "^[[B" history-substring-search-down 
         # [DOWN] - Search History Forward Based on Entered Letters 
bindkey -M vicmd "^[[B" history-beginning-search-down 

# Other useful Vim Like Overrides
bindkey -M vicmd 'u' undo 										# Undo in -- NORMAL -- Mode
bindkey -M vicmd '^r' redo 										# Redo in -- NORMAL -- Mode
bindkey -M vicmd '/' history-incremental-search-backward        # Use / for Search

# END Zsh Vim Mode
##

# Bindings for Xterm Home/End/Insert keys when not in Vi Mode
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[2~" overwrite-mode

unset zle_bracketed_paste













