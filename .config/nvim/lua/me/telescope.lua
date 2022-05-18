local telescope = require('telescope')
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"
local sorters = require 'telescope.sorters'
local utils = require "telescope.utils"
local entry_display = require "telescope.pickers.entry_display"
local strings = require "plenary.strings"
local Path = require "plenary.path"
local conf = require("telescope.config").values

telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  sorters.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter =  sorters.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer   = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer   = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    mappings = {
      i = {
        ["<C-x>"] = false,
        ["C-q"] = actions.send_to_qflist
      }
    },
    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  },
  pickers = {
    lsp_code_actions = {
      theme = "cursor"
    }
  }
}

telescope.load_extension('fzy_native')

-- Custom Functions

local M = {}

M.search_dotfiles = function()
  require("telescope.builtin").find_files({
    prompt_title = "< VimRC >",
    cwd = "~/.config/nvim/"
  })
end

-- Search files in custom `config` git repo
M.search_config = function()
  opts = opts or {}

  local show_untracked = utils.get_default(opts.show_untracked, true)
  local recurse_submodules = utils.get_default(opts.recurse_submodules, false)
  if show_untracked and recurse_submodules then
    error "Git does not support both --others and --recurse-submodules"
  end

  -- By creating the entry maker after the cwd options,
  -- we ensure the maker uses the cwd options when being created.
  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)

  pickers.new(opts, {
    prompt_title = "Config Files",
    finder = finders.new_oneshot_job(
      vim.tbl_flatten {
        "config",
        "ls-files",
        "--exclude-standard",
        "--cached",
        show_untracked and "--others" or nil,
        recurse_submodules and "--recurse-submodules" or nil,
      },
      opts
    ),
    previewer = conf.file_previewer(opts),
    sorter = conf.file_sorter(opts),
  }):find()
end

return M
