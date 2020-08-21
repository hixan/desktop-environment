from subprocess import Popen, PIPE
from pathlib import Path

def get_field(response, cut=-1):
    return response.stdout.readline().decode('utf-8').strip().split()[cut]

def get_active_wd():
    wid = get_field(Popen(['xprop', '-root', '_NET_ACTIVE_WINDOW'], stdout=PIPE))
    pid = str(int(get_field(Popen(['xprop', '-id', wid, '_NET_WM_PID'], stdout=PIPE))) + 1)

    symlink = Path('/proc/') / pid / 'cwd' 
    if symlink.exists():
        return get_field(Popen(['readlink', str(symlink)], stdout=PIPE))
    raise RuntimeError('Could not retrieve active workspace')

if __name__ == '__main__':
    print(get_active_wd())

