function! luc#man#open(...) "{{{2
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

function! luc#man#open_tab(type, string) "{{{2
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

python import man
function! luc#man#complete_topics(ArgLead, CmdLine, CursorPos) "{{{2
  return pyeval('list(man.complete("'.a:ArgLead.'","'.a:CmdLine.'","'.a:CursorPos.'"))')
endfunction

function! luc#man#help_tags() "{{{2
  for item in split(globpath(&runtimepath, 'doc'), '\n')
    if isdirectory(item)
      execute 'helptags' item
    endif
  endfor
endfunction

function luc#man#open_this_in_gvim()
  let l:count = index(g:vimpager_ptree, 'man')
  if l:count == -1
    echohl ErrorMsg
    echomsg 'Are you sure you are viewing a manpage? I am not.'
    echohl None
    return
  endif
  let l:count = len(g:vimpager_ptree) - l:count
  let pid = getpid()
  while l:count != 0
    let pid = system('ps -o ppid= '. pid)[0:-2]
    let l:count -= 1
  endwhile
  let arg = split(system('ps -o args= ' . pid))[-1]
  call system('transparent-gvim.sh --man ' . arg . '&')
  quit
endfunction
