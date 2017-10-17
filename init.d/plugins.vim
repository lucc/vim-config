" plugin setup file by luc
" vim: foldmethod=marker spelllang=en

let s:uname = system('uname')[:-2]

call luc#setup#vim_plug()

runtime init.d/plugins/coding.vim
runtime init.d/plugins/editing.vim
runtime init.d/plugins/completion.vim
runtime init.d/plugins/languages.vim
runtime init.d/plugins/ui.vim

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
"Plugin 'scrooloose/nerdtree'
"Plug 'tpope/vim-vinegar'
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
Plugin 'ryanoasis/vim-devicons'
Plug 'hkupty/iron.nvim'

" finalize {{{1
call plug#end()

" For very short ultisnips triggers to be usable with deoplete:
" https://github.com/SirVer/ultisnips/issues/517#issuecomment-268518251
call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
