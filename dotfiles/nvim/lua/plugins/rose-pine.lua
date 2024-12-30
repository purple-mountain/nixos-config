return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    local rosepine = require("rose-pine")
    rosepine.setup({
      variant = "main",
      dark_variant = "main",
      disable_background = true,
      dim_inactive_windows = false,
      extend_background_behind_borders = true,
    })
    -- vim.cmd("colorscheme rose-pine")
  end,
}
