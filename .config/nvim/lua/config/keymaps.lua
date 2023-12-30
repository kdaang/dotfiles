-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("nivek.utils").load_mappings("general")

-- remove default behaviour of switching tabs
vim.keymap.del("n", "H")
vim.keymap.del("n", "L")

-- removes annoying behaviour where lines are moved accidently
-- https://www.reddit.com/r/neovim/comments/15kgw4g/lazyvim_escape_jk_line_switching/
vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")
