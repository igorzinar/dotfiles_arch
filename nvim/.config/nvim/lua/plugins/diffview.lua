-- Side-by-side git diffs, file history and 3-way merge (WebStorm-style).
-- Opens in its own tab; close with :DiffviewClose (or <leader>gq).
-- During a merge/rebase conflict, <leader>gv shows ours | base | theirs.
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<CR>",          desc = "Diff view (all changes)" },
    { "<leader>gq", "<cmd>DiffviewClose<CR>",         desc = "Close diff view" },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<CR>", desc = "File history" },
    { "<leader>gR", "<cmd>DiffviewFileHistory<CR>",   desc = "Repo history" },
  },
  opts = {
    view = {
      merge_tool = { layout = "diff3_mixed" },
    },
  },
}
