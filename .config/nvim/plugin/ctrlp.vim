" Make sure CtrlP reads wildignore correctly
" https://stackoverflow.com/a/23015387/12344822
if exists("g:ctrlp_user_command")
  unlet g:ctrlp_user_command
endif

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_mruf_relative = 1

" Use <F2> to toggle whether MRU limits results to files within the current
" working directory
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F2>'] }
let g:ctrlp_working_path_mode = 'rwa'
