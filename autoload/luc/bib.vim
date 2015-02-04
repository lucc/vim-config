function! luc#bib#format()
  " format bibentries in the current file

  " format the line with "@type{key,"
  %substitute/^@\([a-z]\+\)\s*{\s*\([a-z0-9.:-]\+\),\s*$/\=s:f(submatch(1), submatch(2))/
  " format lines with closing brackets
  %substitute/^\s*}\s*$/}/
  " format lines in the entries
  %substitute/^\s*\([A-Za-z]\+\)\s*=\s*["{]\(.*\)["}],$/\=s:g(submatch(1), submatch(2))/
endfunction

function! s:f(type, key)
  " Format function to produce a nicely formatied bibtex entry.
  "
  " type: the bibtex entry type as a string
  " key: the bibtex entry key as a string
  " returns: the initial segment of the entry up to the comma after the key
  let factor = s:dist - 2 - strlen(a:type)
  return '@' . a:type . '{' . printf('%'.factor.'s', ' ') . a:key . ','
endfunction

function! s:g(key, value)
  " Format a field - value line in a bibtex entry.
  "
  " key: the field name as a string
  " value: the value of the field as a string
  " returns: a line containing the formatted field name and value
  let factor = s:dist - 4 - strlen(a:key)
  return '  ' . a:key . printf('%'.factor.'s', ' ') . '= "' . a:value . '",'
endfunction

let s:dist = 18
