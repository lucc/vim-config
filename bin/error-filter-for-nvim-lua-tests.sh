#!/bin/sh

# This file can filter the error messages from the neovim makefile in order to
# pass them to nvim for the quickfix feature.

path=~/.cache/nvim/makelogs
mkdir -p "$path"
i=$(ls "$path"/make.log.* 2>/dev/null | wc -l)
((i++))
tee "$path/make.log.$i" | sed -n '/Failure/{n;n;p;q;}'
