-- Lazygit is a TUI for GIT
-- https://github.com/kdheepak/lazygit.nvim

return {
  'kdheepak/lazygit.nvim',

  lazy = true,

  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },

  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },

  config = function()
    local backdrop_bufnr = nil
    local backdrop_winnr = nil

    -- Create backdrop when lazygit opens (only when transparency is off)
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = '*lazygit*',
      callback = function()
        -- Move lazygit window up a bit
        local lazygit_win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(lazygit_win)
        if config.relative ~= '' then
          config.row = config.row - 1
          config.zindex = 50
          vim.api.nvim_win_set_config(lazygit_win, config)
        end

        -- Skip backdrop when transparency is enabled
        if vim.g.transparent_enabled then
          return
        end

        -- Create backdrop buffer
        backdrop_bufnr = vim.api.nvim_create_buf(false, true)
        vim.bo[backdrop_bufnr].bufhidden = 'wipe'

        -- Create full-screen backdrop window
        backdrop_winnr = vim.api.nvim_open_win(backdrop_bufnr, false, {
          relative = 'editor',
          width = vim.o.columns,
          height = vim.o.lines,
          row = 0,
          col = 0,
          style = 'minimal',
          focusable = false,
          zindex = 40,
        })

        -- Dim the backdrop
        vim.api.nvim_set_hl(0, 'LazyGitBackdrop', { bg = '#000000', default = true })
        vim.wo[backdrop_winnr].winhighlight = 'Normal:LazyGitBackdrop'
        vim.wo[backdrop_winnr].winblend = 50
      end,
    })

    -- Clean up backdrop when lazygit closes
    vim.api.nvim_create_autocmd('TermClose', {
      pattern = '*lazygit*',
      callback = function()
        if backdrop_winnr and vim.api.nvim_win_is_valid(backdrop_winnr) then
          vim.api.nvim_win_close(backdrop_winnr, true)
        end
        backdrop_winnr = nil
        backdrop_bufnr = nil
      end,
    })
  end,

  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  -- keys = {
  --   { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  -- },
  keys = {
    {
      '<leader>gg',
      function()
        vim.cmd 'LazyGit'

        -- Sync cwd if lazygit switched worktree

        -- Grab the window lazygit.nvim just opened
        local lg_win = vim.api.nvim_get_current_win()

        -- One-shot: when THIS window closes, sync cwd
        vim.api.nvim_create_autocmd('WinClosed', {
          pattern = tostring(lg_win),
          once = true,
          callback = function()
            vim.schedule(function()
              local newdir_file = vim.fn.expand '~/.lazygit/newdir'
              if vim.fn.filereadable(newdir_file) ~= 1 then
                return
              end

              local new_dir = vim.fn.readfile(newdir_file)[1]
              vim.fn.delete(newdir_file)

              if new_dir and new_dir ~= '' and new_dir ~= vim.fn.getcwd() and vim.fn.isdirectory(new_dir) == 1 then
                vim.cmd('cd ' .. vim.fn.fnameescape(new_dir))
                vim.notify('Worktree: ' .. vim.fn.fnamemodify(new_dir, ':~'), vim.log.levels.INFO)
              end
            end)
          end,
        })
      end,
      desc = 'LazyGit',
    },
  },
}
