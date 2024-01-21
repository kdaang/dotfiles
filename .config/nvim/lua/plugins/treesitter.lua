return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      vim.list_extend(opts.ensure_installed, { "prisma", "markdown" })
      vim.treesitter.language.register("markdown", "mdx")
    end
  end,
}
