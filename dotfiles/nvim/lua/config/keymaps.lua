vim.api.nvim_set_keymap("n", "<C-t>", ":FloatermToggle<CR>", { silent = true })
vim.api.nvim_set_keymap("t", "<C-t>", "<C-\\><C-n>:FloatermToggle<CR>", { silent = true })

-- Moving on a half-page distance
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc")

-- vim.api.nvim_set_keymap("n", "emt", ":TransparentToggle<CR>", { silent = true })
