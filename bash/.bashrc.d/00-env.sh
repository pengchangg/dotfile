# History
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTCONTROL=ignoredups:erasedups
export HISTIGNORE="ls:cd:pwd:clear:exit"
shopt -s histappend

# Shell 行为
shopt -s autocd cdspell checkwinsize extglob globstar
#set -o vi

# Python / Node
export PYTHONWARNINGS=ignore
export PIP_DISABLE_PIP_VERSION_CHECK=1
export NPM_CONFIG_FUND=false

