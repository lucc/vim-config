"  vimrc file by luc
"+ many thanks to 
"+ Bram Moolenaar <Bram@vim.org> for the exelent example vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""
" GENERAL "
"""""""""""
"  Use Vim settings, rather then Vi settings (much better!).
"+ This must be first, because it changes other options as a side effect.
set nocompatible

""""""""""""""
" TODO LIST: "
""""""""""""""
"set transparency=15
"set enc=utf-8

""""""""""""""
" APPEARANCE "
""""""""""""""
"set textwidth=79 	"brake lines after 79 chars (more fancy below)
"set formatoptions=tc 	"brake text and comments but do not reformat lines where no input occures
set laststatus=2
set number 		"line numbers
set ruler 		"show the cursor position all the time (at bottom right)
set scrolloff=10	"spcroll the screen when the courser is 10 lines away from the border line
set statusline=%t%m%r[%{&ff}][%{&fenc}]%y[ASCII=\%03.3b][POS=%04l/%L,%c%V][%p%%]
set laststatus=1	"display statusline only with multible windows
set diffopt=filler,vertical

if version >= 703 	" NEW in VIM 7.3
  set colorcolumn=79 	"highlight the background of the 79th column
  highlight ColorColomn ctermbg=lightgrey guibg=lightgrey
else
  "  i dont understand how but this highlights the part of the line which is 
  "+ longer then 78 char in grey (blue in a terminal).
  augroup vimrc_autocmds
    au!
    autocmd BufRead * highlight OverLength ctermbg=blue ctermfg=white
    autocmd BufRead * match OverLength /\%79v.*/
  augroup END
endif

if &t_Co > 2 || has("gui_running") "check for colours in terminal (echo &t_Co)
  syntax on 		"Switch syntax highlighting on, when the terminal has colors
  set hlsearch 		"Also switch on highlighting the last used search pattern.
endif

if has('folding')
  set foldmethod=indent " fold code by indent
  set foldlevelstart=20 " but open all (20) folds on startup
  autocmd BufNewFile,BufRead *.c,*.cpp,*.c++,*.h setlocal foldmethod=syntax
endif


"""""""""""""""""""""""""""
" Behavior of the editor: "
"""""""""""""""""""""""""""
set history=50 		"keep 50 lines of command line history
set showcmd 		"display incomplete commands
set incsearch 		"do incremental searching
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set autoindent 		"usfull for coding (see below for more fancy alternative)
set shiftwidth=2
set splitright

if has('mouse')
  set mouse=a 		"In many terminal emulators the mouse works just fine, thus enable it.
endif

""""""""""""""""""
" Spellchecking: "
""""""""""""""""""
" on Mac OS X the spellchecking files are in: /Applications/editoren/Vim.app/Contents/Resources/vim/runtime/spell
set spelllang=de_DE
set nospell

""""""""""""""""""""""""""" start of the rest of example file """"""""""""""

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" FIXME I don't understand this |  (luc 2010-12)
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
"  augroup END
"                               ^  
" FIXME I don't understand this |  (luc 2010-12)
"else
"  set autoindent		" always set autoindenting on
"endif " has("autocmd")

"" FIXME don't understand | this (luc 2010-12)
"                         v
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
"if !exists(":DiffOrig")
"  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
"		  \ | wincmd p | diffthis
"endif
