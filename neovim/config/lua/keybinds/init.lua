local basic_keybinds = {
  { "i", "jk", "<Esc>", "Escape insert mode"},
  { "n", "<M-Tab>", ":bnext<CR>", "Cycle buffers"},
  { {"n", "t"}, "<M-Left>", function () vim.cmd.wincmd('h') end, "Move Left" },
  { {"n", "t"}, "<M-Right>", function () vim.cmd.wincmd('l') end, "Move Right" },
  { {"n", "t"}, "<M-Up>", function () vim.cmd.wincmd('l') end, "Move Up" },
  { {"n", "t"}, "<M-Down>", function () vim.cmd.wincmd('j') end, "Move Down" },
  { "n", "<Esc>", function()
                    vim.cmd("noh")
                    vim.cmd("Noice dismiss")
                  end, "Clear highlights"}
}

local telescope = require("keybinds.telescope")

local function setup_keybinds(keys)
  for _, key_spec in ipairs(keys) do
    vim.keymap.set(
      key_spec[1],
      key_spec[2],
      key_spec[3],
      {
        desc = key_spec[4] or ''
      })
  end
end

vim.g.mapleader = " "

setup_keybinds(basic_keybinds)
setup_keybinds(telescope)
