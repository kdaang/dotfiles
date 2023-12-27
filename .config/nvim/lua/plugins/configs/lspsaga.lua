local present, lspsaga = pcall(require, "lspsaga")

if not present then return end

local options = {
    border_style = "single",
    preview = {lines_above = 0, lines_below = 10},
    symbol_in_winbar = {
        enable = true,
        separator = " > ",
        hide_keyword = true,
        show_file = true,
        folder_level = 10,
        color_mode = false,
        respect_root = true
    }
}

options = require("core.utils").load_override(options, "glepnir/lspsaga.nvim")

lspsaga.setup(options)
