-- Global sievins utility with lazy-loading for submodules
---@class sievins
---@field bufdelete sievins.bufdelete
---@field bufhistory sievins.bufhistory
---@field root sievins.root
_G.sievins = setmetatable({}, {
  __index = function(t, k)
    local ok, mod = pcall(require, 'sievins.util.' .. k)
    if ok then
      rawset(t, k, mod)
      return mod
    end
  end,
})
