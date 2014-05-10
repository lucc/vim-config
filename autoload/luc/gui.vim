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

function! luc#gui#resize() " {{{2
  " function to put the gvim window on the left of the screen
  set nofullscreen
  set guioptions-=T
  winpos 0 0
  let &guifont = s:normalfonts
  set lines=999
  set columns=85
  "redraw!
endfunction

function! luc#gui#OpenPdfOrPreview (check, file, go_back) " {{{2
  " function to check if a pdf file is open in Preview.app and bring it to the
  " foreground.  a:go_back is used to return to vim or not.  When a:file is
  " empty the stem of the current file is used with '.pdf' appended.
  "
  " The command to switch to the pdf program or open a pdf file.
  "let l:switch  = '!open -ga Preview'
  let l:switch  = '!open -a Preview'
  let l:open    = '!open -a Preview '
  let l:command = ''
  let l:msg     = ''
  let l:go_back = a:go_back
  " find a suitable filename
  "let l:file = expand('%') =~ '.*\.tex' ? expand('%:r') . '.pdf' : ''
  let l:file = &filetype == 'tex' ? expand('%:r') . '.pdf' : ''
  let l:file = a:file ? a:file : l:file
  if l:file == ''
    echoerr 'No suitable filename found.'
    return
  endif
  " find the right command to execute
  " this version is for mac os x wih Preview.app
  if 0 " don't use Preview.app on macosx
    if a:check
      " collect the output from 'lsof'
      let l:result = system('lsof ' . l:file)
      " parse the output (FIXME system specific)
      let l:result = match(get(split(l:result, '\n'), 1, ''), '^Preview')
      " if the file was not opend, do so, else only switch the application
      if v:shell_error || l:result == -1
	let l:command = l:open . l:file
	let l:msg = 'Opening file "' . l:file . '" ...'
      else
	let l:command = l:switch
	let l:msg = 'Switching to viewer ...'
      endif
    else
      let l:command = l:switch
      let l:msg = 'Switching to viewer ...'
      "let l:go_back = 0
    endif
  else " use mupdf instead (on all systems)
    let l:command = 'killall -HUP mupdf || mupdf ' . l:file . ' &'
    let l:msg = l:command
  endif
  " display a message and execute the command
  echo l:msg
  "silent execute l:command
  call system(l:command)
  " return to vim if desired
  if l:go_back
    " wait for the pdf-viewer to update its display
    sleep 1000m
    " bring vim to the foreground again
    call foreground()
  endif
endfunction
