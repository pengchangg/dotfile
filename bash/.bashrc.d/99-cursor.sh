# $HOME/.local/bin (已在 .profile 中处理，这里跳过避免重复)
if [[ -d $HOME/.local/bin ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
