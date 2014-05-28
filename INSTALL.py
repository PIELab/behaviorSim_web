
from subprocess import call

call('git submodule init')
call('git submodule update')
call('touch ./py/lib/bottle/__init__.py')

