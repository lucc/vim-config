" vim: fdm=marker

function! luc#remote_editor(mail) "{{{1
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

function! luc#time(cmd1, cmd2, count) " {{{1
  " execute two ex commands count times each and print the duration
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

function! luc#capitalize(text) " {{{1
  return substitute(a:text, '\v<(\w)(\w*)>', '\u\1\L\2', 'g')
endfunction

function! luc#capitalize_operator_function(type) "{{{1
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
  let @@ = luc#capitalize(@@)
  normal gvp
  let &selection = sel_save
  let @@ = saved_register
endfunction

function! luc#find_next_spell_error() "{{{1
  " A function to jump to the next spelling error
  setlocal spell
  "if spellbadword(expand('<cword>')) == ['', '']
    normal ]s
  "endif
endfunction

" see:
"http://vim.wikia.com/wiki/Making_Parenthesis_And_Brackets_Handling_Easier
function! luc#get_visual_selection() "{{{1
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

function! luc#format_bib() "{{{1
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
  " format lines with closing brackets
  %substitute/^\s*}\s*$/}/
  " format lines in the entries
  %substitute/^\s*\([A-Za-z]\+\)\s*=\s*["{]\(.*\)["}],$/\=d.g(submatch(1), submatch(2))/
endfunction

function! s:flatten_list(list) "{{{1
  " Code from bairui@#vim.freenode
  " https://gist.github.com/3322468
  let val = []
  for elem in a:list
    if type(elem) == type([])
      call extend(val, luc#flatten_list(elem))
    else
      call add(val, elem)
    endif
    unlet elem
  endfor
  return val
endfunction

function! s:goto_definition(string) "{{{1
  try
    execute 'cscope find g' string
  catch
    try
      execute 'tags' string
    catch
      normal gd
    endtry
  endtry
  " taken from
  " http://www.artandlogic.com/blog/2013/06/vim-for-python-development/
  " execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>
  " noautocmd
endfunction

function! s:select_font(big) "{{{1
  " Select a font and set it
  let delim = ''
  if has('gui_macvim')
    let s:delim = ':h'
  elseif has('gui_gtk2')
    let s:delim = ' '
  endif
  " TODO
endfunction

function! luc#remove_last_bib_and_save()
  $
  ?^}$?+1
  .,$delete
  let g:i += 1
  execute printf('%s%03d%s', 'sav /Users/luc/uni/new-', g:i, '.bib')
endfunction

let s:tip_ignore_file = expand('~/.cache/vim-tip.ignore')
let s:last_tip = ''

function! luc#all_help_tags()
  " return a list of all help tags
  let list = []
  let ignore = readfile(s:tip_ignore_file)
  for file in split(globpath(&runtimepath, 'doc/tags'))
    for line in readfile(file)
      let word = split(line)[0]
      if index(ignore, word) == -1
	call add(list, word)
      endif
    endfor
    "call extend(list, map(readfile(file), 'split(v:val)[0]'))
  endfor
  return list
endfunction

function! luc#tip()
  " display a random help topic
  let list = luc#all_help_tags()
  for line in readfile(s:tip_ignore_file)
    call filter(list, 'v:val == line')
  endfor
  let s:last_tip = list[luc#random(0, len(list) - 1)]
  return s:last_tip
endfunction

function! luc#ignore_tip()
  " ignore the last tip for the future
  let file = readfile(s:tip_ignore_file)
  call add(file, s:last_tip)
  call writefile(file, s:tip_ignore_file)
endfunction
com! HANS echo 'file is' s:tip_ignore_file 'last tip was' s:last_tip
function! luc#random(start, end) "{{{1
  return (system('echo $RANDOM') % (a:end - a:start + 1)) + a:start
  " code by Kazuo on vim@vim.org
  python from random import randint
  python from vim import command
  execute 'python command("return %d" % randint('.a:start.','.a:end.'))'
endfun

function! luc#open_tip()
  execute 'help' luc#tip()
  autocmd BufLeave <buffer> echo confirm('Skip this tip in the future?', '&Yes\n&no') == 1 && luc#ignore_tip()
endfunction

com! VimTip call luc#open_tip()

function! luc#wrap(text, pre, post) "{{{1
  return a:pre . a:text . a:post
endfunction
function! luc#wrap_delim(text, delim) "{{{1
  if a:delim == "'"
    return luc#wrap(a:text, "'", "'")
  elseif a:delim == '"'
    return luc#wrap(a:text, '"', '"')
  elseif a:delim == '(' || a:delim == ')'
    return luc#wrap(a:text, '(', ')')
  elseif a:delim == '[' || a:delim == ']'
    return luc#wrap(a:text, '[', ']')
  elseif a:delim == '{' || a:delim == '}'
    return luc#wrap(a:text, '{', '}')
  elseif a:delim == '<' || a:delim == '>'
    return luc#wrap(a:text, '<', '>')
  elseif a:delim == '$'
    return luc#wrap(a:text, '$', '$')
  elseif a:delim == '$$'
    return luc#wrap(a:text, '$$', '$$')
  elseif a:delim == '\(' || a:delim == '\)'
    return luc#wrap(a:text, '\(', '\)')
  elseif a:delim == '\[' || a:delim == '\]'
    return luc#wrap(a:text, '\[', '\]')
  endif
endfunction
function! luc#wrap_tex(text, wrapper) "{{{1
  if a:delim == "'"
    return luc#wrap(a:text, "'", "'")
  elseif a:delim == '"'
    return luc#wrap(a:text, '"', '"')
  elseif a:delim == '(' || a:delim == ')'
    return luc#wrap(a:text, '(', ')')
  elseif a:delim == '[' || a:delim == ']'
    return luc#wrap(a:text, '[', ']')
  elseif a:delim == '{' || a:delim == '}'
    return luc#wrap(a:text, '{', '}')
  elseif a:delim == '<' || a:delim == '>'
    return luc#wrap(a:text, '<', '>')
  elseif a:delim == '$'
    return luc#wrap(a:text, '$', '$')
  elseif a:delim == '$$'
    return luc#wrap(a:text, '$$', '$$')
  elseif a:delim == '\(' || a:delim == '\)'
    return luc#wrap(a:text, '\(', '\)')
  elseif a:delim == '\[' || a:delim == '\]'
    return luc#wrap(a:text, '\[', '\]')
  endif
  let cmd = a:command
  if cmd[0] != '\'
    let cmd = '\' . cmd
  endif
  "let cmd = split(cmd, '\zs')
  if split(cmd, '\zs')[-1] == '{'
    return luc#wrap(a:text, cmd, '}')
  elseif split(cmd, '\zs')[-2:-1] == ['{', '}']
    return luc.wrap(a:text, join(split(cmd, '\zs')[0:-2], ''), '}')
  else
    return luc#wrap(a:text, cmd . '{', '}')
  endif
endfunction
function! luc#wrap_operator(type) "{{{1
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
  let x = input('Wrap with: ')
  let @@ = luc#wrap_tex_command(@@, x)
  normal gvp
  let &selection = sel_save
  let @@ = saved_register
endfunction

"function! luc#prefix() "{{{1
"  let sel_save = &selection
"  let saved_register = getreg('@', 1, 1)
"  let saved_register_type = getregtype('@')
"  let &selection = "inclusive"
"  let minindent = 100000000
"  for linenr in range(line("'<"), line("'>"))
"    let minindent = min(minindent, indent(linenr))
"  endfor
"  for count in range(line("'>") - line("'<"))
"    call append(thelist, text)
"  endfor
"  call setreg('@', thelist, 'b')
"  call setpos([line("'<"), minindent])
"  execute "normal <C-V>"
"  call setpos([line("'>"), minindent])
"  normal p
"  call setreg('@', saved_register, saved_register_type)
"endfunction

function! luc#prefix(type) range "{{{1
  if a:type == ""
    let first = line("'<")
    let last = line("'>")
    let minindent = min([getpos("'<")[2], getpos("'>")[2]]) - 1
  else
    if a:type == 'line' || a:type == 'char'
      let first = line("'[")
      let last = line("']")
    elseif a:type == 'visual' || a:type == 'v' || a:type == 'V'
      let first = line("'<")
      let last = line("'>")
    else
      echoerr 'Wrong argument:' a:type
    endif
    let minindent = min(map(range(first, last), 'indent(v:val)'))
  endif
  let range = first . ',' . last
  let regex = '\v(.{' . minindent . '})(.*)'
  let fmt = escape('%s' . &commentstring, '"\')
  let subst = '\=printf("' . fmt . '", submatch(1), submatch(2))'
  execute range . 's/' . regex . '/' . subst . '/'
endfunction

function! luc#save_and_compile() " {{{1
  " Use the python function to compile the current file
  let pos = getpos('.')
  silent update
  python compile()
  call setpos('.', pos)
endfunction
