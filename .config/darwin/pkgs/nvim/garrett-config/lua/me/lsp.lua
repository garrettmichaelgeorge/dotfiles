local lspconfig = require 'lspconfig'
local home = os.getenv("HOME")
local util = require "lspconfig".util

local map_opts = { noremap = true, silent = true }

local function nnoremap(bufnr, keystroke, action)
  map_opts.buffer = bufnr
  vim.keymap.set('n', keystroke, action, map_opts)
end

local function vnoremap(bufnr, keystroke, action)
  map_opts.buffer = bufnr
  vim.keymap.set('v', keystroke, action, map_opts)
end

local on_attach = function(client, bufnr)
  -- Use LSP as the handler for omnifunc.
  --    See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  nnoremap(bufnr, 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  nnoremap(bufnr, 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  nnoremap(bufnr, 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  nnoremap(bufnr, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  nnoremap(bufnr, '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  nnoremap(bufnr, '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  nnoremap(bufnr, '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  nnoremap(bufnr, '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  nnoremap(bufnr, '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  nnoremap(bufnr, '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
  nnoremap(bufnr, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  nnoremap(bufnr, '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>')
  nnoremap(bufnr, '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  nnoremap(bufnr, ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  nnoremap(bufnr, '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>')

  -- automatically show the diagnostic for the item under the cursor
  -- vim.api.nvim_command('autocmd CursorHold * lua vim.diagnostic.open_float({focusable = false})')

  -- Set some keybindings conditional on server capabilities
  -- if client.server_capabilities.document_formatting then
  nnoremap(bufnr, '<space>f', '<cmd>lua vim.lsp.buf.format({ async=true })<CR>')
  -- elseif client.server_capabilities.document_range_formatting then
  --   nnoremap(bufnr, '<space>f', "<cmd>lua vim.lsp.buf.range_formatting()<CR>")
  -- end

  -- Set autocommands conditional on server_capabilities
  -- if client.server_capabilities.document_highlight then
  --   vim.api.nvim_exec([[
  --   augroup lsp_document_highlight
  --   autocmd! * <buffer>
  --   autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --   autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --   augroup END
  --     ]], false)
  -- end
end

-- use LSP snippets
-- https://github.com/hrsh7th/nvim-cmp#setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- DEPRECATED: https://github.com/hrsh7th/nvim-compe#how-to-use-lsp-snippet
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   }
-- }

-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers

local elixir_tools = require("elixir")
local elixirls = require("elixir.elixirls")

elixir_tools.setup({
  credo = {
    port = 9000,                           -- connect via TCP with the given port. mutually exclusive with `cmd`
    cmd = "path/to/credo-language-server", -- path to the executable. mutually exclusive with `port`
    on_attach = on_attach
  },
  elixirls = {
    -- specify a repository and branch
    -- repo = "mhanberg/elixir-ls",             -- defaults to elixir-lsp/elixir-ls
    -- branch = "mh/all-workspace-symbols",     -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
    -- tag = "v0.13.0",                         -- defaults to nil, mutually exclusive with the `branch` option

    -- alternatively, point to an existing elixir-ls installation (optional)
    -- not currently supported by elixirls, but can be a table if you wish to pass other args `{"path/to/elixirls", "--foo"}`
    cmd = "elixir-ls",

    -- default settings, use the `settings` function to override settings
    settings = elixirls.settings {
      dialyzerEnabled = true,
      fetchDeps = true,
      enableTestLenses = true,
      suggestSpecs = false,
    },
    on_attach = on_attach
  }
})

-- DEPRECATED: use elixir-tools instead
-- lspconfig.elixirls.setup({
--   enable = true,
--   cmd = { "elixir-ls" },
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     elixirLS = {
--       dialyzerEnabled = false,
--       fetchDeps = true,
--       enableTestLenses = true,
--     }
--   }
-- })

local elixir = {
  lintCommand = "MIX_ENV=test mix credo suggest --format=flycheck --read-from-stdin ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {
    '%f:%l:%c: %t: %m',
    '%f:%l: %t: %m'
  },
  lintCategoryMap = {
    R = 'N',
    D = 'I',
    F = 'E',
    W = 'W'
  },
  rootMarkers = { "mix.exs", "mix.lock" }
}

local prettier = {
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
  env = {
    string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.config/nvim/utils/linter-config/.prettierrc.json')),
  },
  --   formatCommand = "./node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  --   formatStdin = true
}

local shell = {
  lintCommand = "shellcheck",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
}

local nix_nil = {
  lintCommand = "nil",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
}

local nix_statix = {
  lintCommand = "statix",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
}

local nixpkgs_lint = {
  lintCommand = "nispkgs-lint",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
}

local nixpkgs_hammering = {
  lintCommand = "nispkgs-hammering",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  lintIgnoreExitCode = true,
}

-- efm-langserver - general purpose LSP
lspconfig.efm.setup({
  cmd = { 'efm-langserver', '-logfile', home .. '/.config/efm-langserver/efm.log', '-loglevel', '10' },
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "elixir", "heex", "eelixir", "javascript", "javascriptreact", "vue", "sh", "shell", "bash", "nix" },
  init_options = {
    documentFormatting = true,
    hover = true,
    documentSymbol = true,
    codeAction = false,
    completion = false
  },
  root_dir = function(fname)
    return util.root_pattern("tsconfig.json")(fname) or
        util.root_pattern("eslintrc.js", ".git")(fname);
  end,
  settings = {
    -- rootMarkers = { "mix.exs", "mix.lock" },
    languages = {
      elixir = { elixir },
      javascript = { prettier },
      typescript = {},
      shell = { shell },
      bash = { shell },
      nix = { nix_nil, nix_statix, nixpkgs_lint, nixpkgs_hammering }
    }
  }
})

lspconfig.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" }
}

require 'lspconfig'.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

require 'lspconfig'.terraformls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "terraform", "tfbackend" },
}

require 'lspconfig'.tflint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "tflint", "--langserver" },
  filetypes = { "terraform", "tfbackend" },
  root_dir = require 'lspconfig'.util.root_pattern(".terraform", ".git", ".tflint.hcl")
}

require 'lspconfig'.emmet_ls.setup {
  filetypes = { "html", "css", "eelixir", "leex", "heex" },
  on_attach = on_attach,
  capabilities = capabilities
}

require 'lspconfig'.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx",
    "vue" },
  -- handlers = {
  --   ["eslint/confirmESLintExecution"] = <function 1>,
  --   ["eslint/noLibrary"] = <function 2>,
  --   ["eslint/openDoc"] = <function 3>,
  --   ["eslint/probeFailed"] = <function 4>
  -- },
  on_new_config = function(config, new_root_dir)
    -- The "workspaceFolder" is a VSCode concept. It limits how far the
    -- server will traverse the file system when locating the ESLint config
    -- file (e.g., .eslintrc).
    config.settings.workspaceFolder = {
      uri = new_root_dir,
      name = vim.fn.fnamemodify(new_root_dir, ':t'),
    }
  end,
  -- root_dir = function(startpath)
  --   return M.search_ancestors(startpath, matcher)
  -- end,
  settings = {
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine"
      },
      showDocumentation = {
        enable = true
      }
    },
    codeActionOnSave = {
      enable = false,
      mode = "all"
    },
    format = true,
    nodePath = "",
    onIgnoredFiles = "off",
    packageManager = "npm",
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "auto"
    }
  }
}

-- If a server doesn't need special configuration, add it here
local generic_servers = {}
for _, lsp in ipairs(generic_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

require 'lspconfig'.texlab.setup {
  init_options = {
    build = {
      executable = "tectonic",
      onSave = true,
      args = { "--synctex", "--keep-logs", "keep-intermediates" }
    },
    chktex = {
      onOpenAndSave = true,
      onEdit = true
    }
  },
  on_attach = on_attach,
  capabilities = capabilities
}

require 'lspconfig'.html.setup {
  filetypes = { "html", "eelixir", "leex", "heex" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    }
  },
  on_attach = on_attach,
  capabilities = capabilities
}

require 'lspconfig'.jsonls.setup {
  commands = {
    Format = {
      function()
        vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
      end
    }
  },
  on_attach = on_attach,
  capabilities = capabilities
}

require 'lspconfig'.rnix.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- https://github.com/oxalica/nil#neovim-native-lsp-and-nvim-lspconfig
require 'lspconfig'.nil_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

-- Enable Lua custom server
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.lua_ls.setup({
  cmd = { 'lua-language-server' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Set up your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

local lsp = vim.lsp
lsp.handlers["textDocument/publishDiagnostics"] =
    lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      -- Enable underline, use default values
      underline = true,
      signs = true,
      update_in_insert = true,
      virtual_text = {
        prefix = "■",
        -- severity_limit = "Warning",
        source = "always", -- Show source in diagnostics
        spacing = 4,
      }
    })

-- Show a sign when a code action is available
-- vim.cmd([[
--   augroup MyLspGroup
--     autocmd!
--     autocmd CursorHold,CursorHoldI * lua require('me/lsp/code_action_utils').code_action_listener()
--   augroup END
-- ]])

-- local border = {
--   {"🭽", "FloatBorder"},
--   {"▔", "FloatBorder"},
--   {"🭾", "FloatBorder"},
--   {"▕", "FloatBorder"},
--   {"🭿", "FloatBorder"},
--   {"▁", "FloatBorder"},
--   {"🭼", "FloatBorder"},
--   {"▏", "FloatBorder"},
-- }

-- Overriding floating window borders globally
-- local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
-- function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
--   opts = opts or {}
--   opts.border = opts.border or border
--   return orig_util_open_floating_preview(contents, syntax, opts, ...)
-- end

lsp.set_log_level 'error'
