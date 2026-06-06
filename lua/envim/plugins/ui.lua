local profile = require("envim.core.profile")
local ui = require("envim.config.ui")

return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = 300,
      spec = {
        { "<leader>f", group = "find" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>m", group = "embedded/make" },
        { "<leader>p", group = "profile/plugins" },
        { "<leader>t", group = "tabs" },
        { "<leader>x", group = "diagnostics" },
        { "<leader>a", group = "ai" },
      },
    },
  },
  {
    "folke/snacks.nvim",
    enabled = profile.enabled("ui"),
    priority = 900,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = ui.dashboard.header,
          keys = {
            { icon = " ", key = "f", desc = "Find files", action = function() Snacks.picker.files() end },
            { icon = "󰱼 ", key = "g", desc = "Search text", action = function() Snacks.picker.grep() end },
            { icon = " ", key = "e", desc = "Explorer", action = function() Snacks.explorer() end },
            { icon = "󱐋 ", key = "p", desc = "Pick profile", action = function() vim.cmd("ENProfilePick") end },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = function() vim.cmd("Lazy") end },
            { icon = " ", key = "q", desc = "Quit", action = function() vim.cmd("qa") end },
          },
        },
      },
      explorer = { enabled = true },
      input = { enabled = true },
      notifier = {
        enabled = true,
        timeout = ui.notifier.timeout,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Search in Files" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Search Current Word", mode = { "n", "x" } },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Tags" },
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gr", function() Snacks.picker.lsp_references() end, desc = "References", mode = "n" },
      { "gi", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace Symbols" },
      { "<leader>nn", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    },
  },
  {
    "hedyhli/outline.nvim",
    enabled = profile.enabled("coding"),
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>co", "<cmd>Outline<cr>", desc = "Code Outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 28,
        auto_close = false,
        focus_on_open = false,
      },
      outline_items = {
        show_symbol_lineno = false,
      },
      preview_window = {
        auto_preview = false,
      },
      symbol_folding = {
        autofold_depth = 1,
        auto_unfold = {
          hovered = true,
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    enabled = profile.enabled("ui"),
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        always_show_bufferline = ui.bufferline.always_show,
        separator_style = ui.bufferline.separator_style,
      },
    },
    keys = {
      { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
      { "<leader>bR", "<cmd>BufferLineCloseRight<cr>", desc = "Close Buffers to the Right" },
    },
  },
  {
    "karb94/neoscroll.nvim",
    enabled = profile.enabled("ui"),
    event = "WinScrolled",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      duration_multiplier = ui.neoscroll.duration_multiplier,
      easing = ui.neoscroll.easing,
      hide_cursor = ui.neoscroll.hide_cursor,
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = profile.enabled("ui"),
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = ui.indentline.char,
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
    },
  },
}
