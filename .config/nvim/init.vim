set runtimepath^=~/.vim
let &packpath = &runtimepath
source ~/.vim/vimrc

nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>

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
