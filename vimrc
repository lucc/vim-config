" vimrc file by luc {{{1
" vi: set foldmethod=marker spelllang=en:

" start (things to do first) {{{1

" don't be vi compatible, this has to be first b/c it changes other options
set nocompatible

" Don't load menus.  This has to happen before 'syntax on' and 'filetype ...'
set guioptions+=M
set guioptions-=m

" sourcing other files {{{1
if has('python')
  pyfile ~/.vim/vimrc.py
endif

" syntax and filetype {{{1
syntax enable
filetype plugin indent on

" user defined variables {{{1
let mapleader = ','
let s:do_autogit = 1

" functions {{{1

" Check if a buffer is new. {{{2
" That is to say, if it as no name and is empty.
"
" a:1    -- the buffer number to check, 1 is used if absent
" return -- 1 if the buffer is new, else 0
function! s:check_if_buffer_is_new(...) "{{{2
  let number = a:0 ? a:1 : 1
  " save current and alternative buffer
  let current = bufnr('%')
  let alternative = bufnr('#')
  let value = 0
  " check buffer name
  if bufexists(number) && bufname(number) == ''
    silent! execute 'buffer' number
    let value = line('$') == 1 && getline(1) == ''
    silent! execute 'buffer' alternative
    silent! execute 'buffer' current
  endif
  return value
endfunction

function! s:server_setup() "{{{2
  call s:viminfo_setup(!s:server_running())
endfunction

" Check if another vim server is already running. {{{2
function! s:server_running() "{{{2
  return !empty(has('clientserver') ? serverlist() : system('vim --serverlist'))
endfunction

function! s:viminfo_setup(server) "{{{2
  if a:server
    " options: viminfo
    " default: '100,<50,s10,h
    set viminfo='100,<50,s10,h,%,n~/.vim/viminfo
    " the flag ' is for filenames for marks
    set viminfo='100
    " the flag < is the nummber of lines saved per register
    set viminfo+=<50
    " max size saved for registers in kb
    set viminfo+=s10
    " disable hlsearch
    set viminfo+=h
    " remember (whole) buffer list
    set viminfo+=%
    " name of the viminfo file
    set viminfo+=n~/.vim/viminfo
    " load a static viminfo file with a file list
    rviminfo ~/.vim/default-buffer-list.viminfo
  else
    " if we are not running as the server do not use the viminfo file.  We
    " probably only want to edit one file quickly from the command line.
    set viminfo=
  endif
endfunction

" setup for server vim {{{1
call s:server_setup()

" user defined autocommands {{{1

" FileType autocommands {{{2

augroup LucMarkdown "{{{3
  autocmd!
  autocmd FileType markdown
	\ setlocal spell
augroup END

augroup LucLilypond "{{{3
  autocmd!
  autocmd FileType lilypond
	\ setlocal dictionary+=~/.vim/syntax/lilypond-words
augroup END

augroup LucTex "{{{3
  autocmd!
  autocmd FileType tex
	\ setlocal
	\   spell
	\   dictionary+=%:h/**/*.bib,%:h/**/*.tex
	\   grepprg=grep\ -nH\ $*
	\ |
	\ nnoremap <buffer> K
	\   :call pyeval('tex.doc("""'.expand('<cword>').'""") or 1')<CR>|
	\ nnoremap <buffer> gG :python tex_count_vim_wrapper()<CR>|
	\ vnoremap <buffer> gG :python tex_count_vim_wrapper()<CR>
augroup END

augroup LucPython "{{{3
  autocmd!
  autocmd FileType python
	\ setlocal
	\   tabstop=8
	\   expandtab
	\   shiftwidth=4
	\   softtabstop=4
augroup END

augroup LucJava "{{{3
  autocmd!
  autocmd Filetype java
	\ setlocal makeprg=cd\ %:h\ &&\ javac\ %:t
        " setlocal omnifunc=javacomplete#Complete
augroup END

augroup LucMail "{{{3
  autocmd!
  autocmd FileType mail
	\ setlocal textwidth=72 spell
augroup END

augroup LucMan "{{{3
  autocmd!
  autocmd FileType man
	\ stopinsert |
	\ setlocal nospell
augroup END

augroup LucGitCommit "{{{3
  autocmd!
  autocmd FileType gitcommit
	\ setlocal spell
augroup END

augroup LucSession "{{{2
  autocmd!
  autocmd VimEnter *
	\ if s:check_if_buffer_is_new(1) |
	\   bwipeout 1                   |
	\   doautocmd BufRead,BufNewFile |
	\   redraw!                      |
	\ endif
augroup END

augroup LucRemoveWhiteSpaceAtEOL "{{{2
  autocmd!
  autocmd BufWrite *
	\ silent %substitute/\s\+$//e
augroup END

augroup LucAutoGit "{{{2
  autocmd!
  autocmd BufWritePost ~/.config/**,~/src/shell/**
	\ if s:do_autogit                |
	\   call pyeval('autogit_vim()') |
	\ endif
  autocmd BufWritePost ~/uni/philosophie/magisterarbeit/**
	\ if s:do_autogit                    |
	\   call pyeval('autogit_vim(None)') |
	\ endif
augroup END

"augroup LucLocalAutoCd "{{{2
"  autocmd!
"  autocmd BufEnter ~/uni/**     lcd ~/uni
"  autocmd BufEnter ~/.config/** lcd ~/.config
"  autocmd BufEnter ~/src/**     lcd ~/src
"augroup END

"augroup LucLocalWindowCD "{{{2
"  autocmd!
"  " FIXME: still buggy
"  autocmd BufWinEnter,WinEnter,BufNew,BufRead,BufEnter *
"	\ execute 'lcd' pyeval('backup_base_dir_vim_reapper()')
"augroup END

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

" capitalize text
vmap gc  "=luc#capitalize(luc#get_visual_selection())<CR>p
nmap gc  :set operatorfunc=luc#capitalize_operator_function<CR>g@
nmap gcc gciw

" bla
if has('gui_macvim')
  inoremap œ \
  inoremap æ \|
  cnoremap œ \
  cnoremap æ \|
  inoremap <D-s> <C-O>:silent update<CR>
  noremap  <D-s>      :silent update<CR>
endif

" open URLs {{{2
nmap <Leader>w :python for url in strings.urls(vim.current.line): webbrowser.open(url)<CR>

" easy compilation {{{2
nmap <silent> <F2>        :silent update <BAR> python compiler.generic('')<CR>
imap <silent> <F2>   <C-O>:silent update <BAR> python compiler.generic('')<CR>
nmap <silent> <D-F2>
      \      :silent update <BAR> call luc#compiler#generic('', 1)<CR>
imap <silent> <D-F2>
      \ <C-O>:silent update <BAR> call luc#compiler#generic('', 1)<CR>

" backup current buffer
nnoremap <silent> <F11>
      \ :silent update <BAR>
      \ call luc#compiler#generic2('') <BAR>
      \ call pyeval('backup_current_buffer() or True') <BAR>
      \ redraw <CR>

" moveing around {{{2
nmap <C-Tab>        gt
imap <C-Tab>   <C-O>gt
nmap <C-S-Tab>      gT
imap <C-S-Tab> <C-O>gT

nmap <SwipeUp>   gg
imap <SwipeUp>   gg
nmap <SwipeDown> G
imap <SwipeDown> G

nnoremap ' `
nnoremap ` '

" misc {{{2

"nmap <Leader>d "=strftime('%F')<CR>p

" use ß to clear the screen if you want privacy for a moment
nmap ß :!clear<CR>

" always search very magic
"nnoremap / /\v
"nnoremap ? ?\v

" From the .vimrc example file:
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
"command! DiffOrig vne | se bt=nofile | r # | 0d_ | difft | wincmd p | difft

"command! Helptags call LucUpdateAllHelptags()
"command! DislikeCS call s:LucLikeColorscheme(-1)
"command! LikeCS call s:LucLikeColorscheme(1)

"nmap <D-+> :call s:LucLikeColorscheme(1)\|call LucSelectRandomColorscheme()<CR>
"nmap <D--> :call s:LucLikeColorscheme(-1)\|call LucSelectRandomColorscheme()<CR>
"nmap <D-_> :call s:LucRemoveColorscheme()\|call LucSelectRandomColorscheme()<CR>


command! StartAutoGit let s:do_autogit = 1
command! StopAutoGit  let s:do_autogit = 0
command! ToggleAutoGit let s:do_autogit = !s:do_autogit

" options: basic {{{1

" allow backspacing over everything in insert mode
set autoindent
set backspace=indent,eol,start
set backup
set backupdir=~/.vim/backup
let &backupskip .= ',' . expand('$HOME') . '/.config/secure/*'
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

" options: cpoptions {{{1
set cpoptions+=$ " don't redraw the display while executing c, s, ... cmomands
set cpoptions+={ " let { and } stop on a "{" in the first column

" options: dictionary and complete {{{1

set complete+=k

" use the current spell checking settings for directory completion:
set dictionary+=spell

" add private directories:
set dictionary+=~/.vim/dictionary/*

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
  set spellfile+=~/.vim/spell/de.utf-8.add
  set spellfile+=~/.vim/spell/en.utf-8.add
  set spellfile+=~/.vim/spell/names.utf-8.add
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

" options: satusline {{{1
" see below at airline config
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
set wildignore+=.hg,.git,.svn                  " Version control
set wildignore+=*.aux,*.out,*.toc,*.idx,*.fls  " LaTeX intermediate files
set wildignore+=*.fdb_latexmk                  " LaTeXmk files
set wildignore+=*.pdf,*.dvi,*.ps,*.djvu        " binary documents (latex)
set wildignore+=*.odt,*.doc,*.docx             " office text documents
set wildignore+=*.ods,*.xls,*.xlsx             " office spreadsheets
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " binary images
set wildignore+=*.mp3,*.flac                   " music
set wildignore+=.*.sw?                         " Vim swap files
set wildignore+=.DS_Store,*.dmg                " OSX bullshit
set wildignore+=*.o,*.obj,*.exe,*.dll          " compiled object files
set wildignore+=*.class                        " java class files
set wildignore+=*.spl                          " compiled spell word lists
set wildignore+=*.tar,*.tgz,*.tbz2,*.tar.gz,*.tar.bz2
"set wildignore+=*.luac                        " Lua byte code
"set wildignore+=migrations                    " Django migrations
set wildignore+=*.pyc                          " Python byte code
"set wildignore+=*.orig                        " Merge resolution files

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
set runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" plugins: buffer and file management {{{1
Plugin 'kien/ctrlp.vim'

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

" Use the compiled C-version for speed improvements "{{{2
if has('python')
  Plugin 'JazzCore/ctrlp-cmatcher'
  let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
endif

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

  Plugin 'bjoernd/vim-ycm-tex', {'name': 'YouCompleteMe/python/ycm/completers/tex'}
  let g:ycm_semantic_triggers = {'tex': ['\ref{','\cite{']}

  "Plugin 'c9s/vimomni.vim'
  "Plugin 'tek/vim-ycm-vim'

else             " -> neocomplete and neocomplcache {{{2
  " settings which are uniform for both neocomplete and neocomplcache
  Plugin 'Shougo/vimproc'
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
  "  "inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"
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
  Plugin 'SirVer/ultisnips'
  let g:UltiSnipsExpandTrigger = '<C-F>'
  let g:UltiSnipsJumpForwardTrigger = '<C-F>'
  "let g:UltiSnipsJumpBackwardTrigger = '<C-Tab>'
  "let g:UltiSnipsExpandTrigger       = <tab>
  "let g:UltiSnipsListSnippets        = <c-tab>
  "let g:UltiSnipsJumpForwardTrigger  = <c-j>
  "let g:UltiSnipsJumpBackwardTrigger = <c-k>
  let g:UltiSnipsJumpBackwardTrigger = '<SID>NOT_DEFINED'
else
  " snipmate and dependencies
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'garbas/vim-snipmate'
endif

" Snippets are separated from the engine:
Plugin 'honza/vim-snippets'
Plugin 'rbonvall/snipmate-snippets-bib'

" plugins: syntastic {{{1
Plugin 'scrooloose/syntastic'
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
let g:tex_fold_enabled = 1
let g:tex_flavor = 'latex'

" 3109 LatexBox.vmb
"Plugin 'coot/atp_vim'
"Plugin 'LaTeX-functions'
"Plugin 'latextags'
"Plugin 'TeX-9'
"Plugin 'tex.vim'
"Plugin 'tex_autoclose.vim'

"Plugin 'auctex.vim'
Plugin 'LaTeX-Help'

Plugin 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex' "{{{3
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
"let g:Tex_Env_quote = "\\begin{quote}\<CR>,,<++>`` \\cite[S.~<++>]{<++>}\<CR>\\end{quote}"
" the variable Tex_FoldedEnvironments holds the beginnings of names of
" environments which should be folded.  The innermost environments should come
" first.
let g:Tex_FoldedEnvironments  = 'verbatim'
let g:Tex_FoldedEnvironments .= ',comment'
let g:Tex_FoldedEnvironments .= ',eq'
let g:Tex_FoldedEnvironments .= ',gather'
let g:Tex_FoldedEnvironments .= ',align'
let g:Tex_FoldedEnvironments .= ',figure'
let g:Tex_FoldedEnvironments .= ',table'
" environments for structure of mathematical texts (they can contain other
" stuff)
let g:Tex_FoldedEnvironments .= ',th'
let g:Tex_FoldedEnvironments .= ',satz'
let g:Tex_FoldedEnvironments .= ',def'
let g:Tex_FoldedEnvironments .= ',lem'
let g:Tex_FoldedEnvironments .= ',rem'
let g:Tex_FoldedEnvironments .= ',bem'
let g:Tex_FoldedEnvironments .= ',proof'
" quotes can contain other stuff
let g:Tex_FoldedEnvironments .= ',quot'
" environments for the general document
let g:Tex_FoldedEnvironments .= ',thebibliography'
let g:Tex_FoldedEnvironments .= ',keywords'
let g:Tex_FoldedEnvironments .= ',abstract'
let g:Tex_FoldedEnvironments .= ',titlepage'
" alternative 1
  "let Tex_FoldedEnvironments='*'
  "let Tex_FoldedEnvironments+=','
  "let Tex_FoldedEnvironments  = 'document,minipage,'
  "let Tex_FoldedEnvironments .= 'di,lem,ivt,dc,'
  "let Tex_FoldedEnvironments .= 'verbatim,comment,proof,eq,gather,'
  "let Tex_FoldedEnvironments .= 'align,figure,table,thebibliography,'
  "let Tex_FoldedEnvironments .= 'keywords,abstract,titlepage'
  "let Tex_FoldedEnvironments .= 'item,enum,display'
  "let Tex_FoldedMisc = 'comments,item,preamble,<<<'
" alternative 2
  " let g:Tex_FoldedMisc = 'comments,item,preamble,<<<,slide'
" alternative 3
  "let Tex_FoldedEnvironments .= '*'
  "let Tex_FoldedSections = 'part,chapter,section,subsection,subsubsection,paragraph'

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

" strange autocmd which run a lot
"Plugin 'suan/vim-instant-markdown'

" good folding uses expr
Plugin 'nelstrom/vim-markdown-folding'
let g:markdown_fold_style = 'nested'

" strange folding?
"Plugin 'tpope/vim-markdown'

" plugins: comma separated values (csv) {{{2
"Plugin 'csv.vim'
"Plugin 'csv-reader'
"Plugin 'CSVTK'
"Plugin 'rcsvers.vim'
"Plugin 'csv-color'
"Plugin 'CSV-delimited-field-jumper'

" plugins: python {{{2

Plugin 'sunsol/vim_python_fold_compact'
"Plugin 'Python-Syntax-Folding'
"Plugin 'klen/python-mode'

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
"Plugin 'Conque-Shell'
"Plugin 'vimsh.tar.gz'
"Plugin 'xolox/vim-shell'
"Plugin 'vimux'

"Plugin 'Shougo/vimshell.vim' "{{{2
"Plugin 'Shougo/vimproc'
"map <D-F11> :VimShellPop<cr>
"let g:vimshell_temporary_directory = expand('~/.vim/vimshell')

" to be tested (shell in gvim) {{{2
Plugin 'https://bitbucket.org/fboender/bexec.git'
if has('clientserver') | Plugin 'pydave/AsyncCommand' | endif

" plugins: tags {{{1
" Easytags will automatically create and update tags files and set the 'tags'
" option per file type.  Tag navigation can be done with the CTRL-P plugin.
" All these settings are dependent on the file ~/.ctags.
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
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

" plugins: parenthesis and quotes {{{1

Plugin 'Raimondi/delimitMate'
Plugin 'paredit.vim'
Plugin 'tpope/vim-surround'

" plugins: motion {{{1
Plugin 'Lokaltog/vim-easymotion'

" plugins: vcs stuff {{{1
"Plugin 'tpope/vim-git'
Plugin 'tpope/vim-fugitive'
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

if has('python')
  Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
  " the documentation of powerline is not in Vim format but only available at
  " https://powerline.readthedocs.org/
else
  Plugin 'bling/vim-airline'
  "Plugin 'bling/vim-bufferline'
  let g:airline_powerline_fonts = 1
  "let g:airline#extensions#tabline#enabled = 1
endif

" vim options related to the statusline {{{2
set noshowmode   " do not display the current mode in the command line
set laststatus=2 " always display the statusline

" plugins: unsorted {{{1
"Plugin 'coot/CRDispatcher'
"Plugin 'coot/EnchantedVim'

"Plugin 'tyru/open-browser.vim'
"can be replaced by python webbrowser.open()

Plugin 'pix/vim-known_hosts'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'

"Plugin 'browser.vim'
"Plugin 'calendar.vim'

" buggy!
Plugin 'matchit.zip'

Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'

Plugin 'VimRepress'
"Plugin 'connermcd/VimRepress'
"Plugin 'blogit.vim'

Plugin 'ZoomWin'
Plugin 'AndrewRadev/linediff.vim'

" last steps {{{1

call vundle#end()
" switch on filetype detection after defining all Bundles
filetype plugin indent on

" settings for easytags which need the runtimepath set properly {{{2
call xolox#easytags#map_filetypes('tex', 'latex')

" {{{2 Set colors for the terminal.  If the GUI is running the colorscheme
"      will be set in gvimrc.
if ! has('gui_running')
  set background=dark
  colorscheme solarized
endif
