" general plugins for coding
" vim: foldmethod=marker spelllang=en
let s:uname = system('uname')[:-2]
" plugins: snippets {{{1

if has('python')
  if s:uname != 'Linux' || has('nvim')
    Plugin 'SirVer/ultisnips'
  endif
  let g:UltiSnipsExpandTrigger = '<C-F>'
  let g:UltiSnipsJumpForwardTrigger = '<C-F>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-G>'
  "let g:UltiSnipsExpandTrigger       = <tab>
  "let g:UltiSnipsListSnippets        = <c-tab>
  "let g:UltiSnipsJumpForwardTrigger  = <c-j>
  "let g:UltiSnipsJumpBackwardTrigger = <c-k>
  let g:UltiSnipsJumpBackwardTrigger = '<SID>NOT_DEFINED'

  if has('gui_running') && has('gui_macvim')
    " new settings
    let g:UltiSnipsExpandTrigger = '<A-Tab>'
    let g:UltiSnipsJumpForwardTrigger = '<A-Tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<A-S-Tab>'
    let g:UltiSnipsListSnippets = '<SID>NOT_DEFINED'
  endif
  let g:UltiSnipsSnippetsDir = luc#xdg#config.'/UltiSnips'
else
  " snipmate and dependencies
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'garbas/vim-snipmate'
  imap <C-F> <Plug>snipMateNextOrTrigger
  smap <C-F> <Plug>snipMateNextOrTrigger
endif

" Snippets are separated from the engine:
if s:uname != 'Linux' || has('nvim')
  Plugin 'honza/vim-snippets'
  Plugin 'rbonvall/snipmate-snippets-bib'
endif

" plugins: syntastic {{{1
if s:uname != 'Linux' || has('nvim')
  Plugin 'scrooloose/syntastic'
endif
let g:syntastic_mode_map = {
      \ 'mode': 'passive',
      \ 'active_filetypes': [],
      \ 'passive_filetypes': []
      \ }
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5

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
let g:easytags_languages.markdown = {}

" plugins: man pages {{{1
"Plugin 'info.vim'

"Plugin 'ManPageView' "{{{2
" TODO
" http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz
" manually installed: open above url and execute :UseVimaball
" display manpages in a vertical split (other options 'only', 'hsplit',
" 'vsplit', 'hsplit=', 'vsplit=', 'reuse')
let g:manpageview_winopen = 'reuse'

" hints_man {{{2
" http://www.vim.org/scripts/script.php?script_id=1825
" http://www.vim.org/scripts/script.php?script_id=1826
"augroup LucManHints
"  autocmd!
"  autocmd FileType c,cpp set cmdheight=2
"augroup END

" plugins: compiling {{{1
Plugin 'tpope/vim-dispatch'

Plugin 'xuhdev/SingleCompile'
let g:SingleCompile_asyncrunmode = 'python'
let g:SingleCompile_menumode = 0

" plugins: vcs stuff {{{1
"Plugin 'tpope/vim-git'
if s:uname != 'Linux' || has('nvim')
  Plugin 'tpope/vim-fugitive'
endif
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'mhinz/vim-signify'
"let g:signify_disable_by_default = 1
" use :SignifyToggle to activate
