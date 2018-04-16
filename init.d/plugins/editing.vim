" general plugins for editing
" vim: foldmethod=marker spelllang=en

Plug 'ron89/thesaurus_query.vim'

" plugins: buffer and file management {{{1
Plugin 'ctrlpvim/ctrlp.vim'

" cache {{{2
"let g:ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_max = 1000

" ignore/include/exclude patterns {{{2
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v(\/private|\/tmp|\/Users\/luc\/(audio|img|flac))',
      \ }
let g:ctrlp_root_markers = [
      \ 'makefile',
      \ 'Makefile',
      \ ]
" asynchronous file cache update
let g:user_command_async = 1
let g:ctrlp_user_command = 'find %s -type f'

" extensions {{{2
let g:ctrlp_extensions = [
      \ 'tag',
      \ 'quickfix',
      \ 'undo',
      \ 'changes',
      \]
      "\ 'dir',
      "\ 'buffertag',
      "\ 'line',
      "\ 'rtscript',
      "\ 'mixed',
      "\ 'bookmarkdir',

" mappings {{{2
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_map = '<C-Space>'
execute 'inoremap' g:ctrlp_map '<C-O>:' g:ctrlp_cmd '<CR>'

" Use the compiled C-version for speed improvements "{{{2
if has('python')
  Plugin 'JazzCore/ctrlp-cmatcher'
  let g:ctrlp_match_func = {'match' : 'matcher#cmatch'}
endif

" {{{1 fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
"Plug 'wincent/command-t'

" plugins: parenthesis, quotes, alignment {{{1

Plugin 'Raimondi/delimitMate'
Plug 'vim-scripts/paredit.vim'
Plugin 'tpope/vim-surround'
"Plugin 'kana/vim-textobj-indent.git'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'junegunn/vim-easy-align'
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" plugins: motion {{{1
Plugin 'Lokaltog/vim-easymotion'
