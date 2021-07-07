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
    #for line in vim.current.buffer:
    #    if line.startswith(r'\usepackage[') and line.endswith(']{babel}'):
    #        # langs = line.strip(r'\usepackage{babel}')[1:-1].split(',')
    #        langs = line.strip(r'\usepackg{bl}')[1:-1].split(',')
    #        if len(langs) == 1:
    #            return langs[0] == 'english'
    #        else:
    #            for lang in langs:
    #                if lang.startswith('main='):
    #                    return lang == 'main=english'
    #            return langs[-1] == 'english'
    #return False


def find_babel_languages():
    '''Return a list of babel languges for the current file.'''
    for line in vim.current.buffer:
        if line.startswith(r'\usepackage['):
            match = re.match(r'^\\usepackage\[(.*)\]{babel}$', line)
            if match:
                return match.group(1).split(',')
    return []
