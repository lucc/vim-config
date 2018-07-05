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
Plug 'mhinz/vim-grepper'
let g:grepper = {}
let g:grepper.quickfix = 0
command! -nargs=* -complete=file Ag Grepper -jump -tool ag -query <args>
nnoremap <Leader>g :Grepper<CR>

"Plug 'wsdjeg/FlyGrep.vim'

" plugins: unsorted {{{1
Plug 'jamessan/vim-gnupg'
Plug 'pix/vim-known_hosts'
Plug 'scrooloose/nerdcommenter'
"Plugin 'scrooloose/nerdtree'
"Plug 'tpope/vim-vinegar'
Plug 'sjl/gundo.vim'
"Plugin 'VimRepress' "https://bitbucket.org/pentie/vimrepress
Plug 'lucc/VimRepress'
Plug 'aquach/vim-mediawiki-editor'
let g:mediawiki_editor_uri_scheme = 'http'
let g:mediawiki_editor_url = 'asam2'
let g:mediawiki_editor_path = '/asam_wiki/'
let g:mediawiki_editor_username = 'LUC'

"Plugin 'vim-scripts/ZoomWin'
Plug 'AndrewRadev/linediff.vim'

Plug '~/src/vim-tip'

Plug 'chrisbra/unicode.vim'
Plug 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
Plug 'ryanoasis/vim-devicons'
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
call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
" https://github.com/autozimu/LanguageClient-neovim/wiki/deoplete
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)
