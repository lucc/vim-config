" plugin setup file by luc
"
" vim: foldmethod=marker spelllang=en

call luc#setup#vim_plug()

runtime init.d/plugins/coding.vim
runtime init.d/plugins/editing.vim
runtime init.d/plugins/completion.vim
runtime init.d/plugins/languages.vim
runtime init.d/plugins/ui.vim

Plug 'mhinz/vim-grepper' " {{{1
let g:grepper = {}
let g:grepper.dir = 'filecwd'
let g:grepper.jump = 1
let g:grepper.prompt = 0
let g:grepper.quickfix = 0
let g:grepper.searchreg = 1
let g:grepper.tools = ['git', 'rg', 'ag', 'grep']
command! -nargs=* -complete=file S Grepper -jump -query <args>

Plug 'eugen0329/vim-esearch' " {{{1

Plug 'aquach/vim-mediawiki-editor' " {{{1
let g:mediawiki_editor_uri_scheme = 'http'
let g:mediawiki_editor_url = 'asam2'
let g:mediawiki_editor_path = '/asam_wiki/'
let g:mediawiki_editor_username = 'LUC'

Plug 'hkupty/iron.nvim' " {{{1
let g:iron_repl_open_cmd = 'vsplit'
command! REPL IronRepl
" load the current file in the REPL.
command! RF call s:load_current_file_in_repl()
function! s:load_current_file_in_repl()
  if &filetype ==# 'haskell'
    let load = ':load '.bufname('%')
  elseif &filetype ==# 'prolog'
    let load = '["'.bufname('%').'"].'
  else
    echoerr 'Don''t know how to load files for ' . &filetype . '.'
    return
  endif
  call luaeval('require("iron").core.send(_A[1],_A[2])', [&filetype, load])
endfunction

Plug 'nathanaelkane/vim-indent-guides' " {{{1
let g:indent_guides_auto_colors = 0
let g:indent_guides_default_mapping = 0
highlight link IndentGuidesOdd  Normal
highlight link IndentGuidesEven LineNr

" plugins: unsorted {{{1
Plug 'AndrewRadev/linediff.vim'
Plug 'andymass/vim-matchup'
Plug 'chrisbra/unicode.vim'
Plug 'git://fedorapeople.org/home/fedora/wwoods/public_git/vim-scripts.git'
Plug 'jamessan/vim-gnupg'
Plug 'lucc/VimRepress' " clone of https://bitbucket.org/pentie/vimrepress
Plug 'pix/vim-known_hosts'
Plug 'sjl/gundo.vim'
Plug 'ZeroKnight/vim-signjump'
Plug '~/src/vim-tip'

" finalize {{{1
call plug#end()

" For very short ultisnips triggers to be usable with deoplete:
" https://github.com/SirVer/ultisnips/issues/517#issuecomment-268518251
"call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])
" https://github.com/autozimu/LanguageClient-neovim/wiki/deoplete
"call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)

lua <<EOF
iron = require("iron")
iron.core.set_config{
  preferred = {
    prolog = "swipl",
    python = "ipython"
  }
}
EOF
