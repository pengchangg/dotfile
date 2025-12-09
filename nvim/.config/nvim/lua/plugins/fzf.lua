return {
  -------------------------
  -- FZF 核心插件
  -------------------------
  {
    "junegunn/fzf",
    build = "./install --bin",
  },

  -------------------------
  -- FZF.vim 扩展
  -------------------------
  {
    "junegunn/fzf.vim",
    config = function()
      -- ============
      -- 基本配置
      -- ============

      -- 底部弹窗方式打开 FZF（40% 高度）
      vim.g.fzf_layout = { down = "40%" }

      -- 右侧预览窗口（需要 bat）
      vim.g.fzf_preview_window = { "right:50%" }

      -- 如果系统有 rg，则启用更强的 Rg 搜索
      if vim.fn.executable("rg") == 1 then
        vim.g.fzf_commands_expect = "enter"
      end

      -- ============
      -- 快捷键
      -- ============

      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }

      -- 搜索文件
      map("n", "<leader>f", ":Files<CR>", opts)

      -- 全局搜索（需要 rg）
      map("n", "<leader>g", ":Rg<CR>", opts)

      -- 搜索当前 buffer 列表
      map("n", "<leader>b", ":Buffers<CR>", opts)

      -- 搜索当前文件行
      map("n", "<leader>l", ":Lines<CR>", opts)

      -- 最近打开的文件/命令
      map("n", "<leader>r", ":History<CR>", opts)

      -- 查看 Git 文件（如果在 git 项目内）
      map("n", "<leader>p", ":GFiles<CR>", opts)
    end,
  },
}

