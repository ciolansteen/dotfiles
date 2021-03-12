#!/usr/bin/env sh
# -*- mode: sh -*-
# vim: filetype=sh
##### iadrian_profile #####

export TESTVAR="testing"
# Settings
## Defaults
### Paths and Location Variables
TMPDIR="/tmp"
CONFDIR="${HOME}/.config"
### Check for $tempFolder folder and create it if it doesn't exist
tempFolder="${TMPDIR}/${USER}.profile"
if [[ ! -d ${tempFolder} ]]; then
    mkdir "${tempFolder}"
fi
autoStartFolder="${CONFDIR}/autostart"
if [[ ! -d ${autoStartFolder} ]]; then
    mkdir -p "${autoStartFolder}"
fi

### Load User's Profile At login (autostart stuff like generating temporary scripts)
loadUserProfileAtLogin="yes"

loadUserProfileAtLoginTrigger="${HOME}/.loadUserProfileAtLogin"
loadUserProfileAtLoginTmpFile="${tempFolder}/loadUserProfileAtLogin.sh.tmp"
loadUserProfileAtLoginScriptFile="/etc/profile.d/loadUserProfileAtLogin.sh"

if [[ ${loadUserProfileAtLogin} = *"yes" ]]; then
    if [ ! -f ${loadUserProfileAtLoginTrigger} ]; then
        touch ${loadUserProfileAtLoginTrigger}
    fi
    #### Generate the Loader Script in /etc/profile.d/loadUserProfileAtLogin.sh
    if [ ! -f $loadUserProfileAtLoginTmpFile ]; then
sudo cat << loadUserProfileAtLoginScript > ${loadUserProfileAtLoginTmpFile}
if [ -f "\${HOME}/.loadUserProfileAtLogin" ]; then
    . \${HOME}/.profile
fi
loadUserProfileAtLoginScript
chmod +x ${loadUserProfileAtLoginTmpFile}
    fi
    if [ ! -f ${loadUserProfileAtLoginScriptFile} ]; then
        sudo cp ${loadUserProfileAtLoginTmpFile}\
            ${loadUserProfileAtLoginScriptFile}
        $(${loadUserProfileAtLoginScriptFile})
    fi
else
    if [ -f ${loadUserProfileAtLoginTrigger} ]; then
        rm ${loadUserProfileAtLoginTrigger}
    fi
fi

# Functions
## Load SH optional dependencies if they are present
includeDeps (){
    set "$HOME/.secrets"\
        "$HOME/.tempalias"\
        "$@"
    for element do
        if [ -f "${element}" ]; then
            echo "${element} found. Sourcing..."
            . "${element}"
        fi
    done
}
includeDeps

## ls after cd
cdls(){
  cd "$1"
  ls -ah
}

## Create a temporary script in ramdrive to handle emacs for MidnightCommander
### fix for MC being an ass when expanding variables containg spaces - see: https://github.com/fish-shell/fish-shell/issues/6162
emacsClientScriptFile="${tempFolder}/emacsclient"
### Script Creation Function
emacsClientScriptSpawn(){
cat << emacsClientScript > ${emacsClientScriptFile}
#!/usr/bin/env bash
args=( "\$@" )
command='emacsclient -ct'
\$command "\${args[@]}"
emacsClientScript
chmod +x $emacsClientScriptFile
}
### Generate the script if does not exist
if [[ ! -f ${emacsClientScriptFile} ]]; then
    emacsClientScriptSpawn
fi

## If chromium is installed, permit windows creation for each opened Xserver
### (helpful for multiseat, Xephyr configurations)
multiSeatChromiumFile="${tempFolder}/multiseatchromium"
### Script Creation Function
multiSeatChromiumScriptSpawn(){
cat << multiSeatChromiumScript > ${multiSeatChromiumFile}
#!/bin/sh
exec $(which chromium)\
    --enable-greasemonkey \
    --enable-user-scripts\
    --enable-extensions\
    --user-data-dir=\${HOME}/.config/chromium/\$DISPLAY "\$@"
multiSeatChromiumScript
chmod +x $multiSeatChromiumFile
}

# Do not generate the script unless Chromium is installed
if [[ $(which chromium) != *"not found"* ]]; then
    if [[ ! -f $multiSeatChromiumFile ]]; then
        multiSeatChromiumScriptSpawn
    fi
fi

## Merge Xauthority with newly created MIT-MAGIC-COOKIE in /run/user/${UID}/xauth_????

mergeXauthorityFilesScriptFile="${tempFolder}/mergeXauthorityFiles"

mergeXauthorityFilesScriptSpawn(){
cat << mergeXauthorityFilesScript > ${mergeXauthorityFilesScriptFile}
#!/bin/sh
xauthFiles=\$(ls -lah /run/user/\${UID} | grep xauth | rev| cut -d " " -f1 | rev)

for xauthFile in \${xauthFiles}; do
    xauth -f ~/.Xauthority merge /run/user/\${UID}/\$xauthFile
done

mergeXauthorityFilesScript
chmod +x $mergeXauthorityFilesScriptFile
}

# Do not generate the script if exists
if [[ ! -f $mergeXauthorityFilesFile ]]; then
    mergeXauthorityFilesScriptSpawn
    /$mergeXauthorityFilesScriptFile
fi

# Create desktopfile for automatically merge xauth keys for logged user - Fixes Emacs Daemon not being aware of the new cookie generated in /run/user/{UID}/xauth_XXXX if started before the cookie was created (ie - at desktop environment load)
mergeXauthorityFilesDotDesktopFile="${autoStartFolder}/mergeXauthorityFiles.desktop"
mergeXauthorityFilesDotDesktopFileSpawn(){
cat << mergeXauthorityFilesDotDesktop > ${mergeXauthorityFilesDotDesktopFile}
[Desktop Entry]
Comment= Loads $mergeXauthorityFilesScriptFile at DE startup
Exec=sh -c $mergeXauthorityFilesScriptFile
Name=mergeXauthorityFiles
StartupNotify=true
mergeXauthorityFilesDotDesktop
}
# Do not generate the script if exists
if [[ ! -f $mergeXauthorityFilesDotDesktopFile ]]; then
    mergeXauthorityFilesDotDesktopFileSpawn
fi

# Shell based settings
## ZSH
if [[ ${SHELL} == *"/bin/zsh" ]]; then
    ### History - Ignore Duplicates And Spaces
    export HISTCONTROL=ignoreboth     # ignoredups:ignorespace
else
    echo "not zsh. settings to come"
fi

# Preffered Editor
emacsDaemon="$(systemctl --user is-active emacs.service)"
if [ "${emacsDaemon}" = "active" ]; then
    export EDITOR="${emacsClientScriptFile}"
else
    if [[ -e /usr/bin/nvim ]]; then
        export EDITOR="nvim"
    elif [[ -e /usr/bin/vim ]]; then
        export EDITOR="vim"
    elif [[ -e /usr/bin/vi ]]; then
        export EDITOR="vi"
    fi
fi

## For when I type edit because fu that's why...
alias edit=${EDITOR}
## For whenever I feel lazy (mostyly)
alias ed=${EDITOR}

## use neovim diff
alias vimdiff='nvim -d '

alias ll='ls -lF'
alias la='ls -A'
alias l='ls -CF'

## ls after a cd command
alias cd='cdls'

## PiGrep
alias pigrep='grep -Pi --color'

## updatedb before locate
alias search='sudo updatedb && sudo locate -i'

## CPU + GPU Monitor
alias cpumonitor='watch -n0.1 "grep \"cpu MHz\" /proc/cpuinfo && echo \"\" && sensors && nvidia-smi -q -d temperature"'

## Preserve UserSettings for sudo
alias sudo='sudo -E '

## SystemD
alias ssystemctl='sudo systemctl'
alias usystemctl='systemctl --user'

## VM Management
### KVM
alias virsh='sudo virsh'
alias vired='virsh edit'

# Pacman Aliasses
alias yupdate='yay -Syyu && pkcon refresh'
alias pacman='sudo pacman'
alias pacinst='sudo pacman -S'
alias pacsearch='sudo pacman -Ss'
alias pacrmorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pacmirrorefresh='sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias paclistmyinstalls='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'

## Gaming Stuff
alias worms='cd Games/SteamLibrary/steamapps/common/WormsWMD/ && ./Run.sh'

## Bad habbits
alias :q='exit'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
