class Event
    ###
    Event class for triggering and listening to various events to improve code modularity.

    ## Overview example:

    ```js
    var myEvent = new Event;
    myEvent.listen("alert('myEvent triggered!')");  // adds a function to the trigger
    myEvent.listen("alert('first time!')", 1);  // only fires 1 time

    myEvent.trigger();  // triggers the event, launching all listening functions
    ```
    ###
    constructor: ->
        @actions = []
        @count = 0  # number of times event has been triggered

    add_action: (action_function, times='inf') ->
        ###
        adds a listener to be launched on next trigger
        :param funct_str: javascript string to be executed
        :param times: number of times the function should fire
            assumed >1, default=infinite
        ###
        @actions.push({action:action_function, times:times})
        return

    trigger: () ->
        ###
        fires the event, launching all listeners
        ###
        for act in @actions
            if @count > act.times || act.times == 'inf'
                act.action()

            # TODO: if number of times run out, delete from functions list
        return

try
    window.Event = Event
catch error
    module.exports = Event