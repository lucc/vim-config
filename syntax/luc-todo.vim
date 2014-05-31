" Vim syntax file
"  Language: self defined todo file
"  Maintainer: luc
"  Last Change: 2013-03-05
"  Version: 1
"  History:
"    2013-03-05: creation
" ---------------------------------------------------------------------
syntax region LucToDo matchgroup=LucToDoFoldString start="^" end="{{{[0-9]\+$" oneline concealends
highlight def link LucToDo Title
