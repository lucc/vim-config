" vim: spelllang=en
" plugins: completion

let s:choice = 'ncm'

if s:choice == 'coc'
else
  inoremap <expr> <Tab>   pumvisible() ? {_, x -> x}(LanguageClient#textDocument_hover(), "\<C-N>")      : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? {_, x -> x}(LanguageClient#textDocument_hover(), "\<C-P>")      : "\<Tab>"
  inoremap <expr> <CR>    pumvisible() ? {_, x -> x}(LanguageClient#textDocument_hover(), "\<C-Y>\<CR>") : "\<CR>"
endif

if s:choice == 'coc'
else
  Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }
  let g:LanguageClient_serverCommands = {
	\ 'c': ['cquery'] ,
	\ 'css': ['css-languageserver'],
	\ 'docker': ['docker-languageserver'],
	\ 'haskell': ['hie-wrapper'],
	\ 'html': ['html-languageserver'],
	\ 'java': ['jdtls', '-Dlog.level=ALL', '-data', expand('~/.cache/jdtls-workspace')],
	\ 'json': ['json-languageserver'],
	\ 'lua': ['lua-lsp'],
	\ 'nix': ['rnix-lsp'],
	\ 'python': ['pyls'],
	\ 'rust': executable('rustup') ? ['rustup', 'run', 'nightly', 'rls']
	\                              : ['rls'],
	\ 'scala': ['metals-vim'],
	\ 'sh': ['bash-language-server', 'start'],
	\ 'tex': ['texlab'],
	\ }
  "    \ 'php': ['php', 'php-language-server.php'],
  "    \ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],

  nnoremap <silent> KK <CMD>call LanguageClient_textDocument_hover()<CR>
  nnoremap <silent> gd <CMD>call LanguageClient_textDocument_definition()<CR>
  " nnoremap <silent> <F2> <CMD>call LanguageClient_textDocument_rename()<CR>
  Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}
  nnoremap <F5> <CMD>call LanguageClient_contextMenu()<CR>

  " language client mappings for coding
  nnoremap <leader>* <CMD>call LanguageClient_textDocument_documentHighlight()<CR>

  "augroup LucLanguageClientPopup
  "  autocmd!
  "  autocmd CursorHold,CursorHoldI *
  "        \ if &buftype != 'nofile' |
  "        \   call LanguageClient#textDocument_hover() |
  "        \ endif
  "augroup END
endif

" options related to completion

" Use the 'dictionary' option for completion
set complete+=k

" use the current spell checking settings for directory completion:
"set dictionary+=spell
" system word lists
set dictionary+=/usr/share/dict/american-english
set dictionary+=/usr/share/dict/british-english
set dictionary+=/usr/share/dict/ngerman
