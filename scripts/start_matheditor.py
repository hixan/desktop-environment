#!/usr/bin/env python3

from python_tools import scratch_window, move_window, float_window, PidUniqueChecker, DIR
from subprocess import Popen
import shutil
import time
import os

mathfile = '/tmp/desktop_environment_mathfile.py'
math_startfile = DIR / 'config' / 'math_startfile.py'
posx, posy = 0,300
wx, wy = 1000, 1000
vertsplit = True

def clear_tempfile():
    shutil.copy(math_startfile, mathfile)

def editor():
    nvim_cmds = [
            f'-n "{mathfile}"',
             '-c "silent JupyterConnect"',
             '-c JupyterRunFile',
            f'-c "nnoremap <buffer> <silent> <localleader>T :e {math_startfile}<CR>"',
            ]
    nvim_cmd = 'nvim ' + ' '.join(nvim_cmds)
    rv = Popen([
        'urxvt', '-name', 'math', '-e', 'zsh', '-i', '-c', nvim_cmd])
    time.sleep(1)
    float_window(rv)
    time.sleep(.1)
    move_window(rv, (posx, posy), wx // 2 if vertsplit else wx, wy if vertsplit else wy // 2)
    scratch_window(rv)

    return rv

def console():

    # style seems to break latex output
    rv = Popen(['jupyter-qtconsole', '--no-confirm-exit'])#, '--style=paraiso-dark'])
    time.sleep(2)
    float_window(rv)
    time.sleep(.1)
    move_window(rv,
            (wx // 2 + posx if vertsplit else posx, posy if vertsplit else wy // 2 + posy),
            wx // 2 + posx if vertsplit else wx,
            wy if vertsplit else wy // 2)
    scratch_window(rv)

    return rv

if __name__ == '__main__':

    clear_tempfile()

    # start console
    cn = console()

    # start editor
    ed = editor()
