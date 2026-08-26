--[[
--
-- Health check for this config. Run with `:checkhealth sievins`.
-- Auto-discovered by Neovim via the lua/sievins/health.lua runtimepath convention.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if vim.version.ge(vim.version(), '0.11') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. This config uses vim.lsp.config/vim.lsp.enable, which need 0.11+", verstr))
  end
end

local check_external_reqs = function()
  local tools = {
    { exe = 'git', purpose = 'lazy.nvim bootstrap, gitsigns, snacks git pickers' },
    { exe = 'rg', purpose = 'grepprg, snacks grep pickers' },
    { exe = 'fd', purpose = 'snacks file picker' },
    { exe = 'lazygit', purpose = 'lazygit.nvim' },
    { exe = 'gh', purpose = 'snacks gh_issue/gh_pr pickers' },
    { exe = 'unzip', purpose = 'mason package installs' },
    { exe = 'cargo', purpose = 'blink.cmp build step' },
    { exe = 'node', purpose = 'copilot, markdown-preview' },
  }

  for _, tool in ipairs(tools) do
    if vim.fn.executable(tool.exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s'", tool.exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s' (needed for: %s)", tool.exe, tool.purpose))
    end
  end
end

return {
  check = function()
    vim.health.start 'sievins'

    vim.health.info "NOTE: Not every warning is a 'must-fix'. A missing tool only matters if you use the feature that needs it."

    vim.health.info('System Information: ' .. vim.inspect(vim.uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
