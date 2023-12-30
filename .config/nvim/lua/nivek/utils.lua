local M = {}

M.load_mappings = function(section)
  local function set_section_map(section_values)
    if section_values.plugin then
      return
    end
    section_values.plugin = nil

    for mode, mode_values in pairs(section_values) do
      for keybind, mapping_info in pairs(mode_values) do
        local opts = mapping_info.opts or {}
        mapping_info.opts, opts.mode = nil, nil
        opts.desc = mapping_info[2]

        vim.keymap.set(mode, keybind, mapping_info[1], opts)
      end
    end
  end

  local mappings = require("nivek.mappings")

  if type(section) == "string" then
    mappings[section]["plugin"] = nil
    mappings = { mappings[section] }
  end

  for _, sect in pairs(mappings) do
    set_section_map(sect)
  end
end

M.getKeyMapping = function(section_values)
  local keymaps = {}
  for _, mode_values in pairs(section_values) do
    for keybind, mapping_info in pairs(mode_values) do
      local opts = mapping_info.opts or {}
      mapping_info.opts, opts.mode = nil, nil
      opts.desc = mapping_info[2]

      table.insert(keymaps, { keybind, mapping_info[1], desc = opts.desc })
    end
  end

  return keymaps
end

return M
