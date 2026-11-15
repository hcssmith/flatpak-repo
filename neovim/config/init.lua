vim.g.mapleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0


vim.filetype.add({
  extension = {
    psql = 'postgres',
    pgsql = 'postgres',
    sql = 'postgres',
    plsql = 'plpgsql',
  },
})

require('keybinds')
require('ui')
require('commands')
require('lsp')

