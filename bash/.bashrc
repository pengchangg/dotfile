# ~/.bashrc
# ==================================================
# Interactive Bash ONLY
# ==================================================

# 非交互 shell 立即退出（防止卡死）
[[ $- != *i* ]] && return

# 防止递归加载
[ -n "${__BASHRC_LOADED__}" ] && return
export __BASHRC_LOADED__=1

# 发行版兼容：Debian / Ubuntu
[[ -f /etc/bash.bashrc ]] && source /etc/bash.bashrc

# 模块化加载
if [ -d "$HOME/.bashrc.d" ]; then
    for f in "$HOME/.bashrc.d/"*.sh; do
        [ -r "$f" ] && source "$f"
    done
fi

# 私有配置（不进 Git）
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

alias reloadBash='source ~/.bashrc'

