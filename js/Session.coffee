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
            # load from local db
            @db.get(sId).then( (doc)=>
                # TODO check remote revision, if more current than local then ask user 
                # TODO sync changes to remote... (do not sync full remote db to local)
                @doc = doc                
                @_add_access_point()
                console.log('local session loaded')
            ).catch( (err)=>
                console.log('local db load err:', err)
                if err.status not in [404]
                    console.log(err.stack)
                    #return
                # no local, try get session doc from remote
                @remote_db.get(sId).then( (doc)=>
                    # TODO put doc into local 
                    
                    # TODO sync local->remote (not remote->local)
                    @doc = doc
                    @_add_access_point()
                    console.log('remote session loaded')
                ).catch( (err)=>
                    console.log('remote db load err:', err)
                    # no local, no remote
                    console.log('could not load session, using default')
                    @_setup_default()
                    
                    # create new doc in local db
                    @db.put(
                        @doc,
                        sId
                    ).then( (response)=>
                        console.log('local session saved for later')
                        # TODO Sync local->remote
                    ).catch( (err)=>
                        console.log('err putting in local db:', err)
                        throw err
                    )
                )
            )
        else # no session id given
            console.log('no session id given, using demo session')
            @_setup_default()

    # === constants === #
    @SESSION_DB_NAME = 'behaviorsim_sessions'

    @DEFAULT_SESSION = {
        #_id: '_default',
        createDate: new Date().toDateString(),
        widgetLayout: 'TODO',  # TODO
        avatar: 'demoUser',
        messages: ['welcome to behaviorSim'],
        notifications: [],
        tasks: [],
        accessed: []
    }
    # === ========= === #

    # === "private" methods === #
    _add_access_point: ()->
        # adds a session accessed logpoint to the db with relevant info
        @doc.accessed.push(Math.floor(new Date().getTime() / 1000))
        @db.put(@doc)
        
    _setup_default: ()->
        # loads up a default session
        @doc = Session.DEFAULT_SESSION
        return
    # === ================= === #

try
    window.Session = Session
catch error
    module.exports = Session