if exists("current_compiler")
  finish
endif

CompilerSet makeprg=ansible-lint\ --parseable
CompilerSet errorformat=\%f:\%l:\ \%m
