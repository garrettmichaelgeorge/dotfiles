local lspkind = require('lspkind')
local cmp = require('cmp')

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- Your configuration here.
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
        -- elseif luasnip.jumpable(-1) then
        --   cmp.select_prev_item()
      else
        fallback()
      end
    end,
  }),
  formatting = {
    -- show name of completion item kind and source
    -- requires https://github.com/onsails/lspkind-nvim
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        buffer = "[Buffer]",
        latex_symbols = "[Latex]",
        luasnip = "[LuaSnip]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[Lua]",
        omni = "[Omni]",
        path = "[Path]",
        treesitter = "[TS]",
        ultisnips = "[Ulti]",
        vim_dadbod_completion = "[DB]",
        vsnip = "[VSnip]",
        git = "[Git]",
        ctags = "[Ctags]",
        cmdline = "[Cmd]",
      })[entry.source.name]

      return vim_item
    end
  },
  sources = {
    -- { name = 'buffer' },
    { name = 'calc' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'omni' },
    { name = 'path' },
    { name = 'treesitter' },
    { name = 'vim_dadbod_completion' },
    { name = 'vsnip' },
    { name = 'neorg' },
    { name = 'ctags' },
    { name = 'git' },
    -- { name = "ultisnips" }
  },
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline({}),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline({}),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' },
  }, {
    { name = 'buffer' },
  })
})

-- Git completion source
local format = require("cmp_git.format")
local sort = require("cmp_git.sort")

require("cmp_git").setup({
  -- defaults
  filetypes = { "gitcommit", "octo" },
  remotes = { "upstream", "origin" }, -- in order of most to least prioritized
  enableRemoteUrlRewrites = false,    -- enable git url rewrites, see https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtinsteadOf
  git = {
    commits = {
      limit = 100,
      sort_by = sort.git.commits,
      format = format.git.commits,
    },
  },
  github = {
    hosts = {}, -- list of private instances of github
    issues = {
      fields = { "title", "number", "body", "updatedAt", "state" },
      filter = "all", -- assigned, created, mentioned, subscribed, all, repos
      limit = 100,
      state = "open", -- open, closed, all
      sort_by = sort.github.issues,
      format = format.github.issues,
    },
    mentions = {
      limit = 100,
      sort_by = sort.github.mentions,
      format = format.github.mentions,
    },
    pull_requests = {
      fields = { "title", "number", "body", "updatedAt", "state" },
      limit = 100,
      state = "open", -- open, closed, merged, all
      sort_by = sort.github.pull_requests,
      format = format.github.pull_requests,
    },
  },
  gitlab = {
    hosts = {}, -- list of private instances of gitlab
    issues = {
      limit = 100,
      state = "opened", -- opened, closed, all
      sort_by = sort.gitlab.issues,
      format = format.gitlab.issues,
    },
    mentions = {
      limit = 100,
      sort_by = sort.gitlab.mentions,
      format = format.gitlab.mentions,
    },
    merge_requests = {
      limit = 100,
      state = "opened", -- opened, closed, locked, merged
      sort_by = sort.gitlab.merge_requests,
      format = format.gitlab.merge_requests,
    },
  },
  trigger_actions = {
    {
      debug_name = "git_commits",
      trigger_character = ":",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.git:get_commits(callback, params, trigger_char)
      end,
    },
    {
      debug_name = "gitlab_issues",
      trigger_character = "#",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.gitlab:get_issues(callback, git_info, trigger_char)
      end,
    },
    {
      debug_name = "gitlab_mentions",
      trigger_character = "@",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.gitlab:get_mentions(callback, git_info, trigger_char)
      end,
    },
    {
      debug_name = "gitlab_mrs",
      trigger_character = "!",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.gitlab:get_merge_requests(callback, git_info, trigger_char)
      end,
    },
    {
      debug_name = "github_issues_and_pr",
      trigger_character = "#",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.github:get_issues_and_prs(callback, git_info, trigger_char)
      end,
    },
    {
      debug_name = "github_mentions",
      trigger_character = "@",
      action = function(sources, trigger_char, callback, params, git_info)
        return sources.github:get_mentions(callback, git_info, trigger_char)
      end,
    },
  },
}
)

-- Ultisnips source
-- https://github.com/quangnguyen30192/cmp-nvim-ultisnips#installation-and-recommended-mappings
-- require("cmp_nvim_ultisnips").setup {}
