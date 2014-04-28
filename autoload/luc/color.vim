function! luc#color#find() "{{{2
  "return luc#flatten_list(filter(map(split(&rtp, ','),
  "      \ 'glob(v:val .  "/**/colors/*.vim", 0, 1)'), 'v:val != []'))
  return sort(map(split(globpath(&rtp, 'colors/*.vim'), '\n'),
        \ 'split(v:val, "/")[-1][0:-5]'))
endfunction

function! luc#color#selectrandom() "{{{2
  let colorschemes = luc#color#find()
  let this = colorschemes[luc#random(0,len(colorschemes)-1)]
  execute 'colorscheme' this
  redraw
  let g:colors_name = this
  echo g:colors_name
endfunction

function! luc#color#like(val) "{{{2
  let fname = glob('~/.vim/colorscheme-ratings')
  let cfiles = map(readfile(fname), 'split(v:val)')
  for item in cfiles
    if item[0] == g:colors_name
      let item[1] += a:val
      break
    endif
  endfor
  call writefile(map(cfiles, 'join(v:val)'), fname)
  echo g:colors_name
endfunction

