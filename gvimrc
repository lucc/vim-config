" guioptions=egmrLtT
" e = something about tabs
" g = show inactive menu entries (in gray)
" m = show menu
" r = show scrollbar
" L = left hand scroll bar
" t = tearof menu items ??
" T = toolbar
set guioptions-=T


if has("gui_macvim")
  set set tabpagemax=30
  set fuoptions=maxvert,maxhorz
endif


