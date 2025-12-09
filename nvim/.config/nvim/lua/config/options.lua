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
vim.opt.termguicolors = true -- 启用 24-bit 真彩色
vim.opt.cursorline = true    -- 高亮当前行
vim.opt.showmatch = true     -- 匹配括号高亮
vim.opt.swapfile = false     -- 禁用交换文件
vim.opt.backup = false       -- 禁用备份
vim.opt.writebackup = false
vim.opt.undofile = true      -- 启用持久化 undo


-- 自动换行（仅用于长文本，如 Markdown）
vim.opt.wrap = false     -- 默认不换行（更适合代码）
vim.opt.linebreak = true -- 在单词边界换行（若启用 wrap）

-- 分割窗口设置
vim.opt.splitbelow = true -- 水平分割时，新窗口在下方
vim.opt.splitright = true -- 垂直分割时，新窗口在右方

-- 剪贴板集成（系统剪贴板）
if vim.fn.has("clipboard") == 1 then
    vim.opt.clipboard = "unnamedplus" -- Linux 使用 + 寄存器；macOS/Windows 需确保 Neovim 支持
end

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


local opt               = vim.opt
opt.number              = true
opt.relativenumber      = false
opt.termguicolors       = true
opt.foldmethod          = "indent"
opt.foldlevel           = 99
opt.foldenable          = false

vim.opt.tabstop         = 4
vim.opt.shiftwidth      = 4

vim.g.barbar_auto_setup = false

vim.opt.guicursor       = {
    "i:ver25",
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
}

vim.cmd('colorscheme catppuccin')
