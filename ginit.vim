" ginit file by luc

colorscheme NeoSolarized

" Use the gui-shim to set the gui font. See :h gui-shim
GuiFont DejaVu Sans Mono:h9

" Remove all menus
aunmenu *

if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Font', 'DejaVu Sans Mono 9')
  call rpcnotify(1, 'Gui', 'Option', 'Cmdline', 0)
elseif exists('g:gonvim_running')
else
  " nvim-qt?
endif
