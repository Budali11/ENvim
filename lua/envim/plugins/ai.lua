local profile = require("envim.core.profile")

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = profile.enabled("ai"),
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-l>",
          accept_word = "<M-w>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        markdown = true,
        help = false,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = profile.enabled("ai"),
    dependencies = {
      "nvim-lua/plenary.nvim",
      "zbirenbaum/copilot.lua",
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatToggle",
    },
    opts = {
      model = "gpt-4.1",
      auto_insert_mode = true,
      window = {
        layout = "float",
        width = 0.8,
        height = 0.8,
        border = "rounded",
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle AI Chat" },
      { "<leader>ax", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
      { "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "Fix Code", mode = { "n", "v" } },
    },
  },
}
