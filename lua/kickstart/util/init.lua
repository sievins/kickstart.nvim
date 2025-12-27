-- Global Kickstart utility with lazy-loading for submodules
---@class Kickstart
_G.Kickstart = setmetatable({}, {
  __index = function(t, k)
    local ok, mod = pcall(require, 'kickstart.util.' .. k)
    if ok then
      rawset(t, k, mod)
      return mod
    end
  end,
})
