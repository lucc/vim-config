'''
vimrc.py file by luc.  This file should be loaded from vimrc with :pyfile.
'''

from __future__ import print_function

# import random.randint
import bisect
import os
import re
import subprocess
import threading
import time
import vim
# import sys
# import webbrowser

# importing private modules
# sys.path.append(os.path.expanduser('~/src/shell/python'))
import compilercollection
import fs
import git
import ssh
# import strings
import tex

# some wrapper functions to be called from vim


def autogit_vim(branches=['autocmd', 'autogit']):
    '''Wrapper around git.autogit() to be called from vim.'''
    directory = os.path.dirname(vim.current.buffer.name)
    threading.Thread(target=git.autogit, args=(directory, branches)).start()


def find_base_dir_vim_wrapper(cur=None):
    if cur is None:
        cur = vim.current.buffer.name
    return fs.find_base_dir(cur)


def open_pdf_vim_wrapper():
    threading.Thread(target=open_pdf_or_preview_app).start()


def tex_count_vim_wrapper(filename=None, wait=False):
    if filename is None:
        filename = vim.current.buffer.name
    width = vim.current.window.width - 1
    for data in tex.count(filename, wait):
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
    cls = compilercollection.find_compiler(vim.current.buffer.name)
    compiler = cls(vim.current.buffer.name)
    threading.Thread(target=compiler.run).start()


def backup_current_buffer():
    '''Save a backup of the current vim buffer via scp.'''
    filename = vim.current.buffer.name
    servers = {'math': 'vim-buffer-bk', 'ifi': 'vim-buffer-bk'}
    mytime = time.strftime('%Y/%m/%d/%H/%M')
    for server in servers.keys():
        path = os.path.join(servers[server], mytime)
        threading.Thread(target=ssh.background_scp,
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


if 'man_page_cache' not in dir():
    man_page_cache = []


def _generate_man_paths():
    paths = subprocess.check_output(['man', '-w']).decode().strip().split(':')
    for path in paths:
        for dirpath, dirnames, filenames in os.walk(path):
            for filename in filenames:
                # remove some suffixes
                root, ext = os.path.splitext(filename)
                if ext == '.gz':
                    root, ext = os.path.splitext(root)
                if ext in ['.1', '.2', '.3', '.4', '.5', '.6', '.7', '.8', '.9',
                           '.3pm']:
                    yield root
                # else:
                #     yield root + ext


def _fill_man_path_cache():
    for item in _generate_man_paths():
        if item not in man_page_cache:
            bisect.insort_right(man_page_cache, item)


def man_page_topics_for_completion(arg_lead, cmd_line, cursor_position):
    if man_page_cache == []:
        threading.Thread(target=_fill_man_path_cache).start()
    for item in man_page_cache:
        if item.startswith(arg_lead):
            yield item


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
    return tex.find_babel(vim.current.buffer.name) == 'english'
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
