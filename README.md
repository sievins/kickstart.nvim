<p align="center">
  <img src="assets/header.svg" width="640" alt="sievins/nvim">
  <br>
  <img src="assets/palette.svg" alt="the palette, dark to light">
  <br>
  <sub>p e r s o n a l &nbsp; n e o v i m &nbsp; c o n f i g</sub>
</p>

    palette        tokyonight, redrawn on #011628
    leader         space
    plugins        lazy.nvim, lockfile committed
    picker         snacks
    completion     blink.cmp · copilot may only speak in comments
    statusline     lualine · harpoon slots double as the bufferline
    formatting     conform, on save, with an off switch
    debugging      dap, attaches to a running next.js
    namespace      sievins.* · a lazy global, never required
    spelling       en_gb

## q u i r k s

    <CR>           opens a blank line, never leaves normal mode
    c, x           feed the black hole · yanks stay clean
    [b ]b          walk the buffer history stack
    splits         keep the previous buffer in the old window
    buffers        a watchdog complains past 40
    macros         recording status lives in the statusline

## r u n

```sh
git clone git@github.com:sievins/kickstart.nvim.git ~/.config/nvim-kickstart
NVIM_APPNAME=nvim-kickstart nvim

# :checkhealth sievins reports anything missing
```

## f i n e &nbsp; p r i n t

<sub><code>queries/markdown/</code> overrides the runtime treesitter queries to
dodge a Neovim 0.12 crash
(<a href="https://github.com/neovim/neovim/issues/39032">neovim/neovim#39032</a>).
Read the file headers before touching anything in there.</sub>
