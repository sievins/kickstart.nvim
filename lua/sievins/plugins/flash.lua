return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  vscode = true,
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    -- Jump anywhere: type chars, pick a label. Also works mid-operator (e.g. ys<label>).
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    -- Label the treesitter nodes around the cursor, pick one to select it (yS<label> yanks it).
    { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    -- Operate elsewhere: yr -> jump to a label -> finish with a motion (iw, $, ...) -> cursor returns.
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    -- Operate on a remote node: yR -> search -> pick a node label -> yanked, cursor returns.
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search { remote_op = { motion = true } } end, desc = "Treesitter Search" },
    -- Select the node under the cursor, then <c-space> grows / <BS> shrinks the selection.
    { "<c-space>", mode = { "n", "o", "x" },
      function()
        require("flash").treesitter({
          actions = {
            ["<c-space>"] = "next",
            ["<BS>"] = "prev"
          }
        })
      end, desc = "Treesitter Incremental Selection" },
  },
}
