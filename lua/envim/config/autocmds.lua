local group = vim.api.nvim_create_augroup("ENvim", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight on yank",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  desc = "LSP keymaps",
  callback = function(args)
    local map = function(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, {
        buffer = args.buf,
        silent = true,
        desc = desc,
      })
    end

    map("K", vim.lsp.buf.hover, "LSP Hover")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
    map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
    map("<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, "Format Buffer")
    map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
    map("[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
  end,
})
