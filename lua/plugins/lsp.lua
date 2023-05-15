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
      "ansiblels",
      --"bashls",
      "hls",
      --"html",
      "intelephense",
      --"java_language_server",
      --"jedi_language_server",
      --"lua-lsp",
      --"pylsp",
      "pyright",
      "rls",
      "rnix",
      "nil_ls",
      --"sqlls",
      --"yamlls",
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
    --lspconfig.phpactor.setup {
    --  cmd = {
    --    vim.fn.stdpath("data").."/site/pack/packer/opt/phpactor/bin/phpactor",
    --    "language-server"
    --  },
    --}
    lspconfig.psalm.setup {
      cmd = {"psalm", "--language-server"},
    }
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
    lspconfig.yamlls.setup {
      settings = {
	yaml = {
	  keyOrdering = false
	}
      }
    }

    local opts = { noremap=true, expr=true }
    vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? {_, x -> x}(v:lua.vim.lsp.buf.hover(), "\<C-N>") : "\<Tab>"]], opts)
    vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? {_, x -> x}(v:lua.vim.lsp.buf.hover(), "\<C-P>") : "\<Tab>"]], opts)
    vim.api.nvim_set_keymap('i', '<CR>', [[pumvisible() ? {_, x -> x}(v:lua.vim.lsp.buf.hover(), "\<C-Y><CR>") : "\<CR>"]], opts)
    vim.api.nvim_create_user_command("CodeAction", vim.lsp.buf.code_action, {})

    require("symbols-outline").setup()
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
    --{ 'phpactor/phpactor',
    --  run = [[nix shell sys#phpPackages.composer sys#php --command composer install]],
    --  ft = 'php' },
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

return ncm
