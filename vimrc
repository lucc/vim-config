"""""""""""""""""
" Unused stuff: "
"""""""""""""""""
"  this is not used b/c i could not figure out how to open all folds on startup
"+ automatically (zR does not seem to work here).
"set fdm=syntax
"zR

"set transparency=15

"set enc=utf-8


"""""""""""""""""""""""""""""""""""""""""""""""""
" Autoformating text and indicating long lines: "
"""""""""""""""""""""""""""""""""""""""""""""""""

" usfull for coding
set autoindent

" brake lines after 80 chars
"set textwidth=80

" brake text and comments but do not reformat lines where no input occures
"set formatoptions=tc

"  i dont understand how but this highlights the part of the line which is 
"+ longer then 80 char in grey (blue in a terminal).
augroup vimrc_autocmds
  au!
  autocmd BufRead * highlight OverLength ctermbg=blue ctermfg=white guibg=grey "guibg=#592929 
  autocmd BufRead * match OverLength /\%81v.*/
augroup END


"""""""""""""""""""""""""""
" Aperance of the editor: "
"""""""""""""""""""""""""""

" higlight syntax automatically
syntax on

"line numbers
set number


""""""""""""""""""
" for terminals: "
""""""""""""""""""

"make the mouse usable in a terminal
set mouse=a


"""""""""""""""""""""""""""
" Behavior of the editor: "
"""""""""""""""""""""""""""

" go to ``insert'' mode
start












" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Jul 02
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" FIXME I don't understand this |
"                               |
"                               v

" Only do this part when compiled with support for autocommands.
"if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
"  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
"  augroup vimrcEx
"  au!

  " For all text files set 'textwidth' to 78 characters.
"  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
"  autocmd BufReadPost *
"    \ if line("'\"") > 1 && line("'\"") <= line("$") |
"    \   exe "normal! g`\"" |
"    \ endif

"  augroup END
"                               ^  
"                               |
" FIXME I don't understand this |

"else

  set autoindent		" always set autoindenting on

"endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
