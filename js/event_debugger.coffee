
evts = [
    'selectNode',
    'modelComplete',
    'graphChange',
    'selectNodeChange',
    'selectNodeChange_highP',   # update model state displays
    'selectNodeChange_higherP', # update model/data
    'selectNodeChange_highestP' # update UI
]
addEvt = (name) ->
    console.log('watching', name, 'event')
    $( document ).on(
        name,
        (event) ->
            console.log( 'EVENT:', event.type )
    )

addEvt(evt) for evt in evts