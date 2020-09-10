#!/usr/bin/env python3

from python_tools import scratch_window, move_window, float_window, PidUniqueChecker
from subprocess import Popen
import time
import os

mathfile = '/tmp/desktop_environment_mathfile.py'
posx, posy = 0,300
wx, wy = 1000, 1000
vertsplit = True

def clear_tempfile():
    with open(mathfile, 'w') as f:
        print('''import sympy as sm
x, y, z = sm.symbols('x y z')''', file=f)

def editor():
    rv = Popen([
        'urxvt', '-name', 'math', '-e', 'zsh', '-i', '-c', f'nvim -n {mathfile} -c "silent JupyterConnect" -c JupyterRunFile'])
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

print(os.getpid())

if __name__ == '__main__':

    clear_tempfile()

    # start console
    cn = console()

    # start editor
    ed = editor()
