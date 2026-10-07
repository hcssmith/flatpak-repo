-- TokyoNight theme config.
-- Must run BEFORE vim.cmd.colorscheme() in init.lua; setup() only applies
-- to the next colorscheme load.
-- transparent = true clears Normal/NormalNC backgrounds so the terminal
-- (or Neovide) background shows through. Sidebars and floats default to
-- "dark", so set those transparent too for a consistent look.
require("tokyonight").setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent",
  },
})
