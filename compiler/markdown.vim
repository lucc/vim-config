" Vim compiler file
" Compiler:    markdown
" Maintainer:  luc
" Last Change: 2013-10-21

let s:keepcpo = &cpo
set cpo&vim

CompilerSet makeprg=multimarkdown\ --full\ --smart\ %\ --output=%.html


let &cpo = s:keepcpo
unlet s:keepcpo
