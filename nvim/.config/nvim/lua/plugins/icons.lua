return {
  "echasnovski/mini.icons",
  lazy = false,
  config = function()
    require("mini.icons").setup()
    -- Plugins that ask for nvim-web-devicons get mini.icons instead
    MiniIcons.mock_nvim_web_devicons()
  end,
}
