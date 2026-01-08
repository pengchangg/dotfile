#!/usr/bin/env bash
# =========================================================
# Dotfiles 管理脚本
# 功能：恢复和重置 dotfiles 配置
# 使用：./manage.sh [restore|reset|backup|status]
# =========================================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置包列表
PACKAGES=("bash" "nvim" "tmux" "git-workfow" "bat")

# 脚本所在目录（dotfiles 根目录）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${SCRIPT_DIR}/.backup"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 stow 是否安装
check_stow() {
    if ! command -v stow &> /dev/null; then
        log_error "GNU Stow 未安装"
        echo "请先安装 stow:"
        echo "  Arch: sudo pacman -S stow"
        echo "  Debian/Ubuntu: sudo apt install stow"
        echo "  macOS: brew install stow"
        exit 1
    fi
}

# 检查文件是否为符号链接
is_symlink() {
    [ -L "$1" ]
}

# 检查文件是否存在
file_exists() {
    [ -e "$1" ]
}

# 备份现有配置
backup_config() {
    local package=$1
    local target_path=$2
    
    if ! file_exists "$target_path"; then
        return 0  # 文件不存在，无需备份
    fi
    
    if is_symlink "$target_path"; then
        log_info "$target_path 是符号链接，跳过备份"
        return 0
    fi
    
    local backup_path="${BACKUP_DIR}/${package}/${TIMESTAMP}"
    mkdir -p "$backup_path"
    
    # 获取文件所在目录
    local target_dir=$(dirname "$target_path")
    local filename=$(basename "$target_path")
    
    # 如果是目录，需要特殊处理
    if [ -d "$target_path" ]; then
        log_info "备份目录: $target_path -> $backup_path/"
        cp -r "$target_path" "$backup_path/"
    else
        log_info "备份文件: $target_path -> $backup_path/$filename"
        cp "$target_path" "$backup_path/$filename"
    fi
    
    log_success "已备份到: $backup_path"
}

# 备份所有可能冲突的配置
backup_all() {
    log_info "开始备份现有配置..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Bash 配置
    [ -f "$HOME/.bashrc" ] && backup_config "bash" "$HOME/.bashrc"
    [ -f "$HOME/.profile" ] && backup_config "bash" "$HOME/.profile"
    [ -d "$HOME/.bashrc.d" ] && backup_config "bash" "$HOME/.bashrc.d"
    
    # Neovim 配置
    [ -f "$HOME/.config/nvim/init.lua" ] && backup_config "nvim" "$HOME/.config/nvim/init.lua"
    [ -d "$HOME/.config/nvim" ] && backup_config "nvim" "$HOME/.config/nvim"
    
    # Tmux 配置
    [ -f "$HOME/.tmux.conf" ] && backup_config "tmux" "$HOME/.tmux.conf"
    
    # Git 配置
    [ -f "$HOME/.gitconfig" ] && backup_config "git-workfow" "$HOME/.gitconfig"
    [ -f "$HOME/.git-workflow.sh" ] && backup_config "git-workfow" "$HOME/.git-workflow.sh"
    
    # Bat 配置
    [ -f "$HOME/.config/bat/config" ] && backup_config "bat" "$HOME/.config/bat/config"
    [ -d "$HOME/.config/bat" ] && backup_config "bat" "$HOME/.config/bat"
    
    log_success "备份完成！备份位置: $BACKUP_DIR"
}

# 恢复配置（安装）
restore_config() {
    log_info "开始恢复 dotfiles 配置..."
    
    check_stow
    
    # 先备份现有配置
    backup_all
    
    # 切换到 dotfiles 目录
    cd "$SCRIPT_DIR"
    
    # 安装所有配置包
    local failed_packages=()
    for package in "${PACKAGES[@]}"; do
        if [ ! -d "$package" ]; then
            log_warn "配置包 $package 不存在，跳过"
            continue
        fi
        
        log_info "安装配置包: $package"
        if stow -v "$package" 2>&1 | grep -q "WARNING"; then
            log_warn "$package 安装时出现警告，但继续执行"
        fi
        
        if stow "$package"; then
            log_success "$package 安装成功"
        else
            log_error "$package 安装失败"
            failed_packages+=("$package")
        fi
    done
    
    if [ ${#failed_packages[@]} -eq 0 ]; then
        log_success "所有配置恢复成功！"
        echo ""
        echo "提示："
        echo "  - 重新加载 shell: source ~/.bashrc"
        echo "  - 重新加载 tmux: tmux source-file ~/.tmux.conf"
    else
        log_error "以下配置包安装失败: ${failed_packages[*]}"
        exit 1
    fi
}

# 重置配置（卸载）
reset_config() {
    log_info "开始重置 dotfiles 配置..."
    
    check_stow
    
    # 确认操作
    echo ""
    log_warn "这将删除所有 dotfiles 的符号链接"
    read -p "确定要继续吗？[y/N]: " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "操作已取消"
        exit 0
    fi
    
    # 切换到 dotfiles 目录
    cd "$SCRIPT_DIR"
    
    # 卸载所有配置包
    local failed_packages=()
    for package in "${PACKAGES[@]}"; do
        if [ ! -d "$package" ]; then
            log_warn "配置包 $package 不存在，跳过"
            continue
        fi
        
        log_info "卸载配置包: $package"
        if stow -D -v "$package"; then
            log_success "$package 卸载成功"
        else
            log_error "$package 卸载失败"
            failed_packages+=("$package")
        fi
    done
    
    if [ ${#failed_packages[@]} -eq 0 ]; then
        log_success "所有配置重置成功！"
    else
        log_error "以下配置包卸载失败: ${failed_packages[*]}"
        exit 1
    fi
}

# 检查配置状态
check_status() {
    log_info "检查 dotfiles 配置状态..."
    echo ""
    
    cd "$SCRIPT_DIR"
    
    for package in "${PACKAGES[@]}"; do
        if [ ! -d "$package" ]; then
            continue
        fi
        
        echo -e "${BLUE}配置包: $package${NC}"
        
        # 检查 stow 管理的文件
        local stowed_files=$(stow -n "$package" 2>&1 | grep "LINK:" | awk '{print $2}' || true)
        
        if [ -z "$stowed_files" ]; then
            # 尝试检查实际文件
            case $package in
                bash)
                    [ -L "$HOME/.bashrc" ] && echo "  ✓ .bashrc (符号链接)"
                    [ -L "$HOME/.profile" ] && echo "  ✓ .profile (符号链接)"
                    [ -L "$HOME/.bashrc.d" ] && echo "  ✓ .bashrc.d (符号链接)"
                    ;;
                nvim)
                    [ -L "$HOME/.config/nvim/init.lua" ] && echo "  ✓ .config/nvim/init.lua (符号链接)"
                    ;;
                tmux)
                    [ -L "$HOME/.tmux.conf" ] && echo "  ✓ .tmux.conf (符号链接)"
                    ;;
                git-workfow)
                    [ -L "$HOME/.gitconfig" ] && echo "  ✓ .gitconfig (符号链接)"
                    [ -L "$HOME/.git-workflow.sh" ] && echo "  ✓ .git-workflow.sh (符号链接)"
                    ;;
                bat)
                    [ -L "$HOME/.config/bat/config" ] && echo "  ✓ .config/bat/config (符号链接)"
                    ;;
            esac
        else
            echo "$stowed_files" | while read -r line; do
                local target=$(echo "$line" | sed 's|.* -> ||')
                if [ -L "$target" ]; then
                    echo "  ✓ $target (符号链接)"
                else
                    echo "  ✗ $target (未链接)"
                fi
            done
        fi
        
        echo ""
    done
    
    # 显示备份信息
    if [ -d "$BACKUP_DIR" ]; then
        local backup_count=$(find "$BACKUP_DIR" -mindepth 2 -type d | wc -l)
        if [ "$backup_count" -gt 0 ]; then
            echo -e "${BLUE}备份信息:${NC}"
            echo "  备份目录: $BACKUP_DIR"
            echo "  备份数量: $backup_count"
            echo ""
        fi
    fi
}

# 显示帮助信息
show_help() {
    cat << EOF
Dotfiles 管理脚本

用法:
    $0 [命令]

命令:
    restore      恢复/安装所有 dotfiles 配置
    reset        重置/卸载所有 dotfiles 配置
    backup       备份现有配置（不安装）
    status       检查配置状态
    help         显示此帮助信息

示例:
    $0 restore    # 安装所有配置
    $0 reset      # 卸载所有配置
    $0 status     # 查看配置状态

EOF
}

# 主函数
main() {
    local command=${1:-help}
    
    case "$command" in
        restore)
            restore_config
            ;;
        reset)
            reset_config
            ;;
        backup)
            backup_all
            ;;
        status)
            check_status
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            log_error "未知命令: $command"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# 执行主函数
main "$@"
