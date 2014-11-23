
evts = [
    'selectNode',
    'modelComplete',
    'graphChange',
    'graphChange_highP',
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
            console.log( '\t\t\t\t\t\t\t\t\t\t\t\t\t\tEVENT:', event.type )
    )

addEvt(evt) for evt in evts
