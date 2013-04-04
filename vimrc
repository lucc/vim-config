" file:    ~/.vimrc                                                       {{{1
" author:  luc
" credits: Many thanks to Bram Moolenaar <Bram@Vim.org> for the excellent
"          example vimrc
" vi: set foldmethod=marker spelllang=en:
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" start (things to do first) {{{1

" Use Vim settings, rather then Vi settings (much better!).  This must be
" first, because it changes other options as a side effect.
set nocompatible

" Do not load many of the GUI menus.  This has to happen before 'syntax on'
" and 'filetype ...'
set guioptions+=M

" syntax and filetype {{{
if has('syntax')

  " Switch syntax highlighting on, when the terminal has colors
  " check for colours in terminal (echo &t_Co)
  if &t_Co > 2 || has("gui_running")
    syntax enable
  endif

  " Enable file type detection and language-dependent indenting.
  if has('autocmd')
    filetype plugin indent on
  endif

endif

" user defined variables {{{1

let s:notes = '~/.vim/notes'
let mapleader = ','
let s:braces_stack = []
let s:path = [
      \ '.abook',
      \ '.config',
      \ '.emacs.d',
      \ '.env',
      \ '.local',
      \ '.mutt',
      \ '.NetBeansProjects',
      \ '.pentadactyl',
      \ '.postfix',
      \ '.shell',
      \ '.ssh',
      \ '.vim',
      \ 'apply',
      \ 'art',
      \ 'bin',
      \ 'cook',
      \ 'dsa',
      \ 'etc',
      \ 'go',
      \ 'leh',
      \ 'lit',
      \ 'log',
      \ 'phon',
      \ 'sammersee',
      \ 'schule',
      \ 'src',
      \ 'uni',
      \ 'zis',
      \ ]
let s:path = split(join(map(s:path, 'glob("~/" . v:val)')))
call map(s:path, 'v:val . "/**"')

" user defined functions {{{1
function! LucFindBaseDir() "{{{2
  let indicator_files = [
                      \ 'makefile',
                      \ 'build.xml',
                      \ ]
  let matches = []
  let path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let cwd = getcwd()
  while ! empty(path)
    let dir = '/' . join(path, '/')
    for file in indicator_files
      if filereadable(dir . '/' . file)
	call add(matches, [dir, file])
      endif
    endfor
    if dir == cwd
      if empty(matches) || matches[-1][0] != cwd
	call add(matches, [cwd, ''])
      endif
    endif
    unlet path[-1]
  endwhile
  let path = split(cwd, '/')
  while ! empty(path)
    let dir = '/' . join(path, '/')
    for file in indicator_files
      if filereadable(dir . '/' . file)
	call add(matches, [dir, file])
      endif
    endfor
    if dir == cwd
      if empty(matches) || matches[-1][0] != cwd
	call add(matches, [cwd, ''])
      endif
    endif
    unlet path[-1]
  endwhile
  if empty(matches)
    call add(matches, ['/', ''])
  endif
  if len(matches) == 1
    return matches[0][0]
  endif
  " not optimal jet:
  return matches[0][0]
endfunction

function! LucSearchStringForURI(string) "{{{2
  " function to find an URI in a string
  " thanks to
  " http://vim.wikia.com/wiki/Open_a_web-browser_with_the_URL_in_the_current_line
  return matchstr(a:string, '[a-z]\+:\/\/[^ >,;:]\+')
  " alternatives:
  "return matchstr(a:string, '\(http://\|www\.\)[^ ,;\t]*')
  "return matchstr(a:string, '[a-z]*:\/\/[^ >,;:]*')
endfunction

function! LucHandleURI(uri) "{{{2
  " function to find an URI on the current line and open it.
  
  " first find a browser
  let browser = ''
  let choises = [expand($BROWSER), 'elinks', 'links', 'w3m', 'lynx', 'wget', 'curl', '']
  if has('gui_macvim')
    " this only works on Mac OS X
    let browser = 'open'
  else
    for browser in choises
      if executable(browser) | break | endif
    endfor
  endif

  " without browser or uri, bail out
  if browser == '' || a:uri == ''
    echoerr "Can't find a suitable browser or URI."
    return
  endif

  " everything set: open the uri
  echo 'Visiting' a:uri '...'
  silent execute '!' browser shellescape(a:uri)
endfunction

function! LucInsertStatuslineColor(mode) "{{{2
  " function to change the color of the statusline depending on the mode
  " this version is from
  " http://vim.wikia.com/wiki/Change_statusline_color_to_show_insert_or_normal_mode
  if     a:mode == 'i'
    highlight StatusLine guibg=DarkGreen   ctermbg=DarkGreen
  elseif a:mode == 'r'
    highlight StatusLine guibg=DarkMagenta ctermbg=DarkMagenta
  elseif a:mode == 'n'
    highlight StatusLine guibg=DarkBlue    ctermbg=DarkBlue
  else
    highlight statusline guibg=DarkRed     ctermbg=DarkRed
  endif
endfunction

function! LucFindNextSpellError() "{{{2
  " A function to jump to the next spelling error
  setlocal spell
  "if spellbadword(expand('<cword>')) == ['', '']
    normal ]s
  "endif
endfunction

function! LucVisitBufferOrEditFile(name) "{{{2
  " A function to check if a file was already loaded into some buffer.
  " Depending if it was the function either switches to that buffer or
  " executes ':edit ' on the filename.
  if match(expand(a:name), '/') == -1
    let a:name = getcwd() . '/' . a:name
  endif
  execute (bufexists(expand(a:name)) ? 'buffer ' : 'edit ') . expand(a:name)
endfunction

function! LucInitiateSession(load_old_session) "{{{2
  " A function to source a session file and set up an autocommand which will
  " automatically save the session again, when vim is quit.
  let l:session = '~/.vim/Session.vim'
  if a:load_old_session
    execute 'source' l:session
    silent execute '!rm -f' l:session
  endif
  augroup LucSession
    autocmd!
    execute 'autocmd VimLeave * mksession!' l:session
  augroup END
  if argc() | argdelete * | endif
  redraw!
endfunction

function! LucQuickMake(target, override) "{{{2
  " Try to build stuff depending on some parameters.  What will be built is
  " decided by a:target and if absent the current file.  First a makefile is
  " searched for in the directory %:h and above.  If one is found it is used
  " to make a:target.  If no makefile is found and filetype=tex, the current
  " file will be compiled with latexmk.  If a:override is non zero only
  " latexmk will be executed and no makefile will be searched.

  " local variables
  let cmd   = ''
  let error = 0
  let path  = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let dir   = ''
  " try to find a makefile and set dir and cmd
  while ! empty(path)
    let dir = '/' . join(path, '/')
    if filereadable(dir . '/makefile') || filereadable(dir . '/Makefile')
      let cmd = 'make ' . a:target
      let path = []
    else
      unlet path[-1]
    endif
  endwhile

  " if no makefile was found or override was asked for try to use latex
  if a:override || cmd == '' && &filetype == 'tex' && a:target == ''
    let dir = expand('%:h')
    let cmd = 'latexmk -silent ' . expand('%:t')
  endif

  " execute the command in the proper directory
  if cmd == ''
    echoerr 'No makefile found.'
    let error = 1
  else
    execute 'cd' dir
    echo 'Executing' cmd 'in' fnamemodify(getcwd(), ':~') '...'
    silent execute '!' cmd '&'
    cd -
    if v:shell_error
      echoerr 'Make returned ' . v:shell_error . '.'
    endif
    let error = ! v:shell_error
  endif

  " return shell errors
  return error
endfunction

function! LucCheckIfBufferIsNew(...) "{{{2
  " check if the buffer with number a:1 is new.  That is to say, if it as
  " no name and is empty.  If a:1 is not supplied 1 is used.
  " find the buffer nr to check
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

" see:
"http://vim.wikia.com/wiki/Making_Parenthesis_And_Brackets_Handling_Easier
"
"function! LucManageBracesStack(typed) "{{{2
"  " This function handles the b:braces_stack variables. It is intendet to
"  " mange the brackets for the user.
"  if a:typed == ''
"    return
"  elseif a:typed =~ '[[({<]'
"    let l:matching = (a:typed == '(' ? ')' : (a:typed == '[' ? ']' : (a:typed == '{' ? '}' : (a:typed == '<' ? '>' : ''))))
"    if l:matching == ''
"      " not good
"    else
"      call add(b:braces_stack, l:matching)
"    endif
"  elseif a:typed == '[])}>'
"    if a:typed == b:braces_stack[-1]
"      execute 'normal i<BS><ESC>x/' . a:typed . '<CR>a'
"      unlet b:braces_stack[-1]
"    else
"      "not ok
"    endif
"  else
"    "not good
"  endif
"endfunction
  
function! LucRemoteEditor(mail) "{{{2
  " a function to be called by a client who wishes to use a vim server as an
  " non forking edior. One can also set the environment variable EDITOR with
  " EDITOR='vim --remote-tab-wait-silent +call\ LucRemoteEditor()'
  let abbreviate = 'cnoreabbrev <buffer>'
  let quit = 'confirm bdelete'
  let forcequit = 'bdelete!'
  let hide = 'silent call system("osascript -e \"tell application \\\"Finder\\\" to set visible of process \\\"MacVim\\\" to false\"")'
  let quitandhide = quit . '<bar>' . hide . '<bar> redraw'
  let forcequitandhide = forcequit . '<bar>' . hide . '<bar> redraw'
  let write = 'write'
  let update = 'update'
  execute abbreviate 'q'                          quitandhide
  "execute abbreviate 'q!'                    forcequitandhide
  execute abbreviate 'qu'                         quitandhide
  "execute abbreviate 'qu!'                   forcequitandhide
  execute abbreviate 'qui'                        quitandhide
  "execute abbreviate 'qui!'                  forcequitandhide
  execute abbreviate 'quit'                       quitandhide
  "execute abbreviate 'quit!'                 forcequitandhide
  execute abbreviate 'wq'   write  '<bar>'        quitandhide
  execute abbreviate 'x'    update '<bar>'        quitandhide
  execute abbreviate 'xi'   update '<bar>'        quitandhide
  execute abbreviate 'xit'  update '<bar>'        quitandhide
  execute abbreviate 'exi'  update '<bar>'        quitandhide
  execute abbreviate 'exit' update '<bar>'        quitandhide
  execute 'nnoremap <buffer> ZZ :update<bar>'     quitandhide . '<CR>'
  execute 'nnoremap <buffer> ZQ :bdelete!<bar>' hide . '<CR>'
  execute 'nnoremap <buffer> <c-w><c-q>' ':' . quitandhide . '<CR>'
  execute 'nnoremap <buffer> <c-w>q'     ':' . quitandhide . '<CR>'
  if a:mail == 1
    /^$
    redraw!
  endif
endfunction

function! LucEditAllBuffers() "{{{2
  let current = bufnr('%')
  let alternative = bufnr('#')
  bufdo edit
  if bufexists(alternative)
    execute 'buffer' alternative
  endif
  if bufexists(current)
    execute 'buffer' current
  endif
endfunction

function! LucTexDocFunction() "{{{2
  let l:word = expand("<cword>")
  silent execute '!texdoc' l:word
endfunction
" user defined autocommands {{{1

augroup LucLatex "{{{2
  autocmd!
  autocmd BufNewFile,BufRead *.tex setlocal dictionary+=*.bib
  autocmd BufNewFile,BufRead *.tex nmap <buffer> g<C-g> :!texcount -nosub %<CR>
  autocmd BufNewFile,BufRead *.tex nmap <buffer> K :call LucTexDocFunction()<CR>
augroup END

augroup LucNotesFile "{{{2
  " load a notes/scratch buffer which will be saved automatically.
  autocmd!
  " use the variable in the autocommands
  execute 'au BufEnter' s:notes 'setlocal bufhidden=hide'
  execute 'au BufDelete,BufHidden,BufLeave,BufUnload,FocusLost' s:notes 'up'
augroup END

augroup LucTodoFile "{{{2
  autocmd!
  autocmd BufRead,BufNewFile,BufNew,BufEnter ~/TODO normal zM
  autocmd BufRead,BufNewFile,BufNew,BufEnter ~/TODO nmap <buffer> <down> zj
  autocmd BufRead,BufNewFile,BufNew,BufEnter ~/TODO nmap <buffer> <up> zk
  autocmd CursorMoved, ~/TODO normal zx
augroup END

augroup LucSession "{{{2
  autocmd!
  "autocmd VimEnter * if bufname('%') == '' && bufnr('%') == 1 | bwipeout 1 | silent edit | silent redraw | endif
  autocmd VimEnter * if LucCheckIfBufferIsNew(1) | bwipeout 1 | doautocmd BufRead,BufNewFile | endif
augroup END

augroup LucPython "{{{2
  autocmd!
  autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4
augroup END

augroup LucJava "{{{2
  autocmd Filetype java setlocal omnifunc=javacomplete#Complete
  autocmd Filetype java setlocal makeprg=cd\ %:h\ &&\ javac\ %:t
augroup END

augroup LucMail "{{{2
  autocmd FileType mail setlocal textwidth=72
augroup END

augroup LucLocalWindowCD "{{{2
  " FIXME: still buggy
  autocmd BufWinEnter,WinEnter,BufNew,BufRead,BufEnter * execute 'lcd' LucFindBaseDir()
augroup END

" user defined commands and mappings {{{1

" editing {{{2

" make Y behave like D,S,C ...
nmap Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" easy spell checking
inoremap <C-s> <C-o>:call LucFindNextSpellError()<CR><C-x><C-s>
nnoremap <C-s>      :call LucFindNextSpellError()<CR>z=

" TODO: is this usefull?
"inoremap ( ()<++><ESC>F)i
"inoremap [ []<++><ESC>F]i
"inoremap { {}<++><ESC>F}i
"autocmd BufNew,BufNewFile,BufRead * let b:braces_stack = []
"inoremap ( ()<esc>:call LucManageBracesStack('(')<cr>
"inoremap [ []<esc>:call LucManageBracesStack('[')<cr>
"inoremap { {}<esc>:call LucManageBracesStack('{')<cr>
"inoremap < <><esc>:call LucManageBracesStack('<')<cr>
"inoremap ) )<esc>:call LucManageBracesStack(')')<cr>
"inoremap ] ]<esc>:call LucManageBracesStack(']')<cr>
"inoremap } }<esc>:call LucManageBracesStack('}')<cr>
"inoremap > ><esc>:call LucManageBracesStack('>')<cr>

" web {{{2
" functions to open URLs
nmap <Leader>w :call LucHandleURI(LucSearchStringForURI(getline('.')))<CR>

" find a script on vim.org by id or name
nmap <Leader>v :call LucHandleURI('http://www.vim.org/scripts/script.php?script_id=' . matchstr(matchstr(expand('<cword>'), '[0-9]\+[^0-9]*$'), '^[0-9]*'))<CR>

" easy compilation {{{2
nmap <F2> :silent update <BAR> call LucQuickMake('', 0)<CR>
imap <F2> <C-O>:silent update <BAR> call LucQuickMake('', 0)<CR>
nmap <silent> <D-F2> :silent update <BAR> call LucQuickMake('', 1)<CR>
imap <silent> <D-F2> <C-O>:silent update <BAR> call LucQuickMake('', 1)<CR>

" move between tabs {{{2
nmap <C-Tab> gt
imap <C-Tab> <C-O>gt
nmap <C-S-Tab> gT
imap <C-S-Tab> <C-O>gT

" misc {{{2

" use ß to clear the screen if you want privacy for a moment
nmap ß :!clear<CR>

" visit a hidden "notes" buffer
execute 'nmap <C-w># :call LucVisitBufferOrEditFile("' . s:notes . '")<CR>'

"command! -bar -bang Session silent call LucInitiateSession(len('<bang>'))

" From the .vimrc example file:
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
"command! DiffOrig vne | se bt=nofile | r # | 0d_ | difft | wincmd p | difft

" options: TODO {{{1

"set transparency=15
"set foldcolumn=2

" options: basic {{{1

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set backup 
set hidden
set history=1000
set confirm
" set the path for file searching
set path=.
set path+=~/
execute 'set path+=' . join(s:path, ',')
set path+=/usr/include/
set path+=/usr/local/include/
set path+=/usr/lib/wx/include/
set path+=/usr/X11/include/
set path+=/opt/X11/include/
set textwidth=78
set shiftwidth=2
set background=light
" break text and comments but do not reformat lines where no input occures
set formatoptions+=nr
set number
" scroll when the courser is 5 lines from the border line
set scrolloff=5
set shortmess=
set nostartofline
set encoding=utf-8
set switchbuf=useopen

" options: searching {{{1
set ignorecase
set smartcase
if has('extra_search')
  " highlight the last used search pattern.
  set hlsearch
  " incremental search
  set incsearch
endif

" options: spellchecking {{{1

if has('syntax')
  " on Mac OS X the spellchecking files are in:
  " /Applications/editoren/Vim.app/Contents/Resources/vim/runtime/spell
  set spelllang=de
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

if has('statusline')
  " many thanks to
  "   http://vim.wikia.com/wiki/Writing_a_valid_statusline
  "   https://wincent.com/wiki/Set_the_Vim_statusline
  "   http://winterdom.com/2007/06/vimstatusline
  "   http://got-ravings.blogspot.com/2008/08/

  " some examples
  "set statusline=last\ changed\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}

  " my old versions:
  "set statusline=%t%m%r[%{&ff}][%{&fenc}]%y[ASCII=\%03.3b]%=[%c%V,%l/%L][%p%%]
  "set statusline=%t%m%r[%{&fenc},%{&ff}%Y][ASCII=x%02.2B]%=[%c%V,%l/%L][%P]
  "set statusline=%t[%M%R%H][%{strlen(&fenc)?&fenc:'none'},%{&ff}%Y]
  "set statusline+=[ASCII=x%02.2B]%=%{strftime(\"%Y-%m-%d\ %H:%M\")}
  "set statusline+=\ [%c%V,%l/%L][%P]

  " current version
  set statusline=%t                               " tail of the filename
  set statusline+=\ %([%M%R%H]\ %)                " group for mod., ro. & help
  set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " display fileencoding
  set statusline+=%{&ff}                          " filetype (unix/windows)
  set statusline+=%Y]                             " filetype (c/sh/vim/...)
  set statusline+=\ [ASCII=x%03B]                 " ASCII code of char
  "set statusline+=\ [ASCII=x%02.2B]               " ASCII code of char
  set statusline+=\ %=                            " rubber space
  set statusline+=[%{strftime('%a\ %F\ %R')}]     " clock
  set statusline+=\ [%c%V,%l/%L]                  " position in file
  set statusline+=\ [%P]                          " percent of above
  "set statusline+=\ %{SyntasticStatuslineFlag()}  " see :h syntastic

  " always display the statusline
  set laststatus=2

  if has('autocmd')
    " change highlighting when mode changes
    augroup LucStatusLine
      autocmd!
      autocmd InsertEnter * call LucInsertStatuslineColor(v:insertmode)
      autocmd InsertLeave * call LucInsertStatuslineColor('n')
    augroup END
    " now we set the colors for the statusline
    " in the most simple case
    highlight StatusLine term=reverse
    " for color terminal
    highlight StatusLine cterm=bold,reverse
    highlight StatusLine ctermbg=1
    " for the gui
    "highlight StatusLine gui=bold
    highlight StatusLine guibg=DarkBlue
    highlight StatusLine guifg=background
  endif

  if has('wildmenu')
    set wildmenu
  endif

  if has('wildignore')
    set wildmode=longest:full,full
    set wildignore+=.hg,.git,.svn                  " Version control
    set wildignore+=*.aux,*.out,*.toc              " LaTeX intermediate files
    set wildignore+=*.fdb_latexmk                  " LaTeXmk files
    set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " binary images
    set wildignore+=*.sw?                          " Vim swap files
    set wildignore+=*.DS_Store                     " OSX bullshit
    "set wildignore+=*.o,*.obj,*.exe,*.dll,        " compiled object files
    "set wildignore+=*.spl                         " compiled spell word lists
    "set wildignore+=*.luac                        " Lua byte code
    "set wildignore+=migrations                    " Django migrations
    "set wildignore+=*.pyc                         " Python byte code
    "set wildignore+=*.orig                        " Merge resolution files
  endif

" We do not have the 'statusline' feature. Maybe we can still have a ruler?
elseif has('cmdline_info')
  "show the cursor position all the time (at bottom right)
  set ruler
endif

" we could do something similar for tabs.
" see :help 'tabline'
"set tabline=Tabs:\ %{tabpagenr('$')}\ Buffers:\ %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))}%=%{strftime('%a\ %F\ %R')}

" options: colorcolumn {{{1

if version >= 703 	" NEW in VIM 7.3
  set colorcolumn=79 	"highlight the background of the 79th column
else
  " this highlights the part of the line which is longer then 78 char in grey
  " (blue in a terminal).
  augroup LucOverlength
    autocmd!
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
if has('mksession')
  " default: blank,buffers,curdir,folds,help,options,tabpages,winsize
  set sessionoptions+=resize,winpos
endif
if has('viminfo')
  " default: '100,<50,s10,h
  set viminfo='100,<50,s10,h,%
  " the flag ' is for filenames for marks
  set viminfo='100
  " the flag < is the nummber of lines saved per register
  set viminfo+=<50
  " max size saved for registers in kb
  set viminfo+=s10
  " disable hlsearch
  set viminfo+=h
  " remember buffer list
  set viminfo+=%
  " name of the viminfo file
  set viminfo+=n~/.vim/viminfo
  " load a static viminfo file with a file list
  rviminfo ~/.vim/default-buffer-list.viminfo
endif

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

  " always set the background of the line number
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

" getscript 642 {{{2
" Should ship with vim.  The file ~/.vim/GetLatest/GetLatestVimScripts.dat
" contains the instructions to load plugins.

" netrw {{{2
" Should ship with vim.
" TODO: configure with ssh passphrase and netrc file.

" matchit {{{2
"runtime macros/matchit.vim

" plugins: additional: file managing {{{1

" nice {{{2

" vim-fuzzyfinder.zip 1984 {{{3
" requires l9lib (vimscript 3252)
" I can not disable it?

let g:fuf_modesDisable = [ 'directory', 'mrufile', 'mrucmd', 'bookmarkdir', 'taggedfile', 'jumplist', 'changelist', 'lines', 'givenfile', 'givendirectory', 'givencommand', 'callbackfile', 'callbackitem' ]
let g:fuf_enumeratingLimit = 20
let g:fuf_coveragefile_globPatterns = ['~/.*', '~/*']
let g:fuf_dataDir = '~/.vim/fuf-data'
let s:fuf_cov = extend(map(copy(s:path), 'v:val . "/.*"'), map(copy(s:path), 'v:val . "/*"'))
call extend(g:fuf_coveragefile_globPatterns, s:fuf_cov)
nnoremap <silent> <C-f> :silent FufCoverageFile<CR>
nnoremap <silent> <C-b> :silent FufBuffer<CR>
nnoremap <silent> <C-h> :silent FufHelp<CR>
inoremap <silent> <C-f> <ESC>:silent FufCoverageFile<CR>
inoremap <silent> <C-b> <ESC>:silent FufBuffer<CR>
inoremap <silent> <C-h> <ESC>:silent FufHelp<CR>
augroup LucFufMaps
  autocmd FileType fuf inoremap <buffer> <C-I> <C-N>
augroup END

" testing {{{2

" winmanager 95 {{{3
" seems to be abondend since 2002 there is a patch at script_id=1440
"map <C-w><C-t> :WMToggle<CR> 
nmap <leader>a :WMToggle<cr>

" lusty-explorer.vim 1890 {{{3
" help inside script: ~/.vim/plugin/lusty-explorer.vim
" disable mappings
let g:LustyExplorerDefaultMappings = 0
" available commands
"   :LustyFilesystemExplorer [optional-path]
"   :LustyFilesystemExplorerFromHere
"   :LustyBufferExplorer
"   :LustyBufferGrep
" nice!!
nmap <leader>b :LustyFilesystemExplorer<cr>
" nearly the same as "WMToggle" but has preview option
nmap <leader>c :LustyBufferExplorer<cr>

" nerdtree.zip 1658 {{{3
" is only checked for existenc
"let loaded_nerd_tree = 1
let NERDChristmasTree = 1
let NERDTreeHijackNetrw = 1
nmap <leader>d :NERDTreeToggle<cr>

" tselectbuffer.vba 1866 {{{3
" needs tlib >= 0.40
" disable loading for the moment
"let loaded_tselectbuffer = 0
nmap <leader>e :TSelectBuffer<cr>

" command-t.vba 3025 {{{3
"let g:command_t_loaded = 0
let g:CommandTMaxCachedDirectories = 1
let g:CommandTScanDotDirectories = 1
let g:CommandTMatchWindowReverse = 1
" buggy ??
nmap <leader>f :CommandT<cr>

" plugins: additional: buffer managing {{{1

" nice {{{2

" buftabs.vim 1664 {{{3
" no help / can not disable it / quite nice
let g:buftabs_marker_modified = '+'
let g:buftabs_only_basename = 1
"let g:buftabs_in_statusline=1
"set statusline=%=buffers:\ %{buftabs#statusline()}
" i moved this into ~/.vim/do_not_load/

" testing {{{2

" buffet.vim 3896 {{{3
" no help?
" I can not disable it!
nmap <leader>g :Bufferlist<CR>

" qbuf.vim 1910 {{{3
" no help
" bad coding style -> can not dissable it.
"buggy ? 
"but the htky does something interesting :)
let g:qb_loaded = 0
let g:qb_hotkey = '<leader>h'

" qnamebuf.zip 3217 {{{3
let g:qnamebuf_loaded = 0
let g:qnamefile_loaded = 0
" this will not help
let qnamebuf_hotkey = '<leader>i'
let qnamefile_hotkey = '<leader>j'

" incbufswitch.vim 685 {{{3
" no help
" the plugin does only match buffers against the start
" of the buffer name ... (not so nice)
" moved to ~/.vim/do_not_load/

" buflist.vim 1011 {{{3
" no help
" can not customize mapping. unconditionally maps <F4>
" moved to ~/.vim/do_not_load/

" bufexplorer.zip 42 {{{3
" integrates with winmanager.vim

" disabled {{{2

" vim-buffergator.tar.gz 3619 {{{3
" browse buffers with preview, switch to window containing this buffer or
" display buffer in last window
let g:did_buffergator = 0
let g:buffergator_suppress_keymaps = 1
nmap <Leader>k :BuffergatorToggle<CR>

" bufmru.vim 2346 {{{3
" no help
" is only checked for existenc
"let loaded_bufmru = 1
let g:bufmru_switchkey = '<leader>l'
" seems buggy

" lusty-juggler.vim 2050 {{{3
" no help
" is checked for existenc only
"let g:loaded_lustyjuggler = 0
let g:LustyJugglerDefaultMappings = 0

" bufferlist.vim 1325 {{{3
" is only checked for existenc
"let g:BufferListLoaded = 0
" does not need a mapping: 
nmap <leader>m :call Bufferlist()<cr>

" plugins: additional: LeTeX {{{1

" my private enhencements
augroup LucLatex
  autocmd!
  autocmd BufNewFile,BufRead *.tex setlocal dictionary+=*.bib
  autocmd BufNewFile,BufRead *.tex nmap <buffer> K :call LucTexDocFunction()<CR>
augroup END

" {{{2 PLUGIN LaTeX-Suite: 

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
let Tex_FoldedEnvironments.='*'

" compiling with \ll
let g:Tex_CompileRule_pdf='latexmk -silent -pv -pdf $*'
"let g:Tex_CompileRule_pdf='pdflatex -interaction=nonstopmode $*'
let Tex_UseMakefile=1
let g:Tex_ViewRule_pdf='open -a Preview'

"dont use latexsuite folding
"let Tex_FoldedEnvironments=''
"let Tex_FoldedMisc=''
"let Tex_FoldedSections=''

" don't use LaTeX-Suite menus
let g:Tex_Menus=0
"let g:Tex_UseUtfMenus=1

" {{{2 PLUGIN AutomaticLaTexPlugin
" http://www.vim.org/scripts/script.php?script_id=2945
" {{{2 PLUGIN auctex.vim
" http://www.vim.org/scripts/script.php?script_id=162
" {{{2 PLUGIN tex_autoclose
" http://www.vim.org/scripts/script.php?script_id=920
" {{{2 PLUGIN tex9
" http://www.vim.org/scripts/script.php?script_id=3508

" plugins: additional: tags {{{1

" taglist {{{2
" http://www.vim.org/scripts/script.php?script_id=273 
"let Tlist_Auto_Highlight_Tag        = 
"let Tlist_Auto_Open                 = 
let Tlist_Auto_Update               = 1
let Tlist_Close_On_Select           = 1
let Tlist_Compact_Format            = 1
"let Tlist_Ctags_Cmd                 = 
let Tlist_Display_Prototype         = 1
"let Tlist_Display_Tag_Scope         = 
"let Tlist_Enable_Fold_Column        = 
let Tlist_Exit_OnlyWindow           = 1
let Tlist_File_Fold_Auto_Close      = 1
let Tlist_GainFocus_On_ToggleOpen   = 1
"let Tlist_Highlight_Tag_On_BufEnter = 
"let Tlist_Inc_Winwidth              = 
"let Tlist_Max_Submenu_Items         = 
"let Tlist_Max_Tag_Length            = 
"let Tlist_Process_File_Always       = 
"let Tlist_Show_Menu                 = 1
"let Tlist_Show_One_File             = 
"let Tlist_Sort_Type                 = 
"let Tlist_Use_Horiz_Window          = 
let Tlist_Use_Right_Window          = 1
"let Tlist_Use_SingleClick           = 
"let Tlist_WinHeight                 = 
let Tlist_WinWidth                  = 75

" Extend ctags to work with latex
"""""""""""""""""""""""""""""""""
" This is strongly dependent on the file ~/.ctags and the definitions therein.
" See ctags(1) for a description of the format.
" The variable tlist_tex_settings is a semicolon separated list of key:val
" pairs. The first item is no such pair but only the language name used by
" ctags. The key is a single letter used by ctags as "kind" of the tag, the
" val is a word used by tlist to categorice the tags in the tlist window.
"let tlist_tex_settings='tex;b:bibitem;c:command;l:label;s:sections;t:subsections;u:subsubsections'
"let tlist_tex_settings='tex;c:chapters;s:sections;u:subsections;b:subsubsections;p:parts;P:paragraphs;G:subparagraphs'
let tlist_tex_settings='latex;s:structure;g:graphic+listing;l:label;r:ref;b:bib'

nmap <silent> <F4> :TlistToggle<CR>
"augroup LucTagList
"  autocmd!
"  autocmd BufEnter *.tex let Tlist_Ctags_Cmd = expand('~/.vim/ltags')
"  autocmd BufLeave *.tex let Tlist_Ctags_Cmd = 'ctags'
"augroup END

" {{{2 Ctags and Cscope
" always search for a tags file from $PWD down to '/'.
set tags=./tags,tags;/

" try to use Cscope
if has('cscope')
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
    " run ``ctags **/.*[ch]'' to produce the file ``tags''.
    " these headers are used: 
    " http://www.vim.org/scripts/script.php?script_id=2358
    set tags+=~/.vim/tags/usr_include.tags
    set tags+=~/.vim/tags/usr_include_cpp.tags
    set tags+=~/.vim/tags/usr_local_include.tags
    set tags+=~/.vim/tags/usr_local_include_boost.tags
    set tags+=~/.vim/tags/cpp.tags
    set nocscopetag
  endif
  set cscopeverbose
else
  "call s:ctag_falback()
endif

" {{{1 music

"if has('python')
"  python import os, sys
"  python sys.path.append(os.path.expanduser("~/.vim/vimmp"))
"  pyfile ~/.vim/vimmp/main.py
"endif
"nmap <silent> <leader>x :py vimmp_toggle()<CR>

" plugins: additional: misc {{{1

" manpageview {{{
" display manpages in a vertical split (other options 'only', 'hsplit',
" 'vsplit', 'hsplit=', 'vsplit=', 'reuse')
let g:manpageview_winopen = 'reuse'
" }}}
"{{{ hints_man
" http://www.vim.org/scripts/script.php?script_id=1825
" http://www.vim.org/scripts/script.php?script_id=1826
"augroup LucManHints
"  autocmd!
"  autocmd FileType c,cpp set cmdheight=2
"augroup END
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
  augroup LucOmniCppCompete
    autocmd!
    autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|sil! pclose|endif
  augroup END
  set completeopt=menu,longest,preview
  imap <C-TAB> <C-x><C-o>
endif
"}}}
"{{{ AutoComplPop
" id 1879
" do not start popup menu after curser moved.
"let g:acp_mappingDriven = 1
"let g:acp_behaviorKeywordCommand = '<tab>'
"}}}
