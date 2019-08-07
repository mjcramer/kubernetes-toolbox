#!/bin/bash

if [ "$BASH_SOURCE" = "$0" ]; then
    echo "This script can only be sourced."
    exit 1
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

##
## GENERAL OPTIONS 
##

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Update window size after every command
shopt -s checkwinsize

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

# Turn on recursive globbing (enables ** to recurse all directories)
shopt -s globstar 2> /dev/null

##
## HISTORY OPTIONS 
##

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL="erasedups:ignoreboth"

# Don't record some commands
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Useful timestamp format
HISTTIMEFORMAT='%F %T '

# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
HISTFILESIZE=100000

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Enable incremental history search with up/down arrows (also Readline goodness)
# Learn more about this here: http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

##
## TAB-COMPLETION (Readline bindings) 
##

# Display matches for ambiguous patterns at first tab press
bind "set show-all-if-ambiguous on"

##
## DIRECTORY NAVIGATION 
##

# Prepend cd to directory names automatically
shopt -s autocd 2> /dev/null

# Correct spelling errors during tab-completion
shopt -s dirspell 2> /dev/null

# Correct spelling errors in arguments supplied to cd
shopt -s cdspell 2> /dev/null

# This defines where cd looks for targets
# Add the directories you want to have fast access to, separated by colon
# Ex: CDPATH=".:~:~/projects" will look for targets in the current working directory, in home and in the ~/projects folder
CDPATH="."

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Set up path
export PATH=/usr/bin:/usr/sbin:/bin:/sbin:$PATH	

# Add current directory to path
export PATH=$PATH:.

# Set up prompt
export PS1="[\[\e[36m\]\d\[\e[m\] \[\e[33m\]\t\[\e[m\]] \[\e[32m\]\h\[\e[m\]:\[\e[35m\]\w\[\e[m\] -> "

# Set up aliases
alias ..='cd ..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias less='less -r'
alias mkdir='mkdir -pv'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias search='grep -IRHn --color=auto'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias svi='sudo vi'
alias ping='ping -c 5'
alias pingfast='ping -c 100 -s.2'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias listening='lsof -Pn -i4TCP -sTCP:LISTEN'
alias pyjson='python -m json.tool'
