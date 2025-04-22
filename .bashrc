#
# ~/.bashrc
#

export PATH="$HOME/Scripts/:$PATH"

[[ $- != *i* ]] && return

#################
# Dynamic prompt: 
#################

PS1='$\u@$\h:\w$ ' 

#################
# Shell behavior:
#################

shopt -s checkwinsize
shopt -s nocaseglob

#############
# Set Editor:
#############

export EDITOR=emacs

#########
# THE END
#########
