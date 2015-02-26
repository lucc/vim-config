" user defined maps by luc

" Don't use Ex mode, use Q for formatting (from the example file)
nnoremap Q gq

" make Y behave like D,S,C ...
nnoremap Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" easy spell checking
inoremap <C-s>     <C-o>:call luc#find_next_spell_error()<CR><C-x><C-s>
nnoremap <C-s>          :call luc#find_next_spell_error()<CR>z=
nnoremap <leader>s      :call luc#find_next_spell_error()<CR>zv

" capitalize text
vmap gc  "=luc#capitalize(luc#get_visual_selection())<CR>p
nmap gc  :set operatorfunc=luc#capitalize_operator_function<CR>g@
nmap gcc gciw

" prefix lines with &commentstring
vmap <leader>p :call luc#prefix(visualmode())<CR>
nmap <leader>p :set operatorfunc=luc#prefix<CR>g@

" bla
if has('gui_macvim')
  inoremap œ \
  inoremap æ \|
  cnoremap œ \
  cnoremap æ \|
  inoremap <D-s> <C-O>:silent update<CR>
  noremap  <D-s>      :silent update<CR>
endif

" open URLs
python import strings
python import webbrowser
nmap <Leader>w :python for url in strings.urls(vim.current.line):
      \ webbrowser.open(url)<CR>

" easy compilation
nmap <silent> <F2>        :call luc#save_and_compile()<CR>
imap <silent> <F2>   <C-O>:call luc#save_and_compile()<CR>

" backup current buffer
nnoremap <silent> <F11>
      \ :silent update <BAR>
      \ call pyeval('backup_current_buffer() or 1') <BAR>
      \ redraw <CR>

" moveing around
nmap <C-Tab>     gt
imap <C-Tab>     <C-O>gt
nmap <C-S-Tab>   gT
imap <C-S-Tab>   <C-O>gT
nmap <C-W><C-F>  <C-W>f<C-W>L
nmap <SwipeUp>   gg
imap <SwipeUp>   gg
nmap <SwipeDown> G
imap <SwipeDown> G

nnoremap ' `
nnoremap ` '

" use ß to clear the screen if you want privacy for a moment
nmap ß :!clear<CR>

" https://github.com/javyliu/javy_vimrc/blob/master/_vimrc
"vmap // :<C-U>execute 'normal /' . luc#get_visual_selection()<CR>
vmap // y/<C-r>"<CR>
