return {
  'nvim-lualine/lualine.nvim',

  dependencies = { 'nvim-tree/nvim-web-devicons', { 'abeldekat/harpoonline', version = '*' } },

  event = 'VeryLazy',

  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,

  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require 'lualine_require'
    lualine_require.require = require

    vim.o.laststatus = vim.g.lualine_laststatus

    -- Single grey background for all sections (uses bg_highlight from theme)
    local colors = require('tokyonight.colors').setup()
    local grey_bg = colors.bg_highlight
    local grey_theme = {
      normal = {
        a = { bg = grey_bg, fg = colors.blue },
        b = { bg = grey_bg, fg = colors.fg },
        c = { bg = grey_bg, fg = colors.fg },
      },
      insert = {
        a = { bg = grey_bg, fg = colors.green },
        b = { bg = grey_bg, fg = colors.fg },
        c = { bg = grey_bg, fg = colors.fg },
      },
      visual = {
        a = { bg = grey_bg, fg = colors.magenta },
        b = { bg = grey_bg, fg = colors.fg },
        c = { bg = grey_bg, fg = colors.fg },
      },
      replace = {
        a = { bg = grey_bg, fg = colors.red },
        b = { bg = grey_bg, fg = colors.fg },
        c = { bg = grey_bg, fg = colors.fg },
      },
      command = {
        a = { bg = grey_bg, fg = colors.yellow },
        b = { bg = grey_bg, fg = colors.fg },
        c = { bg = grey_bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = grey_bg, fg = colors.dark5 },
        b = { bg = grey_bg, fg = colors.dark5 },
        c = { bg = grey_bg, fg = colors.dark5 },
      },
    }

    local opts = {
      options = {
        theme = grey_theme,
        section_separators = '',
        component_separators = '',
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = { statusline = { 'alpha' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },

        lualine_c = {
          {
            'filename',
            symbols = {
              modified = '',
              readonly = '',
              unnamed = '[No Name]',
              newfile = '',
            },
          },
          {
            'diagnostics',
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
        },
        lualine_x = {
          {
            require('recorder').recordingStatus,
          },
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          function()
            return ' ' .. os.date '%R'
          end,
        },
      },
      extensions = { 'neo-tree', 'lazy', 'fzf' },
    }

    return opts
  end,

  config = function(_, opts)
    local Harpoonline = require 'harpoonline'
    Harpoonline.setup {
      ---@param data HarpoonlineData
      ---@return string HarpoonLine *file1 file2 ...
      custom_formatter = function(data)
        local index = 0
        return #data.items == 0 and ''
          or table.concat(
            vim.tbl_map(function(item)
              index = index + 1
              local filename = string.find(item.value, '/') == nil and item.value or item.value:match('.*' .. '/' .. '(.*)')
              return data.active_idx == index and '*' .. filename or filename
            end, data.items),
            ' '
          )
      end,

      on_update = function()
        require('lualine').refresh()
      end,
    }

    ---@param inputstr string
    ---@param del string
    ---@return table<string>
    local function split(inputstr, del)
      if del == nil then
        del = '%s'
      end
      local t = {}
      for str in string.gmatch(inputstr, '([^' .. del .. ']+)') do
        table.insert(t, str)
      end
      return t
    end

    ---@return boolean
    local function isHarpoonActive()
      return Harpoonline.format() ~= ''
    end

    ---@param str string
    ---@param max_len number
    ---@return string
    local function truncate(str, max_len)
      if #str <= max_len then
        return str
      end
      return string.sub(str, 1, max_len - 1) .. '…'
    end

    ---@param index number
    ---@param max_len number|nil
    ---@return string | nil
    local function getFile(index, max_len)
      local files = split(Harpoonline.format(), ' ')
      local file = files[index]
      -- Remove leading '*' character if present
      local filename = file and string.sub(file, 1, 1) == '*' and string.sub(file, 2) or file
      if filename and max_len then
        return truncate(filename, max_len)
      end
      return filename
    end

    ---@param index number
    ---@return boolean
    local isFileHarpooned = function(index)
      local files = split(Harpoonline.format(), ' ')
      return files[index] ~= nil
    end

    ---@return number
    local function getHarpoonCount()
      local files = split(Harpoonline.format(), ' ')
      return #files
    end

    ---@param index number
    ---@return boolean
    local function isFileCurrentBuffer(index)
      local files = split(Harpoonline.format(), ' ')
      local file = files[index]
      return file and string.sub(file, 1, 1) == '*'
    end

    local max_filename_len = 6
    local truncate_threshold = 5

    ---@param index number
    ---@param isActiveLine boolean
    local function createLualine(index, isActiveLine)
      if isActiveLine then
        return {
          function()
            local max_len = getHarpoonCount() > truncate_threshold and max_filename_len or nil
            return isHarpoonActive() and isFileHarpooned(index) and isFileCurrentBuffer(index) and index .. '. ' .. getFile(index, max_len) or ''
          end,
          'filename',
          color = { fg = '#a1cd5e' },
        }
      else
        return {
          function()
            local max_len = getHarpoonCount() > truncate_threshold and max_filename_len or nil
            return isHarpoonActive() and isFileHarpooned(index) and not isFileCurrentBuffer(index) and index .. '. ' .. getFile(index, max_len) or ''
          end,
          'filename',
        }
      end
    end

    local lualines = {
      {
        function()
          return isHarpoonActive() and '󰛢 [' or ''
        end,
        'filename',
        color = { fg = '#a1cd5e' },
      },
      createLualine(1, true),
      createLualine(1, false),
      createLualine(2, true),
      createLualine(2, false),
      createLualine(3, true),
      createLualine(3, false),
      createLualine(4, true),
      createLualine(4, false),
      createLualine(5, true),
      createLualine(5, false),
      createLualine(6, true),
      createLualine(6, false),
      createLualine(7, true),
      createLualine(7, false),
      createLualine(8, true),
      createLualine(8, false),
      createLualine(9, true),
      createLualine(9, false),
      {
        function()
          return isHarpoonActive() and ']' or ''
        end,
        'filename',
        color = { fg = '#a1cd5e' },
      },
    }

    local function reverseInsert(tbl, tblToInsert)
      for i = #tblToInsert, 1, -1 do
        table.insert(tbl, 1, tblToInsert[i])
      end
    end

    reverseInsert(opts.sections.lualine_c, lualines)

    require('lualine').setup(opts)
  end,
}
