function! luc#bib#format() "{{{1
  " format bibentries in the current file

  " define a local helper function
  let d = {}
  let dist = 18
  function! d.f(type, key)
    let dist = 18
    let factor = dist - 2 - strlen(a:type)
    return '@' . a:type . '{' . printf('%'.factor.'s', ' ') . a:key . ','
  endfunction
  function! d.g(key, value)
    let dist = 18
    let factor = dist - 4 - strlen(a:key)
    return '  ' . a:key . printf('%'.factor.'s', ' ') . '= "' . a:value . '",'
  endfunction

  " format the line with "@type{key,"
  %substitute/^@\([a-z]\+\)\s*{\s*\([a-z0-9.:-]\+\),\s*$/\=d.f(submatch(1), submatch(2))/
  " format lines with closing brackets
  %substitute/^\s*}\s*$/}/
  " format lines in the entries
  %substitute/^\s*\([A-Za-z]\+\)\s*=\s*["{]\(.*\)["}],$/\=d.g(submatch(1), submatch(2))/
endfunction
