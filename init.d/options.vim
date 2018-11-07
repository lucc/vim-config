" options setup by luc
" vim: foldmethod=marker spelllang=en

" Some options where removed in neovim or have different default values. For
" vim we still need to set them.
if !has('nvim') "{{{1
  " don't be vi compatible, this has to be first b/c it changes other options
  set nocompatible
  set autoindent
  " allow backspacing over everything in insert mode
  set backspace=indent,eol,start
  set encoding=utf-8
  " highlight the last used search pattern.
  set hlsearch
  " incremental search
  set incsearch
  set wildmenu
endif

" Don't load menus.  This has to happen before 'syntax on' and 'filetype ...'
set guioptions+=M
set guioptions-=m

" Use neovim-remote as $EDITOR to open files in the same instance.
let $EDITOR = 'nvr'

" basic {{{1

set backup
set backupdir-=.
set backupskip+=/dev/shm/*
set hidden
set confirm
set textwidth=78
set shiftwidth=2
set number
" scroll when the courser is 2 lines from the border line
set scrolloff=2
set shortmess=
set nostartofline
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
"set shell=/bin/sh
" hopefully this is not to demanding (=short)
set updatetime=200
set directory+=~/tmp
set directory+=/tmp
set inccommand=split
set undofile

" shada {{{1
" default: '100,<50,s10,h
" the flag ' is for filenames for marks
" the flag < is the nummber of lines saved per register
" the flag s is the max size saved for registers in kb
" the flag h is to disable hlsearch
" the flag % is to remember (whole) buffer list
" the flag n is the name of the viminfo file
" include bufferlist
set shada+=%
" save all lines from registers
set shada-=<
" save all items smaller than 100K
set shada+=s100

" cpoptions {{{1
set cpoptions+=$ " don't redraw the display while executing c, s, ... cmomands

" terminal stuff {{{1

set title
set titleold=shell

if $COLORTERM ==? 'truecolor' || !empty($KONSOLE_DBUS_SERVICE) || $TERM =~? 'st.*'
  set termguicolors
elseif !has('gui_running')
  set t_Co=256
endif

" searching {{{1
set ignorecase
set smartcase

" spellchecking {{{1

" on Mac OS X the spellchecking files are in:
" MacVim.app/Contents/Resources/vim/runtime/spell
set spelllang=de,en
if &spellfile ==# ''
  set spellfile+=~/.config/nvim/spell/de.utf-8.add
  set spellfile+=~/.config/nvim/spell/en.utf-8.add
  set spellfile+=~/.config/nvim/spell/names.utf-8.add
endif
set nospell

" folding {{{1

set foldmethod=syntax
" fold code by indent
"set foldmethod=indent
" but open all (20) folds on startup
"set foldlevelstart=20
" enable folding for functions, heredocs and if-then-else stuff in sh files.
let g:sh_fold_enabled=7

" path {{{1
" set the path for file searching
" first the directory of the current file
set path=.
" then the current working directory
set path+=,
" all files below the current file
set path+=./**
" all dirs above the current file
set path+=.;
" and the home directory
set path+=~/

" formatoptions {{{1
" formatoptions default is tcq
set formatoptions+=n " recognize numbered lists
set formatoptions+=r " insert comment leader when hitting <enter>
set formatoptions+=j " remove comment leader when joining lines
set formatoptions+=l " do not break lines which are already long

" tabline {{{1
" we could do something similar for tabs.
" see :help 'tabline'
"set tabline=Tabs:
"set tabline+=\ %{tabpagenr('$')}
"set tabline+=\ Buffers:
"set tabline+=\ %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))}
"set tabline+=%=%{strftime('%a\ %F\ %R')}

" wildmenu and wildignore {{{1
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
set wildignore+=*.class     " java
set wildignore+=*.dll       " windows libraries
set wildignore+=*.exe       " windows executeables
set wildignore+=*.o         " object files
set wildignore+=*.obj       " ?
set wildignore+=*.pyc       " Python byte code
set wildignore+=*.luac      " Lua byte code
set wildignore+=__pycache__ " python stuff
set wildignore+=*.egg-info  " python stuff

" unsuported archives and images {{{2
set wildignore+=*.dmg
set wildignore+=*.iso
set wildignore+=*.tar
set wildignore+=*.tar.bz2
set wildignore+=*.tar.gz
set wildignore+=*.tbz2
set wildignore+=*.tgz

" setting variables for special settings {{{1
let mapleader = ','

let g:vimsyn_folding = 'afmpPrt'
" augroups ____________/ ||||||
" fold functions ________/|||||
" fold mzscheme script ___/||||
" fold perl     script ____/|||
" fold python   script _____/||
" fold ruby     script ______/|
" fold tcl      script _______/
let g:netrw_browsex_viewer = 'xdg-open'

" Hard code paths that work for Arch Linux and CentOS.
let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python2'
" Disable python 2 support
"let g:loaded_python_provider = 1

" taken from http://stackoverflow.com/a/7490288
let php_folding = 0        "Set PHP folding of classes and functions.
"let php_htmlInStrings = 1  "Syntax highlight HTML code inside PHP strings.
"let php_sql_query = 1      "Syntax highlight SQL code inside PHP strings.
"let php_noShortTags = 1    "Disable PHP short tags.
