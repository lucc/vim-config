" general plugins for coding

" plugins: man and info pages {{{1
Plug 'alvan/vim-php-manual'
Plug 'alx741/vinfo'
"Plug 'info.vim'

" debugging {{{1
Plug 'vim-vdebug/vdebug', {'on': 'VdebugStart'}
let g:vdebug_options = {
      \ 'break_on_open': 0,
      \ 'continuous_mode': 1,
      \ 'watch_window_style': 'compact',
      \   'window_commands': {
      \     'DebuggerWatch': 'vertical belowright new',
      \     'DebuggerStack': 'belowright new +res5',
      \     'DebuggerStatus': 'belowright new +res5'
      \   },
      \ }
      ""\ 'debug_window_level': 2,
