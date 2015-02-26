" user defined commands by luc

" wrapper command for Dr. Chip's man page viewer
command! -nargs=1 -complete=customlist,luc#man#complete_topics
      \ ManLuc TMan <args>.man

" interactive fix for latex quotes in English files
command! UnsetLaTeXQuotes unlet g:Tex_SmartQuoteOpen g:Tex_SmartQuoteClose
