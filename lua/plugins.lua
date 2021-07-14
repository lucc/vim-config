local command = require("helpers").command

-- legacy, plug stuff
vim.cmd[[
call luc#setup#vim_plug()
runtime init.d/plugins/editing.vim
runtime init.d/plugins/completion.vim
runtime init.d/plugins/languages.vim
runtime init.d/plugins/ui.vim
call plug#end()
]]

-- recmpile the packer file on each change to this file
vim.cmd [[
  augroup LucPluginSetup
  autocmd!
  autocmd BufWritePost ~/.config/nvim/lua/plugins.lua PackerCompile
  augroup END
]]

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

  end,
  config = {
    profile = {
      enable = true,
      --threshold = 1,
    },
  },
}

-- For very short ultisnips triggers to be usable with deoplete:
-- https://github.com/SirVer/ultisnips/issues/517#issuecomment-268518251
--call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
-- https://github.com/autozimu/LanguageClient-neovim/wiki/deoplete
--call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)
