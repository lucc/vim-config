" custom filetype settings by luc
setlocal textwidth=72
setlocal spell

" command to delete empty line(s) ant the end
command -buffer CleanTrail $ global/\v(> ?)*\s*$/ delete

" unfold interesting stuff
silent! /^$/,$ foldopen

" Move below the first empty line.
0;/^$/+1
nohlsearch

redraw
echo "Use CleanTrail!"
