local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.formatting.prettierd,
  },
  on_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then
      vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()"
    end
  end,
})
