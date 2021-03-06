" vim: foldmethod=marker spelllang=en

" plugins: languages

Plug 'Shougo/context_filetype.vim'
" devel version of the official syntax file
Plug 'chrisbra/vim-zsh'
Plug 'tpope/vim-scriptease'
Plug 'vim-scripts/applescript.vim'
Plug 'vim-scripts/icalendar.vim'
Plug 'aliva/vim-fish'
Plug 'vim-scripts/VCard-syntax'
Plug 'vimperator/vimperator.vim'
Plug 'tkztmk/vim-vala'
Plug 'rosstimson/bats.vim'
Plug 'chikamichi/mediawiki.vim'
Plug 'tbastos/vim-lua'
Plug 'vim-scripts/luarefvim'
Plug 'cespare/vim-toml'
Plug 'LnL7/vim-nix'
Plug 'derekelkins/agda-vim'
Plug 'nfnty/vim-nftables'

" Rust {{{1

Plug 'rust-lang/rust.vim'
Plug 'rhysd/rust-doc.vim'
let g:rust_doc#downloaded_rust_doc_dir = '/usr/share/doc/rust'

" Haskell {{{1

" Plug 'vim-scripts/alex.vim' " for the alex lexer generator -- bad
Plug 'neovimhaskell/haskell-vim'
"Plug 'itchyny/vim-haskell-indent'  " to be tested
"Plug 'parsonsmatt/intero-neovim'
let g:intero_ghci_options = '-ghci-script ' . expand('~/.config/ghc/intero.conf')
"let g:intero_prompt_regex = ".*  \e[m"
let g:intero_prompt_regex = "λ> "
let g:intero_use_neomake = 0
let g:intero_start_immediately = 0

Plug 'Twinside/vim-hoogle'

" LaTeX {{{1

" original vim settings for latex
"let g:tex_fold_enabled = 1
let g:tex_flavor = 'latex'

Plug 'lervag/vimtex'
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_types = {
      \ 'sections' : {
      \   'sections' : [
      \     'part',
      \     'chapter',
      \     'section',
      \     'subsection',
      \     'subsubsection',
      \     'paragraph',
      \   ],
      \ }
      \ }
"let g:vimtex_fold_types.comments = {}
"let g:vimtex_fold_types.comments.enabled = 1
let g:vimtex_compiler_method = 'latexrun'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_toc_config = {
      \ 'split_pos': 'vertical'
      \ }
let g:vimtex_toc_todo_labels = {
      \ 'FIXME': 'FIXME: ',
      \ 'TODO': 'TODO: ',
      \ 'XXX': 'FIXME: ',
      \ }

" lisp/scheme {{{1
"Plugin 'vim-scripts/slimv.vim'
"Plugin 'vim-scripts/tslime.vim'
"Plugin 'davidmfoley/tslime.vim'
"Plugin 'vim-scripts/Limp'

" markdown {{{1
" unconditionally binds <Leader>f and <Leader>r (also in insert mode=bad for
" latex)
"Plugin 'vim-pandoc/vim-markdownfootnotes'

" strange folding
"Plugin 'plasticboy/vim-markdown'
"Plugin   'hallison/vim-markdown'

" good folding uses expr
Plug 'nelstrom/vim-markdown-folding'
let g:markdown_fold_style = 'nested'

" strange folding?
"Plugin 'tpope/vim-markdown'

"Plugin 'vim-scripts/pdc.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc#modules#disabled = ["menu"]
let g:pandoc#command#latex_engine = 'pdflatex'
let g:pandoc#folding#fold_yaml = 1
let g:pandoc#folding#fdc = 0
"let g:pandoc#folding#fold_fenced_codeblocks = 1
if exists('g:pandoc#biblio#bibs')
  call insert(g:pandoc#biblio#bibs, '~/bib/main.bib')
else
  let g:pandoc#biblio#bibs = ['~/bib/main.bib']
endif
let g:pandoc#command#autoexec_on_writes = 0
let g:pandoc#command#autoexec_command = "Pandoc pdf"
let g:pandoc#formatting#mode = 'h'

" comma separated values (csv) {{{1
Plug 'chrisbra/csv.vim'
"Plugin 'vim-scripts/csv-reader'
"Plugin 'vim-scripts/CSVTK'
"Plugin 'vim-scripts/rcsvers.vim'
"Plugin 'vim-scripts/csv-color'
"Plugin 'vim-scripts/CSV-delimited-field-jumper'

" python {{{1

"Plugin 'sunsol/vim_python_fold_compact'
"Plugin 'vim-scripts/Python-Syntax-Folding'
Plug 'python-mode/python-mode'
let g:pymode_python = 'python3'
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_lint = 0
let g:pymode_doc = 0
"let g:pymode_folding = 0
"let g:pymode_virtualenv = 0
"let g:pymode_syntax = 0
let g:pymode_indent = 1
let g:pymode_options_max_line_length = 79

" This is nicer than the pymode version.
"Plug 'fs111/pydoc.vim'

" svn checkout http://vimpdb.googlecode.com/svn/trunk/ vimpdb-read-only

" PHP {{{1

" taken from http://stackoverflow.com/a/7490288
let php_folding = 0        "Set PHP folding of classes and functions.
"let php_htmlInStrings = 1  "Syntax highlight HTML code inside PHP strings.
"let php_sql_query = 1      "Syntax highlight SQL code inside PHP strings.
"let php_noShortTags = 1    "Disable PHP short tags.

Plug 'swekaj/php-foldexpr.vim'
