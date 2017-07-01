'''
init.py file by luc.  This file should be loaded from init.vim with :pyfile.
'''

from __future__ import print_function

# import random.randint
import os
import re
import subprocess
import threading
import time
import timeit
import vim
# import sys

# importing private modules
import lib
import lib.compilercollection
import lib.fs
import lib.git
import lib.ssh
import lib.tex

# some wrapper functions to be called from vim


def find_base_dir_vim_wrapper(cur=None):
    if cur is None:
        cur = vim.current.buffer.name
    return lib.fs.find_base_dir(cur)


def open_pdf_vim_wrapper():
    threading.Thread(target=open_pdf_or_preview_app).start()


def tex_count_vim_wrapper(filename=None, wait=False):
    if filename is None:
        filename = vim.current.buffer.name
    width = vim.current.window.width - 1
    for data in lib.tex.count(filename, wait):
        if 'pages' in data:
            print(('%(pages)s pages, %(words)s words and %(chars)s chars '
                   'in %(file)s.'
                   % data)[:width])
        else:
            print(('%(lines)s lines, %(words)s words and %(chars)s chars '
                   'in %(file)s.'
                   % data)[:width])


def compile():
    '''Compile the current file.'''
    cls = lib.compilercollection.find_compiler(vim.current.buffer.name)
    compiler = cls(vim.current.buffer.name)
    threading.Thread(target=compiler.run).start()


def backup_current_buffer():
    '''Save a backup of the current vim buffer via scp.'''
    filename = vim.current.buffer.name
    servers = {'math': 'vim-buffer-bk', 'ifi': 'vim-buffer-bk'}
    mytime = time.strftime('%Y/%m/%d/%H/%M')
    for server in servers.keys():
        path = os.path.join(servers[server], mytime)
        threading.Thread(target=lib.ssh.background_scp,
                         args=([filename], server, path, True, True)).start()


def open_pdf_or_preview_app(check=False, filename=None, go_back=True):
    '''Check if a pdf file is open in Preview.app and bring it to
    the foreground.

    :go_back: is used to return to vim or not.
    :filename:
    '''
    preview = ['open', '-a', 'Preview']
    lsof = ['lsof']
    # mupdf_signal = ['killall', '-HUB', 'mupdf']
    # mupdf = ['mupdf']
    # let l:command = 'killall -HUP mupdf || mupdf ' . l:file . ' &'

    if filename is None:
        filename = vim.current.buffer.name

    pdf = os.path.splitext(filename)[0] + '.pdf'
    print(filename)
    print(pdf)

    if check:
        lsof.append(pdf)
        try:
            # " collect the output from 'lsof'
            # let l:result = system('lsof ' . l:file)
            # " parse the output (FIXME system specific)
            # let l:result = match(get(split(l:result,'\n'),1,''),'^Preview')
            # " if the file was not opend, do so, else only switch the
            # " application
            # if v:shell_error || l:result == -1
            out = subprocess.check_output(lsof)
            out = str(out).splitlines()[1]
        except:
            out = ''
        if 'Preview' not in out:
            preview.append(pdf)
        subprocess.call(preview)
    else:
        subprocess.call(preview)

    if go_back:
        time.sleep(0.5)
        vim.eval('foreground()')


def activate_preview():
    threading.Thread(target=subprocess.call,
                     args=(['open', '-a', 'Preview'])).start()


def osx_version():
    return subprocess.check_output(['defaults', 'read', 'loginwindow',
                                    'SystemVersionStampAsString'])
    # if split(version, '.')[1] == '9'


def check_for_english_babel():
    ''' Check if the given buffer has a line matching
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


def time_cmd(cmd1, cmd2, count=10):
    """Compare the execution time of two vim commands.

    :cmd1: a vim command as a string, will be passed to vim.command
    :cmd2: like cmd1
    :count: the number of times the commands will be executed
    :returns: None

    """
    length = max(len(cmd1), len(cmd2))
    fmt = '%%-%ds %%s' % (length + 2)
    print('Running', count, 'repetitions of ...')
    print(fmt % (cmd1, '->'), end=' ')
    t1 = timeit.timeit(
        'vim.command("""silent '+cmd1+'""")',
        setup='import vim',
        number=count)
    print(t1)
    print(fmt % (cmd2, '->'), end=' ')
    t2 = timeit.timeit(
        'vim.command("""silent '+cmd2+'""")',
        setup='import vim',
        number=count)
    print(t2)


def time_expr(expr1, expr2, count=10):
    """Compare the evaluation time of two vim expressions.

    :expr1: a vim expression as a string, will be passed to vim.eval
    :expr2: like expr2
    :count: the number of times the commands will be executed
    :returns: None

    """
    length = max(len(expr1), len(expr2))
    fmt = '%%-%ds %%s' % (length + 2)
    print('Evaluationg', count, 'repetitions of ...')
    print(fmt % (expr1, '->'), end=' ')
    t1 = timeit.timeit(
        'vim.eval("""'+expr1+'""")',
        setup='import vim',
        number=count)
    print(t1)
    print(fmt % (expr2, '->'), end=' ')
    t2 = timeit.timeit(
        'vim.eval("""'+expr2+'""")',
        setup='import vim',
        number=count)
    print(t2)
    pass
