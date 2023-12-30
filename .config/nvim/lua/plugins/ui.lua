return {
  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  -- add filename to top right of window
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    priority = 1200,
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } },
        hide = {
          cursorline = true,
        },
        render = function(props)
          local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":.:h")
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if vim.bo[props.buf].modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filepath }, { "/" }, { filename, guifg = color } }
        end,
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    opts = function(_, opts)
      local logo = [[
███╗   ██╗██╗██╗   ██╗███████╗██╗  ██╗
████╗  ██║██║██║   ██║██╔════╝██║ ██╔╝
██╔██╗ ██║██║██║   ██║█████╗  █████╔╝ 
██║╚██╗██║██║╚██╗ ██╔╝██╔══╝  ██╔═██╗ 
██║ ╚████║██║ ╚████╔╝ ███████╗██║  ██╗
╚═╝  ╚═══╝╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
      ]]

      logo = string.rep("\n", 8) .. logo .. "\n\n"
      opts.config.header = vim.split(logo, "\n")
    end,
  },
}
