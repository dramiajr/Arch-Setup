#
# ~/.bashrc
#

export PATH="$HOME/Scripts/:$PATH"

[[ $- != *i* ]] && return

################
# Prompt Colors:
################

get_color() { tput setaf "$1"; }

# Customize colors 
USER_COL="\[$(get_color 12)\]"    
HOST_COL="\[$(get_color 5)\]"      
PATH_COL="\[$(get_color 11)\]"    
RESET_COL="\[$(tput sgr0)\]"

#################
# Dynamic prompt: 
#################

PS1="${USER_COL}[\u@${HOST_COL}\h${PATH_COL}\w${HOST_COL}\]${RESET_COL}\$"

#################
# Shell behavior:
#################

shopt -s checkwinsize
shopt -s nocaseglob

# Enable bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind "set completion-ignore-case on"

#################
# Command Colors:
#################

alias ls='ls --color=auto'
alias grep='grep --color=auto'

#############
# Set Editor:
#############

export EDITOR=emacs

##########
# THE END:
##########
