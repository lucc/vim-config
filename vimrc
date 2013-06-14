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
"let s:braces_stack = []
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
  " files which indicate a suitable base directory
  let indicator_files = [
                      \ 'makefile',
                      \ 'build.xml',
                      \ ]
  let indicator_dirs = [
                     \ '~/uni',
                     \ '~/.vim',
		     \ ]
  let matches = []
  let path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let cwd = getcwd()
  " look at directory of the current buffer
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
  " look at the working directory
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
  " fallback value
  if empty(matches)
    call add(matches, ['/', ''])
  endif
  "if len(matches) == 1
  "  return matches[0][0]
  "endif
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

"function! LucInitiateSession(load_old_session) "{{{2
"  " A function to source a session file and set up an autocommand which will
"  " automatically save the session again, when vim is quit.
"  let l:session = '~/.vim/Session.vim'
"  if a:load_old_session
"    execute 'source' l:session
"    silent execute '!rm -f' l:session
"  endif
"  augroup LucSession
"    autocmd!
"    execute 'autocmd VimLeave * mksession!' l:session
"  augroup END
"  if argc() | argdelete * | endif
"  redraw!
"endfunction

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
      let cmd = 'make' . (a:target == '' ? '' : ' ' . a:target)
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

"function! LucEditAllBuffers() "{{{2
"  let current = bufnr('%')
"  let alternative = bufnr('#')
"  bufdo edit
"  if bufexists(alternative)
"    execute 'buffer' alternative
"  endif
"  if bufexists(current)
"    execute 'buffer' current
"  endif
"endfunction

function! LucTexDocFunction() "{{{2
  let l:word = expand("<cword>")
  silent execute '!texdoc' l:word
endfunction

function! LucManPageFunction(...) "{{{2
  " try to find a manpage
  if &filetype == 'man' && a:0 == 0
    execute 'Man' expand('<cword>')
  elseif a:0 > 0
    execute 'tabnew +Man\ ' . join(a:000)
  else
    echohl Error
    echo 'Topic missing.'
    echohl None
    return
  endif
  map <buffer> K :call LucManPageFunction()<CR>
  vmap <buffer> K :call LucManPageFunction(LucGetVisualSelection())<CR>
endfunction

function! LucGetVisualSelection() "{{{2
  " This function is copied from http://stackoverflow.com/questions/1533565/
  let [lnum1, col1] = getpos("'<")[1:2]
  "let [lnum1, col1] = getpos("v")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  "let [lnum2, col2] = getpos(".")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - 2]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

function! LucAutoJumpWraper(...) "{{{2
  " call the autojump executable to change the directory in vim
  if a:0 == 0
    let arg = '-s'
    let cmd = 'echo'
  else
    let arg = join(a:000)
    let cmd = 'cd'
  endif
  let result = system('autojump ' . arg)
  execute cmd result
endfunction

"function! LucMpdClient() "{{{2
"endfunction

"function! LucPatternBufferDo(pattern, ...) "{{{2
"  " like :bufdo but only visit files which match pattern.
"  let buffers = []
"  let i
"  let buf
"  for i in range(bufnr('$'))
"    if bufexists(i)
"      if bufname(i) =~ a:pattern
"	append(buffers, i)
"      endif
"    endif
"  endfor
"  if len(buffers) == 0
"    echoerr 'No buffers match ' . pattern . '!'
"    return
"  endif
"  for buf in buffers
"    echo 'Visiting buffer ' . bufname(buf) . '.'
"    execute 'buffer' buf '|' join(a:000, ' ')
"  endfor
"endfunction

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
inoremap <C-W> <C-G>u<C-W>

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
nmap <Leader>v :call 
  \ LucHandleURI('http://www.vim.org/scripts/script.php?script_id=' .
  \ matchstr(matchstr(expand('<cword>'), '[0-9]\+[^0-9]*$'), '^[0-9]*'))<CR>

" easy compilation {{{2
nmap          <F2>        :silent update <BAR> call LucQuickMake('', 0)<CR>
imap          <F2>   <C-O>:silent update <BAR> call LucQuickMake('', 0)<CR>
nmap <silent> <D-F2>      :silent update <BAR> call LucQuickMake('', 1)<CR>
imap <silent> <D-F2> <C-O>:silent update <BAR> call LucQuickMake('', 1)<CR>

" move between tabs {{{2
nmap <C-Tab>        gt
imap <C-Tab>   <C-O>gt
nmap <C-S-Tab>      gT
imap <C-S-Tab> <C-O>gT

" move with mouse gestures {{{2
nmap <SwipeUp>   gg
imap <SwipeUp>   gg
nmap <SwipeDown> G
imap <SwipeDown> G

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

command! -nargs=* -complete=dir J call LucAutoJumpWraper("<args>")

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
  set statusline+=[
  set statusline+=%{strlen(&fenc)?&fenc:'none'},  " display fileencoding
  set statusline+=%{&ff}                          " filetype (unix/windows)
  set statusline+=%Y                              " filetype (c/sh/vim/...)
  set statusline+=%{fugitive#statusline()}        " info about git
  set statusline+=]
  set statusline+=\ [ASCII=x%03B]                 " ASCII code of char
  "set statusline+=\ [ASCII=x%02.2B]               " ASCII code of char
  set statusline+=\ %=                            " rubber space
  "set statusline+=[%{strftime('%a\ %F\ %R')}]     " clock
  set statusline+=\ [%c%V,%l/%L]                  " position in file
  set statusline+=\ [%P]                          " percent of above
  "set statusline+=\ %{SyntasticStatuslineFlag()}  " see :h syntastic

  " always display the statusline
  set laststatus=2

  if has('autocmd') && 0 "commented out
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
    set wildignore+=*.aux,*.out,*.toc,*.idx,*.fls  " LaTeX intermediate files
    set wildignore+=*.fdb_latexmk                  " LaTeXmk files
    set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg " binary images
    set wildignore+=.*.sw?                         " Vim swap files
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
"set tabline=Tabs:
"set tabline+=\ %{tabpagenr('$')}
"set tabline+=\ Buffers:
"set tabline+=\ %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))}
"set tabline+=%=%{strftime('%a\ %F\ %R')}

" options: colorcolumn {{{1

if version >= 703 	" NEW in VIM 7.3
  set colorcolumn=+1 	"highlight the background of the 79th column
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

" plugins: management {{{1
" I manage plugins with vundle.  In order to easyly test plugins I keep a
" dictionary to store a flag depending on which the plugin should be loaded or
" not.  One could also comment the the line loading the plugin, but these are
" scatterd ofer the file and not centralized.
let s:plugins = {
		\ 'buffergator': 0,
		\ 'bufferlist': 0,
		\ 'buffet': 1,
		\ 'bufmru': 0,
		\ 'buftabs': 0,
		\ 'commandt': 0,
		\ 'ctrlp': 1,
		\ 'fuzzyfinder': 0,
		\ 'latexsuite': 1,
		\ 'lusty': 0,
		\ 'neocompl': 0,
		\ 'nerd': 0,
		\ 'popupbuffer': 1,
		\ 'powerline': 0,
		\ 'qnamebuf': 0,
		\ 'syntastic': 0,
		\ 'taglist': 1,
		\ 'tcommand': 0,
		\ 'tselectbuffer': 0,
		\ 'tselectfiles': 0,
		\ 'unite': 0,
		\ 'vimmp': 0,
		\ 'winmanager': 0,
		\ }

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

" plugins: vundle {{{1
" Managing plugins with Vundle (https://github.com/gmarik/vundle)
filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()
"Bundle 'gmarik/vundle'
Bundle 'lucc/vundle'

" plugins: libs {{{1
Bundle 'L9'
" vimscript 3252
Bundle 'tomtom/tlib_vim'
" vimscript ?

" plugins: buffer and file management {{{1
"42 bufexplorer.zip
"685 incbufswitch.vim
"1011 buflist.vim
"1910 qbuf.vim

if s:plugins['buffergator'] "{{{2
  " vimscript 3619
  Bundle 'jeetsukumaran/vim-buffergator'
  " browse buffers with preview, switch to window containing this buffer or
  " display buffer in last window
  let g:did_buffergator = 0
  let g:buffergator_suppress_keymaps = 1
  nmap <Leader>bg :BuffergatorToggle<CR>
endif

if s:plugins['bufferlist'] "{{{2
  " vimscript 1325
  Bundle 'bufferlist.vim'
  " Very simple list of loaded buffers
  " is only checked for existenc
  "let g:BufferListLoaded = 0
  " does not need a mapping:
  nmap <leader>m :call BufferList()<cr>
endif

if s:plugins['buffet'] "{{{2
  " vimscript 3896
  Bundle 'sandeepcr529/Buffet.vim'
  " no help?
  " I can not disable it!
  nmap <leader>bl :Bufferlist<CR>
endif

if s:plugins['bufmru'] "{{{2
  " vimscript 2346
  Bundle 'bufmru.vim'
  " no help
  " is only checked for existenc
  "let loaded_bufmru = 1
  "let g:bufmru_switchkey = expand('<leader>bm')
  " seems buggy
endif

if s:plugins['buftabs'] "{{{2
  " vimscript 1664
  Bundle 'buftabs'
  " no help / can not disable it / quite nice
  let g:buftabs_marker_modified = '+'
  let g:buftabs_only_basename = 1
  "let g:buftabs_in_statusline=1
  "set statusline=%=buffers:\ %{buftabs#statusline()}
endif

if s:plugins['commandt'] "{{{2
  " vimscript 3025
  Bundle 'git://git.wincent.com/command-t.git'
  "let g:command_t_loaded = 0
  let g:CommandTMaxCachedDirectories = 1 " default
  let g:CommandTMaxCachedDirectories = 10
  let g:CommandTScanDotDirectories = 1
  let g:CommandTMatchWindowReverse = 1
  let g:CommandTMaxFiles = 100000
  "let g:CommandTMatchWindowAtTop = 1
  "let g:CommandTToggleFocusMap = ''
  "let g:CommandTSelectPrevMap = ['<up>', '<C-i>']
  "let g:CommandTSelectNextMap = ['<down>', '<C-S-i>']

  nmap <c-s-f> :CommandT<cr>
  nmap <c-s-b> :CommandTBuffer<cr>
endif

if s:plugins['ctrlp'] "{{{2
  Bundle 'kien/ctrlp.vim'
  "let g:ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_root_markers = ['makefile', 'Makefile', 'latexmkrc']
  let g:ctrlp_map = '<c-space>'
  let g:ctrlp_cmd = 'CtrlPMRU'
  inoremap <C-Space> <C-O>:CtrlPMRU<CR>
endif

if s:plugins['fuzzyfinder'] "{{{2
  " vimscript 1984
  Bundle 'FuzzyFinder'
  " requires l9lib (vimscript 3252)
  let g:fuf_modesDisable = [
			 \ 'directory',
			 \ 'mrufile',
			 \ 'mrucmd',
			 \ 'bookmarkdir',
			 \ 'taggedfile',
			 \ 'jumplist',
			 \ 'changelist',
			 \ 'lines',
			 \ 'givenfile',
			 \ 'givendirectory',
			 \ 'givencommand',
			 \ 'callbackfile',
			 \ 'callbackitem',
			 \ ]
  let g:fuf_enumeratingLimit = 20
  let g:fuf_coveragefile_globPatterns = ['~/.*', '~/*']
  let g:fuf_dataDir = '~/.vim/cache/fuf'
  let s:fuf_cov = extend(map(copy(s:path), 'v:val . "/.*"'),
                       \ map(copy(s:path), 'v:val . "/*"'))
  call extend(g:fuf_coveragefile_globpatterns, s:fuf_cov)
  nnoremap <silent> <d-f> :silent fufcoveragefile<cr>
  nnoremap <silent> <d-b> :silent fufbuffer<cr>
  nnoremap <silent> <c-h> :silent fufhelp<cr>
  inoremap <silent> <d-f> <esc>:silent fufcoveragefile<cr>
  inoremap <silent> <d-b> <esc>:silent fufbuffer<cr>
  inoremap <silent> <c-h> <esc>:silent fufhelp<cr>
  augroup LucFufMaps
    autocmd filetype fuf inoremap <buffer> <c-i> <c-n>
  augroup end
endif

if s:plugins['lusty'] "{{{2
  " vimscript 2050
  bundle 'sjbach/lusty'
  let g:lustyjugglerdefaultmappings = 0
  " help inside script: ~/.vim/plugin/lusty-explorer.vim
  " disable mappings
  let g:lustyexplorerdefaultmappings = 0
  " available commands
  "   :lustyfilesystemexplorer [optional-path]
  "   :lustyfilesystemexplorerfromhere
  "   :lustybufferexplorer
  "   :lustybuffergrep
  " nice!!
  nmap <leader>lf :lustyfilesystemexplorer<cr>
  " nearly the same as "wmtoggle" but has preview option
  nmap <leader>lb :lustybufferexplorer<cr>
endif

if s:plugins['nerd'] "{{{2
  Bundle 'NERD_tree-Project'
  Bundle 'scrooloose/nerdcommenter'
  Bundle 'scrooloose/nerdtree'
  " vimscript 1658
  " is only checked for existenc
  "let loaded_nerd_tree = 1
  let NERDChristmasTree = 1
  let NERDTreeHijackNetrw = 1
  nmap <leader>nt :NERDTreeToggle<cr>
endif

if s:plugins['qnamebuf'] "{{{2
  " vimscript 3217
  Bundle 'qnamebuf'
  let g:qnamebuf_loaded = 0
  "let g:qnamefile_loaded = 0
  " this will not help
  let qnamebuf_hotkey = '<leader>qb'
  "let qnamefile_hotkey = '<leader>j'
endif

if s:plugins['tcommand'] "{{{2
  " vimscript ?
  Bundle 'tomtom/tcommand_vim'
endif

if s:plugins['tselectbuffer'] "{{{2
  " vimscript 1866
  Bundle 'tomtom/tselectbuffer_vim'
  " needs tlib >= 0.40
  " disable loading for the moment
  "let loaded_tselectbuffer = 0
  nmap <leader>t :TSelectBuffer<cr>
endif

if s:plugins['tselectfiles'] "{{{2
  " vimscript ?
  Bundle 'tomtom/tselectfiles_vim'
  noremap <leader>tf :TSelectFiles<cr>
endif

if s:plugins['unite'] "{{{2
  Bundle 'Shougo/unite.vim'
  let g:unite_data_directory = '~/.vim/cache/unite'
endif

if s:plugins['winmanager'] "{{{2
  " vimscript 95
  " The NERD_Tree plugin provides the same functionality but seem nicer
  Bundle 'winmanager'
  "map <C-w><C-t> :WMToggle<CR>
  nmap <leader>wt :WMToggle<cr>
endif

" plugins: LaTeX {{{1

" 3109 LatexBox.vmb
Bundle 'auctex.vim'
" 162 auctex.vim
"Bundle 'coot/atp_vim'
" AutomaticLaTeXPlugin 2945
"Bundle 'LaTeX-functions'
Bundle 'LaTeX-Help'
"Bundle 'latextags'
Bundle 'TeX-9'
" 3508 tex_nine.tar.gz
"Bundle 'tex.vim'
"Bundle 'tex_autoclose.vim'
" 920 tex_autoclose.vim

if s:plugins['latexsuite'] "{{{2
  Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

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
  let Tex_FoldedEnvironments='*'
  "let Tex_FoldedEnvironments+=','
  "let Tex_FoldedEnvironments  = 'document,minipage,'
  "let Tex_FoldedEnvironments .= 'di,lem,ivt,dc,'
  "let Tex_FoldedEnvironments .= 'verbatim,comment,proof,eq,gather,'
  "let Tex_FoldedEnvironments .= 'align,figure,table,thebibliography,'
  "let Tex_FoldedEnvironments .= 'keywords,abstract,titlepage'
  "let Tex_FoldedEnvironments .= 'item,enum,display'
  "let Tex_FoldedMisc = 'comments,item,preamble,<<<'
  "let Tex_FoldedEnvironments .= '*'

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
endif

" plugins: lisp/scheme {{{1

" lisp/scheme interaction {{2
Bundle 'slimv.vim'
"2531 slimv.vim

" plugins: shell {{{1

Bundle 'Shougo/vimproc'
Bundle 'Shougo/vimshell.vim'
Bundle 'Conque-Shell'
" to be tested (shell in gvim)
"http://www.vim.org/scripts/script.php?script_id=118
"http://www.vim.org/scripts/script.php?script_id=165
"http://www.vim.org/scripts/script.php?script_id=1788
"http://www.vim.org/scripts/script.php?script_id=2620
"http://www.vim.org/scripts/script.php?script_id=2711
"http://www.vim.org/scripts/script.php?script_id=2771
"http://www.vim.org/scripts/script.php?script_id=3040
"http://www.vim.org/scripts/script.php?script_id=3123
"http://www.vim.org/scripts/script.php?script_id=3431
"http://www.vim.org/scripts/script.php?script_id=3554
"4011 18175 :AutoInstall: vimux

" plugins: comma separated values (csv) {{{1
"Bundle 'csv.vim'
"Bundle 'csv-reader'
"Bundle 'CSVTK'
"Bundle 'rcsvers.vim'
"Bundle 'csv-color'
"Bundle 'CSV-delimited-field-jumper'

" plugins: tags {{{1
" taglist_45.zip
" ttags.vba.gz
"Bundle 'xolox/vim-easytags'

" Bundle 'taglist-plus' {{{2
Bundle 'taglist-plus'

if s:plugins['taglist'] "{{{2
  " vimscript 273
  Bundle 'taglist.vim'
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
endif

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
  "call s:ctag_fallback()
endif

" plugins: manpages {{{1
" info.vim.gz
" Bundle 'ManPageView' {{{2
" vimscript
" TODO
Bundle 'ManPageView'
" http://www.drchip.org/astronaut/vim/vbafiles/manpageview.vba.gz
" manually installed: open above url and execute :UseVimaball
" display manpages in a vertical split (other options 'only', 'hsplit',
" 'vsplit', 'hsplit=', 'vsplit=', 'reuse')
let g:manpageview_winopen = 'reuse'

"{{{2 hints_man
" http://www.vim.org/scripts/script.php?script_id=1825
" http://www.vim.org/scripts/script.php?script_id=1826
"augroup LucManHints
"  autocmd!
"  autocmd FileType c,cpp set cmdheight=2
"augroup END

" plugins: completion {{{1
" icomplete-0.5.tar.bz2
" cppcomplete.vim.gz

Bundle 'javacomplete'

if s:plugins['neocompl'] "{{{2
  "Bundle 'Shougo/neocomplete.vim'
  Bundle 'Shougo/neocomplcache.vim'
  Bundle 'Shougo/neosnippet'
  " Code from the help file:
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
  "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplcache.
  let g:neocomplcache_enable_at_startup = 1
  " Use smartcase.
  let g:neocomplcache_enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplcache_min_syntax_length = 3
  let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

  " Enable heavy features.
  " Use camel case completion.
  "let g:neocomplcache_enable_camel_case_completion = 1
  " Use underbar completion.
  "let g:neocomplcache_enable_underbar_completion = 1

  " Define dictionary.
  let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
	  \ }

  " Define keyword.
  if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
  endif
  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplcache#undo_completion()
  inoremap <expr><C-l>     neocomplcache#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplcache#close_popup()
  inoremap <expr><C-e>  neocomplcache#cancel_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

  " For cursor moving in insert mode(Not recommended)
  "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
  "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
  "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
  "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
  " Or set this.
  "let g:neocomplcache_enable_cursor_hold_i = 1
  " Or set this.
  "let g:neocomplcache_enable_insert_char_pre = 1

  " AutoComplPop like behavior.
  "let g:neocomplcache_enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplcache_enable_auto_select = 1
  "let g:neocomplcache_disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
  endif
  if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
  endif
  let g:neocomplcache_omni_patterns.php =
  \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  let g:neocomplcache_omni_patterns.c =
  \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
  let g:neocomplcache_omni_patterns.cpp =
  \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplcache_omni_patterns.perl =
  \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}
endif

" Bundle 'OmniCppComplete' {{{2
" vimscript
Bundle 'OmniCppComplete'
"http://www.vim.org/scripts/script.php?script_id=1520
if version >= 7
  " OmniCompletion see ``:help compl-omni''
  " thanks to http://vim.wikia.com/wiki/C%2B%2B_code_completion
  let OmniCpp_NamespaceSearch = 1
  let OmniCpp_GlobalScopeSearch = 1
  let OmniCpp_ShowAccess = 1
  let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
  let OmniCpp_MayCompleteDot = 1      " autocomplete after .
  let OmniCpp_MayCompleteArrow = 1    " autocomplete after ->
  let OmniCpp_MayCompleteScope= 1    " autocomplete after ::
  let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
  " automatically open and close the popup menu / preview window
  augroup LucOmniCppCompete
    autocmd!
    autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|sil! pclose|endif
  augroup END
  set completeopt=menu,longest,preview
  imap <C-TAB> <C-x><C-o>
endif

" Bundle 'AutoComplPop' {{{2
" vimscript id 1879
Bundle 'AutoComplPop'
" do not start popup menu after curser moved.
"let g:acp_mappingDriven = 1
"let g:acp_behaviorKeywordCommand = '<tab>'

" From the help file:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""{{{
" snipMate's Trigger Completion ~
" 
" snipMate's trigger completion enables you to complete a snippet trigger
" provided by snipMate plugin
" (http://www.vim.org/scripts/script.php?script_id=2540) and expand it.
" 
" 
" To enable auto-popup for this completion, add following function to
" plugin/snipMate.vim:
" >
"   fun! GetSnipsInCurrentScope()
"     let snips = {}
"     for scope in [bufnr('%')] + split(&ft, '\.') + ['_']
"       call extend(snips, get(s:snippets, scope, {}), 'keep')
"       call extend(snips, get(s:multi_snips, scope, {}), 'keep')
"     endfor
"     return snips
"   endf
" <
" And set |g:acp_behaviorSnipmateLength| option to 1.
" 
" There is the restriction on this auto-popup, that the word before cursor must
" consist only of uppercase characters.
" 
"                                                                *acp-perl-omni*
" Perl Omni-Completion ~
" 
" AutoComplPop supports perl-completion.vim
" (http://www.vim.org/scripts/script.php?script_id=2852).
" 
" To enable auto-popup for this completion, set |g:acp_behaviorPerlOmniLength|
" option to 0 or more.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""}}}

" plugins: parenthesis and quotes {{{1

Bundle 'Raimondi/delimitMate'
Bundle 'paredit.vim'

" plugins: unsorted {{{1
if s:plugins['powerline'] "{{{2
  Bundle 'Lokaltog/vim-powerline'
  Bundle 'Lokaltog/powerline'
endif

if s:plugins['syntastic'] "{{{2
  Bundle 'scrooloose/syntastic'
endif

if s:plugins['popupbuffer'] "{{{2
  " This is messing with fuf
  Bundle 'PopupBuffer.vim'
endif

" Bundle 'ack.vim' {{{2
Bundle 'ack.vim'

" Bundle 'applescript.vim' {{{2
Bundle 'applescript.vim'

" Bundle 'browser.vim' {{{2
Bundle 'browser.vim'

" Bundle 'calendar.vim' {{{2
"Bundle 'calendar.vim'
" buggy!

" Bundle 'matchit.zip' {{{2
Bundle 'matchit.zip'

" Bundle 'Vim-JDE' {{{2
Bundle 'Vim-JDE'

" Bundle 'VimRepress' {{{2
"3510 vimrepress
Bundle 'VimRepress'
"2582 blogit

" Bundle 'ZoomWin' {{{2
Bundle 'ZoomWin'

" Bundle 'linediff' {{{2
Bundle 'AndrewRadev/linediff.vim'

" plugins: git stuff {{{2
"Bundle 'tpope/vim-git'
Bundle 'tpope/vim-fugitive'

" Bundle 'vimwiki' {{{2
Bundle 'vimwiki'

" plugins: mpd {{{1
"2369 vmmp
"2856 vmmpc
" Bundle 'vimmpc' {{{2
"Bundle 'vimmpc'

if s:plugins['vimmp'] "{{{2
  Bundle 'vimmp'
  let g:vimmp_server_type="mpd"
  let g:mpd_music_directory="~/.mpd/music"
  let g:mpd_playlist_directory="~/.mpd/lists"
  if has('python')
    py import os, sys
    py sys.path.append(os.path.expanduser("~/.vim/bundle/vimmp"))
    pyf ~/.vim/bundle/vimmp/main.py
    command MPC py vimmp_toggle()
  endif
endif

" plugins: colors {{{1
Bundle 'altercation/vim-colors-solarized'
Bundle 'w0ng/vim-hybrid'
Bundle 'chriskempson/vim-tomorrow-theme'
Bundle 'nanotech/jellybeans.vim'
Bundle 'kalt.vim'
Bundle 'kaltex.vim'
Bundle 'textmate16.vim'
Bundle 'vibrantink'
Bundle 'tortex'
Bundle 'tomasr/molokai'

" plugins: bookmarks {{{1
"3412 xterm-color-table.vim.tar.gz
"2540 snipMate

" maybe not interesting {{{2
"877 gvcolor.vim
"1283 tbe.vim

" why is this installed? {{{2
"1066 cecutil.vim

" other default {{{2
"40 DrawIt.tar.gz
"104 blockhl.vim
"120 decho.vim
"122 astronaut.vim
"195 engspchk.vim
"294 Align.vim
"302 AnsiEsc.vim
"451 EasyAccents.vim
"514 mrswin.vim                   # wtf?
"551 Mines.vim                    # wtf?
"628 SeeTab.vim
"670 visincr.vim

" added on 2012-02-14 (bookmarks) {{{2
"1048 R_with_vim.tar.gz
"2358 cpp_src.tar.bz2
"3931 vim-support.zip

" This stuff was in my old ~/.vim dir. {{{2
" AutoAlign.vba.gz
" bash-support.zip
" ex_plugins_package-unix-8.05_b2.zip
" octave_with_vim_0.01-8.tar.gz
" project-1.4.1.tar.gz
" renamer.vim.gz
" sessionman.vim.gz
" snippy_plugin.vba.gz
" supertab.vba.gz
" tskeleton.vba.gz

" last steps {{{1
filetype plugin indent on

" set colors for the terminal {{{1
if has('syntax')
  "" Are we running on MacVim?
  "if has('gui_macvim')
  "  colorscheme macvim
  "  " that is 202=#ff5f00, 234=#1c1c1c
  "  hi Pmenu ctermfg=202 ctermbg=234
  "  hi PmenuSel ctermfg=234 ctermbg=202

  "" what is a good alternative colorsheme?
  ""else
  "endif

  " always set the background of the line number
  highlight LineNr ctermbg=black ctermfg=DarkGrey
  " switching to solarized
  set bg=dark
  colorscheme solarized
endif
