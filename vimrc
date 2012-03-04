" ~/.vimrc file by luc. {{{1
" Many thanks to Bram Moolenaar <Bram@vim.org> for the exelent example vimrc
" vi:fdm=marker:fdl=0

" start (things to do first) {{{1

" Use Vim settings, rather then Vi settings (much better!).  This must be
" first, because it changes other options as a side effect.
set nocompatible

" syntax and filetype {{{

if has('syntax')
  " Switch syntax highlighting on, when the terminal has colors
  " check for colours in terminal (echo &t_Co)
  if &t_Co > 2 || has("gui_running")
    syntax enable
  endif

  " Enable file type detection and language-dependent indenting.
  if has("autocmd")
    filetype plugin indent on
  endif

endif

" user defined variables {{{1

let luc_notes_file = '~/.vim/notes'

" user defined functions {{{1

function! SearchStringForURI(string) "{{{2
  " function to find an URI in a string
  " thanks to
  " http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
  " alternatives:
  "return matchstr(a:string, '\(http://\|www\.\)[^ ,;\t]*')
  "return matchstr(a:string, '[a-z]*:\/\/[^ >,;:]*')
  return matchstr(a:string, '[a-z]\+:\/\/[^ >,;:]\+')
endfunction

function! HandleURI(uri) "{{{2
  " function to find an URI on the current line and open it.
  if a:uri == ''
    echo 'No URI given.'
  elseif has('gui_macvim')
    " this only works on Mac OS X
    exec '!open "' . a:uri . '"'
  else
    " I was lasy one could do something like:
    "exec '!$BROWSER "' . a:uri . '"'
    echo 'Unknown system.'
  endif
endfunction

function! InsertStatuslineColor(mode) "{{{2
  " function to change the color of the statusline depending on the mode
  " this version is from
  " http://vim.wikia.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode
  if a:mode == 'i'
    highlight statusline guibg=DarkGreen   ctermbg=DarkGreen
  elseif a:mode == 'r'
    highlight statusline guibg=DarkMagenta ctermbg=DarkMagenta
  else
    highlight statusline guibg=DarkRed     ctermbg=DarkRed
  endif
endfunction

function! FindNextSpellErrorAndDisplayCorrections(mode) "{{{2
  " A function to jump to the next spelling error and imediatly display
  " possible corrections. In insert mode the Pmenu is used, in normal mode the
  " listoing from z= is used.
  let oldspell = &spell
  if &spell == 0
    set spell
  endif
  if spellbadword(expand('<cword>')) != ['', '']
    if a:mode == 'insert' | <C-x><C-S> | else | z= | endif
  else
    normal ]s
    if a:mode == 'insert' | <C-x><C-S> | else | z= | endif
  endif
  if oldspell == 0
    set nospell
  endif
endfunction

function! VisitBufferOrEditFile(name) "{{{2
  " A function to check if a file was already loaded into some buffer.
  " Depending if it was the function either switches to that buffer or
  " executes ':edit ' on the filename.
  if match(expand(a:name), '/') == -1
    let a:name = getcwd() . '/' . a:name
  endif
  " this is a short version of the lines below:
  "execute (bufexists(expand(a:name)) ? 'buffer ' : 'edit ') . expand(a:name)
  if bufexists(expand(a:name))
    execute 'buffer ' . expand(a:name)
  else
    execute 'edit ' . expand(a:name)
  endif
endfunction

" user defined commands and mappings {{{1

" edit {{{2
" make Y behave like D,S,C ...
map Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" easy spell checking
"imap <C-s> <C-o>:call FindNextSpellErrorAndDisplayCorrections('insert')<CR>
"nmap <C-s>      :call FindNextSpellErrorAndDisplayCorrections('normal')<CR>
"imap <C-s> <C-o>]s
"nmap <C-s> ]s

" TODO: is this usefull?
"inoremap ( ()<++><ESC>F)i
"inoremap [ []<++><ESC>F]i
"inoremap { {}<++><ESC>F}i

" web {{{2
" functions to open URLs
nmap <Leader>w :call HandleURI(SearchStringForURI(getline('.')))<CR><CR>

" find a script on vim.org by id or name
nmap <Leader>v :call HandleURI('http://www.vim.org/scripts/script.php?script_id=' . expand('<cword>'))<CR><CR>

" misc {{{2
" use ß to clear the screen if you wnat privacy for a moment
nmap ß :!clear<CR>

" for the IncBufSwitch plugin (the plugin does only match buffers against the
" start of the buffer name ... (not so nice)
nmap <f2> :IncBufSwitch<CR>

" load a notes/scratch buffer which will be saved automatically.
call bufnr(luc_notes_file, 99)
" use the variable in the autocommands
autocmd BufEnter ~/.vim/notes setlocal nobuflisted bufhidden=hide
autocmd BufDelete,BufHidden,BufLeave,BufUnload,FocusLost ~/.vim/notes update

" commands and mappings to switch to important files fast.
command NO call VisitBufferOrEditFile(luc_notes_file)
command GLF call VisitBufferOrEditFile('~/.vim/GetLatest/GetLatestVimScripts.dat')
" quickly open ~/.vimrc and ~/.gvimrc
command RC  call VisitBufferOrEditFile('~/.vimrc')
command GRC call VisitBufferOrEditFile('~/.gvimrc')
nmap <C-w># :NO<CR>

au FileType python setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4

" From the .vimrc example file:
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p
	\ | diffthis
endif

" options: ToDo {{{1

"set transparency=15
"set foldcolumn=2

" options: basic {{{1
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set backup 
set hidden
set history=100
set confirm
set path=.,~/files/**,~/,~/.vim/**,/usr/include/,/usr/local/include/
set textwidth=78
set shiftwidth=2
set background=light
set formatoptions+=nr 	"brake text and comments but do not reformat lines where no input occures
set number
set scrolloff=5		"scroll when the courser is 5 lines from the border line
set shortmess=
set nostartofline

" options: searching {{{1
set ignorecase
set smartcase
if has("extra_search")
  " highlight the last used search pattern.
  set hlsearch
  " incremental search
  set incsearch
endif

" options: spellchecking {{{1

if has('syntax')
  " on Mac OS X the spellchecking files are in:
  " /Applications/editoren/Vim.app/Contents/Resources/vim/runtime/spell
  set spelllang=de_DE
  set nospell
endif

" options: folding {{{1

if has('folding')
  set foldmethod=syntax
  " fold code by indent
  "set foldmethod=indent
  " but open all (20) folds on startup
  set foldlevelstart=20
  " enable folding for functions, heredocs and if-then-else stuff in sh files.
  let g:sh_fold_enabled=7
endif

" options: satusline and wildmenu {{{1

if has("statusline")
  " many thanks to
  "   http://vim.wikia.com/wiki/Writing_a_valid_statusline
  "   https://wincent.com/wiki/Set_the_Vim_statusline
  "   http://winterdom.com/2007/06/vimstatusline
  "   http://got-ravings.blogspot.com/2008/08/vim-pr0n-making-statuslines-that-own.html

  " some examples
  "set statusline=last\ changed\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}

  " my old versions:
  "set statusline=%t%m%r[%{&ff}][%{&fenc}]%y[ASCII=\%03.3b]%=[%c%V,%l/%L][%p%%]
  "set statusline=%t%m%r[%{&fenc},%{&ff}%Y][ASCII=x%02.2B]%=[%c%V,%l/%L][%P]
  "set statusline=%t[%M%R%H][%{strlen(&fenc)?&fenc:'none'},%{&ff}%Y][ASCII=x%02.2B]%=%{strftime(\"%Y-%m-%d\ %H:%M\")}\ [%c%V,%l/%L][%P]

  " current version
  set statusline=%t                               " tail of the filenam
  set statusline+=\ %([%M%R%H]\ %)                " group with modified, readonly and help indicator
  set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " display fileencoding
  set statusline+=%{&ff}                          " filetype (unix/windows)
  set statusline+=%Y]                             " filetype (c/sh/vim/...)
  set statusline+=\ [ASCII=x%02.2B]               " ASCII code of char
  set statusline+=%=                              " rubber space
  set statusline+=[%{strftime('%a\ %F\ %R')}]     " clock
  set statusline+=\ [%c%V,%l/%L]                  " position in file
  set statusline+=\ [%P]                          " percent of above

  " always display the statusline
  set laststatus=2

  if has("autocmd")
    " change highlighting when mode changes
    au InsertEnter * call InsertStatuslineColor(v:insertmode)
    au InsertLeave * hi statusline guibg=DarkBlue ctermbg=DarkBlue term=reverse
    " default the statusline to green when entering Vim
    highlight statusline guibg=DarkBlue ctermbg=DarkBlue term=reverse
  endif

  if has("wildmenu")
    set wildmenu
  endif

  if has("wildignore")
    set wildmode=longest:full,full
    set wildignore+=.hg,.git,.svn                  " Version control
    set wildignore+=*.aux,*.out,*.toc              " LaTeX intermediate files
    set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " binary images
    set wildignore+=*.sw?                          " Vim swap files
    set wildignore+=*.DS_Store                     " OSX bullshit
    "set wildignore+=*.o,*.obj,*.exe,*.dll,        " compiled object files
    "set wildignore+=*.spl                         " compiled spelling word lists
    "set wildignore+=*.luac                        " Lua byte code
    "set wildignore+=migrations                    " Django migrations
    "set wildignore+=*.pyc                         " Python byte code
    "set wildignore+=*.orig                        " Merge resolution files
  endif

" We do not have the 'statusline' feature. Maybe we can still have a ruler?
elseif has("cmdline_info")
  "show the cursor position all the time (at bottom right)
  set ruler
endif

" options: colorcolumn {{{1

if version >= 703 	" NEW in VIM 7.3
  set colorcolumn=79 	"highlight the background of the 79th column
else
  " this highlights the part of the line which is longer then 78 char in grey
  " (blue in a terminal).
  augroup vimrc_autocmds
    au!
    autocmd BufRead * highlight OverLength ctermbg=blue ctermfg=white
    autocmd BufRead * match OverLength /\%79v.*/
  augroup END
endif

" options: other {{{1
if has('mouse')        | set mouse=a                 | endif
if has('cmdline_info') | set showcmd                 | endif
if has('vertsplit')    | set splitright              | endif
if has('virtualedit')  | set virtualedit=block       | endif
if has('diff')         | set diffopt=filler,vertical | endif
if has('vms')          | set nobackup                | endif

" set colors {{{1
if has('syntax')
  " Are we running on MacVim?
  if has('gui_macvim')
    colorscheme macvim
    " that is 202=#ff5f00, 234=#1c1c1c
    hi Pmenu ctermfg=202 ctermbg=234
    hi PmenuSel ctermfg=234 ctermbg=202
    
  " what is a good alternative colorsheme?
  "else
  endif

  " always set the background of the line nummber
  highlight LineNr ctermbg=black ctermfg=DarkGrey
endif

" plugins: standard {{{1

" 2012-03-01
" These are the builtin plugins which are loaded from the global vim/runtime
" directory:
" - getscriptPlugin.vim
" - gzip.vim
" - matchparen.vim
" - netrwPlugin.vim
" - rrhelper.vim
" - spellfile.vim
" - tarPlugin.vim
" - tohtml.vim
" - vimballPlugin.vim
" - zipPlugin.vim

" getscript {{{
" Should ship with vim, else see
" http://www.vim.org/scripts/script.php?script_id=642
" The file ~/.vim/GetLatest/GetLatestVimScripts.dat contains the instructions
" to load plugins.
" }}}
" netrw {{{
" Should ship with vim.
" TODO: configure with ssh passphrase and netrc file.
" }}}
" matchit {{{
"runtime macros/matchit.vim
" }}}

" plugins: additional: file managing {{{1

" nice {{{2
" testing {{{2
" {{{ winmanager
" http://www.vim.org/scripts/script.php?script_id=95
map <C-w><C-t> :WMToggle<CR> 

" }}}

" lusty-explorer.vim {{{
" http://vim.org/scripts/script.php?script_id=1890
" no help?
" }}}

" vim-fuzzyfinder.zip {{{
" http://vim.org/scripts/script.php?script_id=1984
" requires l9lib (vimscript 3252)
" I can not disable it?

let g:fuf_coveragefile_globPatterns = ['~/.*', '~/*', '~/files/**/.*', '~/files/**/*', '~/.vim/**/.*', '~/.vim/**/*']
nnoremap <C-f> :FufCoverageFile!<CR>
nnoremap <C-b> :FufBuffer!<CR>
nnoremap <C-S-f> :FufCoverageFile<CR>
nnoremap <C-S-b> :FufBuffer<CR>
inoremap <C-f> <ESC>:FufCoverageFile!<CR>
inoremap <C-S-f> <ESC>:FufCoverageFile<CR>
inoremap <C-b> <ESC>:FufBuffer!<CR>
inoremap <C-S-b> <ESC>:FufBuffer<CR>

" }}}

" disabled {{{2
" nerdtree.zip {{{
" http://vim.org/scripts/script.php?script_id=1658
" disable loading for the moment
let loaded_nerd_tree = 1
" }}}

" tselectbuffer.vba {{{
" http://vim.org/scripts/script.php?script_id=1866
" needs tlib >= 0.40
" disable loading for the moment
let loaded_tselectbuffer = 1
" }}}

" command-t.vba {{{
" http://vim.org/scripts/script.php?script_id=3025
let g:command_t_loaded = 1
" }}}


" plugins: additional: buffer managing {{{1

" nice {{{2

" buftabs.vim {{{
" http://vim.org/scripts/script.php?script_id=1664
" no help / can not disable it / quite nice
let g:buftabs_marker_modified = '+'
let g:buftabs_only_basename = 1
"let g:buftabs_in_statusline=1
"set statusline=%=buffers:\ %{buftabs#statusline()}
" }}}

" testing {{{2

" buffet.vim {{{
" http://vim.org/scripts/script.php?script_id=3896
" no help?
" I can not disable it!
" }}}

" qbuf.vim {{{
" http://vim.org/scripts/script.php?script_id=1910
" no help
" bad coding style -> can not dissable it.
"buggy ? 
let g:qb_hotkey = '<F3>'

" }}}

" incbufswitch.vim {{{
" http://vim.org/scripts/script.php?script_id=685
" no help
" can not dissable it. 
" the plugin does only match buffers against the start
" of the buffer name ... (not so nice)
" }}}

" buflist.vim {{{
" http://vim.org/scripts/script.php?script_id=1011
" no help
" can not dissable.
" }}}

" bufexplorer.zip {{{
" http://vim.org/scripts/script.php?script_id=42
" integrates with winmanager.vim
" }}}

" disabled {{{2

" qnamebuf.zip {{{
" http://vim.org/scripts/script.php?script_id=3217
let g:qnamebuf_loaded = 1
let g:qnamefile_loaded = 1
" }}}

" vim-buffergator.tar.gz {{{
" http://vim.org/scripts/script.php?script_id=3619
let g:did_buffergator = 1
" }}}

" bufmru.vim {{{
" http://vim.org/scripts/script.php?script_id=2346
" no help
let loaded_bufmru = 1
" }}}

" lusty-juggler.vim {{{
" http://vim.org/scripts/script.php?script_id=2050
" no help
let g:loaded_lustyjuggler = 1
" }}}

" bufferlist.vim {{{
" http://vim.org/scripts/script.php?script_id=1325
let g:BufferListLoaded = 1
" }}}


" plugins: additional: LeTeX {{{1

" my private enhencements
autocmd BufNewFile,BufRead *.tex setlocal dictionary+=*.bib

" {{{ PLUGIN LaTeX-Suite: 

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
"let g:Tex_CompileRule_pdf='latexmk -silent -pv -pdf $*'
let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode $*'
let Tex_UseMakefile=1
let g:Tex_ViewRule_pdf='open -a Preview'

"dont use latexsuite folding
let Tex_FoldedEnvironments=''
let Tex_FoldedMisc=''
let Tex_FoldedSections=''

" }}} LaTeX-Suite
" {{{ PLUGIN AutomaticLaTexPlugin
" http://www.vim.org/scripts/script.php?script_id=2945

" }}}
" {{{ PLUGIN auctex.vim
" http://www.vim.org/scripts/script.php?script_id=162

" }}}
" {{{ PLUGIN tex_autoclose
" http://www.vim.org/scripts/script.php?script_id=920

" }}}
" {{{ PLUGIN tex9
" http://www.vim.org/scripts/script.php?script_id=3508

" }}}

" plugins: additional: tags {{{1

" taglist {{{
" http://www.vim.org/scripts/script.php?script_id=273 
let Tlist_Auto_Update = 0
let Tlist_Close_On_Select = 1
let Tlist_Display_Prototype = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth = 75
let Tlist_Show_Menu = 1
map <silent> <F4> :TlistToggle<CR>
au BufEnter *.tex let Tlist_Ctags_Cmd = expand('~/.vim/ltags')
au BufLeave *.tex let Tlist_Ctags_Cmd = 'ctags'
" }}}

" {{{ Ctags and Cscope
" always search for a tags file from $PWD down to '/'.
set tags=./tags,tags;/

" this function is used if no Cscope support is available or no database
" found.
function! s:ctag_fallback()
  " run ``ctags **/.*[ch]'' to produce the file ``tags''.
  " these headers are used: http://www.vim.org/scripts/script.php?script_id=2358
  set tags+=~/.vim/tags/usr_include.tags
  set tags+=~/.vim/tags/usr_include_cpp.tags
  set tags+=~/.vim/tags/usr_local_include.tags
  set tags+=~/.vim/tags/usr_local_include_boost.tags
  set tags+=~/.vim/tags/cpp.tags
endfunction

" try to use Cscope
if has("cscope")
  set nocsverb
  if has('quickfix') | set cscopequickfix=s-,c-,d-,i-,t-,e- | endif
  " search cscope database first (1 = ``tags first'')
  set cscopetagorder=0
  set cscopetag
  " {{{ these lines are copied from
  " http://cscope.sourceforge.net/cscope_maps.vim and modified by me. Many
  " thanks to the Cscope guys. 
  " The commands are defided into three prefixes:
  "
  " 	CTRL-_		show querry in current window
  " 	CTRL-@		show querry in horizontal split
  " 	CTRL-@ CTRL-@	show querry in vertival split
  "
  " (NOTE: CTRL-@ can also be typed as CTRL-<SPACE>
  " The querry is determind by the last character of the map. Like this:
  "
  " 	's'   symbol: find all references to the token under cursor
  " 	'g'   global: find global definition(s) of the token under cursor
  " 	'c'   calls:  find all calls to the function name under cursor
  " 	't'   text:   find all instances of the text under cursor
  " 	'e'   egrep:  egrep search for the word under cursor
  " 	'f'   file:   open the filename under cursor
  " 	'i'   includes: find files that include the filename under cursor
  " 	'd'   called: find functions that function under cursor calls
  nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
  nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
  nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
  nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	
  nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
  nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
  nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>  
  " End of http://cscope.sourceforge.net/cscope_maps.vim stuff }}}
  if filereadable("cscope.out")
    cscope add cscope.out
  elseif $CSCOPE_DB != ""
    cscope add $CSCOPE_DB
  else
    " no database so use Ctags instead (unset cscope options)
    call s:ctag_fallback()
    set nocscopetag
  endif
  set cscopeverbose
else
  "call s:ctag_falback()
endif

" extend ctags to work with latex
let tlist_tex_settings='latex;b:bibitem;c:command;l:label'

" }}}

" plugins: additional: misc {{{1

" manpageview {{{
" display manpages in a vertical split (other options 'only', 'hsplit',
" 'vsplit', 'hsplit=', 'vsplit=', 'reuse')
let g:manpageview_winopen = 'reuse'
" }}}
"{{{ hints_man
" http://www.vim.org/scripts/script.php?script_id=1825
" http://www.vim.org/scripts/script.php?script_id=1826
autocmd FileType c,cpp setlocal cmdheight=2
"}}}
"{{{ omnicppcomplete
"http://www.vim.org/scripts/script.php?script_id=1520
if version >= 7
  " OmniCompletion see ``:help compl-omni''
  " thanks to http://vim.wikia.com/wiki/C%2B%2B_code_completion
  let OmniCpp_NamespaceSearch = 1
  let OmniCpp_GlobalScopeSearch = 1
  let OmniCpp_ShowAccess = 1
  let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
  let OmniCpp_MayCompleteDot = 1 " autocomplete after .
  let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
  let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
  let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
  " automatically open and close the popup menu / preview window
  au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
  set completeopt=menu,longest,preview
  imap <C-TAB> <C-x><C-o>
endif
"}}}
