" vimrc file by luc {{{1
" vi: set foldmethod=marker spelllang=en:
" Credits:
" * Many thanks to Bram for the excellent example vimrc
" *

" start (things to do first) {{{1

" Use Vim settings, rather then Vi settings (much better!).  This must be
" first, because it changes other options as a side effect.
set nocompatible

" see if some important features are present else do not load the file
"if version < 700 ||
"      \ (!(
"      \   has('autocmd') &&
"      \   has('gui')     &&
"      \   has('mouse')   &&
"      \   has('syntax')
"      \ ) && !has('neovim'))
"  echoerr "This version of Vim lacks many features, please update!"
"  finish
"endif

" Do not load many of the GUI menus.  This has to happen before 'syntax on'
" and 'filetype ...'
set guioptions+=M
set guioptions-=m

" sourcing other files {{{1
if has('python') | pyfile ~/.vim/vimrc.py
endif

" syntax and filetype {{{
" Switch syntax highlighting on, when the terminal has colors (echo &t_Co)
if &t_Co > 2 || has("gui_running")
  syntax enable
endif
" Enable file type detection and language-dependent indenting.
filetype plugin indent on

" user defined variables {{{1
let mapleader = ','
" a directory/namespace for user defined functions
let luc = {}
" a dir of servers and directories to put backups with the function defined
" below.
let s:servers = {'math': 'vim-buffer-bk', 'ifi': 'vim-buffer-bk'}

" functions: compiler {{{1
if !has_key(luc, 'compiler')
  let luc.compiler = {}
endif

function! LucCompilerGeneric(target, override) "{{{2
  " Try to build stuff depending on some parameters.  What will be built is
  " decided by a:target and if absent the current file.  First a makefile is
  " searched for in the directory %:h and above.  If one is found it is used
  " to make a:target.  If no makefile is found and filetype=tex, the current
  " file will be compiled with latexmk.  If a:override is non zero only
  " latexmk will be executed and no makefile will be searched.

  " local variables
  let bdir = expand('%:h')
  let bfile = expand('%:t')
  let Fun = function('function')
  let functionname = ''
  let path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let dir = ''
  let error = 0

  " old local variables
  let cmd   = ''

  " try to find a makefile and set dir and cmd
  while ! empty(path)
    let dir = '/' . join(path, '/')
    if filereadable(dir . '/makefile') || filereadable(dir . '/Makefile')
      "let Fun = g:luc.compiler.make
      let functionname = 'make'
      let argument = a:target
      let path = []
    elseif filereadable(dir . '/build.xml')
      "let Fun = g:luc.compiler.ant
      let functionname = 'ant'
      let argument = a:target
      let path = []
    else
      unlet path[-1]
    endif
  endwhile

  " if no makefile was found or override was asked for try to use latex
  "if a:override || Fun == function('function') " && &filetype == 'tex' && a:target == ''
  if a:override || functionname == ''
    if has_key(g:luc.compiler, &filetype)
      let functionname = &filetype
      "execute 'let Fun = g:luc.compiler.' . &filetype
      let argument = bfile
      let dir = bdir
    else
      echoerr 'Not able to compile anything.'
      let error = 1
    endif
  endif

  " execute the command in the proper directory
  "if Fun == function('function')
  if functionname == ''
    echoerr 'Not able to compile anything. (2)'
    let error = 1
  else
    execute 'cd' dir
    execute 'let cmd = g:luc.compiler.' . functionname . '(argument)'
    let dir = fnamemodify(getcwd(), ':~:.')
    let dir = dir == '' ? '~' : dir
    echo 'Running' cmd 'in' dir
    silent execute '!' cmd '&'
    cd -
    if v:shell_error
      echoerr 'Compilation returned ' . v:shell_error . '.'
    endif
    let error = ! v:shell_error
  endif

  "if &filetype == 'tex'
  "  silent ! ( sleep 3 && killall -HUP mupdf ) &
  "endif

  " redraw the screen to get rid of unneded "press enter" prompts
  redraw

  " return shell errors
  return error
endfunction

function! LucCompilerGeneric2(target) "{{{2
  " Try to build the current file automatically.  If a:target is not specified
  " and there is a compiler function available in g:luc.compiler it will be
  " used to find out how to compile the current file.  If a:target is
  " specified or there is no compiler function a makefile will be searched.

  " local variables
  let functionname = ''
  let path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let dir = ''
  "let error = 0

  " type check
  if type(a:target) != type('string')
    echoerr 'The target has to be a string.'
    return TypeError
  endif

  " look at g:luc.compiler to find a function for &filetype
  if has_key(g:luc.compiler, &filetype)
    let functionname = &filetype
    let argument = expand('%:t') " file of this buffer
    let dir = expand('%:h') " directory of this buffer
  endif

  " if a target was specified override the filetype compiler or if no filetype
  " compiler was found, use ant or make
  if a:target != '' || functionname == ''
    let functionname = ''
    let argument = ''
    let dir = ''
    " try to find a makefile and set dir and functionname
    while ! empty(path)
      let dir = '/' . join(path, '/')
      if filereadable(dir . '/makefile') || filereadable(dir . '/Makefile')
	let functionname = 'make'
	let argument = a:target
	let path = []
      elseif filereadable(dir . '/build.xml')
	let functionname = 'ant'
	let argument = a:target
	let path = []
      else
	unlet path[-1]
      endif
    endwhile
  endif

  " if no filetype function or makefile was found return with an error
  if functionname == ''
    echoerr 'Not able to compile anything. (2)'
    let error = 1
  " else execute the command in the proper directory
  else
    execute 'cd' dir
    execute 'let cmd = g:luc.compiler.' . functionname . '(argument)'
    let dir = fnamemodify(getcwd(), ':~:.')
    let dir = dir == '' ? '~' : dir
    echo 'Running' cmd 'in' dir
    silent execute '!' cmd '&'
    cd -
    if v:shell_error
      echoerr 'Compilation returned ' . v:shell_error . '.'
    endif
    let error = ! v:shell_error
  endif

  " redraw the screen to get rid of unneded "press enter" prompts
  redraw

  " return shell errors
  return error
endfunction

function! luc.compiler.ant(target) dict "{{{2
  return 'ant' . (a:target == '' ? '' : ' ' . a:target)
endfunction

function! luc.compiler.make(target) dict "{{{2
  return 'make' . (a:target == '' ? '' : ' ' . a:target)
endfunction

function! luc.compiler.markdown(sourcefile) dict "{{{2
  let target = fnamemodify(a:sourcefile, ':r').'.html'
  return 'multimarkdown --full --smart --output='.target.' '.a:sourcefile
endfunction

function! luc.compiler.tex(sourcefile) dict "{{{2
  return 'latexmk -silent ' . a:sourcefile
endfunction

" functions: help and documentation {{{1
if !has_key(luc, 'man')
  let luc.man = {}
endif

function! LucManOpen(...) "{{{2
  " try to find a manpage
  if &filetype == 'man' && a:0 == 0
    execute 'RMan' expand('<cword>')
  elseif a:0 > 0
    execute 'TMan\ ' . join(a:000)
    execute 'RMan\ ' . join(a:000)
  else
    echohl Error
    echo 'Topic missing.'
    echohl None
    return
  endif
  map <buffer> K :call LucManOpen()<CR>
  map <buffer> K :call LucManOpen()<CR>
  vmap <buffer> K :call LucManOpen(LucGetVisualSelection())<CR>
  vmap <buffer> K :call LucManOpen(LucGetVisualSelection())<CR>
endfunction

function! LucManOpenTab(type, string) "{{{2
  " look up string in the documentation for type
  if a:type =~ 'man\|m'
    let suffix = 'man'
  elseif a:type =~ 'info\|i'
    let suffix = 'i'
  elseif a:type =~ 'perldoc\|perl\|pl'
    let suffix = 'pl'
  elseif a:type =~ 'php'
    let suffix = 'php'
  elseif a:type =~ 'pydoc\|python\|py'
    let suffix = 'py'
  else
    let suffix = 'man'
  endif
  execute 'TMan' a:string . '.' . suffix
  " there seems to be a bug in :Man and :TMan
  execute 'RMan' a:string . '.' . suffix
  call foreground()
  redraw
endfunction

function! LucManCompleteTopics(ArgLead, CmdLine, CursorPos) "{{{2
  let paths = tr(system('man -w'), ":\n", "  ")
  "let paths = "/usr/share/man/man9"
  return system('find ' . paths .
	\ ' -type f | sed "s#.*/##;s/\.gz$//;s/\.[0-9]\{1,\}//" | sort -u')
endfunction

function! LucManHelptags() "{{{2
"function! LucUpdateAllHelptags()
  for item in map(split(&runtimepath, ','), 'v:val . "/doc"')
    if isdirectory(item)
      "echo  'helptags' item
      execute 'helptags' item
    endif
  endfor
endfunction

" functions: color scheme {{{1
if !has_key(luc, 'color')
  let luc.color = {}
endif

function! LucColorFind() "{{{2
  "return LucFlattenList(filter(map(split(&rtp, ','),
  "      \ 'glob(v:val .  "/**/colors/*.vim", 0, 1)'), 'v:val != []'))
  return sort(map(split(globpath(&rtp, 'colors/*.vim'), '\n'),
        \ 'split(v:val, "/")[-1][0:-5]'))
endfunction

function! LucColorSelectRandom() "{{{2
  let colorschemes = s:LucFindAllColorschemes()
  let this = colorschemes[LucRandom(0,len(colorschemes)-1)]
  execute 'colorscheme' this
  redraw
  let g:colors_name = this
  echo g:colors_name
endfunction

function! LucColorLike(val) "{{{2
  let fname = glob('~/.vim/colorscheme-ratings')
  let cfiles = map(readfile(fname), 'split(v:val)')
  for item in cfiles
    if item[0] == g:colors_name
      let item[1] += a:val
      break
    endif
  endfor
  call writefile(map(cfiles, 'join(v:val)'), fname)
  echo g:colors_name
endfunction

function! LucRandom(start, end) "{{{2
  return (system('echo $RANDOM') % (a:end - a:start + 1)) + a:start
  " code by Kazuo on vim@vim.org
  python from random import randint
  python from vim import command
  execute 'python command("return %d" % randint('.a:start.','.a:end.'))'
endfun

function! LucFlattenList(list) "{{{2
  " Code from bairui@#vim.freenode
  " https://gist.github.com/3322468
  let val = []
  for elem in a:list
    if type(elem) == type([])
      call extend(val, LucFlattenList(elem))
    else
      call add(val, elem)
    endif
    unlet elem
  endfor
  return val
endfunction

"function! luc.color.remove() "{{{2
"  " what does this do?
"  if !exists('g:colors_name')
"    echoerr 'The variable g:colors_name is not set!'
"    return
"  else
"    let file = globpath(&rtp, 'colors/' . g:colors_name . '.vim')
"    if file == ''
"      echoerr 'Can not find colorscheme ' . g:colors_name . '!'
"      return
"    elseif !exists('g:remove_files')
"      let g:remove_files = [file]
"    elseif type(g:remove_files) != type([])
"      echoerr 'g:remove_files is not a list!'
"      return
"    else
"      call add(g:remove_files, file)
"      return file
"    endif
"  endif
"endfunction

" functions: latex {{{1
if !has_key(luc, 'tex')
  let luc.tex = {}
endif

function! LucTexFormatBib() "{{{2
  " format bibentries in the current file

  " define a local helper function
  let d = {}
  let dist = 18
  function! d.f(type, key)
    let dist = 18
    let factor = dist - 2 - strlen(a:type)
    return '@' . a:type . '{' . printf('%'.factor.'s', ' ') . a:key . ','
  endfunction
  function! d.g(key, value)
    let dist = 18
    let factor = dist - 4 - strlen(a:key)
    return '  ' . a:key . printf('%'.factor.'s', ' ') . '= "' . a:value . '",'
  endfunction

  " format the line with "@type{key,"
  %substitute/^@\([a-z]\+\)\s*{\s*\([a-z0-9.:-]\+\),\s*$/\=d.f(submatch(1), submatch(2))/
  " format lines wit closing brackets
  %substitute/^\s*}\s*$/}/
  " format lines in the entries
  %substitute/^\s*\([A-Za-z]\+\)\s*=\s*["{]\(.*\)["}],$/\=d.g(submatch(1), submatch(2))/
endfunction

function! LucTexDoc() "{{{2
"function! LucTexDocFunction()
  " call the texdoc programm with the word under the cursor or the selected
  " text.
  silent execute '!texdoc' expand("<cword>")
endfunction

function! LucTexSaveFolds() "{{{2
"function! s:LucLatexSaveFolds()
  let l:old = &viewoptions
  set viewoptions=folds
  mkview
  let &viewoptions = l:old
endfunction

function! LucTexCount(file) range "{{{2
"function! LucLatexCount(file) range
  let noerr = ' 2>/dev/null'
  if type(a:file) == type(0)
    let tex = bufname(a:file)
  elseif type(a:file) == type("")
    if a:file == ""
      let tex = expand("%")
    else
      let tex = a:file
    endif
  else
    return No_File_Found
  endif
  let cmd = 'texcount -quiet -nocol -1 -utf8 -incbib '
  let texchars = split(split(system(cmd . '-char ' . tex . noerr), "\n")[0], '+')[0]
  let texwords = split(split(system(cmd . tex . noerr), "\n")[0], '+')[0]
  let pdf = join(split(tex, '\.')[0:-2], '.').'.pdf'
  if filereadable(pdf)
    let cmd = 'pdftotext ' . pdf . ' /dev/stdout | wc -mw'
    let [pdfwords, pdfchars] = split(system(cmd))
  endif
  echo texwords 'words and' texchars 'chars in file' tex
  if exists('pdfwords')
    echo pdfwords 'words and' pdfchars 'chars in file' pdf
  endif
  return
  let tc = '!texcount -nosub '
  let wc = '!pdftotext %:r.pdf /dev/stdout | wc -mw '
  if a:char == 'char'
    let tc .= '-char '
    let wc .= '-m'
  endif
  if a:firstline == a:lastline
    let tc .= '%'
  else
    let tc = a:firstline . ',' . a:lastline . 'write ' . tc . '-'
  endif
  execute tc
  execute wc '2>/dev/null'
endfunction

" functions: server {{{1
function! LucServerSetup() "{{{2
  call LucServerViminfoSetup(!LucServerRunning())
  "if has('neovim')
  "  call LucServerViminfoSetup()
  "elseif has('gui_running')
  "  " try to be the server
  "  call LucServerViminfoSetup(!LucServerRunning())
  "else
  "  " don't try to be the server
  "  call LucServerViminfoSetup(0)
  "endif
endfunction

function! LucServerRunning() "{{{2
  " check if another vim server is already running
  return !empty(has('clientserver') ? serverlist() : system('vim --serverlist'))
endfunction

function! LucServerViminfoSetup(server) "{{{2
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

function! LucMiscRemoteEditor(mail) "{{{2
  " a function to be called by a client who wishes to use a vim server as an
  " non forking edior. One can also set the environment variable EDITOR with
  " EDITOR='vim --remote-tab-wait-silent +call\ LucMiscRemoteEditor()'

  if has('gui_macvim')
    " use an autocommand to move MacVim to the background when leaving the
    " buffer
    augroup RemoteEditor
      autocmd BufDelete <buffer> macaction hide:
    augroup END
  endif

  " define some custom commands to quit the buffer
  command -bang -buffer -bar QuitRemoteEditor confirm bdelete<bang>
  if has('gui_macvim')
    command -bang -buffer -bar HideRemoteEditor macaction hide:
  endif

  cnoreabbrev <buffer> q        bdelete
  cnoreabbrev <buffer> qu       bdelete
  cnoreabbrev <buffer> qui      bdelete
  cnoreabbrev <buffer> quit     bdelete
  cnoreabbrev <buffer> wq       write  <bar> bdelete
  cnoreabbrev <buffer> x        update <bar> bdelete
  cnoreabbrev <buffer> xi       update <bar> bdelete
  cnoreabbrev <buffer> xit      update <bar> bdelete
  cnoreabbrev <buffer> exi      update <bar> bdelete
  cnoreabbrev <buffer> exit     update <bar> bdelete
  nnoremap <buffer> ZZ         :update<bar>bdelete<CR>
  nnoremap <buffer> ZQ         :bdelete!<CR>
  nnoremap <buffer> <c-w><c-q> :bdelete<CR>
  nnoremap <buffer> <c-w>q     :bdelete<CR>

  if a:mail == 1
    /^$
    normal vGzo
    redraw!
  endif
endfunction

" functions: misc {{{1
if !has_key(luc, 'misc')
  let luc.misc = {}
endif

function! LucMiscTime(cmd1, cmd2, count) " {{{2
  let time1 = localtime()
  for i in range(a:count)
    silent execute a:cmd1
  endfor
  let time2 = localtime()
  for i in range(a:count)
    silent execute a:cmd2
  endfor
  let time3 = localtime()
  echo 'Running' a:count 'repetitions of ...'
  echo a:cmd1 ' -> ' time2-time1 'sec'
  echo a:cmd2 ' -> ' time3-time2 'sec'
endfunction

function! LucMiscCapitalize(text) " {{{2
  return substitute(a:text, '\v<(\w)(\w*)>', '\u\1\L\2', 'g')
endfunction

function! LucMiscCapitalizeOperatorFunction(type) "{{{2
  " this function is partly copied from the vim help about g@
  let sel_save = &selection
  let saved_register = @@
  let &selection = "inclusive"
  if a:type == 'line'
    silent execute "normal! '[V']y"
  elseif a:type == 'block'
    silent execute "normal! `[\<C-V>`]y"
  else
    silent execute "normal! `[v`]y"
  endif
  let @@ = LucMiscCapitalize(@@)
  normal gvp
  let &selection = sel_save
  let @@ = saved_register
endfunction

function! LucMiscGotoDefinition(string) "{{{2
  try
    execute 'cscope find g' string
  catch
    try
      execute 'tags' string
    catch
      normal gd
    endtry
  endtry
endfunction

function! LucMiscSearchStringForURI(string) "{{{2
  " function to find an URI in a string
  " thanks to  http://vim.wikia.com/wiki/VimTip306
  return matchstr(a:string, '[a-z]\+:\/\/[^ >,;:]\+')
  " alternatives:
  "return matchstr(a:string, '\(http://\|www\.\)[^ ,;\t]*')
  "return matchstr(a:string, '[a-z]*:\/\/[^ >,;:]*')
endfunction

function! LucMiscInsertStatuslineColor(mode) "{{{2
  " function to change the color of the statusline depending on the mode
  " this version is from http://vim.wikia.com/wiki/VimTip1287
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

function! LucMiscFindNextSpellError() "{{{2
  " A function to jump to the next spelling error
  setlocal spell
  "if spellbadword(expand('<cword>')) == ['', '']
    normal ]s
  "endif
endfunction

function! LucMiscCheckIfBufferIsNew(...) "{{{2
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
function! LucGetVisualSelection() "{{{2
  let saved_register = @@
  let current = getpos('.')
  call setpos('.', getpos("'<"))
  execute 'normal' visualmode()
  call setpos('.', getpos("'>"))
  normal y
  let return_value = @@
  let @@ = saved_register
  call setpos('.', current)
  return return_value
endfunction

" functions: old {{{1
if !has_key(luc, 'old')
  let luc.old = {}
endif

function! luc.old.loadScpBuffers() "{{{2
  badd scp://math/.profile
  badd scp://ifi/.profile
  badd scp://ifi/.profile_local
  badd scp://lg/.bash_profile
endfunction

" setup for server vim {{{1
call LucServerSetup()

" user defined autocommands {{{1

" FileType autocommands {{{2

augroup LucLilypond "{{{3
  autocmd!
  autocmd FileType lilypond
	\ setlocal dictionary+=~/.vim/syntax/lilypond-words
augroup END

augroup LucLatex "{{{3
  autocmd!
  autocmd FileType tex
	\ nmap <buffer> K :call LucTexDoc()<CR>|
	\ nnoremap <buffer> gG :call LucTexCount('')<CR>|
	\ setlocal dictionary+=%:h/**/*.bib,%:h/**/*.tex|
	\ vnoremap <buffer> gG :call LucTexCount('')<CR>|
	\
augroup END

augroup LucLatexSuiteSettings "{{{3
  autocmd!
  " Tex_ViewRule_pdf and Tex_CompileRule_pdf are for the macros ,ll and ,lv
  " Tex_UseMakefile forces latex-suite to use makefiles
  " grep shoul display the filename
  " Tex_Menus are disabled and empty files are treated as LaTeX with
  " tex_flavor='latex'
  autocmd FileType tex
	\ setlocal grepprg=grep\ -nH\ $*|
	\
  " force grep to display filename.
  " Handle empty .tex files as LaTeX (optional).
  " Folding
  "let Tex_FoldedEnvironments='*'
  "let Tex_FoldedEnvironments+=','
  "let Tex_FoldedEnvironments  = 'document,minipage,'
  "let Tex_FoldedEnvironments .= 'di,lem,ivt,dc,'
  "let Tex_FoldedEnvironments .= 'verbatim,comment,proof,eq,gather,'
  "let Tex_FoldedEnvironments .= 'align,figure,table,thebibliography,'
  "let Tex_FoldedEnvironments .= 'keywords,abstract,titlepage'
  "let Tex_FoldedEnvironments .= 'item,enum,display'
  "let Tex_FoldedMisc = 'comments,item,preamble,<<<'
  " let g:Tex_FoldedMisc = 'comments,item,preamble,<<<,slide'
  "let Tex_FoldedEnvironments .= '*'
  "let Tex_FoldedSections = 'part,chapter,section,subsection,subsubsection,paragraph'
  "
  "let g:Tex_UseUtfMenus=1
augroup END

augroup LucPython "{{{3
  autocmd!
  autocmd FileType python setlocal
	\ tabstop=8
	\ expandtab
	\ shiftwidth=4
	\ softtabstop=4
augroup END

augroup LucJava "{{{3
  autocmd!
  "autocmd Filetype java setlocal omnifunc=javacomplete#Complete
  autocmd Filetype java setlocal makeprg=cd\ %:h\ &&\ javac\ %:t
augroup END

augroup LucMail "{{{3
  autocmd!
  autocmd FileType mail setlocal textwidth=72
augroup END

augroup LucMan "{{{3
  autocmd!
  autocmd FileType man stopinsert | setlocal nospell
augroup END

augroup LucSession "{{{2
  autocmd!
  autocmd VimEnter *
	\ if LucMiscCheckIfBufferIsNew(1) |
	\   bwipeout 1 |
	\   doautocmd BufRead,BufNewFile |
	\ endif
augroup END

"augroup LucLocalWindowCD "{{{2
"  autocmd!
"  " FIXME: still buggy
"  autocmd BufWinEnter,WinEnter,BufNew,BufRead,BufEnter *
"	\ execute 'lcd' pyeval('backup_base_dir_vim_reapper()')
"augroup END

augroup LucRemoveWhiteSpaceAtEOL "{{{2
  autocmd!
  autocmd BufWrite * silent %substitute/\s\+$//e
augroup END

"augroup LucLocalAutoCd "{{{2
"  autocmd!
"  autocmd BufEnter ~/uni/**     lcd ~/uni
"  autocmd BufEnter ~/.config/** lcd ~/.config
"  autocmd BufEnter ~/src/**     lcd ~/src
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
inoremap <C-s> <C-o>:call LucMiscFindNextSpellError()<CR><C-x><C-s>
nnoremap <C-s>      :call LucMiscFindNextSpellError()<CR>z=

" capitalize text
vmap gc "=LucMiscCapitalize(LucGetVisualSelection())<CR>p
nmap gc :set operatorfunc=LucMiscCapitalizeOperatorFunction<CR>g@

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
nmap <Leader>w :call OpenBrowser(LucMiscSearchStringForURI(getline('.')))<CR>

" easy compilation {{{2
nmap <silent> <F2>        :sil up <BAR> call LucCompilerGeneric2('')<CR>
imap <silent> <F2>   <C-O>:sil up <BAR> call LucCompilerGeneric2('')<CR>
nmap <silent> <D-F2>      :sil up <BAR> call LucCompilerGeneric('', 1)<CR>
imap <silent> <D-F2> <C-O>:sil up <BAR> call LucCompilerGeneric('', 1)<CR>

" moveing around {{{2
nmap <C-Tab>        gt
imap <C-Tab>   <C-O>gt
nmap <C-S-Tab>      gT
imap <C-S-Tab> <C-O>gT

nmap <SwipeUp>   gg
imap <SwipeUp>   gg
nmap <SwipeDown> G
imap <SwipeDown> G

" misc {{{2

"nmap <Leader>d "=strftime('%F')<CR>p

" use ß to clear the screen if you want privacy for a moment
nmap ß :!clear<CR>

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

nnoremap <silent> <F11> :sil up<BAR>cal LucCompilerGeneric2('')<BAR>call pyeval('backup_current_buffer() or True')<BAR>redr<CR>

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
set statusline=%t                                  " tail of the filename
set statusline+=\ %([%M%R%H]\ %)                   " group for mod., ro. & help
set statusline+=[
set statusline+=%{strlen(&fenc)?&fenc:'none'},     " display fileencoding
set statusline+=%{&fileformat}                     " filetype (unix/windows)
set statusline+=%Y                                 " filetype (c/sh/vim/...)
set statusline+=%{fugitive#statusline()}           " info about git
set statusline+=]
set statusline+=\ [ASCII=x%02B]                    " ASCII code of char
set statusline+=\ %=                               " rubber space
set statusline+=[%{strftime('%R')}]                " clock
set statusline+=\ [%c%V,%l/%L]                     " position in file
set statusline+=\ [%P]                             " percent of above
set statusline+=%(\ %{SyntasticStatuslineFlag()}%) " see :h syntastic

" always display the statusline
set laststatus=2
" use the wildmenu inside the status line
set wildmenu

" " change highlighting when mode changes
" augroup LucStatusLine
"   autocmd!
"   autocmd InsertEnter * call LucMiscInsertStatuslineColor(v:insertmode)
"   autocmd InsertLeave * call LucMiscInsertStatuslineColor('n')
" augroup END
" " now we set the colors for the statusline
" " in the most simple case
" highlight StatusLine term=reverse
" " for color terminal
" highlight StatusLine cterm=bold,reverse
" highlight StatusLine ctermbg=1
" " for the gui
" "highlight StatusLine gui=bold
" highlight StatusLine guibg=DarkBlue
" highlight StatusLine guifg=background

" options: tabline {{{1
" we could do something similar for tabs.
" see :help 'tabline'
"set tabline=Tabs:
"set tabline+=\ %{tabpagenr('$')}
"set tabline+=\ Buffers:
"set tabline+=\ %{len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))}
"set tabline+=%=%{strftime('%a\ %F\ %R')}

" options: wildignore {{{1
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

" plugins: management with vundle {{{1
" I manage plugins with vundle.  In order to easyly test plugins I keep a
" dictionary to store a flag depending on which the plugin should be loaded or
" not.  One could also comment the the line loading the plugin, but these are
" scatterd ofer the file and not centralized.  Also some plugins need further
" configuration which is put in the if statements.
let s:plugins = {
		\ 'latexsuite': 1,
		\ 'vimshell': 0,
		\ }

" Managing plugins with Vundle (https://github.com/gmarik/vundle)
filetype off
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()
Plugin 'gmarik/vundle'
"Plugin 'lucc/vundle'

" plugins: buffer and file management {{{1
Plugin 'kien/ctrlp.vim'

" cache {{{2
"let g:ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0

" ignore/include/exclude patterns {{{2
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v(\/private|\/var|\/tmp|\/Users\/luc\/(audio|img))',
      \ }
let g:ctrlp_root_markers = [
      \ 'makefile',
      \ 'Makefile',
      \ ]
"      \ 'latexmkrc',

" extensions {{{2
let g:ctrlp_extensions = [
      \ 'tag',
      \ 'buffertag',
      \ 'quickfix',
      \ 'dir',
      \ 'undo',
      \ 'line',
      \ 'changes',
      \]
      "\ 'rtscript',
      "\ 'mixed',
      "\ 'bookmarkdir',

" mappings {{{2
let g:ctrlp_cmd = 'CtrlPMRU'
if has('gui_running')
  let g:ctrlp_map = '<C-Space>'
  inoremap <C-Space> <C-O>:CtrlPMRU<CR>
else
  let g:ctrlp_map = '<F1>'
  inoremap <F1> <C-O>:CtrlPMRU<CR>
  augroup LucCtrlP
    autocmd!
    autocmd BufEnter,WinEnter * nnoremap <F1> :CtrlPMRU<CR>
    autocmd BufEnter,WinEnter * inoremap <F1> <C-O>:CtrlPMRU<CR>
  augroup END
endif

" Use the compiled C-version for speed improvements "{{{2
if has('python')
  Plugin 'JazzCore/ctrlp-cmatcher'
  let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
endif

" plugins: completion {{{1
"Plugin 'IComplete'
"Plugin 'cppcomplete'
"Plugin 'javacomplete'

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

else " -> neocomplete and neocomplcache {{{2
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
  inoremap <expr> <TAB>  pumvisible() ? '<C-n>' : '<TAB>'

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

  else " -> neocomplcache {{{3
    Plugin 'Shougo/neocomplcache.vim'
    let g:neocomplcache_enable_at_startup = 1 " necessary
    let g:neocomplcache_enable_refresh_always = 1 " heavy
    let g:neocomplcache_enable_fuzzy_completion = 1 " heavy
    " what is this?
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    if !exists('g:neocompcache_same_filetypes')
      let g:neocomplcache_same_filetypes = {}
    endif
    " In c buffers, completes from cpp and d buffers.
    let g:neocomplcache_same_filetypes.c = 'cpp,d'
    " In cpp buffers, completes from c buffers.
    let g:neocomplcache_same_filetypes.cpp = 'c'
    " In gitconfig buffers, completes from all buffers.
    let g:neocomplcache_same_filetypes.gitconfig = '_'
    " In default, completes from all buffers.
    let g:neocomplcache_same_filetypes._ = '_'
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
"Plugin 'snipMate'
" snippy_plugin.vba.gz
if has('python')
Plugin 'SirVer/ultisnips'
" Snippets are separated from the engine:
Plugin 'honza/vim-snippets' "{{{3
let g:UltiSnipsExpandTrigger = '<C-F>'
let g:UltiSnipsJumpForwardTrigger = '<C-F>'
"let g:UltiSnipsJumpBackwardTrigger = '<C-Tab>'
"let g:UltiSnipsExpandTrigger       = <tab>
"let g:UltiSnipsListSnippets        = <c-tab>
"let g:UltiSnipsJumpForwardTrigger  = <c-j>
"let g:UltiSnipsJumpBackwardTrigger = <c-k>
let g:UltiSnipsJumpBackwardTrigger = '<SID>NOT_DEFINED'
endif

" plugins: syntastic {{{1
Plugin 'scrooloose/syntastic'
let g:syntastic_mode_map = {
      \ 'mode': 'active',
      \ 'active_filetypes': [],
      \ 'passive_filetypes': ['tex']
      \ }

" plugins: languages {{{1

Plugin 'applescript.vim'

" plugins: LaTeX {{{2

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
" this has to be lower case!
let g:tex_flavor = 'latex'
" The other settings for vim-latex are in the LucLatexSuiteSettings
" autocmdgroup.
if has('mac') | let g:Tex_ViewRule_pdf = 'open -a Preview' | endif
let g:Tex_UseMakefile = 1
let g:Tex_CompileRule_pdf = 'latexmk -silent -pv -pdf $*'
let g:Tex_SmartQuoteOpen = '„'
let g:Tex_SmartQuoteClose = '“'
let g:Tex_Env_quote = "\\begin{quote}\<CR>,,<++>`` \\cite[S.~<++>]{<++>}\<CR>\\end{quote}"
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

"Plugin 'python_fold_compact'
"Plugin 'jpythonfold.vim'
Plugin 'Python-Syntax-Folding'
"Plugin 'klen/python-mode'

" plugins: iCal {{{2

" syntax highlighting
Plugin 'icalendar.vim'

" plugins: fish (shell) {{{2
Plugin 'aliva/vim-fish'

" plugins: shell in Vim {{{1

" notes {{{2
"Plugin 'Conque-Shell'
"Plugin 'ervandew/screen'
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
"Plugin 'ttags'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
let g:easytags_by_filetype = '~/.cache/vim-easytag'
let g:easytags_ignored_filetypes = ''

" TODO
"Plugin 'ctags.vim'
"Plugin 'latextags'
"Plugin 'TagsBase.zip'
"Plugin 'aux2tags.vim'
"Plugin 'TagsMenu.zip'
"Plugin 'PreviewTag.vim'
"Plugin 'ProjectTag'
"Plugin 'ProjectCTags'
"Plugin 'tagmaster'
"Plugin 'loadtags'
"Plugin 'OmniTags'
"Plugin 'https://bitbucket.org/abudden/tagsignature'
"Plugin 'https://bitbucket.org/abudden/taghighlight'
"Plugin 'TagManager-BETA'
"Plugin 'tags-for-std-cpp-STL-streams-...'
"Plugin 'previewtag'
"Plugin 'majutsushi/tagbar'
"Plugin 'ttagecho'
"Plugin 'ttags'
"Plugin 'taglist-plus'
"Plugin 'GtagsClient'
"Plugin 'projtags.vim'
"Plugin '0scan'
"Plugin 'TagsParser'
"Plugin 'tagSetting.vim'
"Plugin 'switchtags.vim'
"Plugin 'AutoTag'
"Plugin 'listtag'
"Plugin 'tagselect'
"Plugin 'gtags.vim'
"Plugin 'tagMenu'
"Plugin 'bahejl/Intelligent_Tags'
"Plugin 'tagsubmenu'
"Plugin 'abadcafe/ctags_cache'
"Plugin 'tagexplorer.vim'
"Plugin 'tagfinder.vim'

Plugin 'taglist.vim' "{{{2

" Automatically highlight the current tag in the taglist.
"let g:Tlist_Auto_Highlight_Tag = <++>
" Open the taglist window when Vim starts.
"let g:Tlist_Auto_Open = <++>
" Automatically update the taglist to include newly edited files.
let g:Tlist_Auto_Update = 1
" Close the taglist window when a file or tag is selected.
let g:Tlist_Close_On_Select = 1
" Remove extra information and blank lines from the taglist window.
let g:Tlist_Compact_Format = 1
" Specifies the path to the ctags utility.
"let g:Tlist_Ctags_Cmd =
" Show prototypes and not tags in the taglist window.
let g:Tlist_Display_Prototype = 1
" Show tag scope next to the tag name.
"let g:Tlist_Display_Tag_Scope =
" Show the fold indicator column in the taglist window.
"let g:Tlist_Enable_Fold_Column =
" Close Vim if the taglist is the only window.
let g:Tlist_Exit_OnlyWindow = 1
" Close tag folds for inactive buffers.
let g:Tlist_File_Fold_Auto_Close = 1
" Jump to taglist window on open.
let g:Tlist_GainFocus_On_ToggleOpen = 1
" On entering a buffer, automatically highlight the current tag.
"let g:Tlist_Highlight_Tag_On_BufEnter =
" Increase the Vim window width to accommodate the taglist window.
"let g:Tlist_Inc_Winwidth =
" Maximum number of items in a tags sub-menu.
"let g:Tlist_Max_Submenu_Items =
" Maximum tag length used in a tag menu entry.
"let g:Tlist_Max_Tag_Length =
" Process files even when the taglist window is closed.
"let g:Tlist_Process_File_Always =
" Display the tags menu.
"let g:Tlist_Show_Menu =
" Show tags for the current buffer only.
"let g:Tlist_Show_One_File =
" Sort method used for arranging the tags.
"let g:Tlist_Sort_Type = " TODO
" Use a horizontally split window for the taglist window.
let g:Tlist_Use_Horiz_Window = 0
" Place the taglist window on the right side.
let g:Tlist_Use_Right_Window = 1
" Single click on a tag jumps to it.
"let g:Tlist_Use_SingleClick =
" Horizontally split taglist window height.
"let g:Tlist_WinHeight =
" Vertically split taglist window width.
let g:Tlist_WinWidth = 75
" Hide extra tag data produced by jsctags.
"let g:Tlist_javascript_Hide_Extras =

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

nmap <silent> <F4> :silent TlistToggle<CR>
"augroup LucTagList
"  autocmd!
"  autocmd BufEnter *.tex let Tlist_Ctags_Cmd = expand('~/.vim/ltags')
"  autocmd BufLeave *.tex let Tlist_Ctags_Cmd = 'ctags'
"augroup END

" Ctags and Cscope {{{2
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
  "nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  "nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  "nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
  "nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  "nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
  " End of http://cscope.sourceforge.net/cscope_maps.vim stuff }}}
  if $CSCOPE_DB != ""
    cscope add $CSCOPE_DB
  elseif filereadable('cscope.out')
    cscope add cscope.out
  else
    " no database so use Ctags instead (unset cscope options)
    " run ``ctags **/.*[ch]'' to produce the file ``tags''.
    " these headers are used:
    " http://www.vim.org/scripts/script.php?script_id=2358
    "Plugin 'tags-for-std-cpp-STL-streams-...'
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

" Tags Bookmarks {{{3
"Plugin 'a-new-txt2tags-syntax'
"Plugin 'gtags-multiwindow-browsing'
"Plugin 'utags'
"Plugin 'ctags_cache'
"Plugin 'Intelligent-Tags'
"Plugin 'Find-XML-Tags'
"Plugin 'ProjectCTags'
"Plugin 'cHiTags'
"Plugin 'loadtags'
"Plugin 'OmniTags'
"Plugin 'tags-for-std-cpp-STL-streams-...'
"Plugin 'ctags.exe'
"Plugin 'ttags'
"Plugin 'undo_tags'
"Plugin 'GtagsClient'
"Plugin 'projtags.vim'
"Plugin 'tagscan'
"Plugin 'TagsParser'
"Plugin 'tagSetting.vim'
"Plugin 'switchtags.vim'
"Plugin 'tagselect'
"Plugin 'DoTagStuff'
"Plugin 'txt2tags'
"Plugin 'txt2tags-menu'
"Plugin 'gtags.vim'
"Plugin 'tagsubmenu'
"Plugin 'ctags.vim'
"Plugin 'vtags_def'
"Plugin 'vtags'
"Plugin 'latextags'
"Plugin 'ctags.vim'
"Plugin 'TagsBase.zip'
"Plugin 'functags.vim'
"Plugin 'aux2tags.vim'
"Plugin 'dtags'
"Plugin 'TagsMenu.zip'
"Plugin 'ctags.vim'

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

" plugins: unsorted {{{1
if has('python')
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
set noshowmode
endif

Plugin 'tyru/open-browser.vim'

Plugin 'pix/vim-known_hosts'
Plugin 'ack.vim'

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

" switch on filezype detection after defining all Bundles
filetype plugin indent on

" fix the runtimepath mess that vundle creates {{{2
set runtimepath-=~/.vim
set runtimepath-=~/.vim/after
set runtimepath-=$VIM/vimfiles
set runtimepath-=$VIM/runtime
set runtimepath-=$VIM/vimfiles/after
set runtimepath^=$VIM/runtime
set runtimepath^=$VIM/vimfiles
set runtimepath^=~/.vim
set runtimepath+=$VIM/vimfiles/after
set runtimepath+=~/.vim/after

" {{{2 Set colors for the terminal.  If the GUI is running the colorscheme
"      will be set in gvimrc.
if ! has('gui_running')
  set background=dark
  colorscheme solarized
endif
