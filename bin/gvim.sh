#!/bin/sh
# vim: foldmethod=marker

# A script to use gvim as a replacement for different programs like man and
# info or to call a gvim server.

# variables {{{1
TMP=`mktemp -t $PROG.$$.XXXXXX`
SAVE_STDIN=false
CMD=tab

# start gvim in the background if no vim server is running {{{1
if [ -z "`vim --serverlist`" ]; then
  gvim &
fi

# functions {{{1
# wait for the vimserver to be available {{{2
wait_server () {
  # this does not need any other options to silence the process b/c --cmd will
  # execute the code very early
  vim --cmd 'while serverlist() == "" | sleep 100m | endwhile' "$@"
}

# try to put the server vim in the foreground {{{2
foreground () {
  wait_server \
    --cmd 'let server = split(serverlist())[0]' \
    --cmd 'call remote_foreground(server)' \
    --cmd quit
}

# open a new tab in the server {{{2
tab () {
  wait_server --cmd quit
  vim --remote-tab-wait-silent "$@"
}


# generic function to open documentation {{{2
doc () {
  if [ $# -eq 0 ]; then
    echo Topic needed >&2
    exit 2
  fi
  wait_server \
    --cmd 'let server = split(serverlist())[0]' \
    --cmd "call remote_expr(server, 'luc.man.tabopen(\"$1\", \"${@:2}\")')" \
    --cmd 'call remote_foreground(server)' \
    --cmd quit
}

# wrapper functions for individual help systems {{{2
info    () { doc i   "$@"; }
man     () { doc man "$@"; }
perldoc () { doc pl  "$@"; }
php     () { doc php "$@"; }
pydoc   () { doc py  "$@"; }

# parse the command line {{{1
if [ $# -eq 0 ]; then
  CMD=foreground
else
  # trying to implement long options
  for arg; do
    case "$arg" in
      --editor)
	# be an editor, to be used with $EDITOR
	CMD=tab
	new_args=("${new_args[@]}" '+call luc.misc.RemoteEditor(0)')
	;;
      --info)
	# emulate info(1)
	CMD=info
	;;
      --man)
	# emulate man(1)
	CMD=man
	;;
      --perldoc|--perl|--pl)
	# emulate perldoc(1)
	CMD=perldoc
	;;
      --php)
	CMD=php
	;;
      --pydoc|--python|--py)
	# emulate pydoc(1)
	CMD=pydoc
	;;
      --stdin)
	# read input from stdin
	SAVE_STDIN=true; CMD=${CMD:-tab}
	;;
      --tab)
	# open a new tab in the server
	CMD=tab
	;;
      *)
	# pass this argument to vim directly
	new_args=("${new_args[@]}" "$arg")
	;;
    esac
  done
fi

# do stuff {{{1
if $SAVE_STDIN; then
  # save stdin to a temp file (see :h --remote and :h --)
  cat > "$TMP"
  new_args=("${new_args[@]}" "$TMP")
fi

$CMD "${new_args[@]}"
