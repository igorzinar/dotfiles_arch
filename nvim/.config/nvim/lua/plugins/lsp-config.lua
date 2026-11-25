local servers = {
  -- JS / TS / web
  "ts_ls",
  "eslint",
  "html",
  "cssls",
  "tailwindcss",
  -- Go
  "gopls",
  -- Config files
  "jsonls",
  "yamlls",
  "taplo", -- TOML
  "bashls",
  "dockerls",
  "marksman", -- Markdown
  -- Neovim config
  "lua_ls",
  -- Rust (uncomment when you start)
  -- "rust_analyzer",
}

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = servers,
      automatic_enable = false,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "prettierd", "prettier", "stylua", "goimports", "gofumpt" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- Schemas for package.json, tsconfig, GitHub Actions, docker-compose, ...
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas = require("schemastore").yaml.schemas(),
          },
        },
      })

      vim.lsp.enable(servers)

      -- Neovim 0.11+ also has built-ins: grn (rename), gra (code action),
      -- grr (references), gri (implementation), K (hover)
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end
      map("K", vim.lsp.buf.hover, "Hover docs")
      map("<leader>gd", vim.lsp.buf.definition, "Go to definition")
      map("<leader>gr", vim.lsp.buf.references, "References")
      map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    end,
  },
}
