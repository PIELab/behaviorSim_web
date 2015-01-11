class Session
    ###
    represents a user session and associated data.
    ###
    constructor: ()->
        ###
        attempts to load data of given session id.
        ###
        remote = 'https://theryintrinissalaslanter:8oXG6udJSnyftARSlUBuvI60@7yl4r.cloudant.com/behaviorsim_sessions'
        optns = {
            auto_compaction: false
        }
        @db = new PouchDB(remote, optns)  # the sessions db
        @ready = false
        @noSave = true
        sId = window.uri_search[URI_CODE.sessionId]
        if sId?
            @db.get(sId).then( (doc)=>
                # add new access logpoint
                doc.accessed.append(new Date().getTime() / 1000)
                @doc = doc
            ).then( ()->
                @ready = true
                @noSave = false
            ).catch( @_setup_default )
        else # no session id given
            @_setup_default()

        loggit = (n)=>
            if @doc?
                console.log('session initiated: ', @doc)
            else
                delay = Math.ceil(Math.exp(n))*1000
                console.log('session not ready, waiting ', delay, 'ms...')
                setTimeout(loggit, delay, n+1)

        loggit(0)

    # === constants === #
    @DEFAULT_SESSION = {
        _id: '_default',
        joinDate: new Date().toDateString(),
        widgetLayout: 'TODO',  # TODO
        avatar: 'demoUser',
        messages: ['welcome to behaviorSim'],
        notifications: [],
        tasks: []
    }
    # === ========= === #

    # === "private" methods === #
    _setup_default: ()->
        @doc = @DEFAULT_SESSION
        @ready = true
        @noSave = true
    # === ================= === #

try
    window.Session = Session
catch error
    module.exports = Session