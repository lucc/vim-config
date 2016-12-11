" Autogit Plugin by luc.
" This file depends on the python module.

if !has('python') || exists('g:autogit_loaded') && g:autogit_loaded
  finish
endif
let autogit_loaded = 1
let s:do_autogit = 1

python <<END_OF_PYTHON
import os, threading # stdlib
import vim           # 3. party
import git           # custom
def autogit_vim(branches=['autocmd', 'autogit']):
    '''Wrapper around git.autogit() to be called from vim.'''
    directory = os.path.dirname(vim.current.buffer.name)
    threading.Thread(target=git.autogit, args=(directory, branches)).start()
END_OF_PYTHON

augroup LucAutoGit
  autocmd!
  autocmd BufWritePost ~/.config/**,~/src/shell/**,~/.homesick/repos/**
	\ if s:do_autogit                |
	\   call pyeval('autogit_vim() or 1') |
	\ endif
augroup END

command! AutoGitStart  let s:do_autogit = 1
command! AutoGitStop   let s:do_autogit = 0
command! AutoGitToggle let s:do_autogit = !s:do_autogit
command! AutoGitStatus echon 'AutoGit is ' |
      \ if s:do_autogit                    |
      \   echohl LucAutoGitRunning         |
      \   echon 'running'                  |
      \ else                               |
      \   echohl LucAutoGitStopped         |
      \   echon 'stopped'                  |
      \ endif                              |
      \ echohl None

" define highlight groups after the colorscheme else they will be cleared
highlight LucAutoGitRunning guifg=#719e07
highlight LucAutoGitStopped guifg=#dc322f
