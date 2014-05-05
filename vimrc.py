'''
vimrc.py file by luc.  This file should be loaded from vimrc with :pyfile.
'''

import os
#import random.randint
import vim
import subprocess
import time
import threading
import bisect


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


def find_base_dir(filename,
        indicator_files=('makefile', 'build.xml'),
        indicator_dirs=('~/uni', '~/.vim')):
    '''
    Find a good "base" directory under some file.  Look for makefiles and vsc
    repositories and the like.

    filename: the filename to be used as a starting point
    returns:  the absolute path to the best base directory
    '''
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


def search_uri_vim():
    'Search for uri in the current line in vim.'
    return search_string_for_uri(vim.current.line)


def search_string_for_uri(string):
    '''Search string for an URI.  Return the URI if found, else return NONE'''
    # thanks to  http://vim.wikia.com/wiki/VimTip306
    match = re.search(r'[a-z]+://[^ >,;:]+', string)
    # alternatives:
    # r'\(http://\|www\.\)[^ ,;\t]*'
    # r'[a-z]*:\/\/[^ >,;:]*'
    if match:
        return match.group(0)
    return ''


def string_map_generator(generator):
    '''A generator to yield a string for every item in another generator.
    This is just a helper to check efficiently.'''
    for item in generator:
        yield str(item)


def man_page_topics_for_completion(arg_lead, cmd_line, cursor_position):
    paths = subprocess.check_output(['man', '-w']).decode().strip().split(':')
    all = []
    for path in paths:
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in filenames:
                #remove some suffixes
                norm = filename.split('.')
                if norm[-1] == 'gz':
                    norm = norm[:-1]
                if norm[-1] in '0123456789' or norm[-1] in ['3pm']:
                    norm = norm[:-1]
                bisect.insort_right(all, '.'.join(norm))
    # TODO: only return unique paths
    return all


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


def compile_generic(target):
    filetype = vim.eval('&filetype')
    if 'compile_' + filetype in dir():
        compiler = eval('compile_' + filetype)
    else:
        raise KeyError
    compiler(target, filetype, vim.current.buffer.name)
    base = find_base_dir(vim.current.buffer.name)

    pass


#def compile_generic_2(target):
#    # TODO
#    '''Try to build the current file automatically.  If target is not
#    specified and there is a compiler function available in g:luc.compiler it
#    will be used to find out how to compile the current file.  If a:target is
#    specified or there is no compiler function a makefile will be searched.'''
#
#    # local variables
#    functionname = ''
#    path = os.path.dirname(vim.current.buffer.name)
#    #path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
#    dir = ''
#    filetype = vim.eval('&filetype')
#    #error = 0
#
#    # type check
#    if type(target) != str:
#        raise TypeError
#
#    # look at g:luc.compiler to find a function for &filetype
#    if has_key(g:luc.compiler, &filetype)
#    let functionname = &filetype
#    let argument = expand('%:t') " file of this buffer
#    let dir = expand('%:h') " directory of this buffer
#    endif
#
#    # if a target was specified override the filetype compiler or if no filetype
#    # compiler was found, use ant or make
#    if a:target != '' || functionname == ''
#    let functionname = ''
#    let argument = ''
#    let dir = ''
#    # try to find a makefile and set dir and functionname
#    while ! empty(path)
#      let dir = '/' . join(path, '/')
#      if filereadable(dir . '/makefile') || filereadable(dir . '/Makefile')
#        let functionname = 'make'
#        let argument = a:target
#        let path = []
#      elseif filereadable(dir . '/build.xml')
#        let functionname = 'ant'
#        let argument = a:target
#        let path = []
#      else
#        unlet path[-1]
#      endif
#    endwhile
#    endif
#
#    # if no filetype function or makefile was found return with an error
#    if functionname == ''
#    echoerr 'Not able to compile anything. (2)'
#    let error = 1
#    # else execute the command in the proper directory
#    else
#    execute 'cd' dir
#    execute 'let cmd = g:luc.compiler.' . functionname . '(argument)'
#    let dir = fnamemodify(getcwd(), ':~:.')
#    let dir = dir == '' ? '~' : dir
#    echo 'Running' cmd 'in' dir
#    silent execute '!' cmd '&'
#    cd -
#    if v:shell_error
#      echoerr 'Compilation returned ' . v:shell_error . '.'
#    endif
#    let error = ! v:shell_error
#    endif
#
#    # redraw the screen to get rid of unneded "press enter" prompts
#    redraw
#
#    # return shell errors
#    return error
#    pass


def compile_java(target):
    arguments = ['ant']
    if type(target) is str and target != '':
        arguments.append(target)
    return arguments


def compile_make(target):
    arguments = ['make']
    if type(target) is str and target != '':
        arguments.append(target)
    return arguments


def compile_markdown(target):
    return [
        'multimarkdown',
        '--full',
        '--smart',
        '--output='+os.path.splitext(target)[0]+'.html',
        target
        ]


def compile_tex(target):
    return ['latexmk', '-silent', target]

class Compiler():
    '''base class to compile files'''

    indicator_files = ('makefile', 'build.xml')
    indicator_dirs = ('~/uni', '~/.vim')
    filetype = None
    args = []

    def __init__(self, filetype):
        pass

    def compile(self):
        pass

    def find_base_dir():
        pass

class CompilerMarkdown(Compiler):
    def _create_args(taget):
        return [
            'multimarkdown',
            '--full',
            '--smart',
            '--output='+os.path.splitext(target)[0]+'.html',
            target
            ]
    pass
class CompilerJava(Compiler):
    pass
class CompilerTex(Compiler):
    pass
class CompilerMake(Compiler):
    pass


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


# unused
