"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
"
" tpope defaults
    source $VIMRUNTIME/defaults.vim

" Some basics:
    if &compatible
      " `:set nocp` has many side effects. Therefore this should be done
      " only when 'compatible' is set.
      set nocompatible
    endif

" Use MinPac plugin manager
    if exists('*minpac#init')
      call minpac#init()
      call minpac#add('k-takata/minpac', {'type': 'opt'})

      " Additional plugins here
      call minpac#add('tpope/vim-commentary')
      call minpac#add('tpope/vim-surround')
      call minpac#add('tpope/vim-endwise')
      call minpac#add('tpope/vim-eunuch')
      call minpac#add('tpope/vim-fugitive')
      call minpac#add('tpope/vim-repeat')
      call minpac#add('tpope/vim-tbone')
      call minpac#add('tpope/vim-rails')
      call minpac#add('tpope/vim-rake')
      call minpac#add('tpope/vim-bundler')
      call minpac#add('tpope/vim-dadbod')
      call minpac#add('tpope/vim-abolish')
      call minpac#add('gruvbox-community/gruvbox')
      call minpac#add('iamcco/coc-tailwindcss')
      call minpac#add('hail2u/vim-css3-syntax')
      call minpac#add('nathanaelkane/vim-indent-guides')
      call minpac#add('mattn/emmet-vim')
      call minpac#add('raimondi/delimitmate')
      call minpac#add('neoclide/coc.nvim')
      call minpac#add('vim-airline/vim-airline')
      call minpac#add('vim-airline/vim-airline-themes')
      call minpac#add('junegunn/fzf')
    endif

    let mapleader = " "

    if has('autocmd')
        filetype plugin indent on
    endif

    if has('syntax') && !exists('g:syntax_on')
        syntax enable
    endif

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
" Make sure last line in file has <EOL>
    set fixendofline
" Show commands at the bottom (e.g. when <Leader> is pressed)
    set showcmd
" Indentation:
    filetype plugin indent on
    set softtabstop=2
    set shiftwidth=2
    set expandtab
    set smarttab
    nnoremap g<C-G> gg=G<C-O><C-O>
" Folds:
    filetype indent on
    set foldmethod=syntax
    autocmd FileType .html :set foldmethod=indent
    set foldenable

" Wrapping text:
    set textwidth=80
    nnoremap Q gq
    " Readmes autowrap text:
        autocmd BufRead,BufNewFile *.md set tw=80

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
    set tagcase=followscs

" Display all matching files when we tab complete
    set wildmenu

" Default (complete first full match, next match, etc.):
" set wildmode=full
    set wildmode=list:longest
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,_site/*
    set infercase
" Autocomplete remappings (saves a keystroke (^X))
    inoremap ^L ^X^L

"  TAG JUMPING
" Create the 'tags' file
" (!ctags means 'execute shell command')
    command! MakeTags  !ctags -R
    command! MakeTagsExclude !ctags -R --exclude=@.ctagsignore .

" Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
    set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l

" Compile document, be it groff/LaTeX/markdown/etc.
  " map <leader>c :w! \| !compiler <c-r>%<CR><CR>

" Open corresponding .pdf/.html or preview
  " map <leader>p :!opout <c-r>%<CR><CR>

" Ensure files are read as what I want:
    let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
    autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
    autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
    autocmd BufRead,BufNewFile *.tex set filetype=tex
    autocmd BufRead,BufNewFile *.erb set filetype=html

" When shortcut files are updated, renew bash and ranger configs with new material:
    autocmd BufWritePost ~/.bm* !shortcuts

" Source .vimrc
    command! Ref source $MYVIMRC

" Navigating with guides
    inoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
    vnoremap <Space><Tab> <Esc>/<++><Enter>"_c4l
    map <Space><Tab> <Esc>/<++><Enter>"_c4l

" Move lines up and down
    nnoremap <Leader>j :m +1<CR>
    vnoremap <Leader>j :m +1<CR>
    nnoremap <Leader>k :m -2<CR>
    vnoremap <Leader>k :m -2<CR>

" Coc Plugin:
    nmap <leader>rr <Plug>(coc-rename)
    nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

 "____        _                  _
"/ ___| _ __ (_)_ __  _ __   ___| |_ ___
"\___ \| '_ \| | '_ \| '_ \ / _ \ __/ __|
 "___) | | | | | |_) | |_) |  __/ |_\__ \
"|____/|_| |_|_| .__/| .__/ \___|\__|___/
              "|_|   |_|

"""LATEX
" Word count:
    autocmd FileType tex map <leader><leader>o :w !detex \| wc -w<CR>
" Code snippets
    autocmd FileType tex inoremap ,fr \begin{frame}<Enter>\frametitle{}<Enter><Enter><++><Enter><Enter>\end{frame}<Enter><Enter><++><Esc>6kf}i
    autocmd FileType tex inoremap ,fi \begin{fitch}<Enter><Enter>\end{fitch}<Enter><Enter><++><Esc>3kA
    autocmd FileType tex inoremap ,exe \begin{exe}<Enter>\ex<Space><Enter>\end{exe}<Enter><Enter><++><Esc>3kA
    autocmd FileType tex inoremap ,em \emph{}<++><Esc>T{i
    autocmd FileType tex inoremap ,bf \textbf{}<++><Esc>T{i
    autocmd FileType tex vnoremap , <ESC>`<i\{<ESC>`>2la}<ESC>?\\{<Enter>a
    autocmd FileType tex inoremap ,it \textit{}<++><Esc>T{i
    autocmd FileType tex inoremap ,ct \textcite{}<++><Esc>T{i
    autocmd FileType tex inoremap ,cp \parencite{}<++><Esc>T{i
    autocmd FileType tex inoremap ,glos {\gll<Space><++><Space>\\<Enter><++><Space>\\<Enter>\trans{``<++>''}}<Esc>2k2bcw
    autocmd FileType tex inoremap ,x \begin{xlist}<Enter>\ex<Space><Enter>\end{xlist}<Esc>kA<Space>
    autocmd FileType tex inoremap ,ol \begin{enumerate}<Enter><Enter>\end{enumerate}<Enter><Enter><++><Esc>3kA\item<Space>
    autocmd FileType tex inoremap ,ul \begin{itemize}<Enter><Enter>\end{itemize}<Enter><Enter><++><Esc>3kA\item<Space>
    autocmd FileType tex inoremap ,li <Enter>\item<Space>
    autocmd FileType tex inoremap ,ref \ref{}<Space><++><Esc>T{i
    autocmd FileType tex inoremap ,tab \begin{tabular}<Enter><++><Enter>\end{tabular}<Enter><Enter><++><Esc>4kA{}<Esc>i
    autocmd FileType tex inoremap ,ot \begin{tableau}<Enter>\inp{<++>}<Tab>\const{<++>}<Tab><++><Enter><++><Enter>\end{tableau}<Enter><Enter><++><Esc>5kA{}<Esc>i
    autocmd FileType tex inoremap ,can \cand{}<Tab><++><Esc>T{i
    autocmd FileType tex inoremap ,con \const{}<Tab><++><Esc>T{i
    autocmd FileType tex inoremap ,v \vio{}<Tab><++><Esc>T{i
    autocmd FileType tex inoremap ,a \href{}{<++>}<Space><++><Esc>2T{i
    autocmd FileType tex inoremap ,sc \textsc{}<Space><++><Esc>T{i
    autocmd FileType tex inoremap ,chap \chapter{}<Enter><Enter><++><Esc>2kf}i
    autocmd FileType tex inoremap ,sec \section{}<Enter><Enter><++><Esc>2kf}i
    autocmd FileType tex inoremap ,ssec \subsection{}<Enter><Enter><++><Esc>2kf}i
    autocmd FileType tex inoremap ,sssec \subsubsection{}<Enter><Enter><++><Esc>2kf}i
    autocmd FileType tex inoremap ,st <Esc>F{i*<Esc>f}i
    autocmd FileType tex inoremap ,beg \begin{DELRN}<Enter><++><Enter>\end{DELRN}<Enter><Enter><++><Esc>4k0fR:MultipleCursorsFind<Space>DELRN<Enter>c
    autocmd FileType tex inoremap ,up <Esc>/usepackage<Enter>o\usepackage{}<Esc>i
    autocmd FileType tex nnoremap ,up /usepackage<Enter>o\usepackage{}<Esc>i
    autocmd FileType tex inoremap ,tt \texttt{}<Space><++><Esc>T{i
    autocmd FileType tex inoremap ,bt {\blindtext}
    autocmd FileType tex inoremap ,nu $\varnothing$
    autocmd FileType tex inoremap ,col \begin{columns}[T]<Enter>\begin{column}{.5\textwidth}<Enter><Enter>\end{column}<Enter>\begin{column}{.5\textwidth}<Enter><++><Enter>\end{column}<Enter>\end{columns}<Esc>5kA
    autocmd FileType tex inoremap ,rn (\ref{})<++><Esc>F}i

""" HTML
" Templates
    " autocmd FileType html read ~/.vim/skeletons/skel.html
    inoremap ,html <Esc>:-1read $HOME/.vim/skeletons/skel.html<CR>
" Snippets
    autocmd FileType html inoremap ,b <b></b><Space><++><Esc>FbT>i
    autocmd FileType html inoremap ,it <em></em><Space><++><Esc>FeT>i
    autocmd FileType html inoremap ,1 <h1></h1><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap ,2 <h2></h2><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap ,3 <h3></h3><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap ,p <p></p><Enter><Enter><++><Esc>02kf>a
    autocmd FileType html inoremap ,a <a<Space>href=""><++></a><Space><++><Esc>14hi
    autocmd FileType html inoremap ,e <a<Space>target="_blank"<Space>href=""><++></a><Space><++><Esc>14hi
    autocmd FileType html inoremap ,ul <ul><Enter><li></li><Enter></ul><Enter><Enter><++><Esc>03kf<i
    autocmd FileType html inoremap ,li <Esc>o<li></li><Esc>F>a
    autocmd FileType html inoremap ,ol <ol><Enter><li></li><Enter></ol><Enter><Enter><++><Esc>03kf<i
    autocmd FileType html inoremap ,im <img src="" alt="<++>"><++><esc>Fcf"a
    autocmd FileType html inoremap ,td <td></td><++><Esc>Fdcit
    autocmd FileType html inoremap ,tr <tr></tr><Enter><++><Esc>kf<i
    autocmd FileType html inoremap ,th <th></th><++><Esc>Fhcit
    autocmd FileType html inoremap ,tab <table><Enter></table><Esc>O
    autocmd FileType html inoremap ,dt <dt></dt><Enter><dd><++></dd><Enter><++><esc>2kcit
    autocmd FileType html inoremap ,dl <dl><Enter><Enter></dl><enter><enter><++><esc>3kcc
    autocmd FileType html inoremap ,div <div></div><Enter><Enter><++><Esc>2kf<i
    autocmd FileType html inoremap &<space> &amp;<space>
    autocmd FileType html inoremap á &aacute;
    autocmd FileType html inoremap é &eacute;
    autocmd FileType html inoremap í &iacute;
    autocmd FileType html inoremap ó &oacute;
    autocmd FileType html inoremap ú &uacute;
    autocmd FileType html inoremap ä &auml;
    autocmd FileType html inoremap ë &euml;
    autocmd FileType html inoremap ï &iuml;
    autocmd FileType html inoremap ö &ouml;
    autocmd FileType html inoremap ü &uuml;
    autocmd FileType html inoremap ã &atilde;
    autocmd FileType html inoremap ẽ &etilde;
    autocmd FileType html inoremap ĩ &itilde;
    autocmd FileType html inoremap õ &otilde;
    autocmd FileType html inoremap ũ &utilde;
    autocmd FileType html inoremap ñ &ntilde;
    autocmd FileType html inoremap à &agrave;
    autocmd FileType html inoremap è &egrave;
    autocmd FileType html inoremap ì &igrave;
    autocmd FileType html inoremap ò &ograve;
    autocmd FileType html inoremap ù &ugrave;
    autocmd FileType html inoremap ,cl <Esc>F<ea class=""<Esc>i

" MARKDOWN
    autocmd Filetype markdown,rmd set colorcolumn=+1
    autocmd Filetype markdown,rmd map <leader>w yiWi[<esc>Ea](<esc>pa)
    autocmd Filetype markdown,rmd inoremap ,n ---<Enter><Enter>
    autocmd Filetype markdown,rmd inoremap ,b ****<++><Esc>F*hi
    autocmd Filetype markdown,rmd inoremap ,s ~~~~<++><Esc>F~hi
    autocmd Filetype markdown,rmd inoremap ,e **<++><Esc>F*i
    autocmd Filetype markdown,rmd inoremap ,h ====<Space><++><Esc>F=hi
    autocmd Filetype markdown,rmd inoremap ,i ![](<++>)<++><Esc>F[a
    autocmd Filetype markdown,rmd inoremap ,a [](<++>)<++><Esc>F[a
    autocmd Filetype markdown,rmd inoremap ,1 #<Space><Enter><++><Esc>kA
    autocmd Filetype markdown,rmd inoremap ,2 ##<Space><Enter><++><Esc>kA
    autocmd Filetype markdown,rmd inoremap ,3 ###<Space><Enter><++><Esc>kA
    autocmd Filetype markdown,rmd inoremap ,l --------<Enter>
    autocmd Filetype rmd inoremap ,r ```{r}<CR>```<CR><CR><esc>2kO
    autocmd Filetype rmd inoremap ,p ```{python}<CR>```<CR><CR><esc>2kO
    autocmd Filetype rmd inoremap ,c ```<cr>```<cr><cr><esc>2kO

" NERDTree Plugin:
" Toggle NERDTree using <Leader>f
    nnoremap <Leader>f :NERDTreeToggle<Enter>

" CTRL-P Plugin:
    let g:ctrlp_custom_ignore = {
      \ 'dir': '/**\/node_modules/', }

" Syntax highlighting colors
    colorscheme gruvbox
    let g:gruvbox_italic='1'
    let g:gruvbox_contrast_dark = 'hard'
    set background=dark
    if exists('+termguicolors')
        let &t_ZH="\e[3m"
        let &t_ZR="\e[23m"
    endif
    let g:gruvbox_invert_selection='0'
    highlight Comment cterm=italic gui=italic
    highlight ColorColumn guibg=darkgray

" Built-in terminal display (Vim 8.0+)
    set termguicolors
    set termwinsize="20x0"

" Airline Plugin:
    let g:airline_theme='base16_gruvbox_dark_hard'

" Minpac commands - use these to update packages
    command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
    command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
    command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

" REFERENCE
" Autocomplete:
    " see |ins-completion|

" Example .vimrcs
    " https://github.com/amix/vimrc
    " https://github.com/LukeSmithxyz/voidrice/blob/master/.config/nvim/init.vim
    " https://github.com/tpope/tpope/blob/master/.vimrc
