" plugin setup file by luc
"
" vim: foldmethod=marker spelllang=en

call luc#setup#vim_plug()

runtime init.d/plugins/coding.vim
runtime init.d/plugins/editing.vim
runtime init.d/plugins/completion.vim
runtime init.d/plugins/languages.vim
runtime init.d/plugins/ui.vim

" plugins: searching {{{1
Plugin 'mhinz/vim-grepper' "{{{2
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
"Plugin 'vim-scripts/ZoomWin'
Plugin 'AndrewRadev/linediff.vim'
if has('python')
  Plugin 'guyzmo/notmuch-abook'
endif

Plugin '~/src/vim-tip'

Plugin 'chrisbra/unicode.vim'
Plugin 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
Plugin 'ryanoasis/vim-devicons'
Plug 'hkupty/iron.nvim'
command REPL IronRepl

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_auto_colors = 0
let g:indent_guides_default_mapping = 0
highlight link IndentGuidesOdd  Normal
highlight link IndentGuidesEven LineNr

" finalize {{{1
call plug#end()

" For very short ultisnips triggers to be usable with deoplete:
" https://github.com/SirVer/ultisnips/issues/517#issuecomment-268518251
call deoplete#custom#set('ultisnips', 'matchers', ['matcher_fuzzy'])
