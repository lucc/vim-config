function! luc#random(start, end) "{{{2
  return (system('echo $RANDOM') % (a:end - a:start + 1)) + a:start
  " code by Kazuo on vim@vim.org
  python from random import randint
  python from vim import command
  execute 'python command("return %d" % randint('.a:start.','.a:end.'))'
endfun

function! luc#flatten_list(list) "{{{2
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
  let @@ = LucMiscCapitalize(@@)
  normal gvp
  let &selection = sel_save
  let @@ = saved_register
endfunction

function! luc#goto_definition(string) "{{{2
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

function! luc#search_string_for_uri(string) "{{{2
  " function to find an URI in a string
  " thanks to  http://vim.wikia.com/wiki/VimTip306
  return matchstr(a:string, '[a-z]\+:\/\/[^ >,;:]\+')
  " alternatives:
  "return matchstr(a:string, '\(http://\|www\.\)[^ ,;\t]*')
  "return matchstr(a:string, '[a-z]*:\/\/[^ >,;:]*')
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

" functions: old {{{1
let old = {}

function! old.loadScpBuffers() "{{{2
  badd scp://math/.profile
  badd scp://ifi/.profile
  badd scp://ifi/.profile_local
  badd scp://lg/.bash_profile
endfunction

function! old.color_remove() "{{{2
  " what does this do?
  if !exists('g:colors_name')
    echoerr 'The variable g:colors_name is not set!'
    return
  else
    let file = globpath(&rtp, 'colors/' . g:colors_name . '.vim')
    if file == ''
      echoerr 'Can not find colorscheme ' . g:colors_name . '!'
      return
    elseif !exists('g:remove_files')
      let g:remove_files = [file]
    elseif type(g:remove_files) != type([])
      echoerr 'g:remove_files is not a list!'
      return
    else
      call add(g:remove_files, file)
      return file
    endif
  endif
endfunction
