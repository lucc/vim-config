return { 'Shougo/deoplete.nvim',
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
