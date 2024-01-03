local utils = require("nivek.utils")
local mappings = require("nivek.mappings")

return {
  "nvim-telescope/telescope.nvim",
  keys = vim.list_extend(utils.getKeyMapping(mappings.telescope), { { "<leader>/", false } }),
  opts = {
    pickers = {
      live_grep = {
        mappings = {
          n = {
            ["<C-g>"] = require("nivek.custom.telescope").show_dirs,
            ["<C-l>"] = require("nivek.custom.telescope").actions.set_folders,
            ["<C-f>"] = require("nivek.custom.telescope").actions.set_extension,
          },
          i = {
            ["<C-l>"] = require("nivek.custom.telescope").actions.set_folders,
            ["<C-f>"] = require("nivek.custom.telescope").actions.set_extension,
            ["<C-g>"] = require("nivek.custom.telescope").show_dirs,
          },
        },
      },
    },
  },
}
