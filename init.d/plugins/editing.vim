" general plugins for editing
" vim: foldmethod=marker spelllang=en
let s:uname = system('uname')[:-2]

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
      \ 'dir':  '\v(\/private|\/var|\/tmp|\/Users\/luc\/(audio|img|flac))',
      \ }
let g:ctrlp_root_markers = [
      \ 'makefile',
      \ 'Makefile',
      \ ]
"      \ 'latexmkrc',

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
let g:ctrlp_map = has('gui_running') ? '<C-Space>' : '<NUL>'
execute 'inoremap' g:ctrlp_map '<C-O>:' g:ctrlp_cmd '<CR>'
if has('gui_macvim')
  execute 'nnoremap' '<D-B>' ':CtrlPBuffer<CR>'
  execute 'inoremap' '<D-B>' ':CtrlPBuffer<CR>'
  execute 'nnoremap' '<D-F>' ':CtrlP<CR>'
  execute 'inoremap' '<D-F>' ':CtrlP<CR>'
  execute 'nnoremap' '<D-T>' ':CtrlPTag<CR>'
  execute 'inoremap' '<D-T>' ':CtrlPTag<CR>'
endif

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
Plugin 'paredit.vim'
if s:uname != 'Linux' || has('nvim')
  Plugin 'tpope/vim-surround'
endif
"Plugin 'kana/vim-textobj-indent.git'
if s:uname != 'Linux' || has('nvim')
  Plugin 'michaeljsmith/vim-indent-object'
endif
Plugin 'junegunn/vim-easy-align'
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" plugins: motion {{{1
Plugin 'Lokaltog/vim-easymotion'
