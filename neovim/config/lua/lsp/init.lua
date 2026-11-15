-- LSP servers bundled in the flatpak, using the native
-- vim.lsp.config / vim.lsp.enable API (nvim >= 0.11).

-- Bundled plugin runtimes: lets lua_ls resolve globals like `telescope` and
-- `require("plenary")` when editing this config in the repo, where the
-- plugins are not part of the workspace.
local workspace_library = { vim.env.VIMRUNTIME }
for _, dir in ipairs(vim.fn.glob('/app/share/nvim/site/pack/plugins/start/*', false, true)) do
  if vim.uv.fs_stat(dir .. '/lua') then
    table.insert(workspace_library, dir .. '/lua')
  end
end

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      -- nvim embeds LuaJIT (5.1 + select 5.4 extensions), not PUC Lua 5.4.
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = {
        -- Never write third-party detection lockfiles into workspaces
        -- (and never into the read-only /app install).
        checkThirdParty = false,
        library = workspace_library,
      },
    },
  },
})

vim.lsp.enable('lua_ls')
