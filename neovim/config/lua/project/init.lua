return {
  get_project_list = function()
    local root = vim.fn.expand("~/Git")
    local dirs = vim.fn.glob(root .. "/*/*", false, true)

    local projects = {}

    for _, dir in ipairs(dirs) do
      table.insert(projects, {
        value = dir,
        display = vim.fn.fnamemodify(dir, ":h:t") .. "/" .. vim.fn.fnamemodify(dir, ":t"),
        ordinal = vim.fn.fnamemodify(dir, ":h:t") .. "/" .. vim.fn.fnamemodify(dir, ":t")
      })
    end

    return projects

  end,

    --- @param project string "directory"
  change_project = function(project)
    -- check if existing buffers has unwitten changes
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
        vim.notify("Unritten changes, Save or discard",
                    vim.log.levels.ERROR)
        return
      end
    end

    -- replace with project dashboard eventually
    vim.cmd("enew")

    -- close existing buffers
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= vim.api.nvim_get_current_buf()
        and vim.api.nvim_buf_is_valid(buf)
        and not vim.bo[buf].modified then
        pcall(vim.api.nvim_buf_delete, buf, {force = false})
      end
    end

    vim.cmd.cd(vim.fn.fnameescape(project))
    vim.g.current_project = project

    vim.bo.modified = false
  end
}
