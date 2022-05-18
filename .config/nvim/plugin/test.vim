" vim-test plugin
if has('nvim')
  let test#strategy = "neovim"
else
  let test#strategy = "vimterminal"
endif
nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>

" let g:test#elixir#exunit#options = '--verbose'
