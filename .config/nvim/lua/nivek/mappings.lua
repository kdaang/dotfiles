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
    -- ["<S-tab>"] = { "<cmd>bprevious<cr>", "prev buffer" },
    -- ["<tab>"] = { "<cmd>bnext<cr>", "next buffer" },

    -- toggle last used buffers
    ["<tab>"] = { "<cmd>b#<cr>", "toggle last used buffer" },

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

    -- find
    ["<leader>fo"] = {
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      "find oldfiles",
    },
    ["<leader>fw"] = {
      function()
        Snacks.picker.grep()
      end,
      "live grep",
    },
    ["<leader>tk"] = {
      function()
        Snacks.picker.keymaps()
      end,
      "show keys",
    },

    -- commands
    ["cc"] = {
      function()
        Snacks.picker.commands()
      end,
      "available commands",
    },
    ["ch"] = {
      function()
        Snacks.picker.command_history()
      end,
      "telescope command history",
    },
    ["ht"] = {
      function()
        Snacks.picker.help()
      end,
      "telescope help tags",
    },
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
  n = {},
}

M.telescope = {
  n = {
    -- find
    --     ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "find files" },
    --     ["<leader>fa"] = {
    --       "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
    --       "find all",
    --     },
    --     ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    --
    --     -- git
    --     ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "git commits" },
    --     ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "git status" },
    --     ["<leader>pr"] = {
    --       "<cmd> GitCreatePullRequest <CR>",
    --       "git create pull request",
    --     },
    --
    --     -- fuzzy find in current buffer
    --     ["tf"] = {
    --       "<cmd> Telescope current_buffer_fuzzy_find <CR>",
    --       "telescope find in current buffer",
    --     },
    --
    --     -- locations
    --     ["<leader>m"] = { "<cmd> Telescope marks <CR>", "telescope marks" },
    --     ["<leader>qf"] = { "<cmd> Telescope quickfix <CR>", "telescope quickfix" },
    --     ["<leader>l"] = { "<cmd> Telescope loclist <CR>", "telescope loclist" },
    --
    --     -- lsp
    --     ["gr"] = {
    --       "<cmd> Telescope lsp_references <CR>",
    --       "telescope LSP references",
    --     },
    --     -- like cmd-d in webstorm
    --     ["gd"] = {
    --       "<cmd> Telescope lsp_implementations <CR>",
    --       "telescope LSP implementations",
    --     },
    --     -- like cmd-b in webstorm
    --     ["gb"] = {
    --       "<cmd> Telescope lsp_definitions <CR>",
    --       "telescope LSP definitions",
    --     },
  },
}

return M
