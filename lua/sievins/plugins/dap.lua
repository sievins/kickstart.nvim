-- Debugging via nvim-dap and vscode-js-debug (installed by mason as js-debug-adapter).
-- https://github.com/mfussenegger/nvim-dap
--
-- Next.js server code: start the dev server with the inspector enabled, e.g.
--   bun run dev --inspect   (or: npm run dev -- --inspect)
-- then set a breakpoint and <leader>dc -> 'Attach to Next.js dev server'.
-- Next passes --inspect to the underlying next-server process, which listens on 9229.
-- nvim must be running with the project as its cwd; ${workspaceFolder} below
-- resolves to it and source maps only resolve inside it.
--
-- Breakpoints bind when next-server loads the compiled module, which happens on
-- the first request to that route while attached. If the route was already
-- visited before attaching, the breakpoint stays hollow: save the file, the HMR
-- recompile reloads the module and the breakpoint binds.
--
-- Only code that runs per request is debuggable: route handlers, tRPC procedures,
-- server actions, dynamic pages. Fully static pages render once inside Turbopack
-- build workers (which cannot open an inspector) and are then served from cache,
-- so breakpoints in them never bind. Verified against building-planner (Next 16).
--
-- <leader>dt (terminate) kills the attached dev server; <leader>dd (disconnect)
-- detaches and leaves it running.
--
-- Deliberately no 'launch the dev server through dap' configuration: js-debug
-- injects a --require bootloader into NODE_OPTIONS, and Next mangles it when
-- re-serialising NODE_OPTIONS for its workers ("Cannot find module '<path> <path>
-- <path>'"). Attach instead; the server keeps running when nvim closes anyway.
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' }, opts = {} },
    { 'theHamsta/nvim-dap-virtual-text', opts = {} },
  },
  keys = {
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Toggle Breakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Conditional Breakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').continue()
      end,
      desc = 'Continue / Start',
    },
    {
      '<leader>dC',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Run to Cursor',
    },
    {
      '<leader>di',
      function()
        require('dap').step_into()
      end,
      desc = 'Step Into',
    },
    {
      '<leader>dO',
      function()
        require('dap').step_over()
      end,
      desc = 'Step Over',
    },
    {
      '<leader>do',
      function()
        require('dap').step_out()
      end,
      desc = 'Step Out',
    },
    {
      '<leader>dr',
      function()
        require('dap').repl.toggle()
      end,
      desc = 'Toggle REPL',
    },
    {
      '<leader>dl',
      function()
        require('dap').run_last()
      end,
      desc = 'Run Last',
    },
    {
      '<leader>dt',
      function()
        require('dap').terminate()
      end,
      desc = 'Terminate',
    },
    {
      '<leader>dd',
      function()
        require('dap').disconnect { terminateDebuggee = false }
      end,
      desc = 'Disconnect (leave process running)',
    },
    {
      '<leader>du',
      function()
        require('dapui').toggle()
      end,
      desc = 'Toggle Debug UI',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval()
      end,
      desc = 'Eval',
      mode = { 'n', 'x' },
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.listeners.after.event_initialized['dapui'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui'] = function()
      dapui.close()
    end

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapLogPoint', { text = '◇', texthl = 'DiagnosticInfo' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticWarn', linehl = 'Visual', numhl = 'DiagnosticWarn' })

    -- Mason puts js-debug-adapter on the PATH; it wraps vscode-js-debug's DAP server.
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'js-debug-adapter',
        args = { '${port}' },
      },
    }

    for _, lang in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
      dap.configurations[lang] = {
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to Next.js dev server (run: bun run dev --inspect)',
          port = 9229,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          -- Never inject the js-debug bootloader into the attached server. Next
          -- re-serialises NODE_OPTIONS for its Turbopack workers and mangles the
          -- injected --require flags, crashing every worker with MODULE_NOT_FOUND.
          autoAttachChildProcesses = false,
          -- Do not look for source maps in node_modules; silences a stream of
          -- 'Could not read source map' warnings for prebuilt packages.
          resolveSourceMapLocations = { '${workspaceFolder}/**', '!**/node_modules/**' },
          skipFiles = { '<node_internals>/**', '**/node_modules/**' },
        },
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch current file (node)',
          program = '${file}',
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**' },
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
          sourceMaps = true,
          skipFiles = { '<node_internals>/**', '**/node_modules/**' },
        },
      }
    end
  end,
}
