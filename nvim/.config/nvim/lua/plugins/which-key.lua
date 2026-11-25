-- Press <leader> (space) and wait: a popup lists every key you can press next.
-- <leader>? shows all keymaps for the current buffer.
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git / goto" },
      { "<leader>l", group = "lazygit" },
      { "<leader>r", group = "rename" },
      { "<leader>s", group = "scratch" },
      { "<leader>t", group = "test" },
    },
  },
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer keymaps",
    },
  },
}
