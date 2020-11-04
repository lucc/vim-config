" custom filetype settings by luc
setlocal spell
command! -buffer PandocSetNeomake       setlocal makeprg=pandoc\ %\ -o\ %:r.html
command! -buffer PandocSetNeomakePdf    setlocal makeprg=pandoc\ %\ -o\ %:r.pdf\ -t\ latex
command! -buffer PandocSetNeomakeBeamer setlocal makeprg=pandoc\ %\ -o\ %:r.pdf\ -t\ beamer
