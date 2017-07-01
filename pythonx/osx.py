"""Old code that wasw used on OS X."""

import os.path
import subprocess
import threading
import time

import vim  # pylint: disable=import-error


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
