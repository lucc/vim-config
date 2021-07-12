-- user defined commands by luc

-- interactive fix for latex quotes in English files
vim.cmd [[command! UnsetLaTeXQuotes unlet g:Tex_SmartQuoteOpen g:Tex_SmartQuoteClose]]
-- From the example vimrc file.
vim.cmd [[command! DiffOrig call luc#commands#DiffOrig()]]
-- Open the file under the cursor or the current file with xdg-open.
vim.cmd [[command! -bang O call luc#commands#open("<bang>")]]
vim.cmd [[cabbrev man vertical Man]]
vim.cmd [[command! -nargs=* SSH call luc#commands#ssh(<q-args>)]]
vim.cmd [[command! -nargs=* Alot call luc#commands#alot(<f-args>)]]
vim.cmd [[command! -nargs=* AlotSearch call luc#commands#alot_search_at_cursor()]]
vim.cmd [[command! ClearModeToggle call luc#commands#clean_mode_toggle()]]
vim.cmd [[command! -bang Todo call luc#commands#search_todos("<bang>")]]
