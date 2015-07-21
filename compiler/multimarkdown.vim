" Vim compiler file
" Compiler:    multimarkdown
" Maintainer:  luc
" Last Change: 2015-07-21

if exists("current_compiler")
    finish
endif

let s:keepcpo = &cpo
set cpo&vim

CompilerSet makeprg=multimarkdown\ --full\ --smart\ %\ --output=%.html
CompilerSet errorformat=TODO

let &cpo = s:keepcpo
unlet s:keepcpo
