class Event
    ###
    Event class for triggering and listening to various events to improve code modularity.

    ## Overview example:

    ```js
    var myEvent = new Event;
    myEvent.listen(alert, ['myEvent triggered!']);  // adds a function to the trigger
    myEvent.listen(alert, ['first time!'], 1);  // only fires 1 time

    myEvent.trigger();  // triggers the event, launching all listening functions
    ```
    ###
    constructor: ->
        @functions = []
        @count = 0  # number of times event has been triggered
        
    listen: (funct, args, times='inf') ->
        ###
        adds a listener to be launched on next trigger
        :param function: function to be launched
        :param args: argument list to pass to function
        :param times: number of times the function should fire 
            assumed >1, default=infinite
        ###
        @functions.push({fun:funct, args:args, times=times})
        
    trigger: () ->
        ###
        fires the event, launching all listeners
        ###
        for func in @functions
            if @count > func.times || func.times == 'inf'
                func.fun(func.args)
                
            # TODO: if number of times run out, delete from functions list