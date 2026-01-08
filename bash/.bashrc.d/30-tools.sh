# bash-completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi

# tmux alias
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tls='tmux ls'
alias tk='tmux kill-session -t'
alias trc='tmux source-file ~/.tmux.conf \; display-message "tmux config reloaded"'

_tmux_sessions() {
    COMPREPLY=( $(compgen -W "$(tmux ls 2>/dev/null | awk -F: '{print $1}')" -- "${COMP_WORDS[COMP_CWORD]}") )
}
complete -F _tmux_sessions ta tk

# cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# git-workflow
[ -f ~/.git-workflow.sh ] && source ~/.git-workflow.sh
