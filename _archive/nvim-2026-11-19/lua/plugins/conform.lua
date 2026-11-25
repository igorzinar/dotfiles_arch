local web = { "prettierd", "prettier", stop_after_first = true }

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>gf",
      function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "goimports", "gofumpt" },
      javascript = web,
      javascriptreact = web,
      typescript = web,
      typescriptreact = web,
      vue = web,
      json = web,
      jsonc = web,
      css = web,
      scss = web,
      html = web,
      markdown = web,
      yaml = web,
      graphql = web,
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
}
