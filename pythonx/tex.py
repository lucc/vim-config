'''Functions to do tex and latex specific jobs.'''

import os
import re
import subprocess
import threading
# from builtins import FileNotFoundError


class Cache():

    """An object to cache the information for a file."""

    def __init__(self, file):
        """

        :file: the filename of the file

        """
        if os.path.exists(file):
            self._file = file
        else:
            raise Exception()
        self.pages = None
        self._lines = None
        self.words = None
        self.chars = None
        self._ctime = 0
        self.update()

    def update(self):
        """Update all information about this file.
        :returns: None

        """
        ctime = os.stat(self._file).st_ctime
        if self._ctime < ctime:
            self._ctime = ctime
            self._update()

    def _update(self):
        """TODO: Docstring for _update.
        :returns: None

        """
        pass
        self._update_pages()
        self._update_lines()
        self._update_words()
        self._update_chars()

    def _update_pages(self):
        """Dummy implementation."""
        pass

    def _update_lines(self):
        """Dummy implementation."""
        pass

    def _update_words(self):
        """Dummy implementation."""
        pass

    def _update_chars(self):
        """Dummy implementation."""
        pass


class Tex(Cache):

    """Docstring for Tex. """

    texcount = ['texcount', '-quiet', '-nocol', '-1', '-utf8', '-incbib']

    def _update_lines(self):
        """Do not count comment lines.

        :returns: None

        """
        with open(self._file) as f:
            self.lines = f.readlines().index('\\end{document}\n')

    def _update_words(self):
        """TODO: Docstring for update_words.

        :returns: None

        """
        self.words = subprocess.check_output(
            self.texcount+[self._file]).split()[0].split(b'+')[0].decode()

    def _update_chars(self):
        """TODO: Docstring for _update_words.

        :returns: None

        """
        self.chars = subprocess.check_output(
            self.texcount+['-char', self._file]).split()[0].split(b'+')[0].decode()


class Pdf(Cache):

    """Docstring for Pdf. """

    def _update(self):
        """TODO: Docstring for update.

        :returns: TODO

        """
        self._update_pages()
        p1 = subprocess.Popen(
            ['pdftotext', self._file, '/dev/stdout'], stdout=subprocess.PIPE)
        self.words, self.chars = subprocess.check_output(
            ['wc', '-m', '-w'], stdin=p1.stdout).decode().split()

    def _update_pages(self):
        """TODO: Docstring for _update_pages.

        :returns: None

        """
        for line in subprocess.check_output(
                ['pdfinfo', self._file]).decode().splitlines():
            if line.startswith('Pages:'):
                self.pages = line.split()[-1]
                return

cache = {}


def count(filename, wait=False):
    '''Count the words and characters in a tex and its pdf file.  Returns a
    small report about the counts.'''
    root, ext = os.path.splitext(filename)
    if filename in cache:
        if wait:
            cache[filename].update()
        else:
            threading.Thread(target=cache[filename].update).start()
    else:
        if ext == '.tex':
            cache[filename] = Tex(filename)
        elif ext == '.pdf':
            cache[filename] = Pdf(filename)
    lines = cache[filename].lines
    words = cache[filename].words
    chars = cache[filename].chars
    yield {'file': filename, 'lines': lines, 'words': words, 'chars': chars}
    pdf = root + '.pdf'
    if pdf in cache:
        if wait:
            cache[pdf].update()
        else:
            threading.Thread(target=cache[pdf].update).start()
    else:
        try:
            cache[pdf] = Pdf(pdf)
        except Exception:
            return
    pages = cache[pdf].pages
    words = cache[pdf].words
    chars = cache[pdf].chars
    yield {'file': pdf, 'words': words, 'chars': chars, 'pages': pages}


def doc(word='lshort'):
    '''Call texdoc in the background.'''
    threading.Thread(target=subprocess.call, args=(['texdoc', word],)).start()


def parse_tex(filename, matchfunc, extractfunc, only_header=True,
              directory='.'):
    for result, stop in parse_tex_inner(filename, matchfunc, extractfunc,
                                        only_header, directory):
        yield result


def parse_tex_inner(filename, matchfunc, extractfunc, only_header, directory):
    """TODO: Docstring for parse_tex.

    :filename: TODO
    :function: TODO
    :returns: TODO

    """
    try:
        # TODO fiename fixing with direcotry argument
        with open(os.path.join(directory, filename)) as texfile:
            for line in texfile:
                if matchfunc(line):
                    yield extractfunc(line), False
                else:
                    match = re.match(r'^\s*\\in(clude|put){(.*)}\s*(%.*)?$',
                                     line)
                    if match:
                        newfile = match.group(2)
                        if os.path.splitext(newfile)[1] != '.tex':
                            newfile += '.tex'
                        for result, stop in parse_tex_inner(newfile, matchfunc,
                                                            extractfunc,
                                                            only_header,
                                                            directory):
                            if stop:
                                yield result, stop
                            else:
                                yield result, stop
                if only_header:
                    if line == '\\begin{document}\n':
                        yield None, True
    except IOError:
        yield None, False


def find_babels(filename, relative_dir=None):
    """Return all options given to the babel package for a given tex file.

    :filename: the name of the toplevel tex file to parse
    :relative_dir: a directory relative to which filenames should be searched
    :returns: every option as a string

    """
    def match(line):
        return line.startswith(r'\usepackage[') and line.endswith(']{babel}\n')

    def extract(line):
        return line[12:-9].split(',')

    if relative_dir is None:
        relative_dir = os.path.dirname(filename) or '.'
    for langs in parse_tex(filename, match, extract, directory=relative_dir):
        if type(langs) is str:
            yield langs
        elif type(langs) is list:
            for lang in langs:
                yield lang


def find_babel(filename, relative_dir=None):
    """Return the main language used with babel for a given top level tex file.

    :filename: the name of the toplevel tex file to parse
    :returns: the main language as a string or None

    """
    langs = [lang for lang in find_babels(filename, relative_dir)]
    if len(langs) == 0:
        return None
    for lang in langs:
        if lang.startswith('main='):
            return lang[5:]
    return langs[-1]
