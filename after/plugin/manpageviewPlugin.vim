" file to overwrite a command from manpageviewPlugin.vim
command! -nargs=1 -complete=customlist,luc#man#complete_topics
      \ Man wincmd v <bar> wincmd = <bar> RMan <args>.man
