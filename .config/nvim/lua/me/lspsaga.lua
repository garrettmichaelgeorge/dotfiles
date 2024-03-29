if vim.api.nvim_eval('!has(\'lspsaga\')') then return end

local saga = require 'lspsaga'

-- helpers
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
local map_opts = { noremap=true, silent=true }

local function nnoremap (keystroke, action)
  buf_set_keymap('n', keystroke, action, map_opts)
end

local function vnoremap (keystroke, action)
  buf_set_keymap('v', keystroke, action, map_opts)
end

saga.init_lsp_saga()

-- saga.init_lsp_saga {
-- -- add your config value here
-- -- default value
-- use_saga_diagnostic_sign = true,
-- error_sign = '',
-- warn_sign = '',
-- hint_sign = '',
-- infor_sign = '',
-- dianostic_header_icon = '   ',
-- code_action_icon = ' ',
-- code_action_prompt = {
--   enable = false,
--   sign = true,
--   sign_priority = 20,
--   virtual_text = true,
-- },
-- finder_definition_icon = '  ',
-- finder_reference_icon = '  ',
-- max_preview_lines = 10, -- preview lines of lsp_finder and definition preview
-- finder_action_keys = {
--   open = 'o', vsplit = 's',split = 'i',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' -- quit can be a table
-- },
-- code_action_keys = {
--   quit = 'q',exec = '<CR>'
-- },
-- rename_action_keys = {
--   quit = '<C-c>',exec = '<CR>'  -- quit can be a table
-- },
-- definition_preview_icon = '  ',
-- -- "single" "double" "round" "plus"
-- border_style = "single",
-- rename_prompt_prefix = '➤',
-- -- if you don't use nvim-lspconfig you must pass your server name and
-- -- the related filetypes into this table
-- -- like server_filetype_map = {metals = {'sbt', 'scala'}}
-- -- server_filetype_map = {}
-- }

-- or use default config
-- saga.init_lsp_saga()

-- " -- lsp provider to find the cursor word definition and reference
  -- nnoremap('<silent> gh', ':Lspsaga lsp_finder<CR>')

-- -- " -- code action
-- -- nnoremap('<silent><leader>ca', '<cmd>lua require('lspsaga.codeaction').code_action()<CR>')
-- -- vnoremap('<silent><leader>ca', ':<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>')
  -- -- " -- or use command
  -- nnoremap('<silent><leader>ca', ':Lspsaga code_action<CR>')
  -- vnoremap('<silent><leader>ca', ':<C-U>Lspsaga range_code_action<CR>')

-- -- " -- show hover doc
-- -- nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
  -- -- " -- or use command
  -- nnoremap('<silent>K', ':Lspsaga hover_doc<CR>')

  -- -- " -- scroll down hover doc or scroll in definition preview
  -- nnoremap('<silent> <C-f>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(1)<CR>')
  -- -- " -- scroll up hover doc
  -- nnoremap('<silent> <C-b>', '<cmd>lua require(\'lspsaga.action\').smart_scroll_with_saga(-1)<CR>')

  -- -- " -- show signature help
  -- -- " and you also can use smart_scroll_with_saga to scroll in signature help win
  -- -- nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
  -- -- " -- or command
  -- nnoremap('<silent> gs', ':Lspsaga signature_help<CR>')

  -- -- " -- rename
  -- -- nnoremap <silent>gr <cmd>lua require('lspsaga.rename').rename()<CR>
  -- -- " -- or command
  -- nnoremap('<silent> rn', ':Lspsaga rename<CR>')
  -- -- " -- close rename win use <C-c> in insert mode or `q` in noremal mode or `:q`

  -- -- " -- preview definition
  -- -- nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
  -- -- " -- or use command
  -- nnoremap('<silent> gs', ':Lspsaga preview_definition<CR>')
  -- -- " can use smart_scroll_with_saga to scroll

  -- -- " -- show
  -- -- nnoremap <silent><leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
  -- nnoremap('<silent> <leader>cd', ':Lspsaga show_line_diagnostics<CR>')
  -- -- " -- only show diagnostic if cursor is over the area
  -- -- nnoremap <silent><leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
  -- nnoremap('<silent> <leader>cc', ':Lspsaga show_cursor_diagnostics<CR>')

  -- -- " -- jump diagnostic
  -- -- nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
  -- -- nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
  -- -- " -- or use command
  -- nnoremap('<silent> [e', ':Lspsaga diagnostic_jump_next<CR>')
  -- nnoremap('<silent> ]e', ':Lspsaga diagnostic_jump_prev<CR>')
