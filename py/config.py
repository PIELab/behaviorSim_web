__author__ = '7yl4r'

### default values for config (also accessible via config.WHATEVERRR ###
DEBUG = True  # if this is true, pages might make up things in order to run themselves where they would otherwise fail.
CHOSEN_CSS_URL = '/css/chosen/chosen.css'  # url to retrieve chosen's css
    # '//cdnjs.cloudflare.com/ajax/libs/chosen/1.1.0/chosen.min.css'
CHOSEN_JS_URL  = '/js/lib/chosen.jquery.min.js' # url to retrieve chosen's js. (useful for switching between forks)
    # //cdnjs.cloudflare.com/ajax/libs/chosen/1.1.0/chosen.jquery.min.js'

class Config(object):
    '''
    class for creating configs and using the global var values
    '''
    def __init__(self, debug=DEBUG, chosen_css_url=CHOSEN_CSS_URL, chosen_js_url=CHOSEN_JS_URL):
        self.DEBUG = debug
        self.CHOSEN_CSS_URL = chosen_css_url
        self.CHOSEN_JS_URL = chosen_js_url