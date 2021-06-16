" Compiler settings to build NixOS system config with nixos-rebuild

if exists("current_compiler")
  finish
endif
let current_compiler = "nixos"

"CompilerSet errorformat=
"    \%-G%.%#:\ build,
"    \%-G%.%#preprocessing\ library\ %.%#,
"    \%-G[%.%#]%.%#,
"    \%E%f:%l:%c:\ %m,
"    \%-G--%.%#
CompilerSet makeprg=nixos-rebuild\ build\ --fast
