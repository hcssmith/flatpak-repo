local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

local function hex(color)
  if not color then return nil end
  return string.format('#%06x', color)
end

local transparent = { bg = hex(bg) }

vim.opt.laststatus = 0

