'''
vimrc.py file by luc.  This file should be loaded from vimrc with :pyfile.
'''

#import random.randint
import bisect
import os
import subprocess
import threading
import time
import vim
import sys
import webbrowser

# importing private modules
sys.path.append(os.path.expanduser('~/src/shell/python'))
import compilercollection
import fs
import git
import ssh
import strings
import tex

# some wrapper functions to be called from vim

def autogit_vim(branches=['autocmd', 'autogit']):
    '''Wrapper around git.autogit() to be called from vim.'''
    directory = os.path.dirname(vim.current.buffer.name)
    threading.Thread(target=git.autogit, args=(directory, branches)).start()
    return 0 # bad practice but needed for vim's pyeval()


def find_base_dir_vim_wrapper(cur=None):
    if cur is None:
        cur = vim.current.buffer.name
    return fs.find_base_dir(cur)


def open_pdf_vim_wrapper():
    threading.Thread(target=open_pdf_or_preview_app).start()


def tex_count_vim_wrapper(filename=None):
    if filename is None:
        filename = vim.current.buffer.name
    width = vim.current.window.width - 1
    for text in tex.count(filename):
        print text[0:width]


pass
# functions which depend on the vim module directly

def backup_current_buffer():
    '''Save a backup of the current vim buffer via scp.'''
    filename = vim.current.buffer.name
    servers = {'math': 'vim-buffer-bk', 'ifi': 'vim-buffer-bk'}
    mytime = time.strftime('%Y/%m/%d/%H/%M')
    for server in servers.keys():
        path = os.path.join(servers[server], mytime)
        threading.Thread(target=ssh.background_scp, args=([filename], server,
                path, True, True)).start()


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


pass
# independent functions

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


def activate_preview():
    treading.Thread(target=subprocess.call,
            args=(['open', '-a', 'Preview'])).start()
    #let version = system('defaults read loginwindow SystemVersionStampAsString')
    #if split(version, '.')[1] == '9'
