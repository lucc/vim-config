" general plugins for coding
" vim: foldmethod=marker spelllang=en
let s:uname = system('uname')[:-2]
" plugins: snippets {{{1

Plugin 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger = '<C-F>'
let g:UltiSnipsJumpForwardTrigger = '<C-F>' " <C-J>
let g:UltiSnipsJumpBackwardTrigger = '<C-G>' " <C-K>
"let g:UltiSnipsExpandTrigger       = <tab>
"let g:UltiSnipsListSnippets        = <c-tab>

let g:UltiSnipsSnippetsDir = fnamemodify($MYVIMRC, ':h').'/UltiSnips'

" Snippets are separated from the engine:
Plugin 'honza/vim-snippets'
Plugin 'rbonvall/snipmate-snippets-bib'

" plugins: compilation and linting {{{1

Plug 'neomake/neomake'

if !exists('g:neomake') | let g:neomake = {} | endif
let g:neomake.verbose = 0
"let neomake.open_list = 2 " also preserve cursor position
let g:neomake.list_height = 5

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

" plugins: tags {{{1
" Easytags will automatically create and update tags files and set the 'tags'
" option per file type.  Tag navigation can be done with the CTRL-P plugin.
" All these settings are dependent on the file ~/.ctags.
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
let g:easytags_async = 1
let g:easytags_updatetime_warn = 0
let g:easytags_file = '~/.cache/tags'
"let g:easytags_by_filetype = '~/.cache/vim-easytag'
let g:easytags_ignored_filetypes = ''
let g:easytags_python_enabled = 1
if !exists('g:easytags_languages')
  let g:easytags_languages = {}
endif
let g:easytags_languages.latex = {}
let g:easytags_languages.markdown = {
      \ 'cmd': 'markdown2ctags',
      \ 'fileoutput_opt': '--file',
      \ 'stdout_opt': '--file=-',
      \ 'recurse_flag': ''
      \ }
let g:easytags_languages.pandoc = g:easytags_languages.markdown

" plugins: man and info pages {{{1
Plug 'alvan/vim-php-manual'
"Plugin 'info.vim'
Plugin 'alx741/vinfo'

" hints_man
" http://www.vim.org/scripts/script.php?script_id=1825
" http://www.vim.org/scripts/script.php?script_id=1826
"augroup LucManHints
"  autocmd!
"  autocmd FileType c,cpp set cmdheight=2
"augroup END

" plugins: vcs stuff {{{1
"Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plugin 'ludovicchabant/vim-lawrencium'
"Plugin 'mhinz/vim-signify'
"let g:sygnify_vcs_list = ['git', 'hg', 'svn']
"let g:signify_disable_by_default = 1
" use :SignifyToggle to activate
Plug 'airblade/vim-gitgutter'
"let g:gitgutter_override_sign_column_highlight = 0
Plugin 'junegunn/gv.vim'
Plugin 'gregsexton/gitv'

" debugging {{{1
Plug 'vim-vdebug/vdebug', {'on': 'VdebugStart'}
let g:vdebug_options = {
      \ 'break_on_open': 0,
      \ 'continuous_mode': 1,
      \ 'watch_window_style': 'compact',
      \ }
      ""\ 'debug_window_level': 2,
