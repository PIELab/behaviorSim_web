
from subprocess import call

call('sudo apt-get install python-gevent')

call('sudo apt-get install python-pip') 

call(['pip','install','gevent-websocket'])

call('git submodule init')
call('git submodule update')
call('touch ./py/lib/bottle/__init__.py')

