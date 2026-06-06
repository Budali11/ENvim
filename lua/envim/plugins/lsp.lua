local profile = require("envim.core.profile")

return {
  {
    "mason-org/mason-lspconfig.nvim",
    enabled = profile.enabled("coding"),
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "bashls",
        "clangd",
        "jsonls",
        "lua_ls",
        "pyright",
      },
    },
    config = function(_, opts)
      local servers = {
        bashls = {},
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
          },
        },
        jsonls = {},
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      for server, server_opts in pairs(servers) do
        server_opts.capabilities =
          vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
        vim.lsp.config(server, server_opts)
      end

      require("mason").setup()
      require("mason-lspconfig").setup(opts)

      for server in pairs(servers) do
        vim.lsp.enable(server)
      end
    end,
  },
}
