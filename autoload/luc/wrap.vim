function! luc#wrap#core(text, pre, post) "{{{1
  return a:pre . a:text . a:post
endfunction

function! luc#wrap#delim(text, delim) "{{{1
  if a:delim == "'"
    return luc#wrap#core(a:text, "'", "'")
  elseif a:delim == '"'
    return luc#wrap#core(a:text, '"', '"')
  elseif a:delim == '(' || a:delim == ')'
    return luc#wrap#core(a:text, '(', ')')
  elseif a:delim == '[' || a:delim == ']'
    return luc#wrap#core(a:text, '[', ']')
  elseif a:delim == '{' || a:delim == '}'
    return luc#wrap#core(a:text, '{', '}')
  elseif a:delim == '<' || a:delim == '>'
    return luc#wrap#core(a:text, '<', '>')
  elseif a:delim == '$'
    return luc#wrap#core(a:text, '$', '$')
  elseif a:delim == '$$'
    return luc#wrap#core(a:text, '$$', '$$')
  elseif a:delim == '\(' || a:delim == '\)'
    return luc#wrap#core(a:text, '\(', '\)')
  elseif a:delim == '\[' || a:delim == '\]'
    return luc#wrap#core(a:text, '\[', '\]')
  endif
endfunction

function! luc#wrap#tex(text, wrapper) "{{{1
  if a:delim == "'"
    return luc#wrap#core(a:text, "'", "'")
  elseif a:delim == '"'
    return luc#wrap#core(a:text, '"', '"')
  elseif a:delim == '(' || a:delim == ')'
    return luc#wrap#core(a:text, '(', ')')
  elseif a:delim == '[' || a:delim == ']'
    return luc#wrap#core(a:text, '[', ']')
  elseif a:delim == '{' || a:delim == '}'
    return luc#wrap#core(a:text, '{', '}')
  elseif a:delim == '<' || a:delim == '>'
    return luc#wrap#core(a:text, '<', '>')
  elseif a:delim == '$'
    return luc#wrap#core(a:text, '$', '$')
  elseif a:delim == '$$'
    return luc#wrap#core(a:text, '$$', '$$')
  elseif a:delim == '\(' || a:delim == '\)'
    return luc#wrap#core(a:text, '\(', '\)')
  elseif a:delim == '\[' || a:delim == '\]'
    return luc#wrap#core(a:text, '\[', '\]')
  endif
  let cmd = a:command
  if cmd[0] != '\'
    let cmd = '\' . cmd
  endif
  "let cmd = split(cmd, '\zs')
  if split(cmd, '\zs')[-1] == '{'
    return luc#wrap#core(a:text, cmd, '}')
  elseif split(cmd, '\zs')[-2:-1] == ['{', '}']
    return luc#wrap#core(a:text, join(split(cmd, '\zs')[0:-2], ''), '}')
  else
    return luc#wrap#core(a:text, cmd . '{', '}')
  endif
endfunction

function! luc#wrap#operator(type) "{{{1
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
  let x = input('Wrap with: ')
  let @@ = luc#wrap#tex(@@, x)
  normal gvp
  let &selection = sel_save
  let @@ = saved_register
endfunction
