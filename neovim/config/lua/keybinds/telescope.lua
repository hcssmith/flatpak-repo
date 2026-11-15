local builtin = require('telescope.builtin')
local project = require("project")

local function find_directory()
  local entries = project.get_project_list()
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
        actions.close(prompt_bufnr)
        project.change_project(selection.value)
      end)
      return true
    end,
  }):find()
end

local function find_files()
  if vim.g.current_project ~= nil then
    builtin.git_files()
  else
    builtin.find_files()
  end
end


return {
  {"n", "<leader>fd", find_directory, "Find project"},
  {"n", "<leader>ff", find_files, "Find Files"},
  {"n", "<leader>fg", builtin.live_grep, "Live grep"},
  {"n", "<leader>fb", builtin.buffers, "Find Buffers"}
}
