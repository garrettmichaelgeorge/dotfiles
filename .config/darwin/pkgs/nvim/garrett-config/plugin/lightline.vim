set laststatus=2

let g:lightline = {
      \ 'colorscheme': 'gruvbox_material',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [  'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'gitbranch', 'fugitive' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ 'component': {
      \   'helloworld': 'Hello, world!'
      \ },
\ }

" see :h g:lightline.component
" 		let g:lightline.component = {
" 		    \ 'mode': '%{lightline#mode()}',
" 		    \ 'absolutepath': '%F',
" 		    \ 'relativepath': '%f',
" 		    \ 'filename': '%t',
" 		    \ 'modified': '%M',
" 		    \ 'bufnum': '%n',
" 		    \ 'paste': '%{&paste?"PASTE":""}',
" 		    \ 'readonly': '%R',
" 		    \ 'charvalue': '%b',
" 		    \ 'charvaluehex': '%B',
" 		    \ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
" 		    \ 'fileformat': '%{&ff}',
" 		    \ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
" 		    \ 'percent': '%3p%%',
" 		    \ 'percentwin': '%P',
" 		    \ 'spell': '%{&spell?&spelllang:""}',
" 		    \ 'lineinfo': '%3l:%-2c',
" 		    \ 'line': '%l',
" 		    \ 'column': '%c',
" 		    \ 'close': '%999X X ',
" 		    \ 'winnr': '%{winnr()}' }
