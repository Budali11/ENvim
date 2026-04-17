local profile = require("envim.core.profile")
local embedded = require("envim.profiles.embedded.helpers")

return {
  {
    "nvim-lua/plenary.nvim",
    enabled = profile.enabled("embedded"),
    lazy = true,
  },
  {
    "akinsho/toggleterm.nvim",
    enabled = profile.enabled("embedded"),
    version = "*",
    cmd = {
      "ToggleTerm",
      "TermExec",
    },
    opts = {
      open_mapping = [[<c-\\>]],
      direction = "float",
      shade_terminals = false,
      start_in_insert = false,
      persist_size = true,
      close_on_exit = false,
      float_opts = {
        border = "rounded",
      },
    },
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
      { "<leader>mk", function() embedded.run_build() end, desc = "Run Make Build" },
      { "<leader>mf", function() embedded.run_flash() end, desc = "Run Flash Command" },
      { "<leader>mi", function() embedded.run_monitor() end, desc = "Run Monitor Command" },
      { "<leader>mo", function() embedded.run_openocd() end, desc = "Run OpenOCD" },
    },
  },
  {
    "Civitasv/cmake-tools.nvim",
    enabled = profile.enabled("embedded"),
    ft = { "c", "cpp", "cmake" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim",
    },
    opts = {
      cmake_command = "cmake",
      ctest_command = "ctest",
      cmake_use_preset = true,
      cmake_regenerate_on_save = true,
      cmake_generate_options = {
        "-DCMAKE_EXPORT_COMPILE_COMMANDS=1",
      },
      cmake_compile_commands_options = {
        action = "soft_link",
        target = vim.uv.cwd(),
      },
      cmake_executor = {
        name = "quickfix",
        opts = {
          show = "always",
          position = "belowright",
          size = 10,
          auto_close_when_success = true,
        },
      },
      cmake_runner = {
        name = "toggleterm",
        opts = {
          direction = "float",
          close_on_exit = false,
          singleton = true,
          auto_scroll = true,
        },
      },
      cmake_notifications = {
        runner = { enabled = true },
        executor = { enabled = true },
      },
      cmake_virtual_text_support = true,
    },
    keys = {
      { "<leader>mg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
      { "<leader>mb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>mr", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
      { "<leader>ms", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Select Build Target" },
    },
  },
  {
    "stevearc/overseer.nvim",
    enabled = profile.enabled("embedded"),
    cmd = {
      "OverseerRun",
      "OverseerToggle",
      "OverseerQuickAction",
    },
    opts = {
      task_list = {
        direction = "right",
        min_width = 40,
        max_width = { 80, 0.35 },
        default_detail = 1,
      },
      form = {
        border = "rounded",
      },
      confirm = {
        border = "rounded",
      },
      task_win = {
        border = "rounded",
      },
    },
    keys = {
      { "<leader>mm", "<cmd>OverseerRun<cr>", desc = "Run Task" },
      { "<leader>mt", "<cmd>OverseerToggle<cr>", desc = "Toggle Task List" },
      { "<leader>mq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Task Action" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    enabled = profile.enabled("embedded"),
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "jay-babu/mason-nvim-dap.nvim",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("mason-nvim-dap").setup({
        ensure_installed = { "cppdbg" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      dapui.setup({
        floating = {
          border = "rounded",
        },
      })

      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      dap.listeners.before.attach.envim_dapui = function()
        dapui.open()
      end
      dap.listeners.before.launch.envim_dapui = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.envim_dapui = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.envim_dapui = function()
        dapui.close()
      end

      dap.configurations.c = dap.configurations.c or {}
      dap.configurations.cpp = dap.configurations.cpp or {}
      table.insert(dap.configurations.c, embedded.cppdbg_configuration())
      table.insert(dap.configurations.cpp, embedded.cppdbg_configuration())
    end,
    keys = {
      { "<F5>", function() embedded.dap_continue() end, desc = "Debug Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB", function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, desc = "Conditional Breakpoint" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Open Debug REPL" },
    },
  },
  {
    "folke/trouble.nvim",
    enabled = profile.enabled("embedded"),
    cmd = "Trouble",
    opts = {
      use_diagnostic_signs = true,
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
    },
  },
}
