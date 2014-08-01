__author__ = '7yl4r'

import os

from py.lib.bottle.bottle import template, Bottle, request, abort, static_file, redirect

from py.SimManager import SimManager, TIME_SCALES
from py.config import Config

#=====================================#
#            globals                  #
#=====================================#
app = Bottle()
sim_manager = SimManager()
DOMAIN = 'localhost'  # domain name
CONFIG = Config()
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
    return template('tpl/pages/getting_started', simManager=sim_manager, CONFIG=CONFIG)

@app.route("/think")
def makeThink():
    return template('tpl/pages/think/think', CONFIG=CONFIG, simManager=sim_manager, time_scales=TIME_SCALES)

@app.route("/think/CSMB")
def makeCSMB():
    return template('tpl/pages/think/csmb', CONFIG=CONFIG, simManager=sim_manager, contexts=CONTEXTS, constructs=CONSTRUCTS, behaviors=BEHAVIORS)

@app.route("/draw")
def makeDraw():
	return template('tpl/pages/draw/draw', CONFIG=CONFIG, simManager=sim_manager)

@app.route("/draw/infoFlow")
def makeInfoFLow():
	return template('tpl/pages/draw/infoFlow', CONFIG=CONFIG, simManager=sim_manager)

@app.route("/draw/mediatorModerator")
def makeMedMod():
    return template('tpl/pages/draw/mediatorModerator', CONFIG=CONFIG, simManager=sim_manager)

@app.route("/specify")
def makeSpec():
	return template('tpl/pages/specify', CONFIG=CONFIG, simManager=sim_manager)

@app.route('/tutorial')
@app.route('/tutorial/')
@app.route("/tutorial/<page>" )
def makeTutorial(page=None):
    if page == '1' or page is None:
        return template('tpl/pages/tutorial', CONFIG=CONFIG, simManager=sim_manager)
    elif page == '2':
        return template('tpl/pages/tutorial_2', CONFIG=CONFIG, simManager=sim_manager)
    elif page == '3':
        return template('tpl/pages/tutorial_3', CONFIG=CONFIG, simManager=sim_manager)
    else:
        raise NotImplementedError('unknown tutorial page request for pg #'+str(page))

#=====================================#
#           data recievers            #
#=====================================#
@app.post('/think/submit')
def recieveVarList():
    ctx= request.forms.get('contexts').split(',')
    ctr = request.forms.get('constructs').split(',')
    bvr = request.forms.get('behaviors').split(',')
    sim_manager.addMeasures(ctx, ctr, bvr)
    print 'measurement vars added to model:',ctx,'; ',ctr,'; ',bvr,'\n'
    redirect( '/draw' )

@app.post('/draw/submit')
def recieveDSL():
    DSL= request.forms.get('DSL')
    sim_manager.updateDSL(DSL)
    print 'new DSL recieved.'
    return 'DSL recieved.'

#=====================================#
#            test pages               #
#=====================================#
@app.route('/admin/tests')
def testDisplay():
    #shows a list of tests and links
    testPages = {
        'diagramophone demo page': '/js/lib/diagramophone/index.html',
        'sim_manager debugger': '/admin/tests/sim_manager_touch'
    }

    html = '<body>\n<h1>Choose a test:</h1>\n<h3>\n'
    for key in testPages:
        html += '* <a href="'+testPages[key]+'">'+key+'</a>\n<br>\n'
    html += '</h3>\n</body>'
    return html

@app.route('/admin/tests/sim_manager_touch')
def sim_manager_test():
    return '<textarea style="width:800px" rows=20>'+repr(sim_manager)+'</textarea>';


#=====================================#
#          WEB SERVER START           #
#=====================================#
if __name__ == "__main__":

    port = int(os.environ.get("PORT", 8000))

    print 'starting server on '+str(port)
    app.run(host='0.0.0.0', port=port)
