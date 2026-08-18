-- Treesitter - Highlight, edit, and navigate code
-- https://github.com/nvim-treesitter/nvim-treesitter

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Parsers installed up-front; anything else auto-installs on demand (see autocmd below)
    local ensure_installed = {
      'bash',
      'c',
      'css',
      'csv',
      'diff',
      'gitignore',
      'graphql',
      'html',
      'javascript',
      'json',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'prisma',
      'python',
      'query',
      'sql',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'xml',
      'yaml',
    }
    require('nvim-treesitter').install(ensure_installed)

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('sievins-treesitter', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang then
          return
        end

        local function enable()
          vim.treesitter.start(buf, lang) -- highlighting
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- folding
          vim.wo[0][0].foldmethod = 'expr'
        end

        if vim.treesitter.language.add(lang) then
          enable()
        elseif vim.tbl_contains(require('nvim-treesitter.config').get_available(), lang) then
          -- replaces auto_install = true: install missing parser, then enable
          require('nvim-treesitter').install(lang):await(function(err)
            if not err and vim.api.nvim_buf_is_valid(buf) then
              enable()
            end
          end)
        end
      end,
    })
  end,
  -- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
  -- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
}
