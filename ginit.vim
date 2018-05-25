" ginit file by luc

" GUI specific plugins
Plug 'equalsraf/neovim-gui-shim'

augroup LucDelMenus
  autocmd!
  autocmd VimEnter * aunmenu *
augroup END

nmap ß :windo set rightleft!<CR>

nmap <F12>       :call luc#gui#toggle_font_size()<CR>
imap <F12>  <C-O>:call luc#gui#toggle_font_size()<CR>

" guioptions (default: egmrLtT)
set guioptions+=cegv
set guioptions-=rT
set tabpagemax=30

" TODO set $EDITOR for clientserver
if has('clientserver') && v:servername != ''
  let $EDITOR = 'vim --servername=' . v:servername . ' --remote-tab-wait-silent'
endif

" color settings
set background=dark
if exists('g:gonvim_running')
  colorscheme Neosolarized
else
  colorscheme solarized
endif
if exists('g:gonvim_running')
  GuiFont dejavu sans mono:12
elseif exists('g:GtkGuiLoaded')
  "GuiFont dejavu sans mono:12
  call rpcnotify(1, 'Gui', 'Font', 'DejaVu Sans Mono 10')
endif

