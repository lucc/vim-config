" plugin setup file by luc
" vim: foldmethod=marker spelllang=en

let s:uname = system('uname')[:-2]

call luc#setup#vim_plug()

runtime vimrc.d/plugins/coding.vim
runtime vimrc.d/plugins/editing.vim
runtime vimrc.d/plugins/completion.vim
runtime vimrc.d/plugins/languages.vim
runtime vimrc.d/plugins/colors.vim

" plugins: shell in Vim {{{1

Plugin 'ervandew/screen'
let g:ScreenImpl = 'Tmux'

if has('gui_macvim')

  let g:ScreenShellTerminal = 'iTerm.app'

  " notes
  Plugin 'Conque-Shell'
  "Plugin 'vimsh.tar.gz'
  "Plugin 'xolox/vim-shell'
  "Plugin 'vimux'

  Plugin 'Shougo/vimshell.vim'
  Plugin 'Shougo/vimproc'
  "map <D-F11> :VimShellPop<cr>
  let g:vimshell_temporary_directory = expand('~/.cache/vim/vimshell')
endif

" to be tested (shell in gvim) {{{2
Plugin 'https://bitbucket.org/fboender/bexec.git'
if has('clientserver') | Plugin 'pydave/AsyncCommand' | endif

" plugins: statusline {{{1

if has('python') && ! has('nvim')
  "Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
  " the documentation of powerline is not in Vim format but only available at
  " https://powerline.readthedocs.org/
  source /usr/lib/python3.4/site-packages/powerline/bindings/vim/plugin/powerline.vim
else
  Plugin 'bling/vim-airline'
  "Plugin 'bling/vim-bufferline'
  let g:airline_powerline_fonts = 1
  "let g:airline#extensions#tabline#enabled = 1
endif

" vim options related to the statusline {{{2
set noshowmode   " do not display the current mode in the command line
set laststatus=2 " always display the statusline

" plugins: searching {{{1
"if executable('ag')
  Plugin 'rking/ag.vim'
"elseif executable('ack')
  Plugin 'mileszs/ack.vim'
"endif

" plugins: unsorted {{{1
Plugin 'jamessan/vim-gnupg'
Plugin 'pix/vim-known_hosts'
Plugin 'scrooloose/nerdcommenter'
Plugin 'sjl/gundo.vim'
"Plugin 'VimRepress' "https://bitbucket.org/pentie/vimrepress
Plugin 'lucc/VimRepress'
Plugin 'ZoomWin'
Plugin 'AndrewRadev/linediff.vim'
if has('python')
  Plugin 'guyzmo/notmuch-abook'
  let g:notmuchconfig = "~/.config/notmuch/config"
endif
if s:uname != 'Linux' || has('nvim')
  Plugin 'git://notmuchmail.org/git/notmuch', {'rtp': 'contrib/notmuch-vim'}
endif

Plugin '~/src/vim-tip'

" finalize {{{1
call plug#end()
