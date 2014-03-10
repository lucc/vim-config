" vim functions for plugin management

function! fname#call_git(args)

endfunction
function! fname#call_mercurial(args)
endfunction
function! fname#call_svn(args)
endfunction

function! fname#init_clone(url)
  " create a clone of the repository at url

endfunction

function! fname#copy_directory_structure(dir)
  " copy the directory structure from dir to ~/.vim
  for d in glob(dir . '/**' , 'nowildignore+nosuffixes', 'list')
    if isdirectory(d)
      call mkdir(substitute(d, escape(dir, '/.'), expand($VIM)), 'p')
    endif
  endfor
endfunction

function fname#link_files(dir)
  " link all files below dir to ~/.vim

endfunction
