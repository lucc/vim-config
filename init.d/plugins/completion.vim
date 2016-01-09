" vim: foldmethod=marker spelllang=en
" plugins: completion
if has('python') "{{{1
  "if has('nvim') " -> Deoplete.vim {{{2
  "  Plugin 'Shougo/deoplete.nvim'
  "  let g:deoplete#enable_at_startup = 1
  "else " -> Youcompleteme {{{2
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
  "endif
else             " -> neocomplete and neocomplcache {{{1
  " settings which are uniform for both neocomplete and neocomplcache
  "Plugin 'Shougo/vimproc' "only needed if not loaded elsewhere
  Plugin 'Shougo/context_filetype.vim'
  "Plugin 'Shougo/neosnippet'

  " Enable omni completion for both versions
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " <TAB> completion.
  inoremap <expr> <TAB>    pumvisible() ? '<C-n>' : '<TAB>'
  inoremap <expr> <S-TAB>  pumvisible() ? '<C-p>' : '<S-TAB>'

  if has('lua') " -> neocomplete {{{2
    Plugin 'Shougo/neocomplete.vim'
    let g:neocomplete#enable_at_startup = 1 " necessary
    let g:neocomplete#enable_refresh_always = 1 " heavy
    " what is this?
    if !exists('g:neocomplete#keyword_patterns')
      let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns._ = '\h\w*'
    if !exists('g:neocomplete#same_filetypes')
      let g:neocomplete#same_filetypes = {}
    endif
    " In c buffers, completes from cpp and d buffers.
    let g:neocomplete#same_filetypes.c = 'cpp,d'
    " In cpp buffers, completes from c buffers.
    let g:neocomplete#same_filetypes.cpp = 'c'
    " In gitconfig buffers, completes from all buffers.
    let g:neocomplete#same_filetypes.gitconfig = '_'
    " In default, completes from all buffers.
    let g:neocomplete#same_filetypes._ = '_'

  else          " -> neocomplcache {{{2
    Plugin 'Shougo/neocomplcache.vim'
    let g:neocomplcache_enable_at_startup = 1 " necessary
    let g:neocomplcache_enable_refresh_always = 1 " heavy
    let g:neocomplcache_enable_fuzzy_completion = 1 " heavy
    let g:neocomplcache_temporary_dir = expand('~/.cache/neocomplcache')
    " what is this?
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns._ = '\h\w*'
    if !exists('g:neocompcache_same_filetypes')
      let g:neocomplcache_same_filetypes = {}
    endif
    " mappings from which additional filetypes to fetch completions; '_' means
    " 'all' or 'default'
    let g:neocomplcache_same_filetypes.c         = 'cpp,d'
    let g:neocomplcache_same_filetypes.cpp       = 'c'
    let g:neocomplcache_same_filetypes.gitconfig = '_'
    let g:neocomplcache_same_filetypes._         = '_'

  "  " Define dictionary.
  "  let g:neocomplcache_dictionary_filetype_lists = {
  "      \ 'default' : '',
  "      \ 'vimshell' : $HOME.'/.vimshell_hist',
  "      \ 'scheme' : $HOME.'/.gosh_completions'
  "	  \ }
  "
  "  " Define keyword.
  "  if !exists('g:neocomplcache_keyword_patterns')
  "      let g:neocomplcache_keyword_patterns = {}
  "  endif
  "  let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
  "
  "  " Plugin key-mappings.
  "  inoremap <expr><C-g>     neocomplcache#undo_completion()
  "  inoremap <expr><C-l>     neocomplcache#complete_common_string()
  "
  "  " Recommended key-mappings.
  "  " <CR>: close popup and save indent.
  "  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  "  function! s:my_cr_function()
  "    return neocomplcache#smart_close_popup() . "\<CR>"
  "    " For no inserting <CR> key.
  "    "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
  "  endfunction
  "  " <C-h>, <BS>: close popup and delete backword char.
  "  inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
  "  inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
  "  inoremap <expr><C-y>  neocomplcache#close_popup()
  "  inoremap <expr><C-e>  neocomplcache#cancel_popup()
  "  " Close popup by <Space>.
  "  inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() :
  "        \ "\<Space>"
  "
  "  " For cursor moving in insert mode(Not recommended)
  "  "inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
  "  "inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
  "  "inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
  "  "inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
  "  " Or set this.
  "  "let g:neocomplcache_enable_cursor_hold_i = 1
  "  " Or set this.
  "  "let g:neocomplcache_enable_insert_char_pre = 1
  "
  "  " AutoComplPop like behavior.
  "  "let g:neocomplcache_enable_auto_select = 1
  "
  "  " Shell like behavior(not recommended).
  "  "set completeopt+=longest
  "  "let g:neocomplcache_enable_auto_select = 1
  "  "let g:neocomplcache_disable_auto_complete = 1
  "  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
  "
  "  " Enable heavy omni completion.
  "  if !exists('g:neocomplcache_omni_patterns')
  "    let g:neocomplcache_omni_patterns = {}
  "  endif
  "  if !exists('g:neocomplcache_force_omni_patterns')
  "    let g:neocomplcache_force_omni_patterns = {}
  "  endif
  "  let g:neocomplcache_omni_patterns.php =
  "  \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  "  let g:neocomplcache_omni_patterns.c =
  "  \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
  "  let g:neocomplcache_omni_patterns.cpp =
  "  \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  "
  "  " For perlomni.vim setting.
  "  " https://github.com/c9s/perlomni.vim
  "  let g:neocomplcache_omni_patterns.perl =
  "  \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  endif
endif
