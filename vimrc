"  vimrc file by luc {{{
"+ many thanks to 
"+ Bram Moolenaar <Bram@vim.org> for the exelent example vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vi:fdm=marker:fdl=0
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" {{{ GENERAL
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"  Use Vim settings, rather then Vi settings (much better!).
"+ This must be first, because it changes other options as a side effect.
set nocompatible

" {{{ TODO LIST:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set transparency=15

" {{{ open url from vim
" thanks to
"http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
function! Browser ()
  let line = getline (".")
  let line = matchstr (line, "\(http://\|www\.\)[^ ,;\t]*")
  "exec "!$BROWSER \"".line."\""
endfunction
map <Leader>w :call Browser ()<CR>
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
	  exec "!open \"" . s:uri . "\""
  else
	  echo "No URI found in line."
  endif
endfunction
map <Leader>w :call HandleURI()<CR>
"}}}

" }}} TODO LIST:

" {{{ Behavior of the editor:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set hidden
set history=100
set incsearch
set showcmd
set splitright
set virtualedit=block
set wim=longest:full,full

map Y y$

"In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse') | set mouse=a | endif
" }}} Behavior

" {{{ Spellchecking:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" on Mac OS X the spellchecking files are in:
" /Applications/editoren/Vim.app/Contents/Resources/vim/runtime/spell
set spelllang=de_DE
set nospell
" }}} Spellchecking

" }}} GENERAL

" {{{ APPEARANCE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"colorscheme luc_dark
colo macvim
set bg=light
" {{{ general """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set textwidth=79 	"brake lines after 79 chars (more fancy below)
"set formatoptions=tc 	"brake text and comments but do not reformat lines where no input occures
set number 		"line numbers
set ruler 		"show the cursor position all the time (at bottom right)
set scrolloff=5		"spcroll the screen when the courser is 10 lines away from the border line
set diffopt=filler,vertical
"set foldcolumn=2
" }}}

" {{{ satusline """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" many thanks to
"   http://vim.wikia.com/wiki/Writing_a_valid_statusline
"   https://wincent.com/wiki/Set_the_Vim_statusline
"   http://winterdom.com/2007/06/vimstatusline
"   http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html
" My old versions:
"set statusline=%t%m%r[%{&ff}][%{&fenc}]%y[ASCII=\%03.3b]%=[%c%V,%l/%L][%p%%]
"set statusline=%t%m%r[%{&fenc},%{&ff}%Y][ASCII=x%02.2B]%=[%c%V,%l/%L][%P]
"set statusline=%t[%M%R%H][%{strlen(&fenc)?&fenc:'none'},%{&ff}%Y][ASCII=x%02.2B]%=%{strftime(\"%Y-%m-%d\ %H:%M\")}\ [%c%V,%l/%L][%P]
set statusline=%t\ %([%M%R%H]\ %)[%{strlen(&fenc)?&fenc:'none'},%{&ff}%Y]\ [ASCII=x%02.2B]%=[%{strftime('%F\ %R')}]\ [%c%V,%l/%L]\ [%P]
set laststatus=2
" some examples copied from the above sites:
"set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]
"set statusline=%=\ col:%c%V\ ascii:%b\ pos:%o\ lin:%l\,%L\ %P
"set statusline=%{strftime(\"%c\",getftime(expand(\"%:p\")))}
"set statusline=changed\ %{strftime('%F\ %T',getftime(expand('%:p')))}\ now\ %{strftime('%Y-%m-%d\ %T')}

"this color version is from
"   http://vim.wikia.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode
function! InsertStatuslineColor(mode)
  if a:mode == 'i'     | hi statusline guibg=DarkGreen   ctermbg=DarkGreen
  elseif a:mode == 'r' | hi statusline guibg=DarkMagenta ctermbg=DarkMagenta
  else                 | hi statusline guibg=DarkRed     ctermbg=DarkRed
  endif
endfunction
" change highlighting when mode changes
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkBlue ctermbg=DarkBlue term=reverse
" default the statusline to green when entering Vim
highlight statusline guibg=DarkBlue ctermbg=DarkBlue term=reverse

set wildmenu
" }}} statusline

" {{{ colorcolumn """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if version >= 703 	" NEW in VIM 7.3
  set colorcolumn=79 	"highlight the background of the 79th column
else
  "  i dont understand how but this highlights the part of the line which is 
  "+ longer then 78 char in grey (blue in a terminal).
  augroup vimrc_autocmds
    au!
    autocmd BufRead * highlight OverLength ctermbg=blue ctermfg=white
    autocmd BufRead * match OverLength /\%79v.*/
  augroup END
endif
" }}}

" {{{ syntax """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if &t_Co > 2 || has("gui_running") "check for colours in terminal (echo &t_Co)
  "Switch syntax highlighting on, when the terminal has colors
  syntax on
  "highlight the last used search pattern.
  set hlsearch
endif
" }}}

" {{{ folding """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has('folding')
  "set foldmethod=indent " fold code by indent
  set foldmethod=syntax
  set foldlevelstart=20 " but open all (20) folds on startup
  "enable folding for functions, heredocs and if-then-else stuff.
  let g:sh_fold_enabled=7
endif
" }}}

" }}} APPEARANCE

" {{{ CODING
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
  " Enable file type detection and language-dependent indenting.
  filetype plugin indent on
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!
    " For all text files set 'textwidth' to 78 characters.
    autocmd FileType text setlocal textwidth=78
    autocmd FileType tex,bib,c,cpp,h,hpp setlocal textwidth=78
    set autoindent
    set shiftwidth=2
  augroup END
else
  " always set autoindenting on
  set autoindent
  set shiftwidth=2
endif

au FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4

"{{{ LaTeX stuff (several plugins)

"{{{ old latex bindings
"map € :!~/bin/all-latex -b "%"<CR>
"map ∑ :!~/bin/all-latex  -o "%"<CR>
"map « :!~/bin/all-latex "%"<CR>
"map <C-l> :!pdflatex "%" && open -aPreview "$(if \! lsof `echo "%"\|sed 's/tex$/pdf/'`>/dev/null;then echo "%"\|sed 's/tex$/pdf/';fi)"<CR>
"map ∫ :!bibtex `echo %\|sed s/tex$/aux/`<CR>
"autocmd BufNewFile,BufRead *.tex setlocal makeprg=latexscript\ -af\ % textwidth=79
"autocmd BufNewFile,BufRead *.tex setlocal makeprg=latexscript\ -af\ \"%\" textwidth=79
"autocmd BufNewFile,BufRead *.tex setlocal makeprg=pdflatex\ %\ &&\ open\ -apreview textwidth=79
"}}}

" {{{ PLUGIN LaTeX-Suite: 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REQUIRED: filetype plugin on
" OPTIONAL: filetype indent on
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
"set shellslash
" IMPORTANT: force grep to display filename.
set grepprg=grep\ -nH\ $*
" OPTIONAL: Handle empty .tex files as LaTeX.
let g:tex_flavor='latex'
" Folding:
"let Tex_FoldedEnvironments='*'
"let Tex_FoldedEnvironments+=','
let Tex_FoldedEnvironments='document,minipage,'
let Tex_FoldedEnvironments.='di,lem,ivt,dc,'
let Tex_FoldedEnvironments.='verbatim,comment,proof,eq,gather,'
let Tex_FoldedEnvironments.='align,figure,table,thebibliography,'
let Tex_FoldedEnvironments.='keywords,abstract,titlepage'
let Tex_FoldedEnvironments.='item,enum,display'
let Tex_FoldedMisc='comments,item,preamble,<<<'

" compiling with \ll
let g:Tex_CompileRule_pdf='latexmk -silent -pv -pdf $*'
let g:Tex_ViewRule_pdf='open -a Preview'

"dont use latexsuite folding
let Tex_FoldedEnvironments=''
let Tex_FoldedMisc=''
let Tex_FoldedSections=''
" }}} LaTeX-Suite

"{{{ PLUGIN AutomaticLaTexPlugin: http://www.vim.org/scripts/script.php?script_id=2945
"}}}

"{{{ PLUGIN auctex.vim: http://www.vim.org/scripts/script.php?script_id=162
"}}}

"{{{ PLUGIN tex_autoclose: http://www.vim.org/scripts/script.php?script_id=920
"}}}

"{{{ PLUGIN tex9: http://www.vim.org/scripts/script.php?script_id=3508
"}}}

"{{{ PLUGIN 
"}}}

"}}} LaTeX stuff

" {{{ PLUGIN winmanager: http://www.vim.org/scripts/script.php?script_id=95
map <C-w><C-t> :WMToggle<CR> 
" }}}

" }}} CODING

" {{{ start of the rest of example file 
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: merge with all the rest.

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
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
" }}} end of the rest of the exaple file
