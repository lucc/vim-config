" vim: foldmethod=marker spelllang=en

" plugins: languages

Plug 'Shougo/context_filetype.vim'
Plug 'tpope/vim-scriptease'
Plugin 'vim-scripts/applescript.vim'
Plugin 'vim-scripts/icalendar.vim'
Plugin 'aliva/vim-fish'
Plugin 'vim-scripts/VCard-syntax'
Plugin 'vimperator/vimperator.vim'
Plugin 'tkztmk/vim-vala'

" plugins: LaTeX {{{1

" original vim settings for latex
"let g:tex_fold_enabled = 1
let g:tex_flavor = 'latex'

" 3109 LatexBox.vmb
"Plugin 'coot/atp_vim'
"Plugin 'vim-scripts/LaTeX-functions'
"Plugin 'vim-scripts/latextags'
"Plugin 'vim-scripts/TeX-9'
"Plugin 'vim-scripts/tex.vim'
"Plugin 'vim-scripts/tex_autoclose.vim'

"Plugin 'vim-scripts/auctex.vim'
Plug 'donRaphaco/neotex', { 'for': 'tex' }

Plugin 'vim-latex/vim-latex' "{{{2
"Plugin 'vim-scripts/LaTeX-Help' " is included in vim-latex
let g:ngerman_package_file = 1
let g:Tex_Menus = 0
"let g:Tex_UseUtfMenus = 1

" The other settings for vim-latex are in the LucLatexSuiteSettings
" autocmdgroup.
if has('mac') | let g:Tex_ViewRule_pdf = 'open -a Preview' | endif
let g:Tex_UseMakefile = 1
let g:Tex_CompileRule_pdf = 'latexmk -silent -pv -pdf $*'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_SmartQuoteOpen = '„'
let g:Tex_SmartQuoteClose = '“'
" the variable Tex_FoldedEnvironments holds the beginnings of names of
" environments which should be folded.  The innermost environments should come
" first.
let s:TexFoldEnv = [ 'verbatim',
	           \ 'comment',
	           \ 'eq',
	           \ 'gather',
	           \ 'align',
	           \ 'figure',
	           \ 'table',
		   \ 'luc',
		   \ 'dogma',
	           \ ]
" environments for structure of mathematical texts (they can contain other
" stuff)
call extend(s:TexFoldEnv, [ 'th',
			  \ 'satz',
			  \ 'def',
			  \ 'lem',
			  \ 'rem',
			  \ 'bem',
			  \ 'proof',
			  \ ])
" quotes can contain other stuff
call extend(s:TexFoldEnv, ['quot',])
" the beamer class has two top level environments
call extend(s:TexFoldEnv, [ 'block',
			  \ 'frame',
			  \])
" environments for the general document
call extend(s:TexFoldEnv, [ 'thebibliography',
			  \ 'keywords',
			  \ 'abstract',
			  \ 'titlepage',
			  \ ])
let g:Tex_FoldedEnvironments = join(s:TexFoldEnv, ',')
let s:TexFoldSec = [
      \ 'part',
      \ 'chapter',
      \ 'section',
      \ 'subsection',
      \ 'subsubsection',
      \ 'paragraph',
      \ 'subparagraph',
      \ ]
let g:Tex_FoldedSections = join(s:TexFoldSec, ',')
" alternative 1
  "let s:TexFoldEnv = ['*', 'document', 'minipage', 'di', 'lem', 'ivt', 'dc',
  "      \ 'verbatim', 'comment', 'proof', 'eq', 'gather', 'align', 'figure',
  "      \ 'table', 'thebibliography', 'keywords', 'abstract', 'titlepage'
  "      \ 'item', 'enum', 'display' ]
  "let g:Tex_FoldedMisc = 'comments,item,preamble,<<<'
" alternative 2
  " let g:Tex_FoldedMisc = 'comments,item,preamble,<<<,slide'
" alternative 3
  "let Tex_FoldedEnvironments .= '*'
  "let Tex_FoldedSections =
  "\ 'part,chapter,section,subsection,subsubsection,paragraph'

" Synctex support with evince as described here:
" https://help.gnome.org/users/evince/stable/synctex-editors.html.en
let g:Tex_ViewRule_pdf = 'python /usr/lib/gedit/plugins/synctex/evince_dbus.py'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'latexrun --latex-args --synctex=1 $*'

" plugins: lisp/scheme {{{1
"Plugin 'vim-scripts/slimv.vim'
"Plugin 'vim-scripts/tslime.vim'
"Plugin 'davidmfoley/tslime.vim'
"Plugin 'vim-scripts/Limp'

" plugins: markdown {{{1
" unconditionally binds <Leader>f and <Leader>r (also in insert mode=bad for
" latex)
"Plugin 'vim-pandoc/vim-markdownfootnotes'

" strange folding
"Plugin 'plasticboy/vim-markdown'
"Plugin   'hallison/vim-markdown'

" good folding uses expr
Plugin 'nelstrom/vim-markdown-folding'
let g:markdown_fold_style = 'nested'

" strange folding?
"Plugin 'tpope/vim-markdown'

"Plugin 'vim-scripts/pdc.vim'
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax'
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

" plugins: comma separated values (csv) {{{1
Plugin 'chrisbra/csv.vim'
"Plugin 'vim-scripts/csv-reader'
"Plugin 'vim-scripts/CSVTK'
"Plugin 'vim-scripts/rcsvers.vim'
"Plugin 'vim-scripts/csv-color'
"Plugin 'vim-scripts/CSV-delimited-field-jumper'

" plugins: python {{{1

"Plugin 'sunsol/vim_python_fold_compact'
"Plugin 'vim-scripts/Python-Syntax-Folding'
Plugin 'klen/python-mode'
if has('nvim')
  let g:pymode_python = 'python3'
endif
let g:pymode_rope = 1
let g:pymode_rope_completion = 0
let g:pymode_lint = 0
"let g:pymode_folding = 0
"let g:pymode_virtualenv = 0
"let g:pymode_syntax = 0
let g:pymode_indent = 0
let g:pymode_options_max_line_length = 79

" This is nicer than the pymode version.
Plugin 'fs111/pydoc.vim'

" svn checkout http://vimpdb.googlecode.com/svn/trunk/ vimpdb-read-only

" PHP {{{1

" taken from http://stackoverflow.com/a/7490288
let php_folding = 0        "Set PHP folding of classes and functions.
"let php_htmlInStrings = 1  "Syntax highlight HTML code inside PHP strings.
"let php_sql_query = 1      "Syntax highlight SQL code inside PHP strings.
"let php_noShortTags = 1    "Disable PHP short tags.

Plugin 'swekaj/php-foldexpr.vim'
