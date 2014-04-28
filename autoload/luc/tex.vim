function! luc#tex#format_bib() "{{{2
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
  " format lines wit closing brackets
  %substitute/^\s*}\s*$/}/
  " format lines in the entries
  %substitute/^\s*\([A-Za-z]\+\)\s*=\s*["{]\(.*\)["}],$/\=d.g(submatch(1), submatch(2))/
endfunction

function! luc#tex#doc() "{{{2
"function! LucTexDocFunction()
  " call the texdoc programm with the word under the cursor or the selected
  " text.
  silent execute '!texdoc' expand("<cword>")
endfunction

function! luc#tex#count(file) range "{{{2
"function! LucLatexCount(file) range
  let noerr = ' 2>/dev/null'
  if type(a:file) == type(0)
    let tex = bufname(a:file)
  elseif type(a:file) == type("")
    if a:file == ""
      let tex = expand("%")
    else
      let tex = a:file
    endif
  else
    return No_File_Found
  endif
  let cmd = 'texcount -quiet -nocol -1 -utf8 -incbib '
  let texchars = split(split(system(cmd . '-char ' . tex . noerr), "\n")[0], '+')[0]
  let texwords = split(split(system(cmd . tex . noerr), "\n")[0], '+')[0]
  let pdf = join(split(tex, '\.')[0:-2], '.').'.pdf'
  if filereadable(pdf)
    let cmd = 'pdftotext ' . pdf . ' /dev/stdout | wc -mw'
    let [pdfwords, pdfchars] = split(system(cmd))
  endif
  echo texwords 'words and' texchars 'chars in file' tex
  if exists('pdfwords')
    echo pdfwords 'words and' pdfchars 'chars in file' pdf
  endif
  return
  let tc = '!texcount -nosub '
  let wc = '!pdftotext %:r.pdf /dev/stdout | wc -mw '
  if a:char == 'char'
    let tc .= '-char '
    let wc .= '-m'
  endif
  if a:firstline == a:lastline
    let tc .= '%'
  else
    let tc = a:firstline . ',' . a:lastline . 'write ' . tc . '-'
  endif
  execute tc
  execute wc '2>/dev/null'
endfunction
