--vim.opt.runtimepath:prepend("/app/share/nvim/site")


-- General Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.exrc = true
vim.opt.secure = true

vim.g.mapleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<M-Tab>', ':bnext<CR>')

-- Alt+arrows: move between splits
local winnav = {
  ['<M-Left>'] = 'h',
  ['<M-Right>'] = 'l',
  ['<M-Up>'] = 'k',
  ['<M-Down>'] = 'j',
}
for key, dir in pairs(winnav) do
  vim.keymap.set({ 'n', 't' }, key, function()
    vim.cmd.wincmd(dir)
  end, { desc = 'Move to ' .. dir .. ' split' })
end

vim.filetype.add({
  extension = {
    psql = 'postgres',
    pgsql = 'postgres',
    sql = 'postgres',
    plsql = 'plpgsql',
  },
})


require('theme')
vim.cmd.colorscheme("rose-pine-main")

-- Font for GUI clients (Neovide reads 'guifont'). The family must exist on
-- the machine rendering the GUI: FiraCode Nerd Font Mono is on this host and
-- the Nerd Font glyphs cover the devicons used by the statusline/tabline.
vim.opt.guifont = "FiraCode Nerd Font Mono:h15"
vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
-- Transparent background (pairs with tokyonight transparent = true)
--vim.g.neovide_transparency = 0.85

require('telescope')
require('statusline')
--require('tabline')
require('ui')
require('buffers')

