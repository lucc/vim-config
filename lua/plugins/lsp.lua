-- packer plugin descriptions for LSP and input mode completion

local builtin_lsp = {
  'neovim/nvim-lspconfig',
  requires = {
    'scalameta/nvim-metals',
    'simrat39/symbols-outline.nvim',
  },
  config = function()
    local lspconfig = require'lspconfig'
    local function on_attach(client, bufnr)
      local function map(left, right)
	vim.api.nvim_buf_set_keymap(bufnr, "n", left, right, { noremap=true,
							       silent=true })
      end

      --Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

      -- See `:help vim.lsp.*` for documentation on any of the below functions
      map('gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
      map('gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
      map('K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
      map('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
      map('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
      map('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
      map(']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
      map('<F5>', '<cmd>lua vim.lsp.buf.code_action()<CR>')
      -- mapping for the symbols-outline plugin
      if vim.fn.maparg('gO') == "" then
        map('gO', '<CMD>SymbolsOutline<CR>')
      end
    end
    local servers = {
      --"bashls",
      "hls",
      --"html",
      --"intelephense", "phpactor",
      --"java_language_server",
      --"jedi_language_server",
      --"lua-lsp",
      --"pylsp",
      "pyright",
      "rls",
      "rnix",
      --"sqlls",
      "sqls",
      "yamlls",
    }
    for _, server in ipairs(servers) do
      lspconfig[server].setup { on_attach = on_attach }
    end
    local sumneko_root_path = vim.fn.stdpath('cache') ..
      '/lspconfig/sumneko_lua/lua-language-server'
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    lspconfig.jsonls.setup { cmd = {"vscode-json-languageserver", "--stdio"} }
    lspconfig.lua_ls.setup {
      on_attach = on_attach,
      cmd = {
	"lua-language-server", "-E",
	sumneko_root_path
      },
      settings = {
	Lua = {
	  runtime = {
	    -- Tell the language server which version of Lua you're using
	    -- (most likely LuaJIT in the case of Neovim)
	    version = 'LuaJIT',
	    -- Setup your lua path
	    path = runtime_path,
	  },
	  -- Get the language server to recognize the `vim` global
	  diagnostics = { globals = {'vim'} },
	  -- Make the server aware of Neovim runtime files
	  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
	  -- Do not send telemetry data containing a randomized but unique
	  -- identifier
	  telemetry = { enable = false },
	},
      },
    }
    lspconfig.texlab.setup {
      on_attach = on_attach,
      settings = {
	texlab = {
	  auxDirectory = "latex.out",
	  build = { executable = "latexrun", args = { "%f" } }
	},
      },
    }
    lspconfig.vimls.setup {
      cmd = {
	vim.fn.stdpath("config").."/../yarn/global/node_modules/.bin/vim-language-server",
	"--stdio"
      }
    }

    local opts = { noremap=true, expr=true }
    vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? {_, x -> x}(v:lua.vim.lsp.buf.hover(), "\<C-N>") : "\<Tab>"]], opts)
    vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? {_, x -> x}(v:lua.vim.lsp.buf.hover(), "\<C-P>") : "\<Tab>"]], opts)
    vim.api.nvim_set_keymap('i', '<CR>', [[pumvisible() ? {_, x -> x}(v:lua.vim.lsp.buf.hover(), "\<C-Y><CR>") : "\<CR>"]], opts)
    vim.api.nvim_create_user_command("CodeAction", vim.lsp.buf.code_action, {})
  end,
}
local language_client = {
  'autozimu/LanguageClient-neovim',
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

local ncm = { 'ncm2/ncm2',
  requires = {
    builtin_lsp,
    'roxma/nvim-yarp',
    'ncm2/float-preview.nvim',

    'ncm2/ncm2-bufword',
    'ncm2/ncm2-path',
    -- 'ncm2/ncm2-jedi'
    'ncm2/ncm2-html-subscope',
    'ncm2/ncm2-markdown-subscope',
    'ncm2/ncm2-rst-subscope',
    'ncm2/ncm2-github',
    -- 'ncm2/ncm2-tmux',
    'ncm2/ncm2-tagprefix',
    'filipekiss/ncm2-look.vim',
    'Shougo/neco-syntax',
    'ncm2/ncm2-syntax',
    'ncm2/ncm2-neoinclude',
    'Shougo/neoinclude.vim',
    -- 'wellle/tmux-complete.vim',
    -- 'yuki-ycino/ncm2-dictionary', -- can not handle multible entries in 'dict'
    'ncm2/ncm2-racer',
    'ncm2/ncm2-go',
    'ncm2/ncm2-vim',
    'Shougo/neco-vim',
    { 'phpactor/phpactor',
      run = [[nix shell sys#phpPackages.composer sys#php --command composer install]],
      ft = 'php' },
    'phpactor/ncm2-phpactor',
    'ncm2/ncm2-ultisnips',
  },
  config = function()
    vim.opt.completeopt:append("noinsert")
    vim.opt.completeopt:append("menuone")
    vim.opt.completeopt:append("noselect")
    vim.opt.completeopt:remove("preview")
    vim.g['float_preview#docked'] = 0
    vim.cmd "autocmd BufEnter * call ncm2#enable_for_buffer()"
    vim.fn['ncm2#register_source']({
      name = 'vimtex',
      priority = 1,
      subscope_enable = 1,
      complete_length = 1,
      scope = {'tex'},
      matcher = {
	name = 'combine',
	matchers = {
	  {name = 'abbrfuzzy', key = 'menu'},
	  {name = 'prefix', key = 'word'},
	}},
      mark = 'tex',
      word_pattern = [[\w+]],
      complete_pattern = vim.g['vimtex#re#ncm'],
      on_complete = {'ncm2#on_complete#omni', 'vimtex#complete#omnifunc'},
    })
  end,
}
local coc = { 'neoclide/coc.nvim',
  branch = 'release',
  requires = { 'neoclide/coc-sources', 'Shougo/neco-vim', 'neoclide/coc-neco' },
  config = function()
    vim.g.coc_global_extensions = {
      'coc-git',
      'coc-json',
      'coc-snippets',
      'coc-vimtex',
      'coc-syntax',
    }
    vim.g.coc_data_home = "~/.local/share/coc"
    vim.cmd[[
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
    inoremap <expr> <Tab>   pumvisible() ? "\<C-N>"      : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>"      : "\<Tab>"
    inoremap <expr> <CR>    pumvisible() ? "\<C-Y>\<CR>" : "\<CR>"
    nnoremap <silent> KK <CMD>call CocAction("doHover")<CR>
    ]]
  end,
}
local deoplete = { 'Shougo/deoplete.nvim',
  run = ':UpdateRemotePlugins',
  -- A list of possible source for completion is at
  -- https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
  requires = {
    'Shougo/neco-syntax',
    'Shougo/neco-vim',
    'fszymanski/deoplete-emoji',
    'nicoe/deoplete-khard',
    'padawan-php/deoplete-padawan',
    'poppyschmo/deoplete-latex',
    'zchee/deoplete-zsh',
    'lionawurscht/deoplete-biblatex',
    {'paretje/deoplete-notmuch', ft = 'mail'}
    -- 'zchee/deoplete-jedi',
    -- https://github.com/SevereOverfl0w/deoplete-github
    -- https://github.com/lvht/phpcd.vim
    -- https://github.com/tpope/vim-rhubarb
  },
  config = function()
    vim.g['deoplete#enable_at_startup'] = 1
    vim.g['deoplete#sources#notmuch#command'] = {
      'notmuch', 'address', '--format=json', '--deduplicate=address', '*'
    }
    -- For very short ultisnips triggers to be usable with deoplete:
    -- https://github.com/SirVer/ultisnips/issues/517#issuecomment-268518251
    vim.fn['deoplete#custom#source']('ultisnips', 'matchers', {'matcher_fuzzy'})
    -- https://github.com/autozimu/LanguageClient-neovim/wiki/deoplete
    vim.fn['deoplete#custom#source']('LanguageClient', 'min_pattern_length', 2)
  end,
}

return ncm
