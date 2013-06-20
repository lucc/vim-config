"s:tmux_cmd = 'tmux'

function! LTmux_Session_Names(A,L,P)
  "return system("tmux list-sessions | sed -e 's/:.*$//'")
  return system("tmux list-sessions | cut -f 1 -d :")
  "return split(system("tmux list-sessions"), ':')[0]
endfunction

function! LTmux_Window_Names(A,L,P)
  "return system("tmux list-windows -t " . b:tmux_sessionname . " | sed 's/^[1-9]: //' | sed 's/ .*$//'")
  return system("tmux list-windows -t " . b:tmux_sessionname . " | cut -f 1 -d :")
endfunction

function! LTmux_Pane_Numbers(A,L,P)
  call system("tmux display-panes")
  "return system("tmux list-panes -t " . b:tmux_sessionname . ":" . b:tmux_windowname . " | sed -e 's/:.*$//'")
  return system("tmux list-panes -t " . b:tmux_sessionname . ":" . b:tmux_windowname . " | cut -f 1 -d :")
endfunction


function! LSend_to_Tmux(text)
  if !exists("b:tmux_sessionname") || !exists("b:tmux_windowname")
    if exists("g:tmux_sessionname") && exists("g:tmux_windowname")
      let b:tmux_sessionname = g:tmux_sessionname
      let b:tmux_windowname = g:tmux_windowname
      let b:tmux_panenumber = g:tmux_panenumber
    else
      call LTmux_Vars()
    end
  end

  let target = b:tmux_sessionname . ":" . b:tmux_windowname

  if exists("b:tmux_panenumber")
    let target .= "." . b:tmux_panenumber
  end

  "echoerr "tmux set-buffer " . shellescape(a:text)
  "echoerr "tmux paste-buffer -t " . target
  "call system("tmux set-buffer " . shellescape(a:text))
  call system("tmux set-buffer '" . substitute(a:text, "'", "'\\\\''", 'g') . "'" )
  call system("tmux paste-buffer -t " . target)
  if exists("g:tmux_send_newline")
    if g:tmux_send_newline
      "let @r = "\n"
      "call system("tmux send-keys -l -t " . target . shellescape("\n"))
      call system("tmux send-keys -l -t " . target . " '" . "\n" . "'")
    endif
  endif
endfunction




function! LTmux_Vars()
  let b:tmux_sessionname = input("session name: ", "", "custom,LTmux_Session_Names")
  let b:tmux_windowname = input("window number: ", "", "custom,LTmux_Window_Names")

  let b:tmux_panenumber = input("pane number: ", "", "custom,LTmux_Pane_Numbers")

  if !exists("g:tmux_sessionname") || !exists("g:tmux_windowname")
    let g:tmux_sessionname = b:tmux_sessionname
    let g:tmux_windowname = b:tmux_windowname
    let g:tmux_panenumber = b:tmux_panenumber
  end
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

vmap <C-c><C-c> "ry:call LSend_to_Tmux(@r)<CR>
nmap <C-x><C-e> "ry%:call LSend_to_Tmux(@r)<CR>%
"nmap <C-D-f>    /(<CR>%:noh<cr>
"nmap <C-c><C-c> vip<C-c><C-c>
"nmap <C-c>v :call Tmux_Vars()<CR>

