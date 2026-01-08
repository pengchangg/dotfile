# /usr/local/go/bin
if [[ -d "/usr/local/go/bin" ]]; then
    export PATH=$PATH:~/go/bin:/usr/local/go/bin
fi
export go111module=on
export GOPROXY=https://goproxy.cn

