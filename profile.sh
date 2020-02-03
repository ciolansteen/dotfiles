# vim: filetype=sh
# # # # # # # # # # # # # # # # # # # # #
#    .  .  .  .  .  .  .  .  .  .  .    #      
#   .  .  _  .  _  .  .  .|`|  .  .     #
#    .  o`.\,=./.`o .  . _|_|_  .  .    #
#   .  .  :(o o):  .  .  (o)o) .  .     #
#    --ooO--(_)--Ooo-ooO--(_)--Ooo--    #
#    ╔═╗╦╔═╗╦  ╔═╗╔╗╔╔═╗╔╦╗╔═╗╔═╗╔╗╔    #
#    ║  ║║ ║║  ╠═╣║║║╚═╗ ║ ║╣ ║╣ ║║║    #
#    ╚═╝╩╚═╝╩═╝╩ ╩╝╚╝╚═╝ ╩ ╚═╝╚═╝╝╚╝`s  #
#            .profile file              #
#                                       #
# # # # # # # # # # # # # # # # # # # # #
#
# profile_CLN_RC ver=1.0
#

export PATH=$PATH:/home/ciolansteen/bin
export MC_XDG_OPEN=~/bin/nohup-open

### Sources
include (){
    [[ -f "$1" ]] && source "$1"
}

include $HOME/.profilesen

. /usr/share/LS_COLORS/dircolors.sh

### History settings
export HISTCONTROL=ignoreboth     # ignoredups:ignorespace

### Alliases [START]
    ## FileManagement

    # rm to trash
    alias rm='rmtrash'
    alias rmdir='rmtrash'
    # some more ls aliases
    alias ll='ls -lF'
    alias la='ls -A'
    alias l='ls -CF'

    # ls after a cd commad
    cdls(){
        cd "$1";    # treat $1 as a string - useful for paths including spaces
        ls -ah;
    }
    alias cd='cdls '
    # updatedb before locatd
    alias locate='sudo updatedb && sudo locate -i'

    ## SysInfo
    alias cpumonitor='watch -n0.1 "grep \"cpu MHz\" /proc/cpuinfo && echo \"\" && sensors"'
    
    ## Watch fast
    alias watch='watch -n0.1'

    ## SysControl
        # Fan control
        alias fan_auto='sudo echo level auto | sudo tee /proc/acpi/ibm/fan'
        alias fan_off='sudo echo level 0 | sudo tee /proc/acpi/ibm/fan'
        alias fan_1='sudo echo level 1 | sudo tee /proc/acpi/ibm/fan'
        alias fan_2='sudo echo level 2 | sudo tee /proc/acpi/ibm/fan'
        alias fan_3='sudo echo level 3 | sudo tee /proc/acpi/ibm/fan'
        alias fan_4='sudo echo level 4 | sudo tee /proc/acpi/ibm/fan'
        alias fan_5='sudo echo level 5 | sudo tee /proc/acpi/ibm/fan'
        alias fan_6='sudo echo level 6 | sudo tee /proc/acpi/ibm/fan'
        alias fan_7='sudo echo level 7 | sudo tee /proc/acpi/ibm/fan'


    ## Media


    ## Gaming
        alias codingame='vim ~/Games/CodinGame/SyncFile'
        alias worms='cd Games/SteamLibrary/steamapps/common/WormsWMD/ && ./Run.sh'
    ## Plasma
    alias plasmarestart='kquitapp5 plasmashell && sleep 1 && kstart5 plasmashell'


# Set default editor
if [[ -e /usr/bin/nvim ]]; then
        export EDITOR=nvim
        alias vim='nvim'
elif [[ -e /usr/bin/vim ]]; then
        export EDITOR=vim
else
        export EDITOR=vi
fi


if [[ -e /usr/bin/oni ]]; then
    alias oni='oni .'
fi

# Miscellaneous
alias mc='. /usr/lib/mc/mc-wrapper.sh'
alias home='cd ~'
alias youtube='youtube-viewer -C'
alias :q='exit'
alias pigrep='grep -Pi --color'
alias ssystemctl='sudo systemctl'
alias netrestart='sudo systemctl restart NetworkManager'
alias mouserestart='sudo modprobe -r psmouse && sudo modprobe psmouse'
alias testasmtp='wine WinPrograms/Program\ Files\ \(x86\)/TestaSmtp.exe &'
alias dosconf='vim ~/.dosbox/dosbox-0.74.conf'
alias open='xdg-open'
alias svim='sudo vim'
alias vimdiff='nvim -d'
alias www='cd ~/Devel/www'

# My servers
alias webdev_start='sudo mount --bind ~/Devel/www /srv/http && sudo systemctl start httpd.service && sudo mount --bind ~/Devel/mySQL /var/lib/mysql && sudo systemctl start mysqld.service'
alias webdev_stop='sudo systemctl stop httpd.service && sudo umount -l /srv/http && sudo systemctl stop mysqld.service && sudo umount -l /var/lib/mysql'

# My VMs
alias virsh='sudo virsh'
alias vired='virsh edit'
alias windows='VBoxManage startvm "Windows8.1"'
alias winsize='du -h $HOME/VirtualMachines/Win10.qcow2'
alias node1='ssh root@192.168.122.10'
alias node2='ssh root@192.168.122.11'
alias node3='ssh root@192.168.122.12'

# Pacman Aliasses
alias yupdate='yay -Syyu && pkcon refresh'
alias pacman='sudo pacman'
alias pacinst='sudo pacman -S'
alias pacsearch='sudo pacman -Ss'
alias pacrmorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pacmirrorefresh='sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias paclistmyinstalls='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'

# Locations
alias devel='cd $HOME/PlayGround/Devel'
alias learning='cd $HOME/PlayGround/Learning'


# Alsa Mixer
alias scarmix='alsamixer -cUSB'

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export DISPLAY=:0
#export SCRIPTS_DIR='/usr/cln'

alias sudo='sudo -E '
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

