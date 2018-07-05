" Settings and plugins for the look and feel/user interface (graphics only)

scriptencoding utf-8

" colors
Plug 'iCyMind/NeoSolarized'
Plug 'altercation/vim-colors-solarized'
let g:solarized_menu = 0

" statusline
let s:statusline = 'air'
if s:statusline == 'power'
  " the documentation of powerline is not in Vim format but only available at
  " https://powerline.readthedocs.org/
  let g:powerline_pycmd = 'py3'
  "Plug 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
  source /usr/share/vim/vimfiles/plugin/powerline.vim
elseif s:statusline == 'air'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  let g:airline_theme = 'solarized'
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#whitespace#mixed_indent_algo = 2
  let g:airline#extensions#whitespace#checks = ['indent', 'trailing', 'long']
elseif s:statusline == 'light'
  Plug 'itchyny/lightline.vim'
  let g:lightline = {
	\ 'colorscheme': 'solarized',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
	\ },
	\ 'component_function': {
	\   'fugitive': 'LightLineFugitive',
	\   'filename': 'LightLineFilename'
	\ }
	\ }
  function! LightLineModified()
    return &ft =~ 'help\|vimfiler' ? '' : &mod ? '+' : &mod ? '' : '-'
  endfunction
  function! LightLineReadonly()
    return &ft !~? 'help\|vimfiler' && &readonly ? 'RO' : ''
  endfunction
  function! LightLineFilename()
    return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
	  \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
	  \  &ft == 'unite' ? unite#get_status_string() :
	  \  &ft == 'vimshell' ? vimshell#get_status_string() :
	  \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
	  \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
  endfunction
  function! LightLineFugitive()
    if exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? ' '._ : ''
    endif
    return ''
  endfunction
endif

" vim options related to the statusline
set noshowmode   " do not display the current mode in the command line
set laststatus=2 " always display the statusline
