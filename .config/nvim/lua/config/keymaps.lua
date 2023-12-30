-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

require("nivek.utils").load_mappings("general")

vim.keymap.del("n", "H")
vim.keymap.del("n", "L")
