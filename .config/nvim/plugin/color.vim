if (!exists('g:vscode'))
  set background=dark

  " checks if your terminal has 24-bit color support
  if (has("termguicolors"))
    set termguicolors
    hi LineNr ctermbg=NONE guibg=NONE
  endif

  highlight ColorColumn guibg=darkgray

  " Handle background colors being set by terminal
  let &t_ut=''

  " Adding color to LSP
  " highlight LspDiagnosticsDefaultError guifg='BrightRed'
  " highlight LspDiagnosticsDefaultInformation guifg='DarkCyan'
  " highlight LspDiagnosticsDefaultHint guifg='Green'
  " highlight LspDiagnosticsDefaultWarning guifg='Orange'

  " gruvbox
  let g:gruvbox_italic='1'
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_invert_selection='1'

  " gruvbox-material
  let g:gruvbox_material_palette = 'material' " 'material', 'mix', 'original'
  let g:gruvbox_material_background = 'hard'
  let g:gruvbox_material_enable_italic = 1
  let g:gruvbox_material_disable_italic_comment = 0
  let g:gruvbox_material_enable_bold = 0
  let g:gruvbox_material_diagnostic_text_highlight = 1
  let g:gruvbox_material_diagnostic_virtual_text = 'colored'
  let g:gruvbox_material_better_performance = 1

  nnoremap <leader>mm :lua require('material.functions').toggle_style()<CR>

  colorscheme gruvbox-material
endif
