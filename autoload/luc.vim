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

" create a single terminal.  Calling the function again will open the same
" buffer.
function! luc#terminal() abort
  if s:term_buf_id == 0
    terminal
    let s:term_buf_id = nvim_get_current_buf()
    tmap <silent> <nowait> <buffer> <C-space> <C-\><C-n><C-space>
    tmap <silent> <nowait> <buffer> <C-o> <C-\><C-n><C-o>
    tmap <silent> <nowait> <buffer> <C-6> <C-\><C-n><C-6>
    tmap <silent> <nowait> <buffer> <C-z> <C-\><C-n><C-o>
    nmap <silent> <nowait> <buffer> <C-z> <C-o>
    autocmd TermClose <buffer> let s:term_buf_id = 0
  else
    call nvim_set_current_buf(s:term_buf_id)
  endif
  normal A
endfunction
let s:term_buf_id = 0
