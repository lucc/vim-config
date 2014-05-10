'''
vimrc.py file by luc.  This file should be loaded from vimrc with :pyfile.
'''

#import random.randint
import bisect
import os
import re
import subprocess
import threading
import time
import vim
import webbrowser


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

def open_pdf_vim_wrapper():
    threading.Thread(target=open_pdf_or_preview_app).start()


def open_pdf_or_preview_app(check=False, filename=None, go_back=True):
    '''Check if a pdf file is open in Preview.app and bring it to
    the foreground.

    :go_back: is used to return to vim or not.
    :filename:
    '''
    preview = ['open', '-a', 'Preview']
    lsof = ['lsof']
    mupdf_signal = ['killall', '-HUB', 'mupdf']
    mupdf = ['mupdf']

    if filename == None:
        filename = vim.current.buffer.name
        filetype = vim.eval('&filetype')
    else:
        filetype = os.path.splitext(filename)[1]

    pdf = os.path.splitext(filename)[0] + '.pdf'
    print(filename)
    print(filetype)
    print(pdf)

    if check:
        out = subprocess.check_output(lsof.append(pdf))
        out = str(out).splitlines()[1]
        if 'Preview' in out:
            subprocess.call(preview)
        else:
            subprocess.call(preview.append(pdf))
    else:
        subprocess.call(preview)

    if go_back:
        time.sleep(0.5)
        vim.eval('foreground()')
    #function! luc#gui#OpenPdfOrPreview (check, file, go_back) " {{{2
    #  " function to check if a pdf file is open in Preview.app and bring it to the
    #  " foreground.  a:go_back is used to return to vim or not.  When a:file is
    #  " empty the stem of the current file is used with '.pdf' appended.
    #  "
    #  " The command to switch to the pdf program or open a pdf file.
    #  "let l:switch  = '!open -ga Preview'
    #  let l:switch  = '!open -a Preview'
    #  let l:open    = '!open -a Preview '
    #  let l:command = ''
    #  let l:msg     = ''
    #  let l:go_back = a:go_back
    #  " find a suitable filename
    #  "let l:file = expand('%') =~ '.*\.tex' ? expand('%:r') . '.pdf' : ''
    #  let l:file = &filetype == 'tex' ? expand('%:r') . '.pdf' : ''
    #  let l:file = a:file ? a:file : l:file
    #  if l:file == ''
    #    echoerr 'No suitable filename found.'
    #    return
    #  endif
    #  " find the right command to execute
    #  " this version is for mac os x wih Preview.app
    #  if 0 " don't use Preview.app on macosx
    #    if a:check
    #      " collect the output from 'lsof'
    #      let l:result = system('lsof ' . l:file)
    #      " parse the output (FIXME system specific)
    #      let l:result = match(get(split(l:result, '\n'), 1, ''), '^Preview')
    #      " if the file was not opend, do so, else only switch the application
    #      if v:shell_error || l:result == -1
    #	let l:command = l:open . l:file
    #	let l:msg = 'Opening file "' . l:file . '" ...'
    #      else
    #	let l:command = l:switch
    #	let l:msg = 'Switching to viewer ...'
    #      endif
    #    else
    #      let l:command = l:switch
    #      let l:msg = 'Switching to viewer ...'
    #      "let l:go_back = 0
    #    endif
    #  else " use mupdf instead (on all systems)
    #    let l:command = 'killall -HUP mupdf || mupdf ' . l:file . ' &'
    #    let l:msg = l:command
    #  endif
    #  " display a message and execute the command
    #  echo l:msg
    #  "silent execute l:command
    #  call system(l:command)
    #  " return to vim if desired
    #  if l:go_back
    #    " wait for the pdf-viewer to update its display
    #    sleep 1000m
    #    " bring vim to the foreground again
    #    call foreground()
    #  endif
    #endfunction


def activate_preview():
    treading.Thread(target=subprocess.call,
            args=(['open', '-a', 'Preview'])).start()
    #let version = system('defaults read loginwindow SystemVersionStampAsString')
    #if split(version, '.')[1] == '9'


def compile_generic(target):
    filetype = vim.eval('&filetype')
    if 'compile_' + filetype in globals():
        compiler = eval('compile_' + filetype)
    else:
        raise KeyError
    dirname, args = compiler(target, filetype, vim.current.buffer.name)
    base = find_base_dir(vim.current.buffer.name)
    string = ''
    for arg in args:
        string = ' '.join([string, shellquote(arg)])
    string = 'cd ' + shellquote(dirname) + ' && ' + string
    print 'Executing', ' '.join(args), 'in', dirname
    subprocess.check_call(string, shell=True, stdout=None, stderr=None)


def shellquote(s):
    '''Escape s to be used in shell command.'''
    # from http://stackoverflow.com/a/35857
    # in python3 we can also use shlex.quote()
    return "'" + s.replace("'", "'\\''") + "'"

def compile_generic_2(target):
     ## TODO
     #'''Try to build the current file automatically.  If target is not
     #specified and there is a compiler function available in g:luc.compiler it
     #will be used to find out how to compile the current file.  If a:target is
     #specified or there is no compiler function a makefile will be searched.'''
     #
     ## local variables
     #functionname = ''
     #path = os.path.dirname(vim.current.buffer.name)
     ##path = filter(split(expand('%:p:h'), '/'), 'v:val !~ "^$"')
     #dir = ''
     #filetype = vim.eval('&filetype')
     ##error = 0
     #
     ## type check
     #if type(target) != str:
     #    raise TypeError
     #
     ## look at g:luc.compiler to find a function for &filetype
     #if has_key(g:luc.compiler, &filetype)
     #let functionname = &filetype
     #let argument = expand('%:t') " file of this buffer
     #let dir = expand('%:h') " directory of this buffer
     #endif
     #
     ## if a target was specified override the filetype compiler or if no filetype
     ## compiler was found, use ant or make
     #if a:target != '' || functionname == ''
     #let functionname = ''
     #let argument = ''
     #let dir = ''
     ## try to find a makefile and set dir and functionname
     #while ! empty(path)
     #  let dir = '/' . join(path, '/')
     #  if filereadable(dir . '/makefile') || filereadable(dir . '/Makefile')
     #    let functionname = 'make'
     #    let argument = a:target
     #    let path = []
     #  elseif filereadable(dir . '/build.xml')
     #    let functionname = 'ant'
     #    let argument = a:target
     #    let path = []
     #  else
     #    unlet path[-1]
     #  endif
     #endwhile
     #endif
     #
     ## if no filetype function or makefile was found return with an error
     #if functionname == ''
     #echoerr 'Not able to compile anything. (2)'
     #let error = 1
     ## else execute the command in the proper directory
     #else
     #execute 'cd' dir
     #execute 'let cmd = g:luc.compiler.' . functionname . '(argument)'
     #let dir = fnamemodify(getcwd(), ':~:.')
     #let dir = dir == '' ? '~' : dir
     #echo 'Running' cmd 'in' dir
     #silent execute '!' cmd '&'
     #cd -
     #if v:shell_error
     #  echoerr 'Compilation returned ' . v:shell_error . '.'
     #endif
     #let error = ! v:shell_error
     #endif
     #
     ## redraw the screen to get rid of unneded "press enter" prompts
     #redraw
     #
     ## return shell errors
     #return error
     pass


def compile_java(target, filetype, filename):
    arguments = ['ant']
    if type(target) is str and target != '':
        arguments.append(target)
    return arguments


def compile_make(target, filetype, filename):
    arguments = ['make']
    if type(target) is str and target != '':
        arguments.append(target)
    return arguments


def compile_markdown(target, filetype, filename):
    return [
        'multimarkdown',
        '--full',
        '--smart',
        '--output='+os.path.splitext(target)[0]+'.html',
        target
        ]


def compile_tex(target, filetype, filename):
    return os.path.dirname(filename), ['latexmk', '-silent', os.path.basename(filename)]


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


##############################################################################
# Code taken from other people
##############################################################################

def grabUrls(text):
    '''Given a text string, returns all the urls we can find in it.

    Danny Yoo (dyoo@hkn.eecs.berkeley.edu)

    This is only a small sample of tchrist's very nice tutorial on regular
    expressions.  See http://www.perl.com/doc/FMTEYEWTK/regexps.html for more
    details.

    Note: this properly detects strings like "http://python.org.", with a
    period at the end of the string."""
    '''

    urls = '(?: %s)' % '|'.join("""http telnet gopher file wais ftp""".split())
    ltrs = r'\w'
    gunk = r'/#~:.?+=&%@!\-'
    punc = r'.:?\-'
    any = ltrs+gunk+punc

    url = r"""
        \b                    # start at word boundary
        %(urls)s    :         # need resource and a colon
        [%(any)s]  +?         # followed by one or more of any valid
                              #  character, but be conservative and take only
                              #  what you need to....
        (?=                   # look-ahead non-consumptive assertion
            [%(punc)s]*       # either 0 or more punctuation
            (?:[^%(any)s]|$)  #  followed by a non-url char or end of the
                              #  string
        )
        """ % {'urls' : urls, 'any' : any, 'punc' : punc }

    url_re = re.compile(url, re.VERBOSE | re.MULTILINE)

    return url_re.findall(text)
    # old ideas:
    # match = re.search(r'[a-z]+://[^ >,;:]+', string)
    # alternatives:
    # r'\(http://\|www\.\)[^ ,;\t]*'
    # r'[a-z]*:\/\/[^ >,;:]*'
