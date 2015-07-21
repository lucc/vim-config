" Vim compiler file
" Compiler:    pandoc
" Maintainer:  luc
" Last Change: 2015-07-21

if exists("current_compiler")
    finish
endif

let s:keepcpo = &cpo
set cpo&vim

CompilerSet makeprg=TODO
CompilerSet errorformat=TODO

let &cpo = s:keepcpo
unlet s:keepcpo
