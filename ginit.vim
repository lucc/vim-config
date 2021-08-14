" ginit file by luc

" Remove all menus
aunmenu *

colorscheme NeoSolarized

if exists('g:gnvim')          " https://github.com/vhakulinen/gnvim
  set guifont=DejaVuSansMono\ Nerd\ Font:h9
elseif exists('g:neovide')    " https://github.com/neovide/neovide
  set guifont=DejaVuSansMono\ Nerd\ Font:h8
elseif exists(':GuiFont')     " https://github.com/equalsraf/neovim-qt
  GuiFont DejaVu Sans Mono:h9
endif
