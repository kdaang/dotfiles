local M = {}

M.set_section_map = function(section_values)
  if section_values.plugin then
    return
  end
  section_values.plugin = nil

  for mode, mode_values in pairs(section_values) do
    for keybind, mapping_info in pairs(mode_values) do
      -- merge default + user opts
      local opts = mapping_info.opts or {}
      mapping_info.opts, opts.mode = nil, nil
      opts.desc = mapping_info[2]

      vim.keymap.set(mode, keybind, mapping_info[1], opts)
    end
  end
end

return M
