
evts = [
    'selectNode',
    'modelComplete',
    'graphChange',
    'selectNodeChange',
    'selectNodeChange_highP'
]
addEvt = (name) ->
    console.log('watching', name, 'event')
    $( document ).on(
        name,
        (event) ->
            console.log( 'EVENT:', event.type )
    )

addEvt(evt) for evt in evts
