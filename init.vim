" init.vim file by luc
runtime init.d/options.vim
runtime init.d/autocmds.vim
runtime init.d/plugins.vim
runtime init.d/colors.vim
runtime init.d/final.vim

lua <<EOF
require "plugins"
require "maps"
require "commands"
EOF
