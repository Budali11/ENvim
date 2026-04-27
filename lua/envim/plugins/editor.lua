local profile = require("envim.core.profile")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = profile.enabled("coding"),
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "asm",
        "bash",
        "c",
        "cpp",
        "json",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "vim",
        "vimdoc",
      },
      highlight = {
        enable = true,
        disable = { "asm" },
      },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)
    end,
  },
}
