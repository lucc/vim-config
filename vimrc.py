'''
vimrc.py file by luc.  This file should be loaded from vimrc with :pyfile.
'''

import os
#import random.randint
import vim
import subprocess
import time
import threading


def backup_current_buffer():
    """Save a backup of the current vim buffer via scp."""

    servers = {'math': 'vim-buffer-bk', 'ifi': 'vim-buffer-bk'}
    filename = vim.current.buffer.name
    mytime = time.strftime('%Y-%m-%d-%H-%M')

    def helper_function(server, filename, path):
        subprocess.call(['ssh', server, 'mkdir', '-p', path])
        subprocess.call(['scp', filename, server+':'+path])

    for server in servers.keys():
        path = os.path.join(servers[server], mytime)
        threading.Thread(target=helper_function,
                args=(server, filename, path)).start()


def find_base_dir_vim_wrapper(cur=None):
    if cur is None:
        cur = vim.current.buffer.name
    return find_base_dir(cur)

def find_base_dir(filename):
    '''
    Find a good "base" directory under some file.  Look for makefiles and vsc
    repositories and the like.

    filename: the filename to be used as a starting point
    returns:  the absolute path to the best base directory
    '''
    indicator_files = [
                       'makefile',
                       'build.xml',
                       ]
    indicator_dirs = [
                      '~/uni',
                      '~/.vim',
		      ]
    indicator_dirs = [os.path.expanduser(x) for x in indicator_dirs]
    matches = []
    # look at directory of the current buffer and the working directory
    for cur in [os.path.dirname(filename), os.path.realpath(os.path.curdir)]:
        path = cur
        stopper = False
        while stopper != '':
            for indicator in indicator_files:
                if os.path.exists(os.path.join(path, indicator)):
                    matches.append((path, indicator))
            for directory in indicator_dirs:
                if path == directory:
                    matches.append((path, ''))
            path, stopper = os.path.split(path)
    # fallback value
    if matches == []:
        matches.append(('/', ''))
    #if len(matches) == 1
    #  return matches[0][0]
    #endif
    # TODO not optimal yet
    return matches[0][0]

def search_for_uri_vim_wrapper(pos=None):
    if pos is None:
        pos = vim.current.window.cursor
    return search_for_uri(pos)

def search_for_uri(pos):
    """Search for an uri around pos in the current buffer

    :pos: the position in the current buffer in vim
    :returns: the uri or Null

    """
    pass

def tex_count_vim_wrapper(filename=None):
    if filename is None:
        filename = vim.current.buffer.name
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


##############################################################################
# Code taken from other people
##############################################################################

"""parseUrls.py  A regular expression that detects HTTP urls.

Danny Yoo (dyoo@hkn.eecs.berkeley.edu)

This is only a small sample of tchrist's very nice tutorial on
regular expressions.  See:

    http://www.perl.com/doc/FMTEYEWTK/regexps.html

for more details.

Note: this properly detects strings like "http://python.org.", with a
period at the end of the string."""


import re

def grabUrls(text):
    """Given a text string, returns all the urls we can find in it."""
    return url_re.findall(text)


urls = '(?: %s)' % '|'.join("""http telnet gopher file wais ftp""".split())
ltrs = r'\w'
gunk = r'/#~:.?+=&%@!\-'
punc = r'.:?\-'
any = "%(ltrs)s%(gunk)s%(punc)s" % { 'ltrs' : ltrs,
                                     'gunk' : gunk,
                                     'punc' : punc }

url = r"""
    \b                            # start at word boundary
        %(urls)s    :             # need resource and a colon
        [%(any)s]  +?             # followed by one or more
                                  #  of any valid character, but
                                  #  be conservative and take only
                                  #  what you need to....
    (?=                           # look-ahead non-consumptive assertion
            [%(punc)s]*           # either 0 or more punctuation
            (?:   [^%(any)s]      #  followed by a non-url char
                |                 #   or end of the string
                  $
            )
    )
    """ % {'urls' : urls,
           'any' : any,
           'punc' : punc }

url_re = re.compile(url, re.VERBOSE | re.MULTILINE)


