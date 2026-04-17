local M = {}

local profiles = require("envim.config.profiles")
local state_file = vim.fn.stdpath("state") .. "/envim-profile.txt"

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
  vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
  vim.fn.writefile({ name }, state_file)
end

local function current_profile()
  local name = vim.g.envim_profile or "default"
  return profiles[name] or profiles.default
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
  write_profile(name)
  vim.notify(
    ("Profile switched to %s. Run :Lazy sync and restart Neovim to fully apply plugin changes."):format(name),
    vim.log.levels.INFO
  )
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
