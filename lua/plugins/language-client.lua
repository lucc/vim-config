return { 'autozimu/LanguageClient-neovim',
  branch = 'next',
  run = 'bash install.sh',
  requires = {{
    'roxma/LanguageServer-php-neovim',
    run = [[
      nix shell sys#phpPackages.composer sys#php --command \
      sh -c 'composer install && composer run-script parse-stubs'
    ]],
  }},
  config = function()
    vim.g.LanguageClient_serverCommands = {
      c = {'cquery'} ,
      css = {'css-languageserver'},
      docker = {'docker-languageserver'},
      haskell = {'hie-wrapper'},
      html = {'html-languageserver'},
      java = {'jdtls', '-Dlog.level=ALL', '-data', vim.fn.expand('~/.cache/jdtls-workspace')},
      --javascript = {'/opt/javascript-typescript-langserver/lib/language-server-stdio.js'},
      json = {'json-languageserver'},
      lua = {'lua-lsp'},
      nix = {'rnix-lsp'},
      --php = {'php', 'php-language-server.php'},
      python = {'pyls'},
      rust = vim.fn.executable('rustup') and {'rustup', 'run', 'nightly', 'rls'} or {'rls'},
      scala = {'metals-vim'},
      sh = {'bash-language-server', 'start'},
      tex = {'texlab'},
    }
    vim.cmd[[nnoremap <silent> KK <CMD>call LanguageClient_textDocument_hover()<CR>]]
    vim.cmd[[nnoremap <silent> gd <CMD>call LanguageClient_textDocument_definition()<CR>]]
    -- nnoremap <silent> <F2> <CMD>call LanguageClient_textDocument_rename()<CR>
    vim.cmd[[nnoremap <F5> <CMD>call LanguageClient_contextMenu()<CR>]]
    -- language client mappings for coding
    vim.cmd[[nnoremap <leader>* <CMD>call LanguageClient_textDocument_documentHighlight()<CR>]]
    -- augroup LucLanguageClientPopup
    -- autocmd!
    -- autocmd CursorHold,CursorHoldI *
    -- \ if &buftype != 'nofile' |
    -- \   call LanguageClient#textDocument_hover() |
    -- \ endif
    -- augroup END
    vim.cmd[[inoremap <expr> <Tab>   pumvisible() ? {_, x -> x}(LanguageClient#textDocument_hover(), "\<C-N>")      : "\<Tab>"]]
    vim.cmd[[inoremap <expr> <S-Tab> pumvisible() ? {_, x -> x}(LanguageClient#textDocument_hover(), "\<C-P>")      : "\<Tab>"]]
    vim.cmd[[inoremap <expr> <CR>    pumvisible() ? {_, x -> x}(LanguageClient#textDocument_hover(), "\<C-Y>\<CR>") : "\<CR>"]]
  end,
}
