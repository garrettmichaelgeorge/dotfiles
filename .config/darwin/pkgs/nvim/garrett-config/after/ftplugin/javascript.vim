" let b:ale_linters = ['eslint']
" let b:ale_fixers = ['prettier', 'eslint']

" if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
"   let g:coc_global_extensions += ['coc-prettier']
" endif

" if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
"   let g:coc_global_extensions += ['coc-eslint']
" endif

" Regex for ES6 import and CommonJS require statements
let b:include = "^\s*(import|require)(\s+\w+)*(,\s+{.*})*"
