-- packer plugin descriptions to switch between buffers and select stuff

local ctrlp = { 'ctrlpvim/ctrlp.vim',
  requires = {
    'ryanoasis/vim-devicons', -- icons
    { 'nixprime/cpsm',
      run = [[
      nix shell --command 'VIM=nvim bash ./install.sh' \
      sys#cmake sys#boost.dev sys#ncurses.dev
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
    vim.g.ctrlp_match_func = { match = 'cpsm#CtrlPMatch' }
    vim.g.cpsm_match_empty_query = 0
    -- cpsm doesn't use 1 as a default if the variable doesn't exist.
    vim.g.ctrlp_match_current_file = 0
  end,
}
local clap = { 'liuchengxu/vim-clap',
  cmd = "Clap",
  lock = true,
  run = 'nix shell --command make sys#cargo',
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
local telescope = { 'nvim-telescope/telescope.nvim',
  requires = {
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    { "nvim-telescope/telescope-frecency.nvim", requires = {"tami5/sql.nvim"} },
  },
  config = function()
    require'telescope'.setup {
      mappings = {
	i = {
	  ["<esc>"] = require('telescope.actions').close,
	},
      },
    }
    require"telescope".load_extension("frecency")
    vim.api.nvim_set_keymap("n", "<C-Space>", "<CMD>Telescope oldfiles<CR>",
      {silent = true})
  end,
}

return ctrlp
