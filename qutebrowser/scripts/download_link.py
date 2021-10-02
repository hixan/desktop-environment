#!/usr/bin/env python3

import click
from pathlib import Path
import os
from subprocess import Popen, PIPE
from datetime import datetime

HOME = Path(os.environ['HOME'])
KEYFILE = HOME / 'Videos/Youtube/keys.txt'
KEYFILE_ATTEMPTS = HOME / 'Videos/Youtube/key-attempts.txt'

def check_key(key, attempt=False):
    # return true if the key has been seen before
    with (KEYFILE_ATTEMPTS if attempt else KEYFILE).open('r') as f:
        if key + '\n' in f.readlines():
            return True
    return False

def save_key(key, attempt=False):
    with (KEYFILE_ATTEMPTS if attempt else KEYFILE).open('a') as f:
        print(key, file=f)

@click.command()
@click.argument('url', type=click.STRING, envvar='QUTE_URL')
def main(url):
    # create keyfiles if they dont exist
    for f in [KEYFILE, KEYFILE_ATTEMPTS]:
        if f.exists() and not f.is_file():
            raise ValueError(f'file {f} should be a regular file but is not.')
        elif not f.exists():
            f.touch()

    if 'youtube' in url and 'watch' in url:
        # get watch key
        *_, key = url.split('=')
        save_key(key, True)  # save as attempt
        if check_key(key):  # skip if has been downloaded
            raise ValueError(f'key {key} has already been downloaded')
        now = datetime.now().strftime('%Y-%m-%d-%H-%I')
        process = Popen([
            'youtube-dl', url, '-o',
            f'~/Videos/Youtube/{now} - %(uploader)s - %(title)s.%(ext)s'
        ])
        process.communicate()
        if process.returncode != 0:
            exit(process.returncode)  # raise the exception and exit
        save_key(key)
    else:
        raise ValueError(f'invalid youtube link - got {url}')

if __name__ == '__main__':
    main()
