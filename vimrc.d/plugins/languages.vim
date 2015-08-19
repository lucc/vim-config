" vim: foldmethod=marker spelllang=en
let s:uname = system('uname')[:-2]
" plugins: languages

Plugin 'applescript.vim'
Plugin 'icalendar.vim'
Plugin 'aliva/vim-fish'

" plugins: LaTeX {{{1

" original vim settings for latex
"let g:tex_fold_enabled = 1
let g:tex_flavor = 'latex'

" 3109 LatexBox.vmb
"Plugin 'coot/atp_vim'
"Plugin 'LaTeX-functions'
"Plugin 'latextags'
"Plugin 'TeX-9'
"Plugin 'tex.vim'
"Plugin 'tex_autoclose.vim'

"Plugin 'auctex.vim'

if s:uname != 'Linux' || has('nvim')
  Plugin 'git://git.code.sf.net/p/vim-latex/vim-latex' "{{{2
endif
"Plugin 'LaTeX-Help' " is included in vim-latex
let g:ngerman_package_file = 1
let g:Tex_Menus = 0
"let g:Tex_UseUtfMenus = 1

" The other settings for vim-latex are in the LucLatexSuiteSettings
" autocmdgroup.
if has('mac') | let g:Tex_ViewRule_pdf = 'open -a Preview' | endif
let g:Tex_UseMakefile = 1
let g:Tex_CompileRule_pdf = 'latexmk -silent -pv -pdf $*'
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

" plugins: lisp/scheme {{{1
Plugin 'slimv.vim'
"Plugin 'tslime.vim'
Plugin 'davidmfoley/tslime.vim'
Plugin 'Limp'

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

"Plugin 'pdc.vim'
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
"Plugin 'csv-reader'
"Plugin 'CSVTK'
"Plugin 'rcsvers.vim'
"Plugin 'csv-color'
"Plugin 'CSV-delimited-field-jumper'

" plugins: python {{{1

"Plugin 'sunsol/vim_python_fold_compact'
"Plugin 'Python-Syntax-Folding'
Plugin 'klen/python-mode'
if has('nvim')
  let g:pymode_python = 'python3'
endif
let g:pymode_rope = 0
let g:pymode_lint = 0

Plugin 'vim-autopep8'
" svn checkout http://vimpdb.googlecode.com/svn/trunk/ vimpdb-read-only
Plugin 'fs111/pydoc.vim'
