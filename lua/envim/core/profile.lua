local M = {}

local profiles = require("envim.config.profiles")
local state_file = vim.fn.stdpath("state") .. "/envim-profile.txt"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "ENvim Profile" })
end

local function names()
  local result = vim.tbl_keys(profiles)
  table.sort(result)
  return result
end

local function read_profile()
  local ok, lines = pcall(vim.fn.readfile, state_file)
  if not ok or not lines or lines[1] == nil or lines[1] == "" then
    return "default"
  end
  return lines[1]
end

local function write_profile(name)
  local ok, err = pcall(function()
    vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
    vim.fn.writefile({ name }, state_file)
  end)

  if not ok then
    notify(("Failed to save profile for next startup: %s"):format(err), vim.log.levels.WARN)
  end

  return ok
end

local function current_profile()
  local name = vim.g.envim_profile or "default"
  return profiles[name] or profiles.default
end

local function refresh_lazy()
  local ok_config, config = pcall(require, "lazy.core.config")
  local ok_plugin, plugin = pcall(require, "lazy.core.plugin")
  local ok_handler, handler = pcall(require, "lazy.core.handler")
  if not ok_config or not ok_plugin or not ok_handler then
    return false
  end

  local old_plugins = {}
  for name, old_plugin in pairs(config.plugins or {}) do
    old_plugins[name] = old_plugin
  end
  plugin.load()

  for name, old_plugin in pairs(old_plugins) do
    if not config.plugins[name] then
      handler.disable(old_plugin)
    end
  end

  handler.setup()

  return true
end

local function load_plugin(name)
  local ok_loader, loader = pcall(require, "lazy.core.loader")
  local ok_config, config = pcall(require, "lazy.core.config")
  if not ok_loader or not ok_config or not config.plugins[name] then
    return
  end

  loader.load(name, { profile = M.current_name() })
end

local function refresh_current_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  if vim.bo[bufnr].filetype ~= "" then
    vim.api.nvim_exec_autocmds("FileType", {
      buffer = bufnr,
      modeline = false,
    })
  end

  if M.has("coding") then
    load_plugin("mason-lspconfig.nvim")
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.cmd("silent! LspStart")
      end
    end)
  else
    for _, client in ipairs(vim.lsp.get_clients()) do
      client:stop()
    end
  end

  if M.has("ui") then
    load_plugin("snacks.nvim")
  end
end

local function apply_profile()
  local lazy_refreshed = refresh_lazy()
  refresh_current_buffer()
  return lazy_refreshed
end

function M.current_name()
  return vim.g.envim_profile or "default"
end

function M.current()
  return current_profile()
end

function M.has(feature)
  return vim.tbl_contains(current_profile().features or {}, feature)
end

function M.enabled(feature)
  return function()
    return M.has(feature)
  end
end

function M.set(name)
  if not profiles[name] then
    vim.notify(("Unknown profile: %s"):format(name), vim.log.levels.ERROR)
    return
  end

  vim.g.envim_profile = name
  local persisted = write_profile(name)

  local lazy_refreshed = apply_profile()
  local suffix = ""
  if not lazy_refreshed then
    suffix = suffix .. " lazy.nvim is not ready yet; changes will apply on startup."
  end
  if not persisted then
    suffix = suffix .. " Profile could not be saved for the next startup."
  end
  notify(("Profile switched to %s and applied to the current session.%s"):format(name, suffix))
  vim.cmd("redrawstatus")
end

function M.info()
  local current = M.current_name()
  local lines = {
    ("Current profile: %s"):format(current),
    "",
    "Available profiles:",
  }

  for _, name in ipairs(names()) do
    local profile = profiles[name]
    lines[#lines + 1] = ("- %s: %s"):format(name, profile.desc or profile.label or "")
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "ENvim Profile" })
end

function M.pick()
  vim.ui.select(names(), {
    prompt = "Select ENvim profile",
    format_item = function(name)
      local profile = profiles[name]
      return ("%s — %s"):format(name, profile.desc or profile.label or "")
    end,
  }, function(choice)
    if choice then
      M.set(choice)
    end
  end)
end

function M.setup_commands()
  vim.api.nvim_create_user_command("ENProfile", function(opts)
    if opts.args == "" then
      M.info()
      return
    end
    M.set(opts.args)
  end, {
    nargs = "?",
    complete = function()
      return names()
    end,
    desc = "Show or set ENvim profile",
  })

  vim.api.nvim_create_user_command("ENProfilePick", function()
    M.pick()
  end, {
    desc = "Pick ENvim profile",
  })
end

function M.setup()
  local name = read_profile()
  if not profiles[name] then
    name = "default"
  end

  vim.g.envim_profile = name
  M.setup_commands()
end

return M
