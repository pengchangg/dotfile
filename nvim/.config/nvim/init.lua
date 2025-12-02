-- ~/.config/nvim/init.lua   
-- 无插件 Neovim 基础配置

-- 设置行号和相对行号
vim.opt.number = true
vim.opt.relativenumber = true

-- 缩进设置（通用 2 空格，可按需调整）
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- 搜索设置
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- 外观与体验
vim.opt.termguicolors = true          -- 启用 24-bit 真彩色
vim.opt.background = "dark"           -- 深色背景（可设为 "light"）
vim.opt.cursorline = true             -- 高亮当前行
vim.opt.showmatch = true              -- 匹配括号高亮
-- vim.opt.mouse = "a"                   -- 启用鼠标（可选，不喜欢可注释）
vim.opt.swapfile = false              -- 禁用交换文件
vim.opt.backup = false                -- 禁用备份
vim.opt.writebackup = false
vim.opt.undofile = true               -- 启用持久化 undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- 确保 undo 目录存在
local undodir = vim.fn.stdpath("data") .. "/undo"
if not vim.loop.fs_stat(undodir) then
  vim.fn.mkdir(undodir, "p", 0700)
end

-- 状态行（简洁自定义）
vim.opt.laststatus = 2
vim.opt.statusline = "%f %m%r%h%w  [%{&ff}] %{&fenc?(&fenc):'utf-8'}  %{&filetype?(&filetype):'no ft'}  %=%l/%L (%p%%)  %c"

-- 自动换行（仅用于长文本，如 Markdown）
vim.opt.wrap = false                  -- 默认不换行（更适合代码）
vim.opt.linebreak = true              -- 在单词边界换行（若启用 wrap）

-- 分割窗口设置
vim.opt.splitbelow = true             -- 水平分割时，新窗口在下方
vim.opt.splitright = true             -- 垂直分割时，新窗口在右方

-- 剪贴板集成（系统剪贴板）
if vim.fn.has("clipboard") == 1 then
  vim.opt.clipboard = "unnamedplus"   -- Linux 使用 + 寄存器；macOS/Windows 需确保 Neovim 支持
end

-- 快捷键映射（前导键用空格）
vim.g.mapleader = " "

-- 基础导航与编辑
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

-- 窗口管理
vim.keymap.set("n", "<leader>h", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<leader>j", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<leader>k", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<leader>l", "<C-w>l", { desc = "Window right" })

-- 快速移动（行首/行尾增强）
vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank" })
vim.keymap.set("n", "L", "$", { desc = "Go to end of line" })

-- 搜索相关
vim.keymap.set("n", "n", "nzz", { desc = "Next search (center)" })
vim.keymap.set("n", "N", "Nzz", { desc = "Prev search (center)" })

-- 快速注释（简易版，适用于 #, //, -- 等）
vim.keymap.set("n", "<leader>/", ":%s/^/\\/\\/ /<CR>", { silent = true, desc = "Comment lines (JS/TS/C++)" })
vim.keymap.set("n", "<leader>?", ":%s/^\\/\\/ //<CR>", { silent = true, desc = "Uncomment lines" })

-- 文件树（使用内置 netrw）
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "File explorer" })

-- 格式化（使用内置格式化，如已设置 filetype）
vim.keymap.set("n", "<leader>f", "<cmd>normal gg=G<CR>", { desc = "Format file" })

-- 清除搜索高亮
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { desc = "Clear highlights" })

-- 保持缩进粘贴
vim.keymap.set("v", "<", "<gv", { desc = "Keep selection after unindent" })
vim.keymap.set("v", ">", ">gv", { desc = "Keep selection after indent" })

-- 自动创建父目录（当写入文件路径不存在时）
vim.cmd [[ autocmd BufWritePre * call mkdir(fnamemodify(expand('<afile>'), ':p:h'), 'p', 0755) ]]

-- 文件类型相关设置
vim.cmd [[ autocmd FileType markdown setlocal wrap linebreak ]]

-- 显示不可见字符（可选）
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·", nbsp = "␣" }

-- 禁用内置 vim 兼容模式（Neovim 默认已禁用，此处显式强调）
vim.opt.compatible = false

-- 重新打开文件时跳到上次光标位置
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- 结束
