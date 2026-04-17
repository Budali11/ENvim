local map = vim.keymap.set

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

map("n", "<leader>h", "<C-w>h", { desc = "Window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Window down" })
map("n", "<leader>k", "<C-w>k", { desc = "Window up" })
map("n", "<leader>l", "<C-w>l", { desc = "Window right" })

map("n", "<leader>to", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "Previous tab" })

map("n", "<leader>pp", "<cmd>ENProfilePick<cr>", { desc = "Pick profile" })
map("n", "<leader>pi", "<cmd>ENProfile<cr>", { desc = "Profile info" })
map("n", "<leader>ps", function()
  vim.cmd("Lazy sync")
end, { desc = "Sync plugins" })
