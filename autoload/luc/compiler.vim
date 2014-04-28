" Autoloading functions to compiler different kinds of files.

function! luc#compiler#generic(target, override)
  " Try to build stuff depending on some parameters.  What will be built is
  " decided by a:target and if absent the current file.  First a makefile is
  " searched for in the directory %:h and above.  If one is found it is used
  " to make a:target.  If no makefile is found and filetype=tex, the current
  " file will be compiled with latexmk.  If a:override is non zero only
  " latexmk will be executed and no makefile will be searched.

  " local variables
  let functionname = ''
  let path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let dir = ''

  " try to find a makefile and set dir and cmd
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

  " if no makefile was found or override was asked for try to use latex
  if a:override || functionname == ''
    if has_key(s:, 'compiler_'.&filetype)
      let functionname = &filetype
      let argument = expand('%:t')
      let dir = expand('%:h')
    else
      echoerr 'Not able to compile anything.'
      let error = 1
    endif
  endif

  " if no filetype function or makefile was found return with an error
  if functionname == ''
    echoerr 'Not able to compile anything. (2)'
    let error = 1
  " else execute the command in the proper directory
  else
    execute 'cd' dir
    execute 'let cmd = s:compiler_' . functionname . '(argument)'
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

  redraw " to get rid of unneded 'press enter' prompts
  return error
endfunction

function! luc#compilr#generic2(target) "{{{2
  " Try to build the current file automatically.  If a:target is not specified
  " and there is a compiler function available in g:compiler it will be used
  " to find out how to compile the current file.  If a:target is specified or
  " there is no compiler function a makefile will be searched.

  " local variables
  let functionname = ''
  let path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
  let dir = ''

  " type check
  if type(a:target) != type('string')
    echoerr 'The target has to be a string.'
    return TypeError
  endif

  " look at g:compiler to find a function for &filetype
  if has_key(s:, 'compiler_'.&filetype)
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
    execute 'let cmd = s:compiler_' . functionname . '(argument)'
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

  redraw " to get rid of unneded 'press enter' prompts
  return error
endfunction

function! s:compiler_ant(target)
  return 'ant' . (a:target == '' ? '' : ' ' . a:target)
endfunction

function! s:compiler_make(target)
  return 'make' . (a:target == '' ? '' : ' ' . a:target)
endfunction

function! s:compiler_markdown(sourcefile)
  let target = fnamemodify(a:sourcefile, ':r').'.html'
  return 'multimarkdown --full --smart --output='.target.' '.a:sourcefile
endfunction

function! s:compiler_tex(sourcefile)
  return 'latexmk -silent ' . a:sourcefile
endfunction

