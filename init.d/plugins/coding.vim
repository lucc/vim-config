" general plugins for coding
" vim: foldmethod=marker spelllang=en
let s:uname = system('uname')[:-2]
" plugins: snippets {{{1

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = '<C-F>'
let g:UltiSnipsJumpForwardTrigger = '<C-F>' " <C-J>
let g:UltiSnipsJumpBackwardTrigger = '<C-G>' " <C-K>
"let g:UltiSnipsExpandTrigger       = <tab>
"let g:UltiSnipsListSnippets        = <c-tab>

let g:UltiSnipsSnippetsDir = fnamemodify($MYVIMRC, ':h').'/UltiSnips'

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
let g:neomake_latex_enabled_makers = ['chktex', 'lacheck', 'rubberinfo', 'proselint', 'latexrun']
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

" plugins: man and info pages {{{1
Plug 'alvan/vim-php-manual'
"Plugin 'info.vim'
Plug 'alx741/vinfo'

" hints_man
" http://www.vim.org/scripts/script.php?script_id=1825
" http://www.vim.org/scripts/script.php?script_id=1826
"augroup LucManHints
"  autocmd!
"  autocmd FileType c,cpp set cmdheight=2
"augroup END

" plugins: vcs stuff {{{1
"Plugin 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'ludovicchabant/vim-lawrencium'
"Plugin 'mhinz/vim-signify'
"let g:sygnify_vcs_list = ['git', 'hg', 'svn']
"let g:signify_disable_by_default = 1
" use :SignifyToggle to activate
Plug 'airblade/vim-gitgutter'
"let g:gitgutter_override_sign_column_highlight = 0
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
