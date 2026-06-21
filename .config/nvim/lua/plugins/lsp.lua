local servers = {
  "pyright",
  "marksman",
  "lua_ls",
  "kotlin_language_server",
  "jdtls",
  "yamlls",
}

return {
  {
    "mason-org/mason.nvim",
    opts = {
      install_root_dir = vim.g.local_nvim_data_dir .. "/mason",
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = servers,
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      vim.lsp.enable(servers)
    end,
  },
}
