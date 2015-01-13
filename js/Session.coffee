class Session
    ###
    represents a user session and associated data.
    ###
    constructor: ()->
        ###
        attempts to load data of given session id.
        ###
        optns = {  # database options
            auto_compaction: false
        }
        @db = new PouchDB(Session.SESSION_DB_NAME, optns)  # connect to or create local db

        remote = 'https://theryintrinissalaslanter:8oXG6udJSnyftARSlUBuvI60@7yl4r.cloudant.com/'+Session.SESSION_DB_NAME
        @remote_db = new PouchDB(remote, optns)  # the remote sessions db

        sId = window.uri_search[URI_CODE.sessionId]
        if sId?

            # load local, sync changes to remote... (do not sync full remote db to local)

            # if no local get session doc from remote, put into local, sync local->remote

            # else no local, no remote, start new in local, sync local->remote

            @db.get(sId).then( (doc)=>
                # add new access logpoint
                doc.accessed.append(new Date().getTime() / 1000)
                @doc = doc
            ).catch( (err)=>
                console.log('could not load session, using default. err:', err)
                @_setup_default()
            )
        else # no session id given
            console.log('no session id given, using demo session')
            @_setup_default()

    # === constants === #
    @SESSION_DB_NAME = 'behaviorsim_sessions'

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
        return
    # === ================= === #

try
    window.Session = Session
catch error
    module.exports = Session