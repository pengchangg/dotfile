[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_DEFAULT_OPTS='
--height 60%
--border
--info=inline
--preview "bat --style=numbers --color=always {} | head -500"
'

function fe {
    local f
    f=$(fzf) || return
    ${EDITOR:-vim} "$f"
}

