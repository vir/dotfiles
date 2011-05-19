# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If running interactively, then:
if [ "$PS1" ]; then

    # don't put duplicate lines in the history. See bash(1) for more options
    export HISTCONTROL=ignoredups

    # enable color support of ls and also add handy aliases
    eval `dircolors -b`
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias nmbrlookup='nmblookup -B -S -A -T'

    # some more ls aliases
    #alias ll='ls -l'
    #alias la='ls -A'
    #alias l='ls -CF'

    # set a fancy prompt
    #PS1='\u@\h:\w\$ '

    # GIT goodies
    #PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
    PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '

    # If this is an xterm set the title to user@host:dir
    #case $TERM in
    #xterm*)
    #    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    #    ;;
    #*)
    #    ;;
    #esac

    # enable programmable completion features (you don't need to enable
    # this, if it's already enabled in /etc/bash.bashrc).
    if [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
fi

export PATH=~/bin:$PATH
export LANG="ru_RU.UTF-8" LC_MESSAGES=C LC_TIME=C
alias rdesktop='rdesktop -g 1024x768'
#alias cvsta="cvs status | grep -E 'Status|^\?'"
function cvsta() {
	cvs status $* | grep -E 'Status|^\?'
}


