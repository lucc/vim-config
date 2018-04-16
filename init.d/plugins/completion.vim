" vim: foldmethod=marker spelllang=en
" plugins: completion

let s:choice = 'deoplete'

if s:choice == 'ycm'
  Plugin 'Valloric/YouCompleteMe'
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

  Plugin 'bjoernd/vim-ycm-tex',
	\ {'name': 'YouCompleteMe/python/ycm/completers/tex'}
  let g:ycm_semantic_triggers = {'tex': ['\ref{','\cite{']}

  "Plugin 'c9s/vimomni.vim'
  "Plugin 'tek/vim-ycm-vim'
elseif s:choice == 'deoplete'
  " FIXME for ultisnips integration we have to make a function call after
  " plug#end() in init.d/plugins.vim.
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  "Plug 'zchee/deoplete-jedi'
  "https://github.com/poppyschmo/deoplete-latex
  "https://github.com/lvht/phpcd.vim
  "https://github.com/padawan-php/deoplete-padawan
  "https://github.com/Shougo/neco-vim
  "https://github.com/Shougo/neco-syntax
  "https://github.com/zchee/deoplete-zsh
  "https://github.com/tpope/vim-rhubarb
  "https://github.com/SevereOverfl0w/deoplete-github
  "https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
elseif s:choice == 'ncm'
  Plug 'roxma/nvim-completion-manager'
endif

if s:choice != 'none'
  " Map <S-Tab> to <C-P> to go to the previous completion entry in insert
  " mode.
  inoremap <expr> <Tab>   pumvisible() ? "\<C-N>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<Tab>"
endif

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
let g:LanguageClient_serverCommands = {
      \ 'python': ['pyls'],
      \ 'lua': ['lua-lsp'],
      \ }
"    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
"    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
"    \ }

" Automatically start language servers.
 let g:LanguageClient_autoStart = 1
"
nnoremap <silent> KK :call LanguageClient_textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

Plug 'Shougo/echodoc.vim'
let g:echodoc#enable_at_startup = 1
