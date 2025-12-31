return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim', 'ibhagwan/fzf-lua' },
  config = function()
    local harpoon = require 'harpoon'

    -- REQUIRED
    harpoon:setup {}
    -- REQUIRED

    local function toggle_fzf(harpoon_files)
      local file_paths = {}
      -- Extract file paths from the Harpoon list
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('fzf-lua').fzf_exec(file_paths, {
        prompt = 'Harpoon> ',
        actions = {
          -- By default, press <CR> on a selection to open that file
          ['default'] = function(selected)
            if selected and #selected > 0 then
              vim.cmd('edit ' .. selected[1])
            end
          end,
        },
        -- Optional: If you’d like to preview the file, you can set `previewer`
        -- and/or `fn_transform` to build your own display or preview logic.
        previewer = 'builtin',
      })
    end

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = 'Add file to harpoon' })

    vim.keymap.set('n', '<leader>hA', function()
      harpoon:list():clear()
      harpoon:list():add()
    end, { desc = 'Clear list and add file to harpoon' })

    vim.keymap.set('n', '<leader>he', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle harpoon menu' })

    vim.keymap.set('n', '<leader>ht', function()
      toggle_fzf(harpoon:list())
    end, { desc = 'Toggle harpoon preview' })

    vim.keymap.set('n', '<leader>hc', function()
      harpoon:list():clear()
      -- Notify Harpoonline that the list changed so it rebuilds its cache
      vim.api.nvim_exec_autocmds('User', { pattern = 'HarpoonSwitchedList', modeline = false })
    end, { desc = 'Clear all files in the harpoon list' })

    -- Most of these shift keys are reserved and I've found that remembering
    -- which file is under which key hard to remember.
    --
    -- vim.keymap.set("n", "<S-h>", function()
    --   harpoon:list():select(1)
    -- end, { desc = "Select first harpoon file" })
    --
    -- vim.keymap.set("n", "<S-t>", function()
    --   harpoon:list():select(2)
    -- end, { desc = "Select second harpoon file" })
    --
    -- vim.keymap.set("n", "<S-s>", function()
    --   harpoon:list():select(3)
    -- end, { desc = "Select third harpoon file" })
    --
    -- vim.keymap.set("n", "<S-n>", function()
    --   harpoon:list():select(4)
    -- end, { desc = "Select forth harpoon file" })

    vim.keymap.set('n', '<leader>1', function()
      harpoon:list():select(1)
    end, { desc = 'Select first harpoon file' })

    vim.keymap.set('n', '<leader>2', function()
      harpoon:list():select(2)
    end, { desc = 'Select second harpoon file' })

    vim.keymap.set('n', '<leader>3', function()
      harpoon:list():select(3)
    end, { desc = 'Select third harpoon file' })

    vim.keymap.set('n', '<leader>4', function()
      harpoon:list():select(4)
    end, { desc = 'Select forth harpoon file' })

    vim.keymap.set('n', '<leader>5', function()
      harpoon:list():select(5)
    end, { desc = 'Select fith harpoon file' })

    vim.keymap.set('n', '<leader>6', function()
      harpoon:list():select(6)
    end, { desc = 'Select sixth harpoon file' })

    vim.keymap.set('n', '<leader>7', function()
      harpoon:list():select(7)
    end, { desc = 'Select seventh harpoon file' })

    vim.keymap.set('n', '<leader>8', function()
      harpoon:list():select(8)
    end, { desc = 'Select eigth harpoon file' })

    vim.keymap.set('n', '<leader>9', function()
      harpoon:list():select(9)
    end, { desc = 'Select ninth harpoon file' })

    -- Update lualine config if adding more keymaps

    -- Toggle previous & next buffers stored within Harpoon list (wraps around)
    vim.keymap.set('n', '<S-left>', function()
      local list = harpoon:list()
      local items = list.items
      local length = #items
      if length == 0 then
        return
      end

      local current = vim.fn.expand '%:.'
      local idx = nil
      for i, item in ipairs(items) do
        if item.value == current then
          idx = i
          break
        end
      end

      if idx == nil or idx <= 1 then
        list:select(length)
      else
        list:select(idx - 1)
      end
    end, { desc = 'Go to previous harpoon file (wraps)' })

    vim.keymap.set('n', '<S-right>', function()
      local list = harpoon:list()
      local items = list.items
      local length = #items
      if length == 0 then
        return
      end

      local current = vim.fn.expand '%:.'
      local idx = nil
      for i, item in ipairs(items) do
        if item.value == current then
          idx = i
          break
        end
      end

      if idx == nil or idx >= length then
        list:select(1)
      else
        list:select(idx + 1)
      end
    end, { desc = 'Go to next harpoon file (wraps)' })
  end,
}
