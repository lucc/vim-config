'''Functions to do tex and latex specific jobs.'''

from collections.abc import Callable, Generator
from typing import TypeVar
import os
import re


T = TypeVar("T")


def parse_tex(filename: str, matchfunc: Callable[[str], bool],
              extractfunc: Callable[[str], T], only_header: bool = True,
              directory: str = '.') -> Generator[T | None, None, None]:
    """Extract data from matching lines in a tex file
    (recursive with \\include and \\input)

    :filename: the name of the file
    :matchfunc: a function to check from which line to extract data
    :extractfunc: a function to extract data from a line
    :only_header: whether to only match inside the latex header
    :direcotry: the direcotry of the file

    """
    for result, _stop in parse_tex_inner(filename, matchfunc, extractfunc,
                                         only_header, directory):
        yield result


def parse_tex_inner(filename: str, matchfunc: Callable[[str], bool],
                    extractfunc: Callable[[str], T], only_header: bool,
                    directory: str) -> Generator[
    tuple[T | None, bool], None, None]:
    """Extract data from matching lines in a tex file
    (recursive with \\include and \\input)

    :filename: the name of the file
    :matchfunc: a function to check from which line to extract data
    :extractfunc: a function to extract data from a line
    :only_header: whether to only match inside the latex header
    :direcotry: the direcotry of the file

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
                                return
                            else:
                                yield result, stop
                if only_header:
                    if line == '\\begin{document}\n':
                        yield None, True
                        return
    except IOError:
        yield None, False


def find_babels(filename: str, relative_dir: str | None = None):
    """Return all options given to the babel package for a given tex file.

    :filename: the name of the toplevel tex file to parse
    :relative_dir: a directory relative to which filenames should be searched
    :returns: every option as a string

    """
    def match(line: str):
        return line.startswith(r'\usepackage[') and line.endswith(']{babel}\n')

    def extract(line: str):
        return line[12:-9].split(',')

    if relative_dir is None:
        relative_dir = os.path.dirname(filename) or '.'
    for langs in parse_tex(filename, match, extract, directory=relative_dir):
        if type(langs) is str:
            yield langs
        elif type(langs) is list:
            for lang in langs:
                yield lang


def find_babel(filename: str, relative_dir: str | None = None):
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
