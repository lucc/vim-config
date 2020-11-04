" general plugins for editing
" vim: foldmethod=marker spelllang=en

Plug 'ron89/thesaurus_query.vim'

" plugins: buffer and file management {{{1
Plug 'ctrlpvim/ctrlp.vim'

" cache {{{2
"let g:ctrlp_cache_dir = $HOME.'/.vim/cache/ctrlp'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_mruf_max = 1000

" ignore/include/exclude patterns {{{2
let g:ctrlp_show_hidden = 1
let g:ctrlp_max_files = 0
let g:ctrlp_root_markers = [
      \ '.git',
      \ 'makefile',
      \ 'Makefile',
      \ ]
" asynchronous file cache update
if executable("fd")
  let g:user_command_async = 1
  let g:ctrlp_user_command = 'fd --hidden --type f "" %s'
  let g:ctrlp_use_caching = 0
else
  let g:ctrlp_use_caching = 1
endif

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

" I don't like this as it either doesn't honor the last used file in MRU mode
" (it does some "intelligent" matching on the empty query) or it doesn't
" remove the current file from the results (with cpsm_match_empty_query=0).
Plug 'nixprime/cpsm', { 'do': 'nix-shell --run ''VIM=nvim bash ./install.sh'' -p cmake boost.dev ncurses.dev' }
let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
let g:cpsm_match_empty_query = 0
"" cpsm doesn't use 1 as a default if the variable doesn't exist.
let g:ctrlp_match_current_file = 0

" {{{1 clap
Plug 'liuchengxu/vim-clap', { 'do': {-> jobstart([
      \ 'nix-shell', '--pure', '--run', 'make', '-p', 'openssl.dev', 'cargo',
      \ 'pkg-config'])} }
let g:clap_layout = {'relative': 'editor'}
let g:clap_insert_mode_only = v:true
let g:clap_open_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
      \ }

" {{{1 fzf
"Plug 'junegunn/fzf'
"Plug 'junegunn/fzf.vim'

" plugins: parenthesis, quotes, alignment {{{1

Plug 'Raimondi/delimitMate'
Plug 'vim-scripts/paredit.vim'
Plug 'tpope/vim-surround'
"Plugin 'kana/vim-textobj-indent.git'
Plug 'michaeljsmith/vim-indent-object'
Plug 'junegunn/vim-easy-align'
vmap <Enter> <Plug>(EasyAlign)
nmap <Leader>a <Plug>(EasyAlign)

" plugins: motion {{{1
Plug 'Lokaltog/vim-easymotion'
