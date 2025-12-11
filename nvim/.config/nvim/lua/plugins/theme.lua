return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true,
      flavour = "frappe", -- latte, frappe, macchiato, mocha
      float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
