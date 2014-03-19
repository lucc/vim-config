'''
vimrc.py file by luc.  This file should be loaded from vimrc with :pyfile.
'''

import os
#import random.randint
import vim
import subprocess

#def find_base_dir(cur=vim.current.buffer.name):
#    '''
#    Find a good "base" directory under some file.  Look for makefiles and vsc
#    repositories and the like.
#
#    cur:      the filename to be used as a starting point
#    returns:  the absolute path to the best base directory
#
#    '''
#    indicator_files = [
#                       'makefile',
#                       'build.xml',
#                       ]
#    indicator_dirs = [
#                      '~/uni',
#                      '~/.vim',
#		      ]
#    pass
#    matches = []
#    # from here on it is vim code
#    path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
#    cwd = os.getcwd()
#    # look at directory of the current buffer
#    while path is not []:
#        dir = '/' . join(path, '/')
#    for file in indicator_files
#      if filereadable(dir . '/' . file)
#        call add(matches, [dir, file])
#      endif
#    endfor
#    if dir == cwd
#      if empty(matches) || matches[-1][0] != cwd
#        call add(matches, [cwd, ''])
#      endif
#    endif
#    unlet path[-1]
#    endwhile
#    # look at the working directory
#    let path = split(cwd, '/')
#    while ! empty(path)
#    let dir = '/' . join(path, '/')
#    for file in indicator_files
#      if filereadable(dir . '/' . file)
#        call add(matches, [dir, file])
#      endif
#    endfor
#    if dir == cwd
#      if empty(matches) || matches[-1][0] != cwd
#        call add(matches, [cwd, ''])
#      endif
#    endif
#    unlet path[-1]
#    endwhile
#    # fallback value
#    if empty(matches)
#    call add(matches, ['/', ''])
#    endif
#    #if len(matches) == 1
#    #  return matches[0][0]
#    #endif
#    # not optimal jet:
#    return matches[0][0]


def search_for_uri(pos):
    """Search for an uri around pos in the current buffer

    :pos: the position in the current buffer in vim
    :returns: the uri or Null

    """
    pass


def tex_count_vim_wrapper(filename=None):
    if filename is None:
        filename=vim.current.buffer.name
    tex_count(filename)

def tex_count(filename):
    """Count the words and characters in a tex and its pdf file.  Prints a
    small report about the counts.
    """

    # fist the tex file
    texcount = ['texcount', '-quiet', '-nocol', '-1', '-utf8', '-incbib']
    charopt = '-char'

    if os.path.exists(filename):
        tex_words = subprocess.check_output(texcount+[filename])
        tex_words = tex_words.split()[0].split('+')[0]
        tex_chars = subprocess.check_output(texcount+[charopt, filename])
        tex_chars = tex_chars.split()[0].split('+')[0]
        # TODO filename in display is to long
        print tex_words, 'words and', tex_chars, 'chars in file', filename

    # second, the pdf
    # TODO more robust
    pdf = os.path.splitext(filename)[0] + '.pdf'
    #if os.path.splitext(filename)[1] != '.tex':
    #    #raise Exception()
    #    return False
    #else:
    #    pdf = os.path.splitext(filename)[0] + '.pdf'

    if os.path.exists(pdf):
        p1 = subprocess.Popen(['pdftotext', pdf, '/dev/stdout'],
                stdout=subprocess.PIPE)
        pdf_words, pdf_chars = subprocess.check_output(['wc', '-m', '-w'],
                stdin=p1.stdout).split()
        # TODO filename in display is to long
        print pdf_words, 'words and', pdf_chars, 'chars in file', pdf
