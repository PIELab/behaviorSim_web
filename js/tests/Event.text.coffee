Event = require '../Event'

exports.EventTest =

    'test basic event listener trigger': (test) ->
        event = new Event

        throw_something = () ->
            throw Error('this is not actually an error')

        event.add_action(throw_something)

        test.throws(event.trigger, Error, 'the trigger should cause an error to be thrown')

        test.done()
