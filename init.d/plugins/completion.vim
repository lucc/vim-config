" vim: spelllang=en
" plugins: completion

let s:choice = 'deoplete'

if s:choice == 'ycm'
  Plug 'Valloric/YouCompleteMe'
  let g:ycm_filetype_blacklist = {}
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_completion = 0
  let g:ycm_extra_conf_globlist = [
	\ '~/vcs/nvim/src/.ycm_extra_conf.py',
	\ '~/vcs/neovim/src/.ycm_extra_conf.py'
	\ ]
  let g:ycm_autoclose_preview_window_after_completion = 1

  Plug 'bjoernd/vim-ycm-tex',
	\ {'name': 'YouCompleteMe/python/ycm/completers/tex'}
  let g:ycm_semantic_triggers = {'tex': ['\ref{','\cite{']}

  "Plugin 'c9s/vimomni.vim'
  "Plugin 'tek/vim-ycm-vim'
elseif s:choice == 'deoplete'
  " FIXME for ultisnips integration we have to make a function call after
  " plug#end() in init.d/plugins.vim.
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  " A list of possible source for completion is at
  " https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
  Plug 'Shougo/neco-syntax'
  Plug 'Shougo/neco-vim'
  Plug 'fszymanski/deoplete-emoji'
  Plug 'nicoe/deoplete-khard'
  Plug 'padawan-php/deoplete-padawan'
  Plug 'poppyschmo/deoplete-latex'
  Plug 'zchee/deoplete-zsh'
  Plug 'lionawurscht/deoplete-biblatex'
  "Plug 'zchee/deoplete-jedi'
  "https://github.com/SevereOverfl0w/deoplete-github
  "https://github.com/lvht/phpcd.vim
  "https://github.com/tpope/vim-rhubarb
elseif s:choice == 'ncm'
  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2-abbrfuzzy'

  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-jedi'
  Plug 'ncm2/ncm2-html-subscope'
  Plug 'ncm2/ncm2-markdown-subscope'
  Plug 'ncm2/ncm2-rst-subscope'

  autocmd BufEnter * call ncm2#enable_for_buffer()

  set completeopt+=noinsert
  set completeopt+=menuone
endif

if s:choice != 'none'
  " Map <S-Tab> to <C-P> to go to the previous completion entry in insert
  " mode.
  inoremap <expr> <Tab>   pumvisible() ? "\<C-N>"      : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>"      : "\<Tab>"
  "inoremap <expr> <CR>    pumvisible() ? "\<C-Y>\<CR>" : "\<CR>"
endif

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
let g:LanguageClient_serverCommands = {
      \ 'c': ['cquery'] ,
      \ 'css': ['css-languageserver'],
      \ 'docker': ['docker-languageserver'],
      \ 'html': ['html-languageserver'],
      \ 'java': ['jdtls', '-Dlog.level=ALL'],
      \ 'json': ['json-languageserver'],
      \ 'lua': ['lua-lsp'],
      \ 'python': ['pyls'],
      \ 'sh': ['bash-language-server', 'start'],
      \ }
"    \ 'php': ['php', 'php-language-server.php'],
"    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
"    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
"    \ 'java': ['jdtls', '-data', {{ your workspace }}, '-Dlog.level=ALL'],
"

" Automatically start language servers.
 let g:LanguageClient_autoStart = 1
"
nnoremap <silent> KK :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1

" options related to completion

" Use the 'dictionary' option for completion
set complete+=k

" use the current spell checking settings for directory completion:
set dictionary+=spell
" system word lists
set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/british-english
set dictionary+=/usr/share/dict/ngerman
