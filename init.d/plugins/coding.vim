" general plugins for coding
" vim: foldmethod=marker spelllang=en

" plugins: snippets {{{1
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = '<C-F>'
let g:UltiSnipsJumpForwardTrigger = '<C-F>' " <C-J>
let g:UltiSnipsJumpBackwardTrigger = '<C-G>' " <C-K>
"let g:UltiSnipsExpandTrigger       = <tab>
let g:UltiSnipsListSnippets        = '<C-L>'

" Snippets are separated from the engine:
Plug 'honza/vim-snippets'
Plug 'rbonvall/snipmate-snippets-bib'

" plugins: compilation and linting {{{1

Plug 'neomake/neomake'

if !exists('g:neomake') | let g:neomake = {} | endif
let g:neomake_verbose = 1
"let neomake.open_list = 2 " also preserve cursor position
let g:neomake_list_height = 5

"let g:neomake_php_enabled_makers = ['php', 'phpcs', 'phpmd']
let g:neomake_tex_enabled_makers = ['chktex', 'lacheck', 'rubberinfo', 'proselint', 'latexrun']
let g:neomake_bib_enabled_makers = ['bibtex']
let g:neomake_nvimluatest_maker = {
      \ 'exe': 'sh',
      \ 'args': ['-c', 'make functionaltest TEST_FILE=%:p 2>/dev/null | ~/.config/vim/bin/error-filter-for-nvim-lua-tests.sh'],
      \ 'errorformat': '%f:%l: Expected objects to be the same.',
      \ }
let g:neomake_luctest_maker = {
      \ 'exe': 'make',
      \ 'args': ['functionaltest', 'TEST_FILE=%:p'],
      \ 'errorformat': '%f:%l: Expected objects to be the same.',
      \ }
" A maker to build a pdf file from a tex file if a makefile is afailable.
let g:neomake_tex_make_maker = {
      \ 'exe': { -> filereadable(getcwd() . '/makefile') ? 'make' : '' },
      \ 'args': { -> [expand('%:p:t:r') . '.pdf'] },
      \ }

Plug 'janko/vim-test'
let test#strategy='dispatch_background'

Plug 'tpope/vim-dispatch'
let g:dispatch_no_maps = 1
let g:dispatch_no_tmux_make = 1

" plugins: man and info pages {{{1
Plug 'alvan/vim-php-manual'
Plug 'alx741/vinfo'
"Plug 'info.vim'

" plugins: vcs stuff {{{1
"Plugin 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'  " faster than gitv?  :GV
Plug 'gregsexton/gitv'  " gitk for vim       :Gitv

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
