" Vim compiler file
" Compiler:    markdown
" Maintainer:  luc
" Last Change: 2013-10-21

if exists("current_compiler")
    finish
endif

let s:keepcpo = &cpo
set cpo&vim

if executable('pandoc')
  CompilerSet makeprg=TODO
  CompilerSet errorformat=TODO
elseif executable('multimarkdown')
  CompilerSet makeprg=multimarkdown\ --full\ --smart\ %\ --output=%.html
  CompilerSet errorformat=TODO
elseif executable('markdown')
  CompilerSet makeprg=TODO
  CompilerSet errorformat=TODO
else
  echoerr "No markdown compiler found!"
endif

let &cpo = s:keepcpo
unlet s:keepcpo
