local utils = require("nivek.utils")
local mappings = require("nivek.mappings")

return {
  "nvim-telescope/telescope.nvim",
  keys = vim.list_extend(utils.getKeyMapping(mappings.telescope), { { "<leader>/", false } }),
}
