#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
source ~/.git-prompt.sh
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 " (%s)")'; PS1='\[\e[38;5;51m\][\d\[\e[0m\] \[\e[38;5;51m\]|\[\e[0m\] \[\e[38;5;51m\]\A]\[\e[0m\] \[\e[38;5;46m\]\h\[\e[0m\]@\[\e[38;5;112m\]\u\[\e[0m\] - \[\e[94m\]\W\[\e[0m\] (\[\e[38;5;196m\]$?\[\e[0m\]) -\[\e[38;5;220m\]${PS1_CMD1}\[\e[0m\]> '
. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"
