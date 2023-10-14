set complete+=kspell
" Set completeopt to have a better completion experience
set completeopt=menuone,noselect

fun! LspLocationList()
  lua vim.diagnostic.setloclist({open_loclist = false})
endfun

" Autocompletion mappings
" inoremap <silent><expr> <C-Space> compe#complete()
" inoremap <silent><expr> <CR> compe#confirm('<CR>')
" inoremap <silent><expr> <C-e> compe#close('<C-e>')
" inoremap <silent><expr> <C-f> compe#scroll({ 'delta': +4 })
" inoremap <silent><expr> <C-d> compe#scroll({ 'delta': -4 })

augroup GGEORGE_LSP
  autocmd!
  autocmd! BufWrite, BufEnter, InsertLeave * :call LspLocationList()
augroup END
