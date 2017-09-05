" plugin setup file by luc
" vim: foldmethod=marker spelllang=en

let s:uname = system('uname')[:-2]

call luc#setup#vim_plug()

runtime init.d/plugins/coding.vim
runtime init.d/plugins/editing.vim
runtime init.d/plugins/completion.vim
runtime init.d/plugins/languages.vim
runtime init.d/plugins/colors.vim

" plugins: statusline {{{1

let s:statusline = 'light'
if s:statusline == 'power'
  " the documentation of powerline is not in Vim format but only available at
  " https://powerline.readthedocs.org/
  let g:powerline_pycmd = 'py3'
  "Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
  source /usr/share/vim/vimfiles/plugin/powerline.vim
elseif s:statusline == 'air'
  Plugin 'bling/vim-airline'
  "Plugin 'bling/vim-bufferline'
  let g:airline_powerline_fonts = 1
  "let g:airline_left_sep = ''
  "let g:airline_right_sep = ''
  "let g:airline#extensions#tabline#enabled = 1
elseif s:statusline == 'light'
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
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
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
  Plugin 'itchyny/lightline.vim'
endif

" vim options related to the statusline {{{2
set noshowmode   " do not display the current mode in the command line
set laststatus=2 " always display the statusline

" plugins: searching {{{1
"Plugin 'rking/ag.vim'
"Plugin 'mileszs/ack.vim'
Plugin 'mhinz/vim-grepper' "{{{2
command! -nargs=* -complete=file GG Grepper -jump -tool git -query <args>
command! -nargs=* -complete=file Ag Grepper -jump -tool ag -query <args>

" plugins: unsorted {{{1
Plugin 'jamessan/vim-gnupg'
Plugin 'pix/vim-known_hosts'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/gundo.vim'
"Plugin 'VimRepress' "https://bitbucket.org/pentie/vimrepress
Plugin 'lucc/VimRepress'
Plugin 'vim-scripts/ZoomWin'
Plugin 'AndrewRadev/linediff.vim'
if has('python')
  Plugin 'guyzmo/notmuch-abook'
endif
Plugin 'git://git.notmuchmail.org/git/notmuch', {'rtp': 'contrib/notmuch-vim'}

Plugin '~/src/vim-tip'

Plugin 'chrisbra/unicode.vim'
Plugin 'chrisbra/vim-zsh'
Plugin 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
"Plugin 'ryanoasis/vim-devicons'
Plug 'hkupty/iron.nvim'
Plug 'severin-lemaignan/vim-minimap'

" finalize {{{1
call plug#end()
