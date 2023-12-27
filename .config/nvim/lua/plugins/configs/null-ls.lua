local present, null_ls = pcall(require, "null-ls")

if not present then return end

null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d.with({
            diagnostics_format = '[eslint] #{m}\n(#{c})'
        }), null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.lua_format
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    vim.lsp.buf.formatting_sync()
                end
            })
        end
    end
})
