return require('packer').startup{
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- special new stuff since neovim 0.5
    use { 'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
	require'nvim-treesitter.configs'.setup {
	  -- one of "all", "maintained" (parsers with maintainers), or a list
	  -- of languages
	  ensure_installed = {
	    "bash",
	    "bibtex",
	    "comment",
	    "latex",
	    "lua",
	    "nix",
	    "python",
	    "scala",
	    "yaml",
	  },
	  --ignore_install = { "javascript" },
	  highlight = {
	    enable = true,
	    disable = { "latex" },
	    additional_vim_regex_highlighting = { "lua", "latex" },
	  },
	  indent = { enable = true },
	  matchup = { enable = true },
	  incremental_selection = { enable = true },
	  textobjects = { enable = true },
	}
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      end,
    }
    --use { 'romgrk/nvim-treesitter-context', -- not very stable yet
    --  config = "vim.cmd[[highlight link TreesitterContext CursorLine]]",
    --}

    use { 'mhinz/vim-grepper',
      setup = function()
	vim.g.grepper = {
	  dir = 'filecwd',
	  jump = 1,
	  prompt = 0,
	  quickfix = 0,
	  searchreg = 1,
	  tools = {'git', 'rg', 'ag', 'grep'},
	}
      end,
      config = function()
	vim.cmd [[
	command! -nargs=* -complete=file S Grepper -jump -query <q-args>
	command! -nargs=* -complete=file SS Grepper -jump -query <args>
	]]
      end,
    }

    use { 'hkupty/iron.nvim',
      cmd = {"IronRepl", "REPL", "RF"},
      setup = function()
	vim.g.iron_repl_open_cmd = 'vsplit'
      end,
      config = [[
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
      require("iron").core.set_config {
	preferred = {
	  prolog = "swipl",
	  python = "ipython",
	}
      }
      vim.cmd "command! REPL IronRepl"
      -- load the current file in the REPL.
      vim.cmd "command! RF call v:lua.load_current_file_in_repl()"
      ]]
    }

    -- snippets
    use { 'SirVer/ultisnips',
      -- Snippets are separated from the engine:
      requires = {'honza/vim-snippets', 'rbonvall/snipmate-snippets-bib'},
      setup = function()
	vim.g.UltiSnipsExpandTrigger = '<C-F>'
	vim.g.UltiSnipsJumpForwardTrigger = '<C-F>' -- <C-J>
	vim.g.UltiSnipsJumpBackwardTrigger = '<C-G>' -- <C-K>
	--vim.g.UltiSnipsExpandTrigger = '<tab>'
	vim.g.UltiSnipsListSnippets = '<C-L>'
      end,
    }

    -- async make
    use { 'tpope/vim-dispatch',
      cmd = { "Make" },
      setup = function()
	vim.g.dispatch_no_maps = 1
	vim.g.dispatch_no_tmux_make = 1
      end,
    }
    use { 'janko/vim-test',
      cmd = { "TestFile", "TestSuite", "TestNearest" },
      setup = function()
	vim.g["test#strategy"] = 'neovim'
	vim.g["test#neovim#term_position"] = "vertical"
      end,
    }
    use { 'neomake/neomake',
      setup = function()
	if vim.fn.exists('g:neomake') == 0 then
	  vim.g.neomake = vim.empty_dict()
	end
	vim.g.neomake_verbose = 1
	--vim.g.neomake.open_list = 2 -- also preserve cursor position
	vim.g.neomake_list_height = 5
	--vim.g.neomake_php_enabled_makers = ['php', 'phpcs', 'phpmd']
	vim.g.neomake_tex_enabled_makers = {
	  'chktex', 'lacheck', 'rubberinfo', 'proselint', 'latexrun'
	}
	vim.g.neomake_bib_enabled_makers = {'bibtex'}
	-- A maker to build a pdf file from a tex file if a makefile is
	-- afailable.
	vim.g.neomake_tex_make_maker = {
	  exe = function()
	    return vim.fn.filereadable(vim.fn.getcwd() .. '/makefile') and
	      'make' or ''
	  end,
	  args = function() return {vim.fn.expand('%:p:t:r') .. '.pdf'} end,
	}
      end,
    }

    -- debugging
    use { 'vim-vdebug/vdebug',
      cmd = {'VdebugStart'},
      setup = function()
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
    use { 'iCyMind/NeoSolarized',
      setup = function()
	vim.g.neosolarized_italic = 1
	vim.g.neosolarized_termBoldAsBright = 0
      end,
      config = function()
	-- FIXME it is currently very slow to do this is lua directly and it
	-- yields false results for me, see known bug at :h nvim_set_hl
	--vim.api.nvim_set_hl(0, "VertSplit",
	--  {guifg=0x657b83, guibg=0x657b83})
        --vim.api.nvim_set_hl(0, "MatchParen",
	--  {italic=true, bold=true, guibg="none"})
        vim.cmd[[
        colorscheme NeoSolarized
        highlight! VertSplit  guifg=#657b83 guibg=#657b83
        highlight! MatchParen gui=italic,bold guibg=none
        ]]
      end,
    }

    -- statusline
    use { 'vim-airline/vim-airline',
      requires = {
	'vim-airline/vim-airline-themes', -- solarized theme
	'ryanoasis/vim-devicons',         -- icons
      },
      setup = function()
	vim.g.airline_theme = 'solarized'
	vim.g.airline_powerline_fonts = 1
	vim.g['airline#extensions#whitespace#mixed_indent_algo'] = 2
	vim.g['airline#extensions#whitespace#checks'] = {
	  'indent', 'trailing', 'long'
	}
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
      setup = function()
	vim.g['echodoc#enable_at_startup'] = 1
	vim.g['echodoc#type'] = 'floating'
      end,
    }

    use(require "plugins.select") -- file selector
    use(require "plugins.lsp")    -- completion and lsp

    -- plugins: vcs stuff
    use 'tpope/vim-fugitive'            -- git integration
    --use 'ludovicchabant/vim-lawrencium' -- mercurial integration
    use 'airblade/vim-gitgutter'        -- change indicator in sign column
    use { 'rbong/vim-flog',             -- git history browser
      cmd = { "Flog", "Flogsplit" },
    }
    use { 'rhysd/git-messenger.vim',    -- float win with last commit
      cmd = { "GitMessanger" },
    }

    -- language support
    use 'Shougo/context_filetype.vim'
    use 'chrisbra/vim-zsh' -- devel version of the official syntax file
    use 'tpope/vim-scriptease'
    use 'vim-scripts/applescript.vim'
    use 'vim-scripts/icalendar.vim'
    use 'aliva/vim-fish'
    use 'vim-scripts/VCard-syntax'
    use 'tkztmk/vim-vala'
    use 'rosstimson/bats.vim'
    use 'chikamichi/mediawiki.vim'
    --use 'tbastos/vim-lua'
    --use 'vim-scripts/luarefvim'
    use 'LnL7/vim-nix'
    use 'derekelkins/agda-vim'
    use 'nfnty/vim-nftables'
    use 'chrisbra/csv.vim'
    use { 'https://gist.github.com/jettero/4a619004fb23ada1e5cf302211eee8ae',
      as = "jettero-pycfg-gist",
      run = "mkdir syntax && ln -s pycfg.vim syntax/"
    }
    use 'pearofducks/ansible-vim'
    use 'jwalton512/vim-blade'

    -- rust
    use 'rust-lang/rust.vim'

    -- Haskell
    use 'neovimhaskell/haskell-vim'
    use { 'Twinside/vim-hoogle',
      cmd = { "Hoogle" },
    }
    --use 'itchyny/vim-haskell-indent' -- to be tested

    -- LaTeX
    -- original vim settings for latex
    -- vim.g.tex_fold_enabled = 1
    vim.g.tex_flavor = 'latex'

    use { 'lervag/vimtex',
      setup = function()
	vim.g.vimtex_fold_enabled = 1
	vim.g.vimtex_fold_types = {
	  sections = {
	    sections = {
	      'part',
	      'chapter',
	      'section',
	      'subsection',
	      'subsubsection',
	      'paragraph',
	    },
	  }
	}
	--vim.g.vimtex_fold_types.comments = {}
	--vim.g.vimtex_fold_types.comments.enabled = 1
	vim.g.vimtex_compiler_method = 'latexrun'
	vim.g.vimtex_compiler_progname = 'nvr'
	vim.g.vimtex_view_method = 'zathura'
	vim.g.vimtex_toc_config = { split_pos = 'vertical' }
	vim.g.vimtex_toc_todo_labels = {
	  FIXME = 'FIXME: ',
	  TODO = 'TODO: ',
	  XXX = 'FIXME: ',
	}
      end,
    }

    -- markdown
    use { 'nelstrom/vim-markdown-folding', -- good folding uses expr
      setup = function()
	vim.g.markdown_fold_style = 'nested'
      end,
    }
    use { 'vim-pandoc/vim-pandoc',
      requires = 'vim-pandoc/vim-pandoc-syntax',
      setup = function()
	vim.g['pandoc#modules#disabled'] = {"menu"}
	vim.g['pandoc#command#latex_engine'] = 'pdflatex'
	vim.g['pandoc#folding#fold_yaml'] = 1
	vim.g['pandoc#folding#fdc'] = 0
	--vim.g['pandoc#folding#fold_fenced_codeblocks'] = 1
	if vim.fn.exists('g:pandoc#biblio#bibs') == 0 then
	  vim.g['pandoc#biblio#bibs'] = {'~/bib/main.bib'}
	else
	  vim.fn.insert(vim.g['pandoc#biblio#bibs'], '~/bib/main.bib')
	end
	vim.g['pandoc#command#autoexec_on_writes'] = 0
	vim.g['pandoc#command#autoexec_command'] = "Pandoc pdf"
	vim.g['pandoc#formatting#mode'] = 'h'
      end,
    }

    -- python
    --use { 'python-mode/python-mode',
    --  ft = 'python',
    --  setup = function()
    --    vim.g.pymode_python = 'python3'
    --    vim.g.pymode_rope = 0
    --    vim.g.pymode_rope_completion = 0
    --    vim.g.pymode_lint = 0
    --    vim.g.pymode_doc = 0
    --    --vim.g.pymode_folding = 0
    --    --vim.g.pymode_virtualenv = 0
    --    --vim.g.pymode_syntax = 0
    --    vim.g.pymode_indent = 1
    --    vim.g.pymode_options_max_line_length = 79
    --  end,
    --}

    -- PHP
    use { 'swekaj/php-foldexpr.vim',
      ft = 'php',
      setup = function()
	-- These are not actually settings for the plugin but get leazy
	-- loading like this.
	-- taken from http://stackoverflow.com/a/7490288
	-- Set PHP folding of classes and functions.
	vim.g.php_folding = 0
      end,
    }

    -- commenting
    use { 'b3nj5m1n/kommentary',
      config = function()
	require('kommentary.config').configure_language("default", {
	  prefer_single_line_comments = true,
	  use_consistent_indentation = true,
	})
      end,
    }

    -- unsorted plugins
    use 'eugen0329/vim-esearch'
    use 'AndrewRadev/linediff.vim'
    use { 'andymass/vim-matchup',
      setup = function()
	vim.g.matchup_matchparen_offscreen = {method="popup"}
      end
    }
    use 'chrisbra/unicode.vim'
    use 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
    use 'jamessan/vim-gnupg'
    use 'lucc/VimRepress' -- clone of https://bitbucket.org/pentie/vimrepress
    use 'pix/vim-known_hosts'
    use 'simnalamburt/vim-mundo'
    use 'ZeroKnight/vim-signjump'
    use 'alvan/vim-php-manual'
    use 'ron89/thesaurus_query.vim'
    use 'RRethy/vim-illuminate'
    use 'Lokaltog/vim-easymotion'
    use 'Raimondi/delimitMate'
    use 'kovisoft/paredit'
    use 'tpope/vim-surround'
    --use 'kana/vim-textobj-indent.git'
    use 'michaeljsmith/vim-indent-object'
    use 'fourjay/vim-password-store'
    use { 'norcalli/nvim-colorizer.lua',
      config = function() require'colorizer'.setup() end,
    }
    use { 'dstein64/vim-startuptime',
      cmd = { "StartupTime" },
    }
    use { 'numToStr/FTerm.nvim',
      config = function()
	local toggle = "<CMD>lua require('FTerm').toggle()<CR>"
	vim.api.nvim_set_keymap("n", "<C-Z>", toggle, { noremap=true, silent=true })
	vim.api.nvim_set_keymap("n", "<leader><C-Z>", "<CMD>suspend<CR>", { noremap=true, silent=true })
	vim.cmd 'augroup LucFtermConfig'
	vim.cmd 'autocmd!'
	vim.cmd('autocmd FileType FTerm tmap <silent> <nowait> <buffer> <C-space> '..toggle..'<C-space>')
	vim.cmd('autocmd FileType FTerm nmap <silent> <nowait> <buffer> <C-space> '..toggle..'<C-space>')
	vim.cmd('autocmd FileType FTerm tmap <silent> <nowait> <buffer> <C-z> '..toggle)
	vim.cmd 'augroup END'
      end,
    }
    use 'rickhowe/diffchar.vim'
    use 'editorconfig/editorconfig-vim'
  end,
  config = {
    profile = {
      enable = true,
      --threshold = 1,
    },
  },
}
