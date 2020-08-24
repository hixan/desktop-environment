from subprocess import Popen, PIPE
from pathlib import Path

def get_field(response, cut=-1, skiplines=0):
    return response.stdout.readlines()[skiplines].decode('utf-8').strip().split()[cut]

def get_active_pid():
    wid = get_field(Popen(['xprop', '-root', '_NET_ACTIVE_WINDOW'], stdout=PIPE))
    return str(int(get_field(Popen(['xprop', '-id', wid, '_NET_WM_PID'], stdout=PIPE))) + 1)
    
def get_tty(pid):
    if (rv := get_field(Popen(['ps', '-q', pid, 'axo', 'tty'], stdout=PIPE), skiplines=1)) == '?':
        return False
    return rv

def get_active_wd():
    pid = get_active_pid()
    symlink = Path('/proc/') / pid / 'cwd' 
    if symlink.exists():
        return get_field(Popen(['readlink', str(symlink)], stdout=PIPE))
    raise RuntimeError('Could not retrieve active workspace')

if __name__ == '__main__':
    print(get_active_pid())
    print(get_active_wd())
    print(get_tty(get_active_pid()))

