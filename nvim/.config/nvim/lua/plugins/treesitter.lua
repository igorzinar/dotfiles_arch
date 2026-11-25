return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        -- JS / TS / web
        "javascript",
        "typescript",
        "tsx",
        "jsdoc",
        "html",
        "css",
        "scss",
        -- Go
        "go",
        "gomod",
        "gosum",
        "gowork",
        -- Rust
        "rust",
        -- Config / data
        "json",
        "yaml",
        "toml",
        "dockerfile",
        "bash",
        -- Docs / git
        "markdown",
        "markdown_inline",
        "gitcommit",
        "diff",
        "regex",
        -- Neovim
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "query",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
