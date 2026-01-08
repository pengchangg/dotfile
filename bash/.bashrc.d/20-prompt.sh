__git_ps1_status() {
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local branch status
    branch=$(git symbolic-ref --short HEAD 2>/dev/null \
        || git describe --tags --exact-match 2>/dev/null \
        || git rev-parse --short HEAD 2>/dev/null)

    git diff --quiet --cached || status="+"
    git diff --quiet || status="*"
    [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]] && status="${status}?"

    printf " (%s%s)" "$branch" "$status"
}

PS1='\[\e[1;32m\][\u@\h \W]\[\e[33m\]$(__git_ps1_status)\[\e[1;32m\]\$\[\e[0m\] '

