local group = vim.api.nvim_create_augroup("local_filetype_settings", { clear = true })
local map = vim.keymap.set

local function set_indent(width)
  vim.bo.tabstop = width
  vim.bo.shiftwidth = width
  vim.bo.softtabstop = width
  vim.bo.expandtab = true
end

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "python", "java", "kotlin" },
  callback = function()
    set_indent(4)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "lua", "markdown", "yaml" },
  callback = function()
    set_indent(2)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("local_lsp_keymaps", { clear = true }),
  callback = function(event)
    local opts = function(desc)
      return { buffer = event.buf, desc = "LSP: " .. desc }
    end

    map("n", "gd", vim.lsp.buf.definition, opts("go to definition"))
    map("n", "gr", vim.lsp.buf.references, opts("references"))
    map("n", "K", vim.lsp.buf.hover, opts("hover"))
    map("n", "<leader>rn", vim.lsp.buf.rename, opts("rename"))
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts("code action"))
    map("n", "<leader>ld", vim.diagnostic.open_float, opts("line diagnostics"))
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, opts("previous diagnostic"))
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, opts("next diagnostic"))
  end,
})
