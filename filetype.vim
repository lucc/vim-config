" This file is sourced before the global (upstream) filetype.vim file.  The
" files in ftdetect/ will be sourced after the global filetype.vim.

augroup LucFileType
  autocmd BufNewFile,BufRead $GNUPGHOME/gpg.conf setfiletype gpg
  autocmd BufNewFile,BufRead $GNUPGHOME/options  setfiletype gpg
  autocmd BufRead,BufNewFile PKGBUILD setfiletype sh | let b:is_bash = 1
  autocmd BufRead,BufNewFile *.mutt   setfiletype muttrc
  autocmd BufRead,BufNewFile *.muttrc setfiletype muttrc
  autocmd BufRead,BufNewFile *.ics    setfiletype icalendar
  autocmd BufRead,BufNewFile *.vcf    setfiletype icalendar | set fileformat=dos
  autocmd BufRead,BufNewFile *.tmux   setfiletype tmux
  autocmd BufRead,BufNewFile build.sc setfiletype scala
  autocmd BufRead,BufNewFile *.u      setfiletype ulang | source ~/uni/master/ulang/misc/ulang.vim
  autocmd BufRead,BufNewFile *.blade.php setfiletype php.blade
augroup END
