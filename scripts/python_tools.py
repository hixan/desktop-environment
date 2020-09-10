from subprocess import Popen, PIPE
from pathlib import Path
import os

DIR = Path(os.getenv('HOME'))/'.config'/'desktop-environment'
METADIR = DIR/'meta'
SCRIPTSDIR = DIR / 'scripts'

def get_field(response: Popen, cut: int=-1, skiplines: int=0):
    return response.stdout.readlines()[skiplines].decode('utf-8').strip().split()[cut]

def get_active_window():
    return get_field(Popen(['xprop', '-root', '_NET_ACTIVE_WINDOW'], stdout=PIPE))

def get_active_pid():
    wid = get_active_window()
    return str(int(get_field(Popen(['xprop', '-id', wid, '_NET_WM_PID'], stdout=PIPE))) + 1)

def float_window(window_process):
    wid = get_windowid(window_process.pid, rint=True)
    i3msg(f'[id="{wid}"] floating enable')

def scratch_window(window_process):
    wid = get_windowid(window_process.pid, rint=True)
    i3msg(f'[id="{wid}"] move scratchpad')

def move_window(window_process, pos=None, w=None, h=None):
    wid = get_windowid(window_process.pid, rint=True)
    start = f'[id="{wid}"]'
    if w is not None:
        i3msg(f'{start} resize set width {w}')
    if h is not None:
        i3msg(f'{start} resize set height {h}')
    if pos is not None:
        i3msg(f'{start} move position {pos[0]} {pos[1]}')

def i3msg(cmd):
    Popen(['i3-msg', cmd])


def print_output(pcs: Popen):
    print(pcs.stdout.read())
    return pcs
    
def get_tty(pid: str):
    print(pid)
    if (rv := get_field(Popen(['ps', '-q', pid, 'axo', 'tty'], stdout=PIPE), skiplines=1)) == '?':
        return False
    return rv

def get_active_wd():
    pid = get_active_pid()
    symlink = Path('/proc/') / pid / 'cwd' 
    if symlink.exists():
        return get_field(Popen(['readlink', str(symlink)], stdout=PIPE))
    raise RuntimeError('Could not retrieve active workspace')

def is_python_file(file: Path):
    assert file.exists(), f'file "{file.absolute()}" does not exist'
    if file.suffix == '.py':
        return True
    # check for hashbang
    if (hb := file.open('r').readline())[0:2] == '#!':
        return 'python' in hb


class PidUniqueChecker:

    def __init__(self, name: str, metadir: Path=METADIR, keep_old=True):
        self.pidfile : Path = metadir / name
        self.pid = int(os.getpid())
        self.keep_old = bool(keep_old)

    def ensure_unique(self, error=True):
        # if the file does not exist assume this process is not running.
        if not self.pidfile.exists():
            return True
        # read saved pid (if exists)
        with self.pidfile.open('r') as f:
            observed = int(f.read())
            if observed != self.pid:
                assert not error, f'Program {self.pidfile.name} already running!'
                return False

    def force_start(self):
        '''forces this instance to be the primary instance. Should only be used once!'''
        self.pidfile.unlink()
        self.start_program()

    def release(self):
        self.pidfile.unlink()

    def start_program(self, error=True):
        if self.keep_old:
            self.ensure_unique(error=error)
        self.pidfile.parent.mkdir(parents=True, exist_ok=True)
        with self.pidfile.open('w') as f:
            f.write(str(self.pid))


def get_windowid(pid, rint=False):
    wid = int(Popen(['xdotool', 'search', f'--pid={pid}'], stdout=PIPE).stdout.readline())
    if rint:
        return wid
    wid_hex = f'0x{wid:07X}'
    return wid_hex


if __name__ == '__main__':
    print(get_active_pid())
    print(get_active_wd())
    print(get_tty(get_active_pid()))

