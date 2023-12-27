-- n, v, i, t = mode names
local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local M = {}

M.general = {
    i = {
        -- go to  beginning and end
        ["<C-b>"] = {"<ESC>^i", "beginning of line"},
        ["<C-e>"] = {"<End>", "end of line"},

        -- navigate within insert mode
        ["<C-h>"] = {"<Left>", "move left"},
        ["<C-l>"] = {"<Right>", "move right"},
        ["<C-j>"] = {"<Down>", "move down"},
        ["<C-k>"] = {"<Up>", "move up"}
    },

    n = {
        ["<ESC>"] = {"<cmd> noh <CR>", "no highlight"},

        -- switch between windows
        ["<C-h>"] = {"<C-w>h", "window left"},
        ["<C-l>"] = {"<C-w>l", "window right"},
        ["<C-j>"] = {"<C-w>j", "window down"},
        ["<C-k>"] = {"<C-w>k", "window up"},

        -- save
        ["<C-s>"] = {"<cmd> w <CR>", "save file"},

        -- Copy all
        ["<C-c>"] = {"<cmd> %y+ <CR>", "copy whole file"},

        -- line numbers
        ["<leader>n"] = {"<cmd> set nu! <CR>", "toggle line number"},
        ["<leader>rn"] = {"<cmd> set rnu! <CR>", "toggle relative number"},

        -- toggle wrap
        ["<leader>w"] = {"<cmd> set wrap! <CR>", "toggle wrap"},

        -- update nvchad
        ["<leader>uu"] = {"<cmd> :NvChadUpdate <CR>", "update nvchad"},

        ["<leader>tt"] = {
            function() require("base46").toggle_theme() end, "toggle theme"
        },

        -- forward jump
        ["<C-p>"] = {"<C-i>", "forward jump"},

        -- new tab
        ["<leader>te"] = {":tabedit <CR>", "new tab"},

        -- move between tabs
        ["tn"] = {":tabn <CR>", "go to next tab"},
        ["tp"] = {":tabp <CR>", "go to prev tab"},

        -- split view
        ["ss"] = {":split<Return><C-w>w", "horizontal split"},
        ["sv"] = {":vsplit<Return><C-w>w", "vertical split"},

        -- move around windows
        ["sh"] = {"<C-w>h", "move to left window"},
        ["sl"] = {"<C-w>l", "move to right window"},
        ["sk"] = {"<C-w>k", "move to top window"},
        ["sj"] = {"<C-w>j", "move to bottom window"},

        -- resize windows
        ["<C-w><left>"] = {"<C-w><", "shift left"},
        ["<C-w><right>"] = {"<C-w>>", "shift right"},
        ["<C-w><up>"] = {"<C-w>+", "shift up"},
        ["<C-w><down>"] = {"<C-w>-", "shift bottom"},

        -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
        -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
        -- empty mode is same as using <cmd> :map
        -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
        ["j"] = {
            'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
            opts = {expr = true}
        },
        ["k"] = {
            'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
            opts = {expr = true}
        },
        ["<Up>"] = {
            'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
            opts = {expr = true}
        },
        ["<Down>"] = {
            'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
            opts = {expr = true}
        },

        -- new buffer
        ["<S-b>"] = {"<cmd> enew <CR>", "new buffer"},

        -- close buffer + hide terminal buffer
        ["<leader>x"] = {
            function() require("core.utils").close_buffer() end, "close buffer"
        }
    },

    t = {["<C-x>"] = {termcodes "<C-\\><C-N>", "escape terminal mode"}},

    v = {
        ["j"] = {
            'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
            opts = {expr = true}
        },
        ["k"] = {
            'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
            opts = {expr = true}
        },
        ["<Up>"] = {
            'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
            opts = {expr = true}
        },
        ["<Down>"] = {
            'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
            opts = {expr = true}
        },
        -- Don't copy the replaced text after pasting in visual mode
        -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
        ["p"] = {'p:let @+=@0<CR>:let @"=@0<CR>', opts = {silent = true}}
    }
}

M.tabufline = {
    plugin = true,

    n = {
        -- cycle through buffers
        ["<TAB>"] = {
            function() require("core.utils").tabuflineNext() end,
            "goto next buffer"
        },

        ["<S-Tab>"] = {
            function() require("core.utils").tabuflinePrev() end,
            "goto prev buffer"
        },

        -- pick buffers via numbers
        ["<Bslash>"] = {"<cmd> TbufPick <CR>", "Pick buffer"}
    }
}

M.comment = {
    plugin = true,

    -- toggle comment in both modes
    n = {
        ["<leader>/"] = {
            function()
                require("Comment.api").toggle.linewise.current()
            end, "toggle comment"
        }
    },

    v = {
        ["<leader>/"] = {
            "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
            "toggle comment"
        }
    }
}

M.lspconfig = {
    plugin = true,

    -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

    n = {
        -- lsp
        ["gr"] = {
            "<cmd> Telescope lsp_references <CR>", "telescope LSP references"
        },
        ["gd"] = {
            "<cmd> Telescope lsp_definitions <CR>", "telescope LSP definitions"
        }, -- like cmd-b in webstorm
        ["gi"] = {
            "<cmd> Telescope lsp_implementations <CR>",
            "telescope LSP implementations"
        }, -- like cmd-d in webstorm
        ["te"] = {
            "<cmd> Telescope diagnostics <CR>", "telescope LSP diagnostics"
        },

        ["gD"] = {function() vim.lsp.buf.declaration() end, "LSP declaration"},
        ["K"] = {function() vim.lsp.buf.hover() end, "LSP hover"},
        ["<leader>f"] = {
            function() vim.diagnostic.open_float() end, "floating diagnostic"
        },
        ["<leader>ls"] = {
            function() vim.lsp.buf.signature_help() end, "LSP signature_help"
        },
        ["<leader>ca"] = {
            function() vim.lsp.buf.code_action() end, "LSP code_action"
        },
        ["<leader>fm"] = {
            function() vim.lsp.buf.formatting {} end, "LSP formatting"
        },
        ["<leader>D"] = {
            function() vim.lsp.buf.type_definition() end, "lsp definition type"
        },
        ["<leader>ra"] = {
            function() require("nvchad_ui.renamer").open() end, "LSP rename"
        },

        ["gh"] = {"<cmd>Lspsaga lsp_finder<CR>", "lsp_saga finder"},
        ["gK"] = {"<cmd>Lspsaga hover_doc<CR>", "lsp_saga hover"},
        ["gf"] = {
            "<cmd>Lspsaga show_cursor_diagnostics<CR>",
            "lsp_saga cursor diagnostics"
        },

        -- ["gD"] = {
        --   function()
        --     vim.lsp.buf.definition()
        --   end,
        --   "lsp definition",
        -- },
        -- ["gi"] = {
        --   function()
        --     vim.lsp.buf.implementation()
        --   end,
        --   "lsp implementation",
        -- },
        -- ["gr"] = {
        --   function()
        --     vim.lsp.buf.references()
        --   end,
        --   "lsp references",
        -- },

        ["[d"] = {function() vim.diagnostic.goto_prev() end, "goto prev"},
        ["d]"] = {function() vim.diagnostic.goto_next() end, "goto_next"},
        -- don't know what these are for
        ["<leader>q"] = {
            function() vim.diagnostic.setloclist() end, "diagnostic setloclist"
        },
        ["<leader>wa"] = {
            function() vim.lsp.buf.add_workspace_folder() end,
            "add workspace folder"
        },
        ["<leader>wr"] = {
            function() vim.lsp.buf.remove_workspace_folder() end,
            "remove workspace folder"
        },
        ["<leader>wl"] = {
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, "list workspace folders"
        }
    }
}

M.nvimtree = {
    plugin = true,

    n = {
        -- toggle
        ["<C-n>"] = {"<cmd> NvimTreeToggle <CR>", "toggle nvimtree"},

        -- focus
        ["<leader>e"] = {"<cmd> NvimTreeFocus <CR>", "focus nvimtree"}
    }
}

M.telescope = {
    plugin = true,

    n = {
        -- find
        ["<leader>ff"] = {"<cmd> Telescope find_files <CR>", "find files"},
        ["<leader>fa"] = {
            "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
            "find all"
        },
        ["<leader>fw"] = {"<cmd> Telescope live_grep <CR>", "live grep"},
        ["<leader>fb"] = {"<cmd> Telescope buffers <CR>", "find buffers"},
        ["<leader>fh"] = {"<cmd> Telescope help_tags <CR>", "help page"},
        ["<leader>fo"] = {
            "<cmd> Telescope oldfiles cwd_only=true <CR>", "find oldfiles"
        },
        ["<leader>tk"] = {"<cmd> Telescope keymaps <CR>", "show keys"},
        ["<leader>fs"] = {
            function()
                require("plugins.configs.telescope").live_grep_in_folder()
            end, "search in specific directory"
        },

        -- file browser
        ["<leader>b"] = {"<cmd> Telescope file_browser <CR>", "show keys"},

        -- git
        ["<leader>cm"] = {"<cmd> Telescope git_commits <CR>", "git commits"},
        ["<leader>gt"] = {"<cmd> Telescope git_status <CR>", "git status"},
        ["<leader>pr"] = {
            "<cmd> GitCreatePullRequest <CR>", "git create pull request"
        },

        -- pick a hidden term
        ["<leader>pt"] = {"<cmd> Telescope terms <CR>", "pick hidden term"},

        -- theme switcher
        ["<leader>th"] = {"<cmd> Telescope themes <CR>", "nvchad themes"},

        -- fuzzy find in current buffer
        ["tf"] = {
            "<cmd> Telescope current_buffer_fuzzy_find <CR>",
            "telescope find in current buffer"
        },

        -- commands
        ["cc"] = {
            "<cmd> Telescope commands <CR>", "telescope list available commands"
        },
        ["ch"] = {
            "<cmd> Telescope command_history show_buf_command=false<CR>",
            "telescope command history"
        },
        ["ht"] = {"<cmd> Telescope help_tags <CR>", "telescope help tags"},

        -- locations
        ["<leader>m"] = {"<cmd> Telescope marks <CR>", "telescope marks"},
        ["<leader>qf"] = {"<cmd> Telescope quickfix <CR>", "telescope quickfix"},
        ["<leader>l"] = {"<cmd> Telescope loclist <CR>", "telescope loclist"},

        ["<leader>tt"] = {
            function()
                require("plugins.configs.telescope").testerino()
            end, "testerino"
        }
    }
}

M.nvterm = {
    plugin = true,

    t = {
        -- toggle in terminal mode
        ["<A-i>"] = {
            function() require("nvterm.terminal").toggle "float" end,
            "toggle floating term"
        },

        ["<A-h>"] = {
            function() require("nvterm.terminal").toggle "horizontal" end,
            "toggle horizontal term"
        },

        ["<A-v>"] = {
            function() require("nvterm.terminal").toggle "vertical" end,
            "toggle vertical term"
        }
    },

    n = {
        -- toggle in normal mode
        ["<A-i>"] = {
            function() require("nvterm.terminal").toggle "float" end,
            "toggle floating term"
        },

        ["<A-h>"] = {
            function() require("nvterm.terminal").toggle "horizontal" end,
            "toggle horizontal term"
        },

        ["<A-v>"] = {
            function() require("nvterm.terminal").toggle "vertical" end,
            "toggle vertical term"
        },

        -- new

        ["<leader>h"] = {
            function() require("nvterm.terminal").new "horizontal" end,
            "new horizontal term"
        },

        ["<leader>v"] = {
            function() require("nvterm.terminal").new "vertical" end,
            "new vertical term"
        }
    }
}

M.whichkey = {
    plugin = true,

    n = {
        ["<leader>wK"] = {
            function() vim.cmd "WhichKey" end, "which-key all keymaps"
        },
        ["<leader>wk"] = {
            function()
                local input = vim.fn.input "WhichKey: "
                vim.cmd("WhichKey " .. input)
            end, "which-key query lookup"
        }
    }
}

M.blankline = {
    plugin = true,

    n = {
        ["<leader>bc"] = {
            function()
                local ok, start =
                    require("indent_blankline.utils").get_current_context(vim.g
                                                                              .indent_blankline_context_patterns,
                                                                          vim.g
                                                                              .indent_blankline_use_treesitter_scope)

                if ok then
                    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(),
                                                {start, 0})
                    vim.cmd [[normal! _]]
                end
            end, "Jump to current_context"
        }
    }
}

return M
