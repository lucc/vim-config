" vim compiler file
" Compiler: SWI Prolog
" Maintainer: Lucas Hoffmann

if exists("current_compiler")
  finish
endif
let current_compiler = 'swipl'

CompilerSet errorformat=
      \ERROR:\ %f:%l:%c:\ %m
CompilerSet makeprg=swipl\ --quiet\ -g\ halt\ -s\ $*
