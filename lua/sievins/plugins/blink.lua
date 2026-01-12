-- Autocompletion
-- https://github.com/saghen/blink.cmp

-- Check if cursor is in a comment using treesitter
local function in_comment()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, row - 1, col - 1)
  if ok and captures then
    for _, capture in ipairs(captures) do
      if capture.capture:match 'comment' then
        return true
      end
    end
  end
  return false
end

return {
  'saghen/blink.cmp',

  event = 'VimEnter',

  dependencies = {
    'rafamadriz/friendly-snippets',
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      build = ':Copilot auth',
      opts = {
        suggestion = { enabled = false }, -- Disable inline suggestions, use blink instead
        panel = { enabled = false },
      },
    },
    {
      'giuxtaposition/blink-cmp-copilot',
    },
  },

  -- use a release tag to download pre-built binaries
  version = '1.*',

  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
    -- 'super-tab' for mappings similar to vscode (tab to accept)
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = 'super-tab',
      -- Cancel menu if open, then always exit insert mode
      -- C-e hides the menu
      -- ['<Escape>'] = { 'cancel', 'fallback' }, -- Escape out of the menu without selecting anything
      ['<Escape>'] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.cancel()
            vim.schedule(function()
              vim.cmd 'stopinsert'
            end)
            return true -- Prevent fallback from running before cancel finishes
          end
          -- Menu not visible, let fallback handle normal Escape
        end,
        'fallback',
      },
      -- Scroll half a page through menu items
      ['<C-d>'] = {
        function(cmp)
          return cmp.select_next { count = 5 }
        end,
      },
      ['<C-u>'] = {
        function(cmp)
          return cmp.select_prev { count = 5 }
        end,
      },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    -- (Default) Only show the documentation popup when manually triggered
    completion = {
      menu = { border = 'rounded' },
      documentation = {
        auto_show = false,
        window = { border = 'rounded' },
      },
    },

    -- Dynamically select sources - only copilot in comments
    sources = {
      default = function()
        if in_comment() then
          return { 'copilot' }
        end
        return { 'lsp', 'path', 'snippets', 'buffer', 'lazydev', 'copilot' }
      end,
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          async = true,
          score_offset = 100,
        },
      },
    },

    -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
    -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
    -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
    --
    -- See the fuzzy documentation for more information
    fuzzy = {
      sorts = {
        'exact', -- Always prioritize exact matches
        'score',
        'sort_text',
      },
      implementation = 'prefer_rust_with_warning',
    },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },

  -- opts_extend removed since sources.default is now a function
  -- opts_extend = { 'sources.default' },
}

-- NOTE: Idea - Only show copilot when popup triggered manually
-- https://cmp.saghen.dev/recipes.html#hide-copilot-on-suggestion
--
-- Set icons for specific sources
-- https://cmp.saghen.dev/recipes.html#set-source-kind-icon-and-name
