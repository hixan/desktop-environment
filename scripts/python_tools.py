from subprocess import Popen, PIPE
from pathlib import Path
import os

DIR = Path(os.getenv('HOME'))/'.config'/'desktop-environment'
METADIR = DIR/'meta'
SCRIPTSDIR = DIR / 'scripts'

def get_field(response: Popen, cut: int=-1, skiplines: int=0):
    return response.stdout.readlines()[skiplines].decode('utf-8').strip().split()[cut]

def get_active_pid():
    wid = get_field(Popen(['xprop', '-root', '_NET_ACTIVE_WINDOW'], stdout=PIPE))
    return str(int(get_field(Popen(['xprop', '-id', wid, '_NET_WM_PID'], stdout=PIPE))) + 1)

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

    def start_program(self, error=True):
        if self.keep_old:
            self.ensure_unique(error=error)
        self.pidfile.parent.mkdir(parents=True, exist_ok=True)
        with self.pidfile.open('w') as f:
            f.write(str(self.pid))


if __name__ == '__main__':
    print(get_active_pid())
    print(get_active_wd())
    print(get_tty(get_active_pid()))

