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
        @noSave = true

        sId = window.uri_search[URI_CODE.sessionId]
        if sId?
            @db.get(sId).then( (doc)=>
                # add new access logpoint
                doc.accessed.append(new Date().getTime() / 1000)
                @doc = doc
                @noSave = false
                loggit(0)
            ).catch( (err)=>
                console.log('could not load session, using default. err:', err)
                @_setup_default()
            )
        else # no session id given
            console.log('no session id given, using demo session')
            @_setup_default()

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
        @doc = Session.DEFAULT_SESSION
        @noSave = true
        return
    # === ================= === #

try
    window.Session = Session
catch error
    module.exports = Session