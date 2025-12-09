return {
    {
        "ggandor/flit.nvim",
        dependencies = { "ggandor/leap.nvim" },
        config = function()
            require("flit").setup({
                keys = { f = "f", F = "F", t = "t", T = "T" },
                labeled_modes = "nv", -- n,v 模式都支持 label 跳转
                multiline = true,     -- 允许跨行跳转
                opts = {},
            })
        end,
    },
}
