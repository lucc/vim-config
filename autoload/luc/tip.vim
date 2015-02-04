function! luc#tip#open()
  execute 'help' s:select()
  autocmd BufLeave <buffer> call s:dialog()
endfunction

function! luc#tip#info()
  " Display a small info about the plugin.
  echo 'file is' s:ignore_file 'last tip was' s:last_tip
endfunction

let s:ignore_file = expand('~/.cache/vim-tip.ignore')
let s:last_tip = ''

function! s:select()
  " display a random help topic
  let list = s:tags()
  for line in readfile(s:ignore_file)
    call filter(list, 'v:val != line')
  endfor
  let s:last_tip = list[s:random(0, len(list) - 1)]
  return s:last_tip
endfunction

function! s:dialog()
  " Ask to ignore the last tip for the future
  if confirm('Skip this tip in the future?', "&Yes\n&no") == 1
    let file = readfile(s:ignore_file)
    call add(file, s:last_tip)
    call writefile(file, s:ignore_file)
  endif
endfunction

function! s:tags()
  " return a list of all help tags
  let list = []
  let ignore = readfile(s:ignore_file)
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

function! s:random(start, end) "{{{1
  return (system('echo $RANDOM') % (a:end - a:start + 1)) + a:start
  python import random
  return pyeval('random.randint('.a:start.','.a:end.')')
endfun
