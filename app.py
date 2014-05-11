__author__ = '7yl4r'

import os

from py.lib.bottle.bottle import template, Bottle, request, abort

from py.SimManager import SimManager

# Globals:
sim_manager = SimManager()

#=====================================#
#            globals                  #
#=====================================#
app = Bottle()
DOMAIN = 'localhost'  # domain name

#=====================================#
#           Splash Page               #
#=====================================#
@app.route("/")
def makeSplash():
    return 'this is a test'
#=====================================#
#           websockets                #
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

    port = int(os.environ.get("PORT", 80))
    server = WSGIServer(("0.0.0.0", port), app,
                        handler_class=WebSocketHandler)
    print 'starting server on '+str(port)
    server.serve_forever()
    # ^that^ == app.run(host='0.0.0.0', port=port)