local M = {}

M.general = {

  i = {
    -- navigate within insert mode
  },

  n = {
    ["<ESC>"] = { "<cmd> noh <CR>", "no highlight" },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "save file" },

    -- Copy all
    ["<C-c>"] = { "<cmd> %y+ <CR>", "copy whole file" },

    -- line numbers
    ["<leader>n"] = { "<cmd> set nu! <CR>", "toggle line number" },
    ["<leader>rn"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -- toggle wrap
    ["<leader>w"] = { "<cmd> set wrap! <CR>", "toggle wrap" },

    -- forward jump
    ["<C-p>"] = { "<C-i>", "forward jump" },

    -- new tab
    ["<leader>te"] = { ":tabedit <CR>", "new tab" },

    -- move between tabs
    ["tn"] = { ":tabn <CR>", "go to next tab" },
    ["tp"] = { ":tabp <CR>", "go to prev tab" },

    -- move between buffers
    ["<S-tab>"] = { "<cmd>bprevious<cr>", "prev buffer" },
    ["<tab>"] = { "<cmd>bnext<cr>", "next buffer" },

    -- split view
    ["ss"] = { ":split<Return><C-w>w", "horizontal split" },
    ["sv"] = { ":vsplit<Return><C-w>w", "vertical split" },

    -- move around windows
    ["sh"] = { "<C-w>h", "move to left window" },
    ["sl"] = { "<C-w>l", "move to right window" },
    ["sk"] = { "<C-w>k", "move to top window" },
    ["sj"] = { "<C-w>j", "move to bottom window" },

    -- resize windows
    ["<C-w>h"] = { "<C-w>10<", "shift left" },
    ["<C-w>l"] = { "<C-w>10>", "shift right" },
    ["<C-w>k"] = { "<C-w>10+", "shift up" },
    ["<C-w>j"] = { "<C-w>10-", "shift bottom" },
    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      opts = { expr = true },
    },
    ["k"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      opts = { expr = true },
    },
    ["<Up>"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      opts = { expr = true },
    },
    ["<Down>"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      opts = { expr = true },
    },

    -- new buffer
    ["<S-b>"] = { "<cmd> enew <CR>", "new buffer" },

    -- close buffer + hide terminal buffer
    -- ["<leader>x"] = {
    --   function()
    --     require("core.utils").close_buffer()
    --   end,
    --   "close buffer",
    -- },
  },

  v = {
    ["j"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      opts = { expr = true },
    },
    ["k"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      opts = { expr = true },
    },
    ["<Up>"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      opts = { expr = true },
    },
    ["<Down>"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      opts = { expr = true },
    },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = { 'p:let @+=@0<CR>:let @"=@0<CR>', opts = { silent = true } },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "toggle comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    -- lsp
    ["gr"] = {
      "<cmd> Telescope lsp_references <CR>",
      "telescope LSP references",
    },
    -- like cmd-d in webstorm
    ["gd"] = {
      "<cmd> Telescope lsp_implementations <CR>",
      "telescope LSP implementations",
    },
    -- like cmd-b in webstorm
    ["gb"] = {
      "<cmd> Telescope lsp_definitions <CR>",
      "telescope LSP definitions",
    },
    ["te"] = {
      "<cmd> Telescope diagnostics <CR>",
      "telescope LSP diagnostics",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "toggle nvimtree" },

    -- focus
    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    ["<leader>fa"] = {
      "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
      "find all",
    },
    ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>fo"] = {
      "<cmd> Telescope oldfiles cwd_only=true <CR>",
      "find oldfiles",
    },
    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "show keys" },
    -- ["<leader>fs"] = {
    --   function()
    --     require("plugins.configs.telescope").live_grep_in_folder()
    --   end,
    --   "search in specific directory",
    -- },

    -- file browser
    ["<leader>b"] = { "<cmd> Telescope file_browser <CR>", "show keys" },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },
    ["<leader>pr"] = {
      "<cmd> GitCreatePullRequest <CR>",
      "git create pull request",
    },

    -- fuzzy find in current buffer
    ["tf"] = {
      "<cmd> Telescope current_buffer_fuzzy_find <CR>",
      "telescope find in current buffer",
    },

    -- commands
    ["cc"] = {
      "<cmd> Telescope commands <CR>",
      "telescope list available commands",
    },
    ["ch"] = {
      "<cmd> Telescope command_history show_buf_command=false<CR>",
      "telescope command history",
    },
    ["ht"] = { "<cmd> Telescope help_tags <CR>", "telescope help tags" },

    -- locations
    ["<leader>m"] = { "<cmd> Telescope marks <CR>", "telescope marks" },
    ["<leader>qf"] = { "<cmd> Telescope quickfix <CR>", "telescope quickfix" },
    ["<leader>l"] = { "<cmd> Telescope loclist <CR>", "telescope loclist" },
  },
}

return M
