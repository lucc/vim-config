" init.vim file by luc
" vim: spelllang=en

" user defined variables
let mapleader = ','

" source subfiles
runtime init.d/options.vim
runtime init.d/autocmds.vim
runtime init.d/maps.vim
runtime init.d/commands.vim
runtime init.d/plugins.vim
runtime init.d/colors.vim
runtime init.d/final.vim

" taken from http://stackoverflow.com/a/7490288
let php_folding = 0        "Set PHP folding of classes and functions.
"let php_htmlInStrings = 1  "Syntax highlight HTML code inside PHP strings.
"let php_sql_query = 1      "Syntax highlight SQL code inside PHP strings.
"let php_noShortTags = 1    "Disable PHP short tags.
