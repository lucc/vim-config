" vimrc file by luc {{{1
" vi: set foldmethod=marker spelllang=en:

" start (things to do first) {{{1

" don't be vi compatible, this has to be first b/c it changes other options
set nocompatible

" Don't load menus.  This has to happen before 'syntax on' and 'filetype ...'
set guioptions+=M
set guioptions-=m
set guiheadroom=0

" fix the runtimepath to conform to XDG a little bit
set runtimepath+=~/.config/vim
call luc#xdg#runtimepath()
let $MYGVIMRC = substitute($MYVIMRC, 'vimrc$', 'gvimrc', '')
let $GVIMINIT = 'source $MYGVIMRC'

" set up python {{{1
if has('nvim')
  "runtime! python_setup.vim
  python import vim
  pyfile ~/.config/vim/vimrc.py
elseif has('python')
  python import vim
  "python if vim.VIM_SPECIAL_PATH not in sys.path: sys.path.append(vim.VIM_SPECIAL_PATH)
  pyfile ~/.config/vim/vimrc.py
endif

" syntax and filetype {{{1
syntax enable
filetype plugin indent on

" user defined variables {{{1
let s:uname = system('uname')[:-2]
let mapleader = ','

" functions {{{1

function! s:viminfo_setup(server) "{{{2
  if a:server
    " options: viminfo
    " default: '100,<50,s10,h
    set viminfo='100,<50,s10,h,%
    let &viminfo .= ',n' . luc#xdg#cache . '/viminfo'
    " the flag ' is for filenames for marks
    " the flag < is the nummber of lines saved per register
    " the flag s is the max size saved for registers in kb
    " the flag h is to disable hlsearch
    " the flag % is to remember (whole) buffer list
    " the flag n is the name of the viminfo file
    " load a static viminfo file with a file list
    rviminfo ~/.config/vim/default-buffer-list.viminfo
    " set up an argument list to prevent the empty buffer at start up
    "if argc() == 0
    "  execute 'args' bufname(2)
    "endif
  else
    " if we are not running as the server do not use the viminfo file.  We
    " probably only want to edit one file quickly from the command line.
    set viminfo=
  endif
endfunction

" setup for server vim {{{1
call s:viminfo_setup(!luc#server#running())

" user defined autocommands {{{1

augroup LucRemoveWhiteSpaceAtEOL "{{{2
  autocmd!
  autocmd BufWrite *
	\ let s:position = getpos('.')          |
	\ silent keepjumps %substitute/\s\+$//e |
	\ call setpos('.', s:position)          |
augroup END

" user defined commands and mappings {{{1

" editing {{{2

" Don't use Ex mode, use Q for formatting (from the example file)
nnoremap Q gq

" make Y behave like D,S,C ...
nnoremap Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" easy spell checking
inoremap <C-s> <C-o>:call luc#find_next_spell_error()<CR><C-x><C-s>
nnoremap <C-s>      :call luc#find_next_spell_error()<CR>z=
nnoremap <leader>s  :call luc#find_next_spell_error()<CR>zv

" capitalize text
vmap gc  "=luc#capitalize(luc#get_visual_selection())<CR>p
nmap gc  :set operatorfunc=luc#capitalize_operator_function<CR>g@
nmap gcc gciw

" prefix lines with &commentstring
vmap <leader>p :call luc#prefix(visualmode())<CR>
nmap <leader>p :set operatorfunc=luc#prefix<CR>g@

" bla
if has('gui_macvim')
  inoremap œ \
  inoremap æ \|
  cnoremap œ \
  cnoremap æ \|
  inoremap <D-s> <C-O>:silent update<CR>
  noremap  <D-s>      :silent update<CR>
endif

" interactive fix for latex quotes in English files
command! UnsetLaTeXQuotes unlet g:Tex_SmartQuoteOpen g:Tex_SmartQuoteClose

" open URLs {{{2
python import strings
python import webbrowser
nmap <Leader>w :python for url in strings.urls(vim.current.line):
      \ webbrowser.open(url)<CR>

" easy compilation {{{2
nmap <silent> <F2>        :call luc#save_and_compile()<CR>
imap <silent> <F2>   <C-O>:call luc#save_and_compile()<CR>

" backup current buffer
nnoremap <silent> <F11>
      \ :silent update <BAR>
      \ call pyeval('backup_current_buffer() or 1') <BAR>
      \ redraw <CR>

" moveing around {{{2
nmap <C-Tab>        gt
imap <C-Tab>   <C-O>gt
nmap <C-S-Tab>      gT
imap <C-S-Tab> <C-O>gT

nmap <C-W><C-F> <C-W>f<C-W>L

nmap <SwipeUp>   gg
imap <SwipeUp>   gg
nmap <SwipeDown> G
imap <SwipeDown> G

nnoremap ' `
nnoremap ` '

" misc {{{2

" use ß to clear the screen if you want privacy for a moment
nmap ß :!clear<CR>

" https://github.com/javyliu/javy_vimrc/blob/master/_vimrc
"vmap // :<C-U>execute 'normal /' . luc#get_visual_selection()<CR>
vmap // y/<C-r>"<CR>

command! -nargs=1 -complete=customlist,luc#man#complete_topics
      \ ManLuc TMan <args>.man

" options: basic {{{1

" allow backspacing over everything in insert mode
set autoindent
set backspace=indent,eol,start
set backup
execute 'set backupdir=' . luc#xdg#cache . '/backup'
"let &backupskip .= ',' . expand('$HOME') . '/.*/**/secure/*'
set hidden
set history=2000
set confirm
set textwidth=78
set shiftwidth=2
set number
" scroll when the courser is 2 lines from the border line
set scrolloff=2
set shortmess=
set nostartofline
set encoding=utf-8
set switchbuf=useopen
set colorcolumn=+1
set mouse=a
set showcmd
set splitright
set virtualedit=block
set diffopt=filler,vertical
" default: blank,buffers,curdir,folds,help,options,tabpages,winsize
set sessionoptions+=resize,winpos
" use /bin/sh as shell to have a shell with a simple prompt TODO fix zsh
" prompt
set shell=/bin/sh
" save the swap files in a xdg dir
execute 'set directory=' . luc#xdg#cache . '/swap'
set directory+=~/tmp
set directory+=/tmp

" options: cpoptions {{{1
set cpoptions+=$ " don't redraw the display while executing c, s, ... cmomands
set cpoptions+={ " let { and } stop on a "{" in the first column

" options: dictionary and complete {{{1

set complete+=k

" use the current spell checking settings for directory completion:
set dictionary+=spell
" add private directories:
set dictionary+=~/.config/vim/dictionary/*
" system word lists
set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/british-english
set dictionary+=/usr/share/dict/ngerman

" options: terminal stuff {{{1
"if $TERM_PROGRAM == 'iTerm.app'
if !has('gui_running')
  set t_Co=256
endif

" options: searching {{{1
set ignorecase
set smartcase
" highlight the last used search pattern.
set hlsearch
" incremental search
set incsearch

" options: spellchecking {{{1

" on Mac OS X the spellchecking files are in:
" MacVim.app/Contents/Resources/vim/runtime/spell
set spelllang=de,en
if &spellfile == ''
  set spellfile+=~/.config/vim/spell/de.utf-8.add
  set spellfile+=~/.config/vim/spell/en.utf-8.add
  set spellfile+=~/.config/vim/spell/names.utf-8.add
endif
set nospell

" options: folding {{{1

set foldmethod=syntax
" fold code by indent
"set foldmethod=indent
" but open all (20) folds on startup
"set foldlevelstart=20
" enable folding for functions, heredocs and if-then-else stuff in sh files.
let g:sh_fold_enabled=7

" options: path {{{1
" set the path for file searching
set path=.,,./**,.;,~/
set path+=/usr/include/
set path+=/usr/local/include/
set path+=/usr/lib/wx/include/
set path+=/usr/X11/include/
set path+=/opt/X11/include/

" options: formatoptions {{{1
" formatoptions default is tcq
set formatoptions+=n " recognize numbered lists
set formatoptions+=r " insert comment leader when hitting <enter>
set formatoptions+=j " remove comment leader when joining lines
set formatoptions+=l " do not break lines which are already long

" options: tabline {{{1
" we could do something similar for tabs.
" see :help 'tabline'
"set tabline=Tabs:
"set tabline+=\ %{tabpagenr('$')}
"set tabline+=\ Buffers:
"set tabline+=\ %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))}
"set tabline+=%=%{strftime('%a\ %F\ %R')}

" options: wildmenu and wildignore {{{1
set wildmenu
set wildmode=longest:full,full

" version control {{{2
set wildignore+=.git
set wildignore+=.hg
set wildignore+=.svn
"set wildignore+=*.orig " Merge resolution files

" latex intermediate files {{{2
set wildignore+=*.aux
set wildignore+=*.fdb_latexmk
set wildignore+=*.fls
set wildignore+=*.idx
set wildignore+=*.out
set wildignore+=*.toc

" binary documents and office documents {{{2
set wildignore+=*.djvu
set wildignore+=*.doc   " Microsoft Word
set wildignore+=*.docx  " Microsoft Word
set wildignore+=*.dvi
set wildignore+=*.ods   " Open Document spreadsheet
set wildignore+=*.odt   " Open Document spreadsheet template
set wildignore+=*.pdf
set wildignore+=*.ps
set wildignore+=*.xls   " Microsoft Excel
set wildignore+=*.xlsx  " Microsoft Excel

" binary images {{{2
set wildignore+=*.bmp
set wildignore+=*.gif
set wildignore+=*.jpeg
set wildignore+=*.jpg
set wildignore+=*.png

" music {{{2
set wildignore+=*.mp3
set wildignore+=*.flac

" special vim files {{{2
set wildignore+=.*.sw? " Vim swap files
set wildignore+=*.spl  " compiled spell word lists

" OS specific files {{{2
set wildignore+=.DS_Store

" compiled and binary files {{{2
set wildignore+=*.class " java
set wildignore+=*.dll   " windows libraries
set wildignore+=*.exe   " windows executeables
set wildignore+=*.o     " object files
set wildignore+=*.obj   " ?
set wildignore+=*.pyc   " Python byte code
set wildignore+=*.luac  " Lua byte code

" unsuported archives and images {{{2
set wildignore+=*.dmg
set wildignore+=*.iso
set wildignore+=*.tar
set wildignore+=*.tar.bz2
set wildignore+=*.tar.gz
set wildignore+=*.tbz2
set wildignore+=*.tgz

" setting variables for special settings {{{1
"let g:vimsyn_folding  = 'a' " augroups
"let g:vimsyn_folding .= 'f' " fold functions
"let g:vimsyn_folding .= 'm' " fold mzscheme script
"let g:vimsyn_folding .= 'p' " fold perl     script
"let g:vimsyn_folding .= 'P' " fold python   script
"let g:vimsyn_folding .= 'r' " fold ruby     script
"let g:vimsyn_folding .= 't' " fold tcl      script

" plugins: management with vundle {{{1
" https://github.com/gmarik/Vundle.vim
filetype off
let s:bundle_path = expand(luc#xdg#data . '/bundle')
execute 'set runtimepath+=' . s:bundle_path . '/Vundle.vim'
call vundle#begin(s:bundle_path)
Plugin 'gmarik/Vundle.vim'

" plugins: buffer and file management {{{1
if s:uname != 'Linux' || has('nvim')
  Plugin 'kien/ctrlp.vim'
endif

" cache {{{2
"let g:ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0

" ignore/include/exclude patterns {{{2
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v(\/private|\/var|\/tmp|\/Users\/luc\/(audio|img|flac))',
      \ }
let g:ctrlp_root_markers = [
      \ 'makefile',
      \ 'Makefile',
      \ ]
"      \ 'latexmkrc',

" extensions {{{2
let g:ctrlp_extensions = [
      \ 'tag',
      \ 'quickfix',
      \ 'undo',
      \ 'changes',
      \]
      "\ 'dir',
      "\ 'buffertag',
      "\ 'line',
      "\ 'rtscript',
      "\ 'mixed',
      "\ 'bookmarkdir',

" mappings {{{2
let g:ctrlp_cmd = 'CtrlPMRU'
if has('gui_running')
  let g:ctrlp_map = '<C-Space>'
else
  " In the terminal <c-space> doesn't work but sadly <F1> is also mapped by
  " latex-suite so we have to overwrite that.
  let g:ctrlp_map = '<F1>'
  augroup LucCtrlP
    autocmd!
    autocmd BufEnter,WinEnter *
	  \ execute 'nnoremap' g:ctrlp_map      ':' g:ctrlp_cmd '<CR>'
    autocmd BufEnter,WinEnter *
	  \ execute 'inoremap' g:ctrlp_map '<C-O>:' g:ctrlp_cmd '<CR>'
  augroup END
endif
execute 'inoremap' g:ctrlp_map '<C-O>:' g:ctrlp_cmd '<CR>'
if has('gui_macvim')
  execute 'nnoremap' '<D-B>' ':CtrlPBuffer<CR>'
  execute 'inoremap' '<D-B>' ':CtrlPBuffer<CR>'
  execute 'nnoremap' '<D-F>' ':CtrlP<CR>'
  execute 'inoremap' '<D-F>' ':CtrlP<CR>'
  execute 'nnoremap' '<D-T>' ':CtrlPTag<CR>'
  execute 'inoremap' '<D-T>' ':CtrlPTag<CR>'
endif

" Use the compiled C-version for speed improvements "{{{2
"if has('python')
"  Plugin 'JazzCore/ctrlp-cmatcher'
"  let g:ctrlp_match_func = {'match' : 'matcher#cmatch'}
"endif

" plugins: completion {{{1
if has('python') " -> Youcompleteme {{{2
  Plugin 'Valloric/YouCompleteMe'
  let g:ycm_filetype_blacklist = {}
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_completion = 0

  Plugin 'bjoernd/vim-ycm-tex',
	\ {'name': 'YouCompleteMe/python/ycm/completers/tex'}
  let g:ycm_semantic_triggers = {'tex': ['\ref{','\cite{']}

  "Plugin 'c9s/vimomni.vim'
  "Plugin 'tek/vim-ycm-vim'

else             " -> neocomplete and neocomplcache {{{2
  " settings which are uniform for both neocomplete and neocomplcache
  "Plugin 'Shougo/vimproc' "only needed if not loaded elsewhere
  Plugin 'Shougo/context_filetype.vim'
  "Plugin 'Shougo/neosnippet'

  " Enable omni completion for both versions
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " <TAB> completion.
  inoremap <expr> <TAB>    pumvisible() ? '<C-n>' : '<TAB>'
  inoremap <expr> <S-TAB>  pumvisible() ? '<C-n>' : '<S-TAB>'

  if has('lua') " -> neocomplete {{{3
    Plugin 'Shougo/neocomplete.vim'
    let g:neocomplete#enable_at_startup = 1 " necessary
    let g:neocomplete#enable_refresh_always = 1 " heavy
    " what is this?
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '\h\w*'
    if !exists('g:neocomplete#same_filetypes')
      let g:neocomplete#same_filetypes = {}
    endif
    " In c buffers, completes from cpp and d buffers.
    let g:neocomplete#same_filetypes.c = 'cpp,d'
    " In cpp buffers, completes from c buffers.
    let g:neocomplete#same_filetypes.cpp = 'c'
    " In gitconfig buffers, completes from all buffers.
    let g:neocomplete#same_filetypes.gitconfig = '_'
    " In default, completes from all buffers.
    let g:neocomplete#same_filetypes._ = '_'

  else          " -> neocomplcache {{{3
    Plugin 'Shougo/neocomplcache.vim'
    let g:neocomplcache_enable_at_startup = 1 " necessary
    let g:neocomplcache_enable_refresh_always = 1 " heavy
    let g:neocomplcache_enable_fuzzy_completion = 1 " heavy
    let g:neocomplcache_temporary_dir = expand('~/.cache/neocomplcache')
    " what is this?
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    if !exists('g:neocompcache_same_filetypes')
      let g:neocomplcache_same_filetypes = {}
    endif
    " mappings from which additional filetypes to fetch completions; '_' means
    " 'all' or 'default'
    let g:neocomplcache_same_filetypes.c         = 'cpp,d'
    let g:neocomplcache_same_filetypes.cpp       = 'c'
    let g:neocomplcache_same_filetypes.gitconfig = '_'
    let g:neocomplcache_same_filetypes._         = '_'

  "  " Define dictionary.
  "  let g:neocomplcache_dictionary_filetype_lists = {
  "      \ 'default' : '',
  "      \ 'vimshell' : $HOME.'/.vimshell_hist',
  "      \ 'scheme' : $HOME.'/.gosh_completions'
  "	  \ }
  "
  "  " Define keyword.
  "  if !exists('g:neocomplcache_keyword_patterns')
  "      let g:neocomplcache_keyword_patterns = {}
  "  endif
  "  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
  "
  "  " Plugin key-mappings.
  "  inoremap <expr><C-g>     neocomplcache#undo_completion()
  "  inoremap <expr><C-l>     neocomplcache#complete_common_string()
  "
  "  " Recommended key-mappings.
  "  " <CR>: close popup and save indent.
  "  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  "  function! s:my_cr_function()
  "    return neocomplcache#smart_close_popup() . "\<CR>"
  "    " For no inserting <CR> key.
  "    "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
  "  endfunction
  "  " <C-h>, <BS>: close popup and delete backword char.
  "  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  "  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  "  inoremap <expr><C-y>  neocomplcache#close_popup()
  "  inoremap <expr><C-e>  neocomplcache#cancel_popup()
  "  " Close popup by <Space>.
  "  inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() :
  "        \ "\<Space>"
  "
  "  " For cursor moving in insert mode(Not recommended)
  "  "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
  "  "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
  "  "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
  "  "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
  "  " Or set this.
  "  "let g:neocomplcache_enable_cursor_hold_i = 1
  "  " Or set this.
  "  "let g:neocomplcache_enable_insert_char_pre = 1
  "
  "  " AutoComplPop like behavior.
  "  "let g:neocomplcache_enable_auto_select = 1
  "
  "  " Shell like behavior(not recommended).
  "  "set completeopt+=longest
  "  "let g:neocomplcache_enable_auto_select = 1
  "  "let g:neocomplcache_disable_auto_complete = 1
  "  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
  "
  "  " Enable heavy omni completion.
  "  if !exists('g:neocomplcache_omni_patterns')
  "    let g:neocomplcache_omni_patterns = {}
  "  endif
  "  if !exists('g:neocomplcache_force_omni_patterns')
  "    let g:neocomplcache_force_omni_patterns = {}
  "  endif
  "  let g:neocomplcache_omni_patterns.php =
  "  \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  "  let g:neocomplcache_omni_patterns.c =
  "  \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
  "  let g:neocomplcache_omni_patterns.cpp =
  "  \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  "
  "  " For perlomni.vim setting.
  "  " https://github.com/c9s/perlomni.vim
  "  let g:neocomplcache_omni_patterns.perl =
  "  \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  endif
endif

" plugins: snippets {{{1

if has('python')
  if s:uname != 'Linux' || has('nvim')
    Plugin 'SirVer/ultisnips'
  endif
  let g:UltiSnipsExpandTrigger = '<C-F>'
  let g:UltiSnipsJumpForwardTrigger = '<C-F>'
  "let g:UltiSnipsJumpBackwardTrigger = '<C-Tab>'
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

" plugins: languages {{{1

Plugin 'applescript.vim'

" plugins: LaTeX {{{2

" original vim settings for latex
"let g:tex_fold_enabled = 1
let g:tex_flavor = 'latex'

" 3109 LatexBox.vmb
"Plugin 'coot/atp_vim'
"Plugin 'LaTeX-functions'
"Plugin 'latextags'
"Plugin 'TeX-9'
"Plugin 'tex.vim'
"Plugin 'tex_autoclose.vim'

"Plugin 'auctex.vim'

if s:uname != 'Linux' || has('nvim')
  Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex' "{{{3
endif
"Plugin 'LaTeX-Help' " is included in vim-latex
let g:ngerman_package_file = 1
let g:Tex_Menus = 0
"let g:Tex_UseUtfMenus = 1

" The other settings for vim-latex are in the LucLatexSuiteSettings
" autocmdgroup.
if has('mac') | let g:Tex_ViewRule_pdf = 'open -a Preview' | endif
let g:Tex_UseMakefile = 1
let g:Tex_CompileRule_pdf = 'latexmk -silent -pv -pdf $*'
let g:Tex_SmartQuoteOpen = '„'
let g:Tex_SmartQuoteClose = '“'
" the variable Tex_FoldedEnvironments holds the beginnings of names of
" environments which should be folded.  The innermost environments should come
" first.
let s:TexFoldEnv = [ 'verbatim',
	           \ 'comment',
	           \ 'eq',
	           \ 'gather',
	           \ 'align',
	           \ 'figure',
	           \ 'table',
		   \ 'luc',
		   \ 'dogma',
	           \ ]
" environments for structure of mathematical texts (they can contain other
" stuff)
call extend(s:TexFoldEnv, [ 'th',
			  \ 'satz',
			  \ 'def',
			  \ 'lem',
			  \ 'rem',
			  \ 'bem',
			  \ 'proof',
			  \ ])
" quotes can contain other stuff
call extend(s:TexFoldEnv, ['quot',])
" the beamer class has two top level environments
call extend(s:TexFoldEnv, [ 'block',
			  \ 'frame',
			  \])
" environments for the general document
call extend(s:TexFoldEnv, [ 'thebibliography',
			  \ 'keywords',
			  \ 'abstract',
			  \ 'titlepage',
			  \ ])
let g:Tex_FoldedEnvironments = join(s:TexFoldEnv, ',')
let s:TexFoldSec = [
      \ 'part',
      \ 'chapter',
      \ 'section',
      \ 'subsection',
      \ 'subsubsection',
      \ 'paragraph',
      \ 'subparagraph',
      \ ]
let g:Tex_FoldedSections = join(s:TexFoldSec, ',')
" alternative 1
  "let s:TexFoldEnv = ['*', 'document', 'minipage', 'di', 'lem', 'ivt', 'dc',
  "      \ 'verbatim', 'comment', 'proof', 'eq', 'gather', 'align', 'figure',
  "      \ 'table', 'thebibliography', 'keywords', 'abstract', 'titlepage'
  "      \ 'item', 'enum', 'display' ]
  "let g:Tex_FoldedMisc = 'comments,item,preamble,<<<'
" alternative 2
  " let g:Tex_FoldedMisc = 'comments,item,preamble,<<<,slide'
" alternative 3
  "let Tex_FoldedEnvironments .= '*'
  "let Tex_FoldedSections =
  "\ 'part,chapter,section,subsection,subsubsection,paragraph'

" plugins: lisp/scheme {{{2
Plugin 'slimv.vim'
"Plugin 'tslime.vim'
Plugin 'davidmfoley/tslime.vim'
Plugin 'Limp'

" plugins: markdown {{{2
" unconditionally binds <Leader>f and <Leader>r (also in insert mode=bad for
" latex)
"Plugin 'vim-pandoc/vim-markdownfootnotes'

" strange folding
"Plugin 'plasticboy/vim-markdown'
"Plugin   'hallison/vim-markdown'

" good folding uses expr
Plugin 'nelstrom/vim-markdown-folding'
let g:markdown_fold_style = 'nested'

" strange folding?
"Plugin 'tpope/vim-markdown'

"Plugin 'pdc.vim'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc#modules#disabled = ["menu"]
let g:pandoc#command#latex_engine = 'pdflatex'
let g:pandoc#folding#fold_yaml = 1
let g:pandoc#folding#fdc = 0
"let g:pandoc#folding#fold_fenced_codeblocks = 1
if exists('g:pandoc#biblio#bibs')
  call insert(g:pandoc#biblio#bibs, '~/bib/main.bib')
else
  let g:pandoc#biblio#bibs = ['~/bib/main.bib']
endif
let g:pandoc#command#autoexec_on_writes = 1
let g:pandoc#command#autoexec_command = "Pandoc pdf"
let g:pandoc#formatting#mode = 'h'

" plugins: comma separated values (csv) {{{2
"Plugin 'csv.vim'
"Plugin 'csv-reader'
"Plugin 'CSVTK'
"Plugin 'rcsvers.vim'
"Plugin 'csv-color'
"Plugin 'CSV-delimited-field-jumper'

" plugins: python {{{2

"Plugin 'sunsol/vim_python_fold_compact'
"Plugin 'Python-Syntax-Folding'
Plugin 'klen/python-mode'
let g:pymode_rope = 0

Plugin 'vim-autopep8'
" svn checkout http://vimpdb.googlecode.com/svn/trunk/ vimpdb-read-only
Plugin 'fs111/pydoc.vim'

" plugins: iCal {{{2

" syntax highlighting
Plugin 'icalendar.vim'

" plugins: fish (shell) {{{2
Plugin 'aliva/vim-fish'

" plugins: shell in Vim {{{1

Plugin 'ervandew/screen'
let g:ScreenImpl = 'Tmux'
let g:ScreenShellTerminal = 'iTerm.app'

" notes {{{2
Plugin 'Conque-Shell'
"Plugin 'vimsh.tar.gz'
"Plugin 'xolox/vim-shell'
"Plugin 'vimux'

Plugin 'Shougo/vimshell.vim' "{{{2
Plugin 'Shougo/vimproc'
"map <D-F11> :VimShellPop<cr>
let g:vimshell_temporary_directory = expand('~/.cache/vim/vimshell')

" to be tested (shell in gvim) {{{2
Plugin 'https://bitbucket.org/fboender/bexec.git'
if has('clientserver') | Plugin 'pydave/AsyncCommand' | endif

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
let g:easytags_python_enabled = 0
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

" plugins: parenthesis, quotes, alignment {{{1

Plugin 'Raimondi/delimitMate'
Plugin 'paredit.vim'
if s:uname != 'Linux' || has('nvim')
  Plugin 'tpope/vim-surround'
endif
"Plugin 'kana/vim-textobj-indent.git'
Plugin 'michaeljsmith/vim-indent-object.git'
Plugin 'junegunn/vim-easy-align.git'
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" plugins: motion {{{1
Plugin 'Lokaltog/vim-easymotion'

" plugins: vcs stuff {{{1
"Plugin 'tpope/vim-git'
if s:uname != 'Linux' || has('nvim')
  Plugin 'tpope/vim-fugitive'
endif
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'mhinz/vim-signify' "{{{3
let g:signify_disable_by_default = 1
" use :SignifyToggle to activate

" plugins: colors {{{1
" list all colorschemes with: globpath(&rtp,'colors/*.vim')

"Plugin 'ScrollColors'
"Plugin 'Colour-Sampler-Pack'

Plugin 'altercation/vim-colors-solarized' "{{{3
let g:solarized_menu = 0

" old unused colors {{{2
"Plugin 'w0ng/vim-hybrid'
"Plugin 'chriskempson/vim-tomorrow-theme'
"Plugin 'nanotech/jellybeans.vim'
"Plugin 'kalt.vim'
"Plugin 'kaltex.vim'
"Plugin 'textmate16.vim'
""Plugin 'vibrantink'
"Plugin 'tortex'
"Plugin 'tomasr/molokai'
"Plugin 'jonathanfilip/vim-lucius'
"
""Plugin 'molokai'
""Plugin 'pyte'
""Plugin 'dw_colors'
""Plugin 'Zenburn'
""Plugin 'desert-warm-256'
""Plugin 'tango-desert.vim'
""Plugin 'desertEx'
""Plugin 'darkerdesert'
""Plugin 'DesertedOceanBurnt'
""Plugin 'desertedocean.vim'
""Plugin 'desertedocean.vim'
""Plugin 'desert256.vim'
""Plugin 'desert.vim'
""Plugin 'eclm_wombat.vim'
""Plugin 'wombat256.vim'
""Plugin 'Wombat'
""Plugin 'oceandeep'

" plugins: statusline {{{1

if has('python') && ! has('nvim')
  "Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
  " the documentation of powerline is not in Vim format but only available at
  " https://powerline.readthedocs.org/
  source /usr/lib/python3.4/site-packages/powerline/bindings/vim/plugin/powerline.vim
else
  Plugin 'bling/vim-airline'
  "Plugin 'bling/vim-bufferline'
  let g:airline_powerline_fonts = 1
  "let g:airline#extensions#tabline#enabled = 1
endif

" vim options related to the statusline {{{2
set noshowmode   " do not display the current mode in the command line
set laststatus=2 " always display the statusline

" plugins: searching {{{1
"if executable('ag')
  Plugin 'rking/ag.vim'
"elseif executable('ack')
  Plugin 'mileszs/ack.vim'
"endif

" plugins: compiling {{{1
Plugin 'tpope/vim-dispatch'

Plugin 'xuhdev/SingleCompile'
let g:SingleCompile_asyncrunmode = 'python'
let g:SingleCompile_menumode = 0

" plugins: unsorted {{{1
Plugin 'jamessan/vim-gnupg'
Plugin 'pix/vim-known_hosts'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
"Plugin 'VimRepress' "https://bitbucket.org/pentie/vimrepress
Plugin 'lucc/VimRepress'
Plugin 'ZoomWin'
Plugin 'AndrewRadev/linediff.vim'
if has('python')
  Plugin 'guyzmo/notmuch-abook'
endif
if s:uname != 'Linux' || has('nvim')
  Plugin 'git://notmuchmail.org/git/notmuch', {'rtp': 'contrib/notmuch-vim'}
endif

" last steps {{{1

call vundle#end()
" fix the runtimepath to conform to XDG a little bit
call luc#xdg#runtimepath()

" switch on filetype detection after defining all Bundles
filetype plugin indent on

" settings for easytags which need the runtimepath set properly {{{2
"call xolox#easytags#map_filetypes('tex', 'latex')

" {{{2 Set colors for the terminal.  If the GUI is running the colorscheme
"      will be set in gvimrc.
if ! has('gui_running')
  set background=dark
  colorscheme solarized
endif

" neovim special code {{{1
if has('nvim') && has('gui_macvim')
  call jobstart('Greeting', 'growlnotify',
	\ ['--message', 'YEAH neovim rocks!', '--title', 'Hello Neovim'])
endif
