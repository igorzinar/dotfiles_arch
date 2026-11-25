-- Git change markers in the gutter, plus hunk actions.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("]h", function() gs.nav_hunk("next") end, "Next git hunk")
      map("[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
      map("<leader>gh", gs.preview_hunk, "Preview hunk")
      map("<leader>gs", gs.stage_hunk, "Stage / unstage hunk")
      map("<leader>gu", gs.reset_hunk, "Undo (reset) hunk")
      map("<leader>gb", gs.blame_line, "Blame line")
    end,
  },
}
