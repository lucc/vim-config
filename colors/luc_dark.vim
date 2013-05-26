" Vim color file
" Maintainer: Luc
" Last Change: 2011-11-03

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let colors_name = "luc_dark"

" Normal mode
hi Normal ctermbg=Black ctermfg=White guibg=#1c1c1c guifg=White

" Preffered groups
hi Comment	ctermfg=DarkBlue   guifg=DarkBlue
hi Constant	ctermfg=DarkRed    guifg=DarkRed
hi Identifier	ctermfg=Green      guifg=Green
"hi Statement	any statement
"hi PreProc	generic Preprocessor
hi Type		ctermfg=DarkGreen guifg=DarkGreen
"hi Special	any special symbol
"hi Underlined	text that stands out, HTML links
"hi Ignore		left blank, hidden  |hl-Ignore|
hi Error	ctermbg=Red       guifg=Red
hi Todo		ctermbg=Yellow    guifg=Yellow

"highlight Comment          ctermfg=DarkBlue
"highlight Cursor          guifg=bg guibg=fg

  "highlight ColorColomn ctermbg=lightgrey guibg=lightgrey
highlight ColorColumn      ctermbg=DarkRed guibg=DarkRed
  highlight ColorColomn ctermbg=235 guibg=lightgrey



  " set colors for closed folds
  " execute :XtermColorTable to check the values of colors




  highlight Search term=reverse ctermbg=11 ctermfg=0 guibg=Yellow

" Folds
highlight Folded ctermfg=1 ctermbg=235 guifg=DarkBlue guibg=LightGrey

" Popup Menu
highlight Pmenu      ctermbg=235      ctermfg=green
highlight PmenuSel   ctermbg=green    ctermfg=235
highlight PmenuSbar  ctermbg=DarkGrey
highlight PmenuThumb ctermbg=green




"	*Comment	any comment
"
"	*Constant	any constant
"	 String		a string constant: "this is a string"
"	 Character	a character constant: 'c', '\n'
"	 Number		a number constant: 234, 0xff
"	 Boolean	a boolean constant: TRUE, false
"	 Float		a floating point constant: 2.3e10
"
"	*Identifier	any variable name
"	 Function	function name (also: methods for classes)
"
"	*Statement	any statement
"	 Conditional	if, then, else, endif, switch, etc.
"	 Repeat		for, do, while, etc.
"	 Label		case, default, etc.
"	 Operator	"sizeof", "+", "*", etc.
"	 Keyword	any other keyword
"	 Exception	try, catch, throw
"
"	*PreProc	generic Preprocessor
"	 Include	preprocessor #include
"	 Define		preprocessor #define
"	 Macro		same as Define
"	 PreCondit	preprocessor #if, #else, #endif, etc.
"
"	*Type		int, long, char, etc.
"	 StorageClass	static, register, volatile, etc.
"	 Structure	struct, union, enum, etc.
"	 Typedef	A typedef
"
"	*Special	any special symbol
"	 SpecialChar	special character in a constant
"	 Tag		you can use CTRL-] on this
"	 Delimiter	character that needs attention
"	 SpecialComment	special things inside a comment
"	 Debug		debugging statements
"
"	*Underlined	text that stands out, HTML links
"
"	*Ignore		left blank, hidden  |hl-Ignore|
"
"	*Error		any erroneous construct
"
"	*Todo		anything that needs extra attention; mostly the
"			keywords TODO FIXME and XXX
"
