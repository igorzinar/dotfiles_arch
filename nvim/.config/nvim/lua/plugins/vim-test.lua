return {
  "vim-test/vim-test",
  keys = {
    { "<leader>tn", "<cmd>TestNearest<CR>", desc = "Test nearest" },
    { "<leader>tf", "<cmd>TestFile<CR>",    desc = "Test file" },
    { "<leader>ts", "<cmd>TestSuite<CR>",   desc = "Test suite" },
    { "<leader>tl", "<cmd>TestLast<CR>",    desc = "Test last" },
    { "<leader>tv", "<cmd>TestVisit<CR>",   desc = "Visit last test file" },
  },
  init = function()
    -- Run tests in a Neovim terminal split (no tmux needed)
    vim.g["test#strategy"] = "neovim"
  end,
}
