function __git_ps1_status {
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

# Prompt 配置
# 使用 \033 而不是 \e，在某些环境下更兼容（特别是 tmux）
PS1='\[\033[1;32m\][\u@\h \W]\[\033[33m\]$(__git_ps1_status)\[\033[1;32m\]\$\[\033[0m\] '

