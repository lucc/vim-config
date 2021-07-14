-- legacy, plug stuff
vim.cmd[[
call luc#setup#vim_plug()
runtime init.d/plugins/languages.vim
call plug#end()
]]

-- recmpile the packer file on each change to this file
vim.cmd [[
  augroup LucPluginSetup
  autocmd!
  autocmd BufWritePost ~/.config/nvim/lua/plugins.lua PackerCompile
  augroup END
]]

local language_client = {
  'autozimu/LanguageClient-neovim',
  branch = 'next',
  run = 'bash install.sh',
  requires = {
    'roxma/LanguageServer-php-neovim',
    run = 'composer install && composer run-script parse-stubs',
  },
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

require('packer').startup{
  function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- special new stuff since neovim 0.5
  use { 'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
	ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	--ignore_install = { "javascript" }, -- List of parsers to ignore installing
	highlight = {
	  enable = true,              -- false will disable the whole extension
	  disable = { "latex" },  -- list of language that will be disabled (ts language not &ft!)
	},
	indent = { enable = true },
	matchup = { enable = true },
      }
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  }
  use { 'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use { 'romgrk/nvim-treesitter-context', -- not very stable yet
    config = "vim.cmd[[highlight link TreesitterContext CursorLine]]",
  }
  --use { 'wellle/context.vim',
  --  config = function()
  --    vim.g.context_filetype_blacklist = { "help" }
  --    vim.g.context_nvim_no_redraw = 1
  --  end,
  --}

  use { 'mhinz/vim-grepper',
    config = function()
      vim.cmd "command! -nargs=* -complete=file S Grepper -jump -query <q-args>"
      vim.cmd "command! -nargs=* -complete=file SS Grepper -jump -query <args>"
      vim.g.grepper = {
	dir = 'filecwd',
	jump = 1,
	prompt = 0,
	quickfix = 0,
	searchreg = 1,
	tools = {'git', 'rg', 'ag', 'grep'},
      }
    end,
  }

  use { 'hkupty/iron.nvim',
    --cmd = {"IronRepl", "REPL", "RF"},
    config = function()
      require("iron").core.set_config {
	preferred = {
	  prolog = "swipl",
	  python = "ipython",
	}
      }
      vim.g.iron_repl_open_cmd = 'vsplit'
      vim.cmd "command! REPL IronRepl"
      -- load the current file in the REPL.
      vim.cmd "command! RF call v:lua.load_current_file_in_repl()"
    end,
  }
  -- helper function for iron repl stuff (global function)
  function load_current_file_in_repl()
    local ft = vim.bo.filetype
    local load
    if ft == 'haskell' then
      load = ':load ' .. vim.fn.bufname('%')
    elseif ft == 'prolog' then
      load = '["' .. vim.fn.bufname('%') .. '"].'
    else
      error("Don't know how to load files for " .. ft)
    end
    require("iron").core.send(ft, load)
  end

  -- snippets
  use { 'SirVer/ultisnips',
    -- Snippets are separated from the engine:
    requires = {'honza/vim-snippets', 'rbonvall/snipmate-snippets-bib'},
    config = function()
      vim.g.UltiSnipsExpandTrigger = '<C-F>'
      vim.g.UltiSnipsJumpForwardTrigger = '<C-F>' -- <C-J>
      vim.g.UltiSnipsJumpBackwardTrigger = '<C-G>' -- <C-K>
      --vim.g.UltiSnipsExpandTrigger = '<tab>'
      vim.g.UltiSnipsListSnippets = '<C-L>'
    end,
  }

  -- async make
  use { 'tpope/vim-dispatch',
    config = function()
      vim.g.dispatch_no_maps = 1
      vim.g.dispatch_no_tmux_make = 1
    end,
  }
  use { 'janko/vim-test',
    config = function()
      vim.g["test#strategy"] = 'dispatch_background'
    end,
  }
  use { 'neomake/neomake',
    config = function()
      if not vim.fn.exists('g:neomake') then
	vim.g.neomake = vim.empty_dict()
      end
      vim.g.neomake_verbose = 1
      --vim.g.neomake.open_list = 2 -- also preserve cursor position
      vim.g.neomake_list_height = 5
      --vim.g.neomake_php_enabled_makers = ['php', 'phpcs', 'phpmd']
      vim.g.neomake_tex_enabled_makers = {'chktex', 'lacheck', 'rubberinfo', 'proselint', 'latexrun'}
      vim.g.neomake_bib_enabled_makers = {'bibtex'}
      -- A maker to build a pdf file from a tex file if a makefile is afailable.
      vim.g.neomake_tex_make_maker = {
	exe = function() return vim.fn.filereadable(vim.fn.getcwd() .. '/makefile') and 'make' or '' end,
	args = function() return {vim.fn.expand('%:p:t:r') .. '.pdf'} end,
      }
    end,
  }

  -- debugging
  use { 'vim-vdebug/vdebug',
    cmd = {'VdebugStart'},
    config = function()
      vim.g.vdebug_options = {
	break_on_open = 0,
	continuous_mode = 1,
	watch_window_style = 'compact',
	window_commands = {
	  DebuggerWatch = 'vertical belowright new',
	  DebuggerStack = 'belowright new +res5',
	  DebuggerStatus = 'belowright new +res5'
	},
	--debug_window_level = 2,
      }
    end,
  }

  -- colors
  use 'iCyMind/NeoSolarized'
  use { 'altercation/vim-colors-solarized',
    config = function() vim.g.solarized_menu = 0 end,
  }
  -- statusline
  use { 'bling/vim-airline',
    requires = {
      'vim-airline/vim-airline-themes', -- solarized theme
      'ryanoasis/vim-devicons',         -- icons
    },
    config = function()
      vim.g.airline_theme = 'solarized'
      vim.g.airline_powerline_fonts = 1
      vim.g['airline#extensions#whitespace#mixed_indent_algo'] = 2
      vim.g['airline#extensions#whitespace#checks'] = {'indent', 'trailing', 'long'}
      vim.g['airline#extensions#vimtex#enabled'] = 1
      -- do not display the current mode in the command line
      vim.opt.showmode = false
    end,
  }

  use { 'junegunn/vim-easy-align',
    config = function()
      vim.cmd "vmap <Enter> <Plug>(EasyAlign)"
      vim.cmd "nmap <Leader>a <Plug>(EasyAlign)"
    end,
  }
  use { 'Shougo/echodoc.vim',
    config = function()
      vim.g['echodoc#enable_at_startup'] = 1
      vim.g['echodoc#type'] = 'floating'
    end,
  }

  -- file selector
  use { 'ctrlpvim/ctrlp.vim',
    requires = {
      'ryanoasis/vim-devicons', -- icons
      { 'nixprime/cpsm',
	run = [[
          nix-shell --run 'VIM=nvim bash ./install.sh' \
                    -p cmake boost.dev ncurses.dev
        ]],
      },
    },
    -- Lazy loading on this key does nt work and lazy loading the command
    -- messes up the solarized theme in CtrlP.
    --keys = { "<C-Space>" },
    --cmd = "CtrlPMRU",
    config = function()
      --vim.g.ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
      vim.g.ctrlp_clear_cache_on_exit = 0
      vim.g.ctrlp_mruf_max = 1000
      -- ignore/include/exclude patterns
      vim.g.ctrlp_show_hidden = 1
      vim.g.ctrlp_max_files = 0
      vim.g.ctrlp_root_markers = { '.git', 'makefile', 'Makefile' }
      -- asynchronous file cache update
      if vim.fn.executable("fd") then
	vim.g.user_command_async = 1
	vim.g.ctrlp_user_command = 'fd --hidden --type f "" %s'
	vim.g.ctrlp_use_caching = 0
      else
	vim.g.ctrlp_use_caching = 1
      end
      -- extensions
      vim.g.ctrlp_extensions = { 'tag', 'quickfix' }
      -- mappings
      vim.g.ctrlp_cmd = 'CtrlPMRU'
      vim.g.ctrlp_map = '<C-Space>'
      vim.cmd('inoremap '..vim.g.ctrlp_map..' <CMD>'..vim.g.ctrlp_cmd..'<CR>')
      -- Use the compiled C-version for speed improvements
      -- I don't like this as it either doesn't honor the last used file in
      -- MRU mode (it does some "intelligent" matching on the empty query)
      -- or it doesn't remove the current file from the results (with
      -- cpsm_match_empty_query=0).
      vim.g.ctrlp_match_func = { match = 'cpsm#CtrlPMatch' }
      vim.g.cpsm_match_empty_query = 0
      -- cpsm doesn't use 1 as a default if the variable doesn't exist.
      vim.g.ctrlp_match_current_file = 0
    end,
  }
  use { 'liuchengxu/vim-clap',
    cmd = "Clap",
    lock = true,
    run = 'nix-shell --run make -p cargo',
    config = function()
      vim.g.clap_layout = { relative = 'editor' }
      vim.g.clap_enable_background_shadow = false
      vim.g.clap_insert_mode_only = true
      vim.g.clap_open_preview = "never"
      vim.cmd "nnoremap <silent> <C-Space> <CMD>Clap history<CR>"
      vim.vmd "autocmd FileType clap_input inoremap <silent> <buffer> <C-F> <CMD>call <SID>switch(1)<CR>"
      vim.cmd "autocmd FileType clap_input inoremap <silent> <buffer> <C-B> <CMD>call <SID>switch(-1)<CR>"
      local function switch(index)
        local providers = {"history", "files", "buffers"}
        local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
        vim.fn["clap#exit"]()
        local cur = vim.fn.index(providers, vim.g.clap.provider.id)
        if cur == -1 then
          vim.cmd("Clap " .. providers[0])
        else
          vim.cmd("Clap " .. providers[(cur + index) % vim.fn.len(providers)])
        end
        vim.fn.feedkeys(vim.fn.join(text, "\n"))
      end
    end,
  }

  -- completion
  use { 'ncm2/ncm2',
    requires = {
      language_client,
      'roxma/nvim-yarp',
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
	run = [[nix-shell --run 'composer install' -p php80Packages.composer php80]],
        ft = 'php' },
      'phpactor/ncm2-phpactor',
      'ncm2/ncm2-ultisnips',
      },
      config = function()
	vim.opt.completeopt:append("noinsert")
	vim.opt.completeopt:append("menuone")
	vim.opt.completeopt:append("noselect")
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
  use { 'neoclide/coc.nvim',
    opt = true,
    lock = true,
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
  use { 'Shougo/deoplete.nvim',
    opt = true,
    lock = true,
    run = ':UpdateRemotePlugins',
    -- A list of possible source for completion is at
    -- https://github.com/Shougo/deoplete.nvim/wiki/Completion-Sources
    requires = {
      language_client,
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

  -- plugins: vcs stuff
  use 'tpope/vim-fugitive'            -- git integration
  --use 'ludovicchabant/vim-lawrencium' -- mercurial integration
  use 'airblade/vim-gitgutter'        -- change indicator in sign column
  use 'rbong/vim-flog'                -- git history browser
  use 'rhysd/git-messenger.vim'       -- float win with last commit

  -- unsorted plugins
  use 'eugen0329/vim-esearch'
  use 'AndrewRadev/linediff.vim'
  use 'andymass/vim-matchup'
  use 'chrisbra/unicode.vim'
  use 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
  use 'jamessan/vim-gnupg'
  use 'lucc/VimRepress' -- clone of https://bitbucket.org/pentie/vimrepress
  use 'pix/vim-known_hosts'
  use 'simnalamburt/vim-mundo'
  use 'ZeroKnight/vim-signjump'
  use '~/src/vim-tip'
  use 'alvan/vim-php-manual'
  use 'ron89/thesaurus_query.vim'
  use 'RRethy/vim-illuminate'
  use 'Lokaltog/vim-easymotion'
  use 'Raimondi/delimitMate'
  use 'vim-scripts/paredit.vim'
  use 'tpope/vim-surround'
  --use 'kana/vim-textobj-indent.git'
  use 'michaeljsmith/vim-indent-object'

  end,
  config = {
    profile = {
      enable = true,
      --threshold = 1,
    },
  },
}
