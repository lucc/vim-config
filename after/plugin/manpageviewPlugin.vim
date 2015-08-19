" file to overwrite a command from manpageviewPlugin.vim
if exists('g:vimpager') && g:vimpager
  command! -nargs=1 -complete=customlist,luc#man#complete_topics
	\ Man RMan <args>.man
else
  command! -nargs=1 -complete=customlist,luc#man#complete_topics
	\ Man wincmd v <bar> wincmd = <bar> RMan <args>.man
endif
