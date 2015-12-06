" gui options setup by luc

" guioptions (default: egmrLtT)
set guioptions+=cegv
set guioptions-=rT
set tabpagemax=30
set guiheadroom=0

if has("gui_macvim")
  set fuoptions=maxvert,maxhorz
  set antialias
endif

" TODO set $EDITOR for clientserver
if has('clientserver') && v:servername != ''
  let $EDITOR = 'vim --servername=' . v:servername . ' --remote-tab-wait-silent'
endif
