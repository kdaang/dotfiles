local present, telescope = pcall(require, "telescope")

if not present then return end

vim.g.theme_switcher_loaded = true

require("base46").load_highlight "telescope"

local options = {
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case"
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "normal",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8
            },
            vertical = {mirror = false},
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = {"node_modules"},
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = {"truncate"},
        winblend = 0,
        border = {},
        borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
        color_devicons = true,
        set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {n = {["q"] = require("telescope.actions").close}}
    },
    pickers = {
        find_files = {
            initial_mode = "insert",
            mappings = {
                n = {
                    ["cd"] = function(prompt_bufnr)
                        local selection =
                            require("telescope.actions.state").get_selected_entry()
                        local dir = vim.fn.fnamemodify(selection.path, ":p:h")
                        require("telescope.actions").close(prompt_bufnr)
                        -- Depending on what you want put `cd`, `lcd`, `tcd`
                        vim.cmd(string.format("silent lcd %s", dir))
                    end
                }
            }
        },
        live_grep = {initial_mode = "insert"},
        keymaps = {initial_mode = "insert"},
        commands = {initial_mode = "insert"},
        current_buffer_fuzzy_find = {initial_mode = "insert"},
        lsp_references = {
            jump_type = "never",
            fname_width = 100,
            show_line = false
        }
    },

    extensions_list = {"themes", "terms", "file_browser"}
}

-- check for any override
options = require("core.utils").load_override(options,
                                              "nvim-telescope/telescope.nvim")
telescope.setup(options)

-- load extensions
pcall(function()
    for _, ext in ipairs(options.extensions_list) do
        telescope.load_extension(ext)
    end
end)

local M = {}

local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local os_sep = require("plenary.path").path.sep
local scan = require("plenary.scandir")

M.live_grep_in_folder = function()
    local data = {}
    scan.scan_dir(vim.loop.cwd(), {
        hidden = options.hidden,
        depth = 3,
        only_dirs = true,
        respect_gitignore = options.respect_gitignore,
        on_insert = function(entry) table.insert(data, entry .. os_sep) end
    })
    table.insert(data, 1, "." .. os_sep)
    table.sort(data)

    pickers.new(options, {
        initial_mode = "insert",
        prompt_title = "Folders for Live Grep",
        finder = finders.new_table {
            results = data,
            entry_maker = make_entry.gen_from_file(options)
        },
        previewer = conf.file_previewer(options),
        sorter = conf.file_sorter(options),
        attach_mappings = function(prompt_bufnr)
            action_set.select:replace(function()
                local current_picker = action_state.get_current_picker(
                                           prompt_bufnr)
                local dirs = {}
                local selections = current_picker:get_multi_selection()
                if vim.tbl_isempty(selections) then
                    table.insert(dirs, action_state.get_selected_entry().value)
                else
                    for _, selection in ipairs(selections) do
                        table.insert(dirs, selection.value)
                    end
                end
                actions._close(prompt_bufnr,
                               current_picker.initial_mode == "insert")
                require("telescope.builtin").live_grep {search_dirs = dirs}
            end)
            return true
        end
    }):find()
end

M.testerino = function(opts)
    opts = {
        attach_mappings = function(prompt_bufnr)
            action_set.select:replace(function()
                local current_picker = action_state.get_current_picker(
                                           prompt_bufnr)
                local dirs = {}
                local selections = current_picker:get_multi_selection()
                if vim.tbl_isempty(selections) then
                    table.insert(dirs, action_state.get_selected_entry().value)
                else
                    for _, selection in ipairs(selections) do
                        table.insert(dirs, selection.value)
                    end
                end
                actions._close(prompt_bufnr,
                               current_picker.initial_mode == "insert")
                require("telescope.builtin").live_grep {search_dirs = dirs}
            end)
            return true
        end
    }
    -- opts.entry_maker = require "telescope._extensions.file_browser.make_entry"
    local finder = require"telescope".extensions.file_browser
    finder.file_browser(opts)
end

return M
