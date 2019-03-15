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

### Sources
include (){
    [[ -f "$1" ]] && source "$1"
}

include $HOME/.profilesen

### History settings
export HISTCONTROL=ignoreboth     # ignoredups:ignorespace

### Alliases [START]
    ## FileManagement
        # ls after a cd commad
            cdls(){
                cd $1;
                ls --color=tty -ah;
            }
            alias cd='cdls'
        # updatedb before locate
            alias locate='sudo updatedb && sudo locate -i'

    ## SysInfo
    alias cpumonitor='watch -n0.1 "grep \"cpu MHz\" /proc/cpuinfo && echo \"\" && sensors"'



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


# Miscellaneous

alias netflix='qutebrowser :open netflix.com &'
alias :q='exit'
alias pigrep='grep -Pi --color'
alias ssystemctl='sudo systemctl'
alias netrestart='sudo systemctl restart NetworkManager'
alias mouserestart='sudo modprobe -r psmouse && sudo modprobe psmouse'
alias touchpad_disable='xinput disable SynPS/2\ Synaptics\ TouchPad'
alias touchpad_enable='xinput enable SynPS/2\ Synaptics\ TouchPad'
alias trackpoint_disable='xinput disable TPPS/2\ IBM\ TrackPoint'
alias trackpoint_enable='xinput enable TPPS/2\ IBM\ TrackPoint'
#alias reboot='sudo reboot'
alias testasmtp='wine WinPrograms/Program\ Files\ \(x86\)/TestaSmtp.exe &'
alias dosconf='vim ~/.dosbox/dosbox-0.74.conf'
alias open='xdg-open'
alias svim='sudo -E vim'
alias www='cd ~/Devel/www'
alias edp144='xrandr --output eDP-1-1 --mode 1920x1080 -r 60 && xrandr --output eDP-1-1 --mode 1920x1080 -r 144'

# My servers
alias webdev_start='sudo mount --bind ~/Devel/www /srv/http && sudo systemctl start httpd.service && sudo mount --bind ~/Devel/mySQL /var/lib/mysql && sudo systemctl start mysqld.service'
alias webdev_stop='sudo systemctl stop httpd.service && sudo umount -l /srv/http && sudo systemctl stop mysqld.service && sudo umount -l /var/lib/mysql'

# My VMs
alias windows='VBoxManage startvm "Windows8.1"'

# Pacman Aliasses
alias yupdate='yay -Syyu && pkcon refresh'
alias pacman='sudo pacman'
alias pacinst='sudo pacman -S'
alias pacsearch='sudo pacman -Ss'
alias pacrmorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias pacmirrorefresh='sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias paclistmyinstalls='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'

alias monitor_birou_on='xrandr --addmode DP-1 1680x1050 && xrandr --output DP-1 --mode 1680x1050 && xrandr --output DP-1 --pos -1920x0'
alias monitor_birou_off='xrandr --output DP-1 --off'

alias kwincompON='qdbus org.kde.KWin /Compositor resume'
alias kwincompOFF='qdbus org.kde.KWin /Compositor suspend'

### Aliases [END]

## MC Trash Support
#alias clear='printf "\033c"'
#
#if command -v tmux>/dev/null; then # check if tmux is installed 
#    # Chech if executed from a TTY and *not* from Tmux
#    if [[ "$(tty)" =~ /dev/tty ]] && [[ ! "$TERM" =~ screen ]] && [ -z "$TMUX" ]; then
#        #fbterm -- $(tmux new-session -A -s MasterConsole) 
#        tmux
#    fi
#fi

#mc_tmux(){
#    [[ -z $TMUX ]] && mc -c || TERM=xterm-256color mc -c
#}
#alias mc=mc_tmux

. /usr/share/LS_COLORS/dircolors.sh


