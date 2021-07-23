-- packer plugin descriptions to switch between buffers and select stuff

local ctrlp = { 'ctrlpvim/ctrlp.vim',
  requires = {
    'ryanoasis/vim-devicons', -- icons
    { 'nixprime/cpsm',
      run = [[
        nix shell sys#cmake sys#boost.dev sys#ncurses.dev \
        --command env VIM=nvim bash ./install.sh
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
    if vim.fn.executable("fd") == 1 then
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
    --vim.g.ctrlp_match_func = { match = 'cpsm#CtrlPMatch' }
    vim.g.cpsm_match_empty_query = 0
    -- cpsm doesn't use 1 as a default if the variable doesn't exist.
    vim.g.ctrlp_match_current_file = 0
  end,
}
local clap = { 'liuchengxu/vim-clap',
  cmd = "Clap",
  lock = true,
  run = 'nix shell sys#cargo --command make',
  config = function()
    vim.g.clap_layout = { relative = 'editor' }
    vim.g.clap_enable_background_shadow = false
    vim.g.clap_insert_mode_only = true
    vim.g.clap_open_preview = "never"
    vim.cmd[[
    nnoremap <silent> <C-Space> <CMD>Clap history<CR>
    autocmd FileType clap_input inoremap <silent> <buffer> <C-F> <CMD>lua Clap_switch_helper(1)<CR>
    autocmd FileType clap_input inoremap <silent> <buffer> <C-B> <CMD>lua Clap_switch_helper(-1)<CR>
    ]]
    -- Global function!
    function Clap_switch_helper(index)
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
local telescope = { 'nvim-telescope/telescope.nvim', tag = '0.1.0',
  requires = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'nvim-telescope/telescope-frecency.nvim', 'kkharji/sqlite.lua',
  },
  config = function()
    local cycle = require "telescope.cycle"(
      function()
	local sorter = require 'telescope.config'.values.file_sorter()
	require 'telescope'.extensions.frecency.frecency { sorter = sorter }
      end,
      require "telescope.builtin".find_files
    )
    local actions = require 'telescope.actions'
    require'telescope'.setup {
      defaults = {
	mappings = {
	  i = {
	    ["<esc>"] = actions.close,
	    ["<C-Space>"] = function() cycle.next() end,
	    ["<C-h>"] = actions.which_key,
	    ["<C-s>"] = actions.select_horizontal,
	    ["<C-Down>"] = require('telescope.actions').cycle_history_next,
	    ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
	  },
	},
      },
      pickers = {
	find_files = {
	  root = require "telescope.utils".buffer_dir,
	},
      },
      extensions = {
	["ui-select"] = {
	  require "telescope.themes".get_dropdown(),
	},
      },
    }

    require "telescope".load_extension "frecency"
    require "telescope".load_extension "ui-select"

    local opts = {silent = true}
    vim.keymap.set({"n", "i"}, "<C-Space>", function() cycle() end, opts)
    vim.keymap.set({"n", "i"}, "<C-S>", function()
      local cwd = vim.fn.FugitiveGitDir(vim.fn.bufnr(""))
      if cwd == "" then
	cwd = require"telescope.utils".buffer_dir()
      else
	cwd = cwd:sub(1, -5)  -- remove the .git suffix
      end
      require"telescope.builtin".live_grep{
	default_text = vim.fn.expand("<cword>"),
	cwd = cwd,
      }
    end, opts)
  end,
}

return telescope
