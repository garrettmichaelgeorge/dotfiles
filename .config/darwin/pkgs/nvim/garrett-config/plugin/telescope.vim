" Mappings
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files({ hidden = true })<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fvi <cmd>lua require('me/telescope').search_dotfiles()<cr>
nnoremap <leader>fcf <cmd>lua require('me/telescope').search_config()<cr>

" -- Treesitter
nnoremap <leader>ft <cmd>lua require('telescope.builtin').treesitter()<cr>

" -- LSP
nnoremap <leader>flr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fld <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>fli <cmd>lua require('telescope.builtin').lsp_implementations()<cr>
nnoremap <leader>fld <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>flc <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <leader>fls <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
