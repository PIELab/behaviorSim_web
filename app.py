__author__ = '7yl4r'

import os

from py.lib.bottle.bottle import template, Bottle, request, abort, static_file, redirect

from py.SimManager import SimManager

#=====================================#
#            globals                  #
#=====================================#
app = Bottle()
sim_manager = SimManager()
DOMAIN = 'localhost'  # domain name
# temporary (to be replaced by db later) TODO: replace with db
CONTEXTS = ['GPS position', 'ambient noise level', 'avatar influence']
CONSTRUCTS = ['physical activity self efficacy']
BEHAVIORS = ['step count', 'caloric intake']

#=====================================#
#            Static Routing           #
#=====================================#
@app.route('/css/<filename:path>')
def css_static(filename):
    return static_file(filename, root='./css/')

@app.route('/js/<filename:path>')
def js_static(filename):
    return static_file(filename, root='./js/')
    
@app.route('/img/<filename:path>')
def js_static(filename):
    return static_file(filename, root='./img/')
    

#=====================================#
#               Pages                 #
#=====================================#
@app.route("/")
def makeSplash():
    return template('tpl/pages/getting_started', simManager=sim_manager)

@app.route("/think")
def makeThink():
    return template('tpl/pages/think', simManager=sim_manager)

@app.route("/think/CSMB")
def makeCSMB():
    return template('tpl/pages/think/csmb', simManager=sim_manager, contexts=CONTEXTS, constructs=CONSTRUCTS, behaviors=BEHAVIORS)

@app.route("/draw")
def makeDraw():
	return template('tpl/pages/draw', simManager=sim_manager)

@app.route("/specify")
def makeSpec():
	return template('tpl/pages/specify', simManager=sim_manager)

#=====================================#
#           data recievers            #
#=====================================#
@app.post('/think/submit')
def recieveVarList():
    ctx= request.forms.get('contexts')
    ctr = request.forms.get('constructs')
    bvr = request.forms.get('behaviors')
    sim_manager.addMeasures(ctx, ctr, bvr)
    print 'measurement vars added to model:',ctx,'; ',ctr,'; ',bvr,'\n'
    redirect( '/draw' )


#=====================================#
#      websockets (currently unused)  #
#=====================================#
@app.route('/websocket')
def handle_websocket():
    wsock = request.environ.get('wsgi.websocket')
    if not wsock:
        abort(400, 'Expected WebSocket request.')

    while True:
        try:
            message = wsock.receive()
            print "received : "+str(message)
            sim_manager.parseMessage(message, wsock)

        except WebSocketError:
            break


#=====================================#
#          WEB SERVER START           #
#=====================================#
if __name__ == "__main__":

    from gevent.pywsgi import WSGIServer
    from geventwebsocket.handler import WebSocketHandler
    from geventwebsocket import WebSocketError

    port = int(os.environ.get("PORT", 8080))
    server = WSGIServer(("0.0.0.0", port), app,
                        handler_class=WebSocketHandler)
    print 'starting server on '+str(port)
    server.serve_forever()
    # ^that^ == app.run(host='0.0.0.0', port=port)
