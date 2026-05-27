local map = vim.keymap.set

local function close_tab_or_buffer()
  if vim.fn.tabpagenr("$") > 1 then
    vim.cmd.tabclose()
    return
  end

  local ok, bufdelete = pcall(function()
    return Snacks.bufdelete
  end)
  if ok and bufdelete then
    bufdelete()
    return
  end

  vim.cmd.bdelete()
end

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

map("i", "<C-h>", "<Left>",  { desc = "Move left" })
map("i", "<C-j>", "<Down>",  { desc = "Move down" })
map("i", "<C-k>", "<Up>",    { desc = "Move up" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })

map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tx", close_tab_or_buffer, { desc = "Close tab or buffer" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

map("n", "<leader>pp", "<cmd>ENProfilePick<cr>", { desc = "Pick profile" })
map("n", "<leader>pi", "<cmd>ENProfile<cr>", { desc = "Profile info" })
map("n", "<leader>ps", function()
  vim.cmd("Lazy sync")
end, { desc = "Sync plugins" })
