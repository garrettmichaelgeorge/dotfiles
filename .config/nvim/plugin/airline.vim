set noshowmode

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

let g:airline_highlighting_cache = 1

" Plugin integration
let g:airline_extensions = ['nvimlsp', 'branch', 'fugitiveline', 'searchcount', 'quickfix']

let g:airline#extensions#fugitiveline#enabled = 1

let g:airline#extensions#nvimlsp#enabled = 1
let airline#extensions#nvimlsp#warning_symbol = 'W:'
let airline#extensions#nvimlsp#error_symbol = 'E:'

" to truncate all path sections but the last one, e.g. a branch
" 'foo/bar/baz' becomes 'f/b/baz', use
let g:airline#extensions#branch#format = 2

let g:airline_theme = 'gruvbox_material'
let g:gruvbox_material_statusline_style = 'original'
