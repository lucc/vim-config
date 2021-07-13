local command = require("helpers").command

-- legacy, plug stuff
vim.cmd[[
call luc#setup#vim_plug()
runtime init.d/plugins/coding.vim
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

require('packer').startup(function()

  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- special new stuff since neovim 0.5
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use 'mhinz/vim-grepper'
  vim.g.grepper = {
    dir = 'filecwd',
    jump = 1,
    prompt = 0,
    quickfix = 0,
    searchreg = 1,
    tools = {'git', 'rg', 'ag', 'grep'},
  }
  vim.cmd "command! -nargs=* -complete=file S Grepper -jump -query <q-args>"
  vim.cmd "command! -nargs=* -complete=file SS Grepper -jump -query <args>"

  use { 'hkupty/iron.nvim',
    config = function()
      require("iron").core.set_config {
	preferred = {
	  prolog = "swipl",
	  python = "ipython"
	}
      }
    end
  }
  vim.g.iron_repl_open_cmd = 'vsplit'
  command("REPL", "IronRepl")
  -- load the current file in the REPL.
  command("RF", "call v:lua.load_current_file_in_repl()")
  -- helper function for iron repl stuff (global function)
  function load_current_file_in_repl()
    local ft = vim.bo.filetype
    local load
    if ft == 'haskell' then
      load = ':load ' .. bufname('%')
    elseif ft == 'prolog' then
      load = '["' .. bufname('%') .. '"].'
    else
      error("Don't know how to load files for " .. ft)
    end
    require("iron").core.send(ft, load)
  end

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

end)

-- For very short ultisnips triggers to be usable with deoplete:
-- https://github.com/SirVer/ultisnips/issues/517#issuecomment-268518251
--call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
-- https://github.com/autozimu/LanguageClient-neovim/wiki/deoplete
--call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)
