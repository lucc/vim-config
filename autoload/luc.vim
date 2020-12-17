
function! luc#remote_editor(mail) abort
  " a function to be called by a client who wishes to use a vim server as an
  " non forking edior. One can also set the environment variable EDITOR with
  " EDITOR='vim --remote-tab-wait-silent +call\ luc#remote_editor()'

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

function! luc#time(cmd1, cmd2, count) abort
  " execute two ex commands count times each and print the duration
  let header = [
	\ 'let s:time1 = reltime()',
	\ 'for i in range('.a:count.')'
	\ ]
  let footer = [
	\ 'endfor',
	\ 'let s:time2 = reltime(s:time1)'
	\ ]
  let length = min([max([len(a:cmd1), len(a:cmd2)]) + 5, &columns - 20])
  let fmt = '%-'.length.'.'.length.'s'
  let echostr = 'echo %s." -> ".reltimestr(s:time2)." sec"'
  let echo1 = printf(echostr, string(printf(fmt, a:cmd1)))
  let echo2 = printf(echostr, string(printf(fmt, a:cmd2)))
  echo 'Running' a:count 'repetitions of ...'
  let file = tempname()
  call writefile(header+[a:cmd1]+footer+[echo1], file)
  execute 'source' file
  call writefile(header+[a:cmd2]+footer+[echo2], file)
  execute 'source' file
  call delete(file)
endfunction

function! luc#capitalize(text) abort
  return substitute(a:text, '\v<(\w)(\w*)>', '\u\1\L\2', 'g')
endfunction

function! luc#capitalize_operator_function(type) abort
  " This does not work in block moode
  ""%s/\%'<\_.*\%'>/\=substitute(submatch(0), '\v<(\w)(\w*)>', '\u\1\L\2', 'g')/
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

function! luc#find_next_spell_error() abort
  " A function to jump to the next spelling error
  setlocal spell
  "if spellbadword(expand('<cword>')) == ['', '']
    normal! ]s
  "endif
endfunction

function! luc#get_visual_selection() abort
  " see:
  "http://vim.wikia.com/wiki/Making_Parenthesis_And_Brackets_Handling_Easier
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

function! s:flatten_list(list) abort
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

function! s:goto_definition(string) abort
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

function! s:select_font(big) abort
  " Select a font and set it
  let delim = ''
  if has('gui_macvim')
    let s:delim = ':h'
  elseif has('gui_gtk2')
    let s:delim = ' '
  endif
  " TODO
endfunction

function! luc#prefix_old() abort
  let sel_save = &selection
  let saved_register = getreg('@', 1, 1)
  let saved_register_type = getregtype('@')
  let &selection = "inclusive"
  let minindent = 100000000
  for linenr in range(line("'<"), line("'>"))
    let minindent = min(minindent, indent(linenr))
  endfor
  for count in range(line("'>") - line("'<"))
    call append(thelist, text)
  endfor
  call setreg('@', thelist, 'b')
  call setpos([line("'<"), minindent])
  execute "normal <C-V>"
  call setpos([line("'>"), minindent])
  normal p
  call setreg('@', saved_register, saved_register_type)
endfunction

function! luc#prefix(type) range abort
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

function! luc#mail_format_quote_header() range abort
  " Formate the header of a quote block in an email message.
  "
  " : TODO
  " returns: TODO
  execute a:firstline . ',' . a:lastline . 'substitute/^\(> *\)*//'
  execute a:firstline . ',' . a:lastline . 'global/^-----Ursprüngliche Nachricht-----$/delete'
  " TODO find header fields ...
endfunction

function! luc#prepare_vcard_null_lines_for_merge() range abort
  " documentation
  "
  " : TODO
  " returns: TODO
  if a:firstline < a:lastline
    execute a:firstline . ',' . (a:lastline - 1) . 'substitute/END:VCARD$//'
    execute (a:firstline + 1) . ',' . a:lastline . 'substitute/^BEGIN:VCARD//'
  endif
  execute a:firstline . ',' . a:lastline 'substitute/\%x00/\r/g'
  execute 'set undolevels=' . &undolevels
  execute a:firstline + 1 . ',/^END:VCARD$/-1 sort u'
  execute a:firstline + 1 . ',/^END:VCARD$/-1 global /^$/ delete'
  execute a:firstline + 1 . ',/^END:VCARD$/-1 global /^VERSION:/ move' . a:firstline
  noh
  redraw
endfunction

function! luc#vcard2null_line() range abort
  "
  "
  " : TODO
  " returns: TODO
  execute a:firstline . ',' . a:lastline . 'substitute/\n\([A-Z]\)/\n\1/g'
  noh
  redraw
endfunction

function! luc#nvim_as_terminal() abort
  " Set up nvim to be usable as a stand alone terminal.
  if exists('s:terminal')
    let s:terminal.last_buffer = buffer_number('%')
    execute 'buffer' s:terminal.buffer
    startinsert
  else
    let s:terminal = {}
    let s:terminal.last_buffer = buffer_number('%')
    terminal zsh
    let s:terminal.buffer = buffer_number('%')
    let s:terminal.original_options = {}
    let s:terminal.original_options.laststatus = &laststatus
    let s:terminal.original_options.cmdheight = &cmdheight
    let s:terminal.original_options.showmode = &showmode
  endif
  set laststatus=0
  set cmdheight=1
  set noshowmode
  tnoremap <buffer> <C-S> <C-\><C-N>:call luc#return_from_terminal()<CR>
endfunction

function! luc#return_from_terminal() abort
  " Undo the settings done by luc#nvim_as_terminal.
  if !exists('s:terminal')
    echoerr "The terminal was never opened!"
    return
  endif
  for [option, value] in items(s:terminal.original_options)
    execute 'let &' . option . '=' . string(value)
  endfor
  execute 'buffer' s:terminal.last_buffer
endfunction

function! luc#get_terminal() abort
  return copy(s:terminal)
endfunction

function! luc#khard_editor() abort
  " Load options and maps for editing khard yaml files.
  setfiletype yaml
  map  <buffer> <tab>       /^[^#]/<cr>A
  imap <buffer> <tab> <c-o>:/^[^#]/ normal $<cr>
endfunction