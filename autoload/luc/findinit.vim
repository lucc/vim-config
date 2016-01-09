" Functions to start Ctrl-P in fullscreen mode to find an initial buffer to
" edit.

let s:saved = {}
let s:restore = {}

function! luc#findinit#from_env()
    call s:Run(exists('$LUC_FINDINIT_DEFAULT_INPUT') ? $LUC_FINDINIT_DEFAULT_INPUT : '')
endfunction

function! luc#findinit#run(input)
  " Wrapper arround s:Run.  See docs there.
  "
  " input: the initial text to put in the CtrlP command, a string
  " returns: 0
  call s:Run(a:input)
endfunction

function! s:Save_global_variable(variable_name, new_value)
  " Save the old value of the given variable name and set it to the new value.
  "
  " variable_name: the name of the global variable to save (without the
  "                leading "g:")
  " new_value: the new value for the variable
  " returns: the new value
  if exists('g:'.a:variable_name)
    let s:saved[a:variable_name] = get(g:, a:variable_name)
    let s:restore[a:variable_name] = 1
  else
    let s:restore[a:variable_name] = 0
  endif
  let g:[a:variable_name] = a:new_value
  return a:new_value
endfunction

function! s:Restore_global_variable(variable_name)
  " Resore a previously saved global variable.
  "
  " variable_name: the name of the global variable the restore (without the
  "                leading "g:")
  " returns: 0
  if s:restore[a:variable_name]
    let g:[a:variable_name] = s:saved[a:variable_name]
  else
    unlet g:[a:variable_name]
  endif
  unlet s:restore[a:variable_name]
  unlet s:saved[a:variable_name]
endfunction

function! s:Run(input)
  " Run CtrlPMRU with the given input and clean up afterwards.
  "
  " input: the input to feed to CtrlP initially
  " returns: 0

  " Typecheck the argument.
  let l:input = type(a:input) != type('') ? '' : a:input
  " Save the global window settings and apply custom ones.
  if exists('g:ctrlp_match_window')
    let l:saved_ctrlp_match_window = g:ctrlp_match_window
  endif
  let g:ctrlp_match_window = 'bottom,order:btt,min:'.(&lines + 1).',max:'.(&lines + 1)
  " Save the global default input and apply the custom one.
  if exists('g:ctrlp_default_input')
    let l:saved_ctrlp_default_input = g:ctrlp_default_input
  endif
  let g:ctrlp_default_input = l:input
  let g:ctrlp_open_single_match = ['all']
  " Run CtrlP.
  CtrlPMRU
  unlet g:ctrlp_open_single_match
  " Clean up the default input settings.
  if exists('l:saved_ctrlp_default_input')
    let g:ctrlp_default_input = l:saved_ctrlp_default_input
  else
    unlet g:ctrlp_default_input
  endif
  " Clean up the default window settings.
  if exists('l:saved_ctrlp_match_window')
    let g:ctrlp_match_window = l:saved_ctrlp_match_window
  else
    unlet g:ctrlp_match_window
  endif
endfunction
