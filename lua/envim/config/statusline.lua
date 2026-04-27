local M = {}

local modes = {
  n = "NORMAL",
  no = "OP-PENDING",
  nov = "OP-PENDING",
  noV = "OP-PENDING",
  ["no\22"] = "OP-PENDING",
  niI = "NORMAL",
  niR = "NORMAL",
  niV = "NORMAL",
  nt = "NORMAL",
  v = "VISUAL",
  vs = "VISUAL",
  V = "V-LINE",
  Vs = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
  i = "INSERT",
  ic = "INSERT",
  ix = "INSERT",
  R = "REPLACE",
  Rc = "REPLACE",
  Rx = "REPLACE",
  Rv = "V-REPLACE",
  Rvc = "V-REPLACE",
  Rvx = "V-REPLACE",
  c = "COMMAND",
  cv = "EX",
  ce = "EX",
  r = "PROMPT",
  rm = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  t = "TERMINAL",
}

local function escape(value)
  local escaped = tostring(value):gsub("%%", "%%%%")
  return escaped
end

local function mode()
  return modes[vim.api.nvim_get_mode().mode] or "UNKNOWN"
end

local function filename()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    name = "[No Name]"
  else
    name = vim.fn.fnamemodify(name, ":~:.")
  end

  if vim.bo.modified then
    name = name .. " [+]"
  end

  if vim.bo.readonly or not vim.bo.modifiable then
    name = name .. " [RO]"
  end

  return name
end

local function diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local counts = vim.diagnostic.count(bufnr)
  local parts = {}

  if (counts[vim.diagnostic.severity.ERROR] or 0) > 0 then
    parts[#parts + 1] = "E:" .. counts[vim.diagnostic.severity.ERROR]
  end
  if (counts[vim.diagnostic.severity.WARN] or 0) > 0 then
    parts[#parts + 1] = "W:" .. counts[vim.diagnostic.severity.WARN]
  end
  if (counts[vim.diagnostic.severity.INFO] or 0) > 0 then
    parts[#parts + 1] = "I:" .. counts[vim.diagnostic.severity.INFO]
  end
  if (counts[vim.diagnostic.severity.HINT] or 0) > 0 then
    parts[#parts + 1] = "H:" .. counts[vim.diagnostic.severity.HINT]
  end

  if #parts == 0 then
    return ""
  end

  return table.concat(parts, " ")
end

local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ""
  end

  local names = {}
  for _, client in ipairs(clients) do
    names[#names + 1] = client.name
  end
  table.sort(names)

  return "LSP:" .. table.concat(names, ",")
end

local function profile()
  local ok, current = pcall(require, "envim.core.profile")
  if not ok then
    return "Profile:unknown"
  end

  return "Profile:" .. current.current_name()
end

function M.render()
  local left = table.concat({
    " " .. mode(),
    escape(filename()),
  }, " | ")

  local middle = diagnostics()

  local right = {}
  local lsp = lsp_clients()
  if lsp ~= "" then
    right[#right + 1] = escape(lsp)
  end
  right[#right + 1] = escape(profile())
  right[#right + 1] = escape(vim.bo.filetype ~= "" and vim.bo.filetype or "no ft")

  return table.concat({
    "%#StatusLine#",
    left,
    middle ~= "" and (" | " .. middle) or "",
    "%=",
    table.concat(right, " | "),
    " | %l:%c %p%% ",
  }, "")
end

function M.setup()
  vim.o.laststatus = 3
  if vim.fn.has("nvim-0.9") == 1 then
    vim.o.cmdheight = 0
  end
  vim.o.statusline = "%!v:lua.require'envim.config.statusline'.render()"

  local group = vim.api.nvim_create_augroup("ENvimStatusline", { clear = true })
  vim.api.nvim_create_autocmd({
    "BufEnter",
    "DiagnosticChanged",
    "LspAttach",
    "LspDetach",
    "ModeChanged",
  }, {
    group = group,
    callback = function()
      vim.cmd("redrawstatus")
    end,
  })
end

return M
