local M = {}

local config = require("envim.profiles.embedded.config")

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "ENvim Embedded" })
end

local function executable(bin)
  return type(bin) == "string" and bin ~= "" and vim.fn.executable(bin) == 1
end

local function shell_join(parts)
  local escaped = {}
  for _, part in ipairs(parts or {}) do
    escaped[#escaped + 1] = vim.fn.shellescape(part)
  end
  return table.concat(escaped, " ")
end

function M.config()
  return config
end

function M.openocd_command()
  if not config.toolchain.openocd or config.toolchain.openocd == "" then
    return nil
  end

  local parts = { config.toolchain.openocd }
  vim.list_extend(parts, config.dap.openocd_args or {})
  return shell_join(parts)
end

function M.run_in_terminal(name, cmd, direction)
  if not cmd or cmd == "" then
    notify(("No command configured for %s. Update lua/envim/profiles/embedded/config.lua."):format(name), vim.log.levels.WARN)
    return
  end

  local ok, term_mod = pcall(require, "toggleterm.terminal")
  if not ok then
    notify("toggleterm.nvim is not available yet.", vim.log.levels.ERROR)
    return
  end

  local term = term_mod.Terminal:new({
    cmd = cmd,
    hidden = true,
    close_on_exit = false,
    direction = direction or "float",
  })

  term:toggle()
end

function M.run_build()
  M.run_in_terminal("build", config.tasks.build, "float")
end

function M.run_flash()
  M.run_in_terminal("flash", config.tasks.flash, "float")
end

function M.run_monitor()
  M.run_in_terminal("monitor", config.tasks.monitor, "horizontal")
end

function M.run_openocd()
  if not executable(config.toolchain.openocd) then
    notify(("OpenOCD not found: %s"):format(config.toolchain.openocd), vim.log.levels.ERROR)
    return
  end

  M.run_in_terminal("openocd", M.openocd_command(), "horizontal")
end

function M.pick_program()
  local sep = vim.uv.os_uname().sysname:match("Windows") and "\\" or "/"
  local default = vim.fn.getcwd() .. sep
  local program = vim.fn.input("Path to executable: ", default, "file")
  if program == "" then
    return nil
  end
  return vim.fn.fnamemodify(program, ":p")
end

function M.cppdbg_configuration()
  return {
    name = "Embedded (cppdbg + gdbserver)",
    type = "cppdbg",
    request = "launch",
    cwd = "${workspaceFolder}",
    program = function()
      return M.pick_program()
    end,
    MIMode = "gdb",
    miDebuggerPath = config.toolchain.gdb,
    miDebuggerServerAddress = config.dap.gdb_target,
    stopAtEntry = config.dap.stop_at_entry,
    externalConsole = false,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "Enable pretty printing",
        ignoreFailures = true,
      },
    },
  }
end

function M.dap_continue()
  if not executable(config.toolchain.gdb) then
    notify(("Debugger not found: %s"):format(config.toolchain.gdb), vim.log.levels.ERROR)
    return
  end

  require("dap").continue()
end

return M
