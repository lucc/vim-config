" vim: foldmethod=marker spelllang=en
" plugins: completion

let s:choice = 'ycm'

"if s:choice == 'ycm'
  Plugin 'Valloric/YouCompleteMe'
  let g:ycm_filetype_blacklist = {}
  let g:ycm_complete_in_comments = 1
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_autoclose_preview_window_after_completion = 0
  let g:ycm_extra_conf_globlist = [
	\ '~/vcs/nvim/src/.ycm_extra_conf.py',
	\ '~/vcs/neovim/src/.ycm_extra_conf.py'
	\ ]
  let g:ycm_autoclose_preview_window_after_completion = 1

  Plugin 'bjoernd/vim-ycm-tex',
	\ {'name': 'YouCompleteMe/python/ycm/completers/tex'}
  let g:ycm_semantic_triggers = {'tex': ['\ref{','\cite{']}

  "Plugin 'c9s/vimomni.vim'
  "Plugin 'tek/vim-ycm-vim'
"elseif s:choice == 'deoplete'
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  let g:deoplete#enable_at_startup = 1
  Plug 'zchee/deoplete-jedi'
"endif

if s:choice != 'none'
  " Map <S-Tab> to <C-P> to go to the previous completion entry in insert
  " mode.
  inoremap <expr> <Tab>   pumvisible() ? "\<C-N>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-P>" : "\<Tab>"
endif
