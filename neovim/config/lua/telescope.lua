local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


local function find_directory()
  local root = vim.fn.expand("~/Git")
  local directories = vim.fn.glob(root .. "/*", false, true)
  local entries = {}

  for _, directory in ipairs(directories) do
    if vim.fn.isdirectory(directory) == 1 then
      table.insert(entries, {
        value = directory,
        display = vim.fn.fnamemodify(directory, ":t"),
        ordinal = vim.fn.fnamemodify(directory, ":t"),
      })
    end
  end

  local finders = require("telescope.finders")
  local pickers = require("telescope.pickers")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Change Project Directory",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        return entry
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if not selection then
          return
        end

        local target = selection.value

        -- Refuse to proceed if any buffer has unwritten changes.
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buffer)
            and vim.bo[buffer].modified then
            vim.notify(
              "Unwritten changes exist. Save or discard them first.",
              vim.log.levels.ERROR
            )
            return
          end
        end

        actions.close(prompt_bufnr)

        -- Replace the current buffer with a fresh empty buffer.
        vim.cmd("enew")

        -- Delete all other buffers.
        for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
          if buffer ~= vim.api.nvim_get_current_buf()
            and vim.api.nvim_buf_is_valid(buffer)
            and not vim.bo[buffer].modified then
            pcall(vim.api.nvim_buf_delete, buffer, { force = false })
          end
        end

        -- Change directory for the session.
        vim.cmd.cd(vim.fn.fnameescape(target))

        -- Ensure the current buffer is empty and unnamed.
        vim.api.nvim_buf_set_lines(0, 0, -1, false, { "" })
        vim.bo.modified = false
      end)

      return true
    end,
  }):find()
end

vim.keymap.set("n", "<leader>fd", find_directory, {
  desc = "Find project directory",
})
