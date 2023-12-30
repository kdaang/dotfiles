local utils = require("nivek.utils")
local mappings = require("nivek.mappings")

return {

  "nvim-telescope/telescope.nvim",
  keys = utils.getKeyMapping(mappings.telescope),
}
