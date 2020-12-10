" Vim Compiler File
" Compiler:	nvim testsuite via the makefile
" Maintainer:	luc
" Last Change:	2015-07-19

if exists("current_compiler")
    finish
endif
let current_compiler = "nvimtestsuite"

CompilerSet makeprg=make\ functionaltest\ TEST_FILE=%

"CompilerSet errorformat=
"      \%-EFailure\ →\ %.%#\ @\ %*[0-9]\#,
"      \%-C%.%#,
"      \%Z%f:%l:\ Expected\ objects\ to\ be\ the\ same.,
"      \%-G%.%#
CompilerSet errorformat=
      \%f:%l:\ Expected\ objects\ to\ be\ the\ same.

"CompilerSet errorformat=\ %#[%.%#]\ %#%f:%l:%v:%*\\d:%*\\d:\ %t%[%^:]%#:%m,
"    \%A\ %#[%.%#]\ %f:%l:\ %m,%-Z\ %#[%.%#]\ %p^,%C\ %#[%.%#]\ %#%m
"
"
"
"
"   Failure → test/functional/legacy/eval_spec.lua @ 76
"various eval features let tests
"test/functional/legacy/eval_spec.lua:93: Expected objects to be the same.
