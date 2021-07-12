-- user defined maps by lucc

local map = require("helpers").map

-- Don't use Ex mode, use Q for formatting (from the example file)
map("n", "Q", "gq")

-- make Y behave like D,S,C ...
map("n", "Y", "y$")

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
map("i", "<C-U>", "<C-G>u<C-U>")
map("i", "<C-W>", "<C-G>u<C-W>")

-- easy spell checking
map("i", "<C-s>", "<cmd>call luc#find_next_spell_error()<CR><C-x><C-s>")
map("n", "<C-s>", "<cmd>call luc#find_next_spell_error()<CR>z=")
map("n", "<leader>s", "<cmd>call luc#find_next_spell_error()<CR>zv")
map("n", "<leader>k", "1z=")

-- capitalize text
map("v", "gc",  "=luc#capitalize(luc#get_visual_selection())<CR>p")
map("n", "gc", "<cmd>set operatorfunc=luc#capitalize_operator_function<CR>g@")
map("n", "gcc", "gciw", {noremap=false})

-- try to make the current window as tall as the content
map("n", "<C-W>.", "<CMD>execute 'resize' nvim_buf_line_count(0)<CR>")

-- prefix lines with &commentstring
map("v", "<leader>p", "<cmd>call luc#prefix(visualmode())<CR>")
map("n", "<leader>p", "<cmd>set operatorfunc=luc#prefix<CR>g@")

-- moveing around
map("n", "<C-W><C-F>", "<C-W>f<C-W>L")
map("n", "<SwipeUp>", "gg")
map("i", "<SwipeUp>", "gg")
map("n", "<SwipeDown>", "G")
map("i", "<SwipeDown>", "G")
map("n", "g<CR>", "<C-]>")

map("n", "'", "`")
map("n", "`", "'")

-- https://github.com/javyliu/javy_vimrc/blob/master/_vimrc
map("v", "*", 'y/<C-r>"<CR>')
map("v", "#", 'y?<C-r>"<CR>')

-- Use ESC to leave terminal mode
map("t", "<Esc>", "<C-\\><C-n>")

-- open the file under the cursor with xdg-open
map("n", "gF", "<CMD>O<CR>")

map("n", "<silent>", "<C-Z> <CMD>call luc#terminal()<CR>")
map("n", "<silent>", "<leader><C-Z> <CMD>suspend<CR>")
