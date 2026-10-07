function _G.tabline_click(minwid, clicks, button, mod)
  if button == 'l' then
    vim.api.nvim_set_current_buf(minwid)
  end
end

function _G.custom_tabline()
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  local parts = {}

  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      if name == '' then
        name = '[No Name]'
      else
        name = vim.fn.fnamemodify(name, ':t')
      end

      if buf == current_buf then
        table.insert(parts, '%#TabLineSel#%' .. buf .. '@v:lua.tabline_click@ ' .. name .. ' %T')
      else
        table.insert(parts, '%#TabLine#%' .. buf .. '@v:lua.tabline_click@ ' .. name .. ' %T')
      end
    end
  end

  if #parts == 0 then
    return ''
  end

  return table.concat(parts, '%#TabLine#|') .. '%#TabLineFill#'
end

vim.opt.tabline = '%!v:lua.custom_tabline()'
vim.opt.mouse = 'a'

vim.api.nvim_create_autocmd({ 'BufAdd', 'BufDelete', 'BufEnter' }, {
  callback = function()
    local count = 0
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
        count = count + 1
      end
    end
    vim.opt.showtabline = count > 1 and 2 or 0
  end,
})
