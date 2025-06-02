return {
  "zenbones-theme/zenbones.nvim",
  -- Optionally install Lush. Allows for more configuration or extending the colorscheme
  -- If you don't want to install lush, make sure to set g:zenbones_compat = 1
  -- In Vim, compat mode is turned on as Lush only works in Neovim.
  dependencies = "rktjmp/lush.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.cmd("colorscheme neobones")
    vim.api.nvim_set_hl(0, "Normal", { bg = "#100c08" })

    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#100c08" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#100c08" })

    -- vim.api.nvim_set_hl(0, "Normal", { bg = "#0f0f0f" })
    -- vim.cmd("set background=dark")
  end,
}
