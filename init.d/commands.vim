" user defined commands by luc

" interactive fix for latex quotes in English files
command! UnsetLaTeXQuotes unlet g:Tex_SmartQuoteOpen g:Tex_SmartQuoteClose
" From the example vimrc file.
command! DiffOrig call luc#commands#DiffOrig()
" Open the file under the cursor or the current file with xdg-open.
command! -bang O call luc#commands#open("<bang>")
cabbrev man vertical Man
command! -nargs=* SSH call luc#commands#ssh(<q-args>)
command! -nargs=* Alot call luc#commands#alot(<f-args>)
command! -nargs=* AlotSearch call luc#commands#alot_search_at_cursor()
command! ClearModeToggle call luc#commands#clean_mode_toggle()
command! -bang Todo call luc#commands#search_todos("<bang>")
