function! luc#remote_editor(mail) "{{{2
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

function! luc#time(cmd1, cmd2, count) " {{{2
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

function! luc#capitalize(text) " {{{2
  return substitute(a:text, '\v<(\w)(\w*)>', '\u\1\L\2', 'g')
endfunction

function! luc#capitalize_operator_function(type) "{{{2
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

function! luc#find_next_spell_error() "{{{2
  " A function to jump to the next spelling error
  setlocal spell
  "if spellbadword(expand('<cword>')) == ['', '']
    normal ]s
  "endif
endfunction

" see:
"http://vim.wikia.com/wiki/Making_Parenthesis_And_Brackets_Handling_Easier
function! luc#get_visual_selection() "{{{2
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

function! luc#format_bib() "{{{2
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

function! luc#resize_gui() " {{{2
  " function to put the gvim window on the left of the screen
  set nofullscreen
  set guioptions-=T
  winpos 0 0
  let &guifont = s:normalfonts
  set lines=999
  set columns=85
  "redraw!
endfunction

function! s:flatten_list(list) "{{{2
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

function! s:goto_definition(string) "{{{2
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

function! s:select_font(big) "{{{2
  " Select a font and set it
  let delim = ''
  if has('gui_macvim')
    let s:delim = ':h'
  elseif has('gui_gtk2')
    let s:delim = ' '
  endif
  " TODO
endfunction
