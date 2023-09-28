nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>

" Old .vimrc
let mapleader = " "

if has('autocmd')
  filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

" Environment variables
let $RTP=split(&runtimepath, ',')[0]
let $RC="$HOME/.vim/vimrc"
let $FTP="$HOME/.vim/after/ftplugin"
let $INIT="$HOME/config/nvim/init.vim"

" Basic options
set encoding=utf-8
filetype on
set number relativenumber
set noerrorbells
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set smartcase
set nowrap
set backspace=indent,eol,start
set ruler
set matchpairs+=<:>
set fixendofline
set showcmd
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab
set foldmethod=syntax
set nofoldenable
set nohlsearch
" set foldlevel=0 " Don't fold the top-level class/module in a file
set textwidth=80
nnoremap Q gq
" Indent the whole file
nnoremap g<C-G> gg=G<C-O><C-O>
" Mouse support in normal and visual modes
set mouse=nv

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" FINDING FILES:
" Usage:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**
set path-=vendor/bundle/
set tagcase=followscs
set wildmenu
set wildchar=<Tab>
set wildmode=list:longest " default: full

" Ignore irrelevant and vendor directories
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,*/_site/*,*/vendor/*,*/_build/*,*/deps/*
" Ignore static asset files
set wildignore+=*/*.png,*/*.jpg,*/*.jpeg
set infercase
" Autocomplete remappings (saves a keystroke (^X))
inoremap ^L ^X^L

" Keep things centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" Avoid polluting the jumplist with { and }
nnoremap } :keepjumps normal! }<cr>
nnoremap { :keepjumps normal! {<cr>

" TAG JUMPING
" Create the 'tags' file
command! MakeTags  !ctags -R
command! MakeTagsExclude !ctags -R --exclude=@.ctagsignore .
" Generate tags based on git
" command! MakeTags !git ls-files | ctags -L -

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Splits open at the bottom and right
set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Ensure files are read as what I want:
augroup FiletypeGroup
  autocmd!
  autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
  autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
  autocmd BufRead,BufNewFile *.tex set filetype=tex
  autocmd BufRead,BufNewFile vimrc set filetype=vim
  autocmd BufNewFile,BufRead *.jsx set filetype=javascript,jsx
augroup END

" Highlight on yank
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup end

" Source .vimrc
command! Ref source $RC

" Move lines up and down
nnoremap <Leader>j :m .+1<CR>==
nnoremap <Leader>k :m .-2<CR>==
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Y yanks until the end of line (like D)
nnoremap Y y$

" copy into pasteboard register
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" Surround
let g:surround_45 = "<% \r %>"
let g:surround_61 = "<%= \r %>"

" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
set previewheight=16

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Vimspector Plugin
let g:vimspector_enable_mappings = "HUMAN" " Use default keybindings

" command! PackUpdate call minpac#update()
" command! PackClean  call minpac#clean()
" command! PackStatus packadd minpac | call minpac#status()

" Begin nvim init.vim

runtime! lua/me/lsp.lua
runtime! lua/me/telescope.lua
runtime! lua/me/treesitter.lua
runtime! lua/me/cmp.lua
runtime! lua/me/refactoring.lua

lua vim.lsp.set_log_level('debug')

lua require("me/lsp")
" lua require("me/lspsaga")
lua require("me/telescope")
lua require("me/treesitter")
lua require("me/cmp")
lua require("me/refactoring")

" Refactorings
" heavily influenced by Gary Bernhardt
" https://github.com/garybernhardt/dotfiles/blob/main/.vimrc
function! ExtractVariable()
  let name = input("Variable name: ")
  if name == ''
    return
  endif

  " Re-enter visual mode
  normal! gv
  " Define the variable on the line above
  exec "normal c" . name
  " Paste the original selected text to be the variable value
  exec "normal! O" . name . " = "
  normal! $p
endfunction

function! InlineVariable()
  " Copy the variable under the cursor into the 'a' register
  :let l:tmp_a = @a
  :normal "ayiw
  " Delete variable and equals sign
  :normal 2daW
  " Delete the expression into the 'b' register
  :let l:tmp_b = @b
  :normal "bd$
  " Delete the remnants of the line
  :normal dd
  " Go to the end of the previous line so we can start our search for the
  " usage of the variable to replace. Doing '0' instead of 'k$' doesn't
  " work; I'm not sure why.
  normal k$
  " Find the next occurence of the variable
  exec '/\<' . @a . '\>'
  " Replace that occurence with the text we yanked
  exec ':.s/\<' . @a . '\>/' . escape(@b, "/")
  :let @a = l:tmp_a
  :let @b = l:tmp_b
endfunction

function! ExtractFunctionElixir()
  let name = input("Function name: ")
  if name == ''
    return
  endif

  let params = input("Params: ")
  let name_and_params = name .. '(' .. params .. ')'

  normal gv
  " Yank the selected code
  normal y
  " Go to the end of the current function
  " (requires vim-indentwise)
  normal 1]_

  " Insert the def ... do ... end parts
  normal o
  exec 'normal odef' name_and_params .. ' do'
  normal oend

  " Paste the extracted code inside the function body
  " and indent it by 4 spaces
  normal O
  normal p
  exec 'normal I    '

  " Replace the extracted code with the function call
  normal gv
  exec 'normal c' . name_and_params
endfunction

function! ExtractPrivateFunctionElixir()
  let name = input("Private function name: ")
  if name == ''
    return
  endif

  let params = input("Params: ")
  let name_and_params = name .. '(' .. params .. ')'

  normal gv
  " Yank the selected code
  normal y
  " Go to the end of the current function
  " (requires vim-indentwise)
  normal 1]_

  " Insert the def ... do ... end parts
  normal o
  exec 'normal odefp' name_and_params .. ' do'
  normal oend

  " Paste the extracted code inside the function body
  " and indent it by 4 spaces
  normal O
  normal p
  exec 'normal I    '

  " Replace the extracted code with the function call
  normal gv
  exec 'normal c' . name_and_params
endfunction

function! ConvertFunctionCallToPipeline()
  " Navigate to and yank the first arg of the function call (up to the next
  " comma)
  normal 0f(l"pyt,
  " Delete the rest
  normal dW
  " Paste extracted arg
  exec "normal O\<C-R>p"
  " Insert pipeline operator
  normal jI|> 
  normal w
endfunction

function! ConvertPipelineToFunctionCall()
  " Note: must be on the line at the start of the pipeline (i.e. one line above
  " the function that will house the call)
  exec "normal 0w\"pd$dd"
  exec "normal 0f|dWf(\"ppa, "
  normal 0w
endfunction

command! InlineVariable call InlineVariable()
command! ExtractVariable call ExtractVariable()
command! ConvertFunctionCallToPipeline call ConvertFunctionCallToPipeline()
command! ConvertPipelineToFunctionCall call ConvertPipelineToFunctionCall()
command! -range ExtractFunctionElixir call ExtractFunctionElixir()
command! -range ExtractPrivateFunctionElixir call ExtractPrivateFunctionElixir()

vnoremap <leader>ref :ExtractFunctionElixir<CR>
vnoremap <leader>rep :ExtractPrivateFunctionElixir<CR>
nnoremap <leader>re> :ConvertFunctionCallToPipeline<CR>
nnoremap <leader>re< :ConvertPipelineToFunctionCall<CR>

nnoremap <leader>l; :luafile %<CR>

colorscheme gruvbox-material
