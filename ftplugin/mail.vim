" custom filetype settings by luc
setlocal textwidth=72
setlocal spell

" command to delete empty line(s) at the end
command -buffer CleanTrail $ global/\v^(\> ?)*\s*$/ delete

" unfold interesting stuff
silent! /^$/,$ foldopen

" Move below the first empty line.  This should be just below the header.
0;/^$/+1
nohlsearch

" If this is the last line in the file and is empty add a new line
if line('.') == line('$') && getline('.') =~# '^$'
  normal o
endif

redraw
echo 'Use CleanTrail!'
