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

function! luc#man#complete_topics(ArgLead, CmdLine, CursorPos) "{{{2
  let paths = tr(system('man -w'), ":\n", "  ")
  "let paths = "/usr/share/man/man9"
  return system('find ' . paths .
	\ ' -type f | sed "s#.*/##;s/\.gz$//;s/\.[0-9]\{1,\}//" | sort -u')
endfunction

function! luc#man#help_tags() "{{{2
  for item in split(globpath(&runtimepath, 'doc'), '\n')
    if isdirectory(item)
      execute 'helptags' item
    endif
  endfor
endfunction

