" Ack.vim
nnoremap \ :Ack<SPACE>
if executable('ag')
  let g:ackprg = "ag --vimgrep"
endif
let g:ack_use_dispatch = 1
let g:ackhighlight = 1
let g:ackpreview = 1
let g:ack_use_cword_for_empty_search = 1
