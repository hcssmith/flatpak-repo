-- Close all buffers whose file no longer exists on disk.
-- Usage: :CloseMissing
vim.api.nvim_create_user_command('CloseMissing', function()
  local closed = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      local path = vim.api.nvim_buf_get_name(buf)
      if path ~= '' and vim.fn.filereadable(path) == 0 then
        vim.api.nvim_buf_delete(buf, { force = true })
        closed = closed + 1
      end
    end
  end
  print(string.format('Closed %d missing buffer(s)', closed))
end, { desc = 'Close all buffers whose files no longer exist' })
