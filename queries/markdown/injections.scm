; Local override of Neovim's runtime markdown injections query.
;
; WHY THIS FILE EXISTS
; --------------------
; The `nvim-treesitter` plugin (master branch, pinned in lazy-lock.json)
; ships its own `queries/markdown/injections.scm`. Because plugin runtime
; dirs come before $VIMRUNTIME in 'runtimepath', that file becomes the
; BASE injection query for markdown (see "HOW THIS OVERRIDE WORKS" below).
;
; Its first pattern is:
;
;   (fenced_code_block
;     (info_string
;       (language) @_lang)
;     (code_fence_content) @injection.content
;     (#set-lang-from-info-string! @_lang))
;
; The `#set-lang-from-info-string!` custom directive, in combination with
; the `(html_block) ... (#set! injection.combined)` pattern later in the
; same file, triggers a Neovim 0.12.2 crash during injection processing:
;
;   .../vim/treesitter/languagetree.lua:215:
;   .../vim/treesitter.lua:196:
;   attempt to call method 'range' (a nil value)
;
; The visible call stack typically goes through nvim-treesitter-context's
; `get_parent_langtrees` (which calls `parse()` early), but the same
; failure also fires from the core treesitter highlighter
; (highlighter.lua:580). The trigger is parse-time injection processing,
; not the context plugin.
;
; Either pattern in isolation parses cleanly. The crash only reproduces
; when both patterns coexist, which is the case for the bundled file.
;
; See sibling override `highlights.scm` for the related (but distinct)
; `conceal_lines` issue tracked at:
;   https://github.com/neovim/neovim/issues/39032
;
; HOW THIS OVERRIDE WORKS
; -----------------------
; This file lives in the config dir, which is prepended to 'runtimepath'
; before plugin dirs and $VIMRUNTIME. Neovim's query loader treats the
; FIRST file (in rtp order) without a ";; extends" modeline as the base
; query and ignores later base files. See:
;   $VIMRUNTIME/lua/vim/treesitter/query.lua  (function `M.get_files`)
; Therefore this file silently replaces the nvim-treesitter version.
; Snacks.nvim's `queries/markdown/injections.scm` uses `; extends` and
; is still appended on top of this base.
;
; WHAT WAS CHANGED VS NVIM-TREESITTER
; -----------------------------------
; The fenced_code_block pattern's `@_lang` capture and
; `(#set-lang-from-info-string! @_lang)` directive have been replaced
; with the upstream Neovim form `(language) @injection.language`. All
; other patterns are byte-identical to both nvim-treesitter and Neovim
; runtime (which agree on those).
;
; TRADE-OFF
; ---------
; nvim-treesitter's directive maps custom info-string aliases to parser
; names (e.g. it can route `js` to the `javascript` parser). With this
; override, language detection falls back to Neovim's built-in alias
; resolution (`vim.treesitter.language.get_lang`, which goes through
; filetype mappings via `vim.filetype.match`). Common aliases like
; `js`/`javascript`, `ts`/`typescript`, `sh`/`bash` already resolve
; correctly via filetype. If a particular language fence stops getting
; injected after this change, add a filetype mapping or a more specific
; injection in `lua/sievins/plugins/` rather than reverting this file.
;
; MAINTENANCE
; -----------
; When upgrading Neovim or nvim-treesitter, check whether this is still
; needed:
;
; 1) Diff against the upstream Neovim query shipped with the running
;    Neovim:
;
;      diff -u \
;        "$(nvim --headless --clean +'echo $VIMRUNTIME' +q 2>&1)"/queries/markdown/injections.scm \
;        ~/.config/nvim-kickstart/queries/markdown/injections.scm
;
;    The only differences should be this comment block. If anything
;    else differs, upstream changed -- port the new captures into this
;    file.
;
; 2) Test whether the bug is fixed:
;
;      mv ~/.config/nvim-kickstart/queries/markdown/injections.scm \
;         ~/.config/nvim-kickstart/queries/markdown/injections.scm.bak
;      NVIM_APPNAME=nvim-kickstart nvim --headless \
;        -c 'edit ~/.config/nvim-kickstart/README.md' \
;        -c 'sleep 2' -c 'qall!' 2>&1 | head -20
;
;    If no `attempt to call method 'range' (a nil value)` error appears,
;    delete the .bak file (and likely the whole `queries/markdown/` dir
;    if `highlights.scm` is also no longer needed). Otherwise restore:
;
;      mv ~/.config/nvim-kickstart/queries/markdown/injections.scm.bak \
;         ~/.config/nvim-kickstart/queries/markdown/injections.scm
;
; 3) Track the upstream issue: https://github.com/neovim/neovim/issues/39032

(fenced_code_block
  (info_string
    (language) @injection.language)
  (code_fence_content) @injection.content)

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
