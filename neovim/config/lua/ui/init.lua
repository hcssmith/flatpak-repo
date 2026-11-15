require("ui.themes")

require('noice').setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      }
    },
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
    },
    cmdline = {
      view = "cmdline",
    },
    views = {
      ["mini.win_options.winblend"] = 0,
    },
    presets = {
      bottom_search = true,
      long_message_to_split = true,
      inc_rename = false,
      lsp_doc_border = false,
    }
  })

vim.cmd.colorscheme("rose-pine-main")
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
vim.opt.laststatus = 0
vim.o.stl = "%{repeat('─',winwidth('.'))}"
vim.opt.guifont = "FiraCode Nerd Font Mono:h13"
vim.g.neovide_position_animation_length = 0
vim.g.neovide_cursor_animation_length = 0.00
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_animate_in_insert_mode = false
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_scroll_animation_far_lines = 0
vim.g.neovide_scroll_animation_length = 0.00
-- Transparent background (pairs with tokyonight transparent = true)
--vim.g.neovide_transparency = 0.85
vim.g.neovide_opacity = 0.85
vim.g.neovide_normal_opacity = 0.85
