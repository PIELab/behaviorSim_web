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
#           dynamic js files          #
#=====================================#
@app.route("/tpl/js/<filename>")
def getDynamicJS(filename):
    # check for user login token in cookies
    return template('tpl/js/'+filename, simManager=sim_manager, CONFIG=CONFIG)


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
def make_spec():
    try:
        selected_node = sim_manager.getNextNode()
        if selected_node is None:
            redirect('/done_with_specifying')  # TODO: make this go somewhere meaningful
        else:
            return template('tpl/pages/specify', CONFIG=CONFIG, simManager=sim_manager, selected_node=selected_node)
    except ValueError as err:
        return template('tpl/pages/notReady', CONFIG=CONFIG, simManager=sim_manager, details_message=err.message)

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
#           data receivers            #
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
def receive_dsl():
    dsl = request.forms.get('DSL')
    sim_manager.updateDSL(dsl)
    print 'new DSL received: ', dsl
    print dsl.split('\n')

    return 'DSL received.'

@app.post('/node_spec/submit')
def receive_node_spec():
    node_type = request.forms.get('type')
    model_type = request.forms.get('model')
    options = request.forms.get('options')
    sim_manager.specify_node(node_type, model_type, options)
    print 'spec for node "'+sim_manager.selected_node.name+'" recieved.'


#=====================================#
#            test pages               #
#=====================================#
@app.route('/admin/tests')
@app.route('/admin/tests/')
def test_display():
    #shows a list of tests and links
    test_pages = {
        'diagramophone demo page': '/js/lib/diagramophone/index.html',
        'sim_manager debugger': '/admin/tests/sim_manager_touch',
        'mock specify page': '/admin/tests/mock_specify_page',
        'mock med/mod draw page': '/admin/tests/mock_mediator_moderator',
        'mock specify construct': '/admin/tests/mock_specify_construct'
    }

    html = '<body>\n<h1>Choose a test:</h1>\n<h3>\n<ul>'
    for key in test_pages:
        html += '<li><a href="'+test_pages[key]+'">'+key+'</a></li>'
    html += '</ul></h3>\n</body>'
    return html

@app.route('/admin/tests/selenium')
def show_selenium_all_tests_test_suite():
    return static_file('_all_tests_test_suite', root='./selenium/seleniumIDE_tests/')

@app.route('/admin/tests/mock_mediator_moderator')
def draw_page_test():
    dsl = '''ctx2 -> constr2
            ctx2 -> constr3
            constr2 -> constr3
            pers1 -> constr2
            pers2 -> constr3'''
    sim_manager.updateDSL(dsl)
    return template('tpl/pages/draw/mediatorModerator', CONFIG=CONFIG, simManager=sim_manager)


@app.route('/admin/tests/sim_manager_touch')
def sim_manager_test():
    return '<textarea style="width:800px" rows=20>'+repr(sim_manager)+'</textarea>';

@app.route('/admin/tests/mock_specify_page')
def specify_page_test():
    # set up fake model if needed
    if not sim_manager.connectionsMade:
        dsl = '''ctx2 -> constr2
                ctx2 -> constr3
                constr2 -> constr3
                pers1 -> constr2
                pers2 -> constr3'''
        sim_manager.updateDSL(dsl)

    selected_node = sim_manager.getNextNode()
    if selected_node is None:
        redirect('/done_with_specifying')  # TODO: make this go somewhere meaningful

    return template('tpl/pages/specify', CONFIG=CONFIG, simManager=sim_manager, selected_node=selected_node)

@app.route('/admin/tests/mock_specify_construct')
def specify_construct_page():
    # set up fake model
    dsl = '''ctx1 -> constr
            p1 -> constr'''
    sim_manager.updateDSL(dsl)

    # spec ctx1 and p1
    sim_manager.getNextNode()
    sim_manager.specify_node('context', 'i dunno i dunno', 'i dunno here neither')
    sim_manager.getNextNode()
    sim_manager.specify_node('personality', 'constant', '5 or something')

    selected_node = sim_manager.getNextNode()
    return template('tpl/pages/specify', CONFIG=CONFIG, simManager=sim_manager, selected_node=selected_node)



#=====================================#
#          WEB SERVER START           #
#=====================================#
if __name__ == "__main__":

    port = int(os.environ.get("PORT", 8000))

    print 'starting server on '+str(port)
    app.run(host='0.0.0.0', port=port)
