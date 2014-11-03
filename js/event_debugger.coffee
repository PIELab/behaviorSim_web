
evts = [
    'selectNode'
]
addEvt = (name) ->
    console.log('adding', name, 'event')
    $( document ).on(
        name,
    (event) ->
        console.log( 'EVENT:', event.type )
    )

addEvt(evt) for evt in evts
