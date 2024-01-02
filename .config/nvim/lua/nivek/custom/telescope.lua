local Path = require("plenary.path")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local transform_mod = require("telescope.actions.mt").transform_mod
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local os_sep = Path.path.sep
local pickers = require("telescope.pickers")
local state = require("telescope.state")
local scan = require("plenary.scandir")
local p_window = require("telescope.pickers.window")

local M = {}

---Keep track of the active extension and folders for `live_grep`
local live_grep_filters = {
  ---@type nil|string
  extension = nil,
  ---@type nil|string[]
  directories = nil,
  ---@type nil|string[]
  current_input = nil,
}

local prev_live_grep = nil

---Run `live_grep` with the active filters (extension and folders)
local function run_live_grep(filters)
  require("telescope.builtin").live_grep({
    search_dirs = filters.directories,
    additional_args = filters.extension and function()
      return { "-g", "*." .. filters.extension }
    end,
    default_text = filters.current_input,
    -- code taken from https://github.com/nvim-telescope/telescope.nvim/issues/1701#issuecomment-1016227855
    attach_mappings = function(prompt_bufnr, map)
      actions.close:enhance({
        post = function()
          -- taken from builtin.resume maybe rfc into a `telescope.utils`.get_last_picker
          local cached_pickers = state.get_global_key("cached_pickers")
          if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
            print("No picker(s) cached")
            return
          end
          prev_live_grep = cached_pickers[1] -- last picker is always 1st

          live_grep_filters.current_input = prev_live_grep.default_text
        end,
      })
      return true
    end,
  })
end

local function live_grep_cached(opts)
  opts = opts or {}

  if prev_live_grep == nil then
    run_live_grep(live_grep_filters)
  else
    -- code taken from telescope.internal.resume
    -- https://github.com/nvim-telescope/telescope.nvim/blob/3466159b0fcc1876483f6f53587562628664d850/lua/telescope/builtin/__internal.lua#L122-L166
    --
    -- reset layout strategy and get_window_options if default as only one is valid
    -- and otherwise unclear which was actually set
    if prev_live_grep.layout_strategy == conf.layout_strategy then
      prev_live_grep.layout_strategy = nil
    end
    if prev_live_grep.get_window_options == p_window.get_window_options then
      prev_live_grep.get_window_options = nil
    end
    opts.resumed_picker = true

    pickers.new(opts, prev_live_grep):find()
  end
end

M.actions = transform_mod({
  ---Ask for a file extension and open a new `live_grep` filtering by it
  set_extension = function(prompt_bufnr)
    vim.ui.input({ prompt = "*." }, function(input)
      if input == nil then
        return
      end

      live_grep_filters.extension = input

      actions.close(prompt_bufnr)

      run_live_grep(live_grep_filters)
    end)
  end,
  ---Ask the user for a folder and olen a new `live_grep` filtering by it
  set_folders = function(prompt_bufnr)
    local data = {}
    scan.scan_dir(vim.loop.cwd(), {
      hidden = true,
      only_dirs = true,
      depth = 3,
      respect_gitignore = true,
      on_insert = function(entry)
        table.insert(data, entry .. os_sep)
      end,
    })
    table.insert(data, 1, "." .. os_sep)

    actions.close(prompt_bufnr)
    pickers
      .new({}, {
        prompt_title = "Folders for Live Grep",
        finder = finders.new_table({ results = data, entry_maker = make_entry.gen_from_file({}) }),
        previewer = conf.file_previewer({}),
        sorter = conf.file_sorter({}),
        attach_mappings = function(prompt_bufnr)
          action_set.select:replace(function()
            local current_picker = action_state.get_current_picker(prompt_bufnr)

            local dirs = {}
            local selections = current_picker:get_multi_selection()
            if vim.tbl_isempty(selections) then
              table.insert(dirs, action_state.get_selected_entry().value)
            else
              for _, selection in ipairs(selections) do
                table.insert(dirs, selection.value)
              end
            end
            live_grep_filters.directories = dirs

            actions.close(prompt_bufnr)

            run_live_grep(live_grep_filters)
          end)
          return true
        end,
      })
      :find()
  end,
})

---Small wrapper over `live_grep` to first reset our active filters
M.live_grep = function(opts)
  live_grep_cached(opts)
end

return M
