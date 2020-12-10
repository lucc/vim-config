" Compiler file for stack (haskell tool stack)

if exists("current_compiler")
  finish
endif
let current_compiler = "stack"

CompilerSet errorformat=
    \%-G%.%#:\ build,
    \%-G%.%#preprocessing\ library\ %.%#,
    \%-G[%.%#]%.%#,
    \%E%f:%l:%c:\ %m,
    \%-G--%.%#
CompilerSet makeprg=stack\ build
