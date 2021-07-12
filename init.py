'''
init.py file by luc.  This file should be loaded from init.vim with :pyfile.
'''

import re

import vim

# importing private modules
import lib.tex

# some wrapper functions to be called from vim


def check_for_english_babel():
    r''' Check if the given buffer has a line matching
    "\usepackage[english]{babel}".'''
    return lib.tex.find_babel(vim.current.buffer.name) == 'english'
