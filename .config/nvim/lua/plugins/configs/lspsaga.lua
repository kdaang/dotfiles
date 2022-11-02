
local present, lspsaga = pcall(require, "lspsaga")

if not present then
    return
end

local options = {
    border_style = "single"
}

options = require("core.utils").load_override(options, "glepnir/lspsaga.nvim")

lspsaga.init_lsp_saga(options)
