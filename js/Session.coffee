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

        syncOptns = {  # local->remote sync options
            continuous: true
        }

        remote = 'https://theryintrinissalaslanter:8oXG6udJSnyftARSlUBuvI60@7yl4r.cloudant.com/'+Session.SESSION_DB_NAME

        @db = new PouchDB(Session.SESSION_DB_NAME, optns)  # connect to or create local db
        @remote_db = new PouchDB(remote, optns)  # the remote sessions db

        sId = window.uri_search[URI_CODE.sessionId]
        if sId?
            # load from local db
            @db.get(sId).then( (doc)=>
                # TODO check for existing remote session
                # TODO check remote revision, if more current than local then ask user 
                @doc = doc
                @db.replicate.to(remote, syncOptns)
                @_add_access_point()
                console.log('local session loaded')
            ).catch( (err)=>
                @_logError('local', err)

                # no local, try get session doc from remote
                @remote_db.get(sId).then( (doc)=>
                    @doc = doc
                    @_add_access_point()  # Note: this also puts doc into local
                    @db.replicate.to(remote, syncOptns)
                    console.log('remote session loaded')
                ).catch( (err)=>
                    @_logError('remote', err)
                    # no local, no remote
                    console.log('could not load session, using default')
                    @_setup_default()
                    
                    # create new doc in local db
                    @db.put(
                        @doc,
                        sId
                    ).then( (response)=>
                        console.log('local session saved for later')
                        @db.replicate.to(remote, syncOptns)
                    ).catch( (err)=>
                        console.log('err putting in local db:', err)
                        throw err
                    )
                )
            )
        else # no session id given
            console.log('no session id given, using demo session')
            @_setup_default()

        $(document).on('appReady',() =>
            @updateSessionUI()

            $(document).on('graphChange', ()=>
                @doc.model = model_builder._model.getPackedModel()  # TODO: do this w/o global reference
                @db.put(@doc)
            )

            # TODO: why does this does not work in place of all the other @db.put()s
            #$(window).on("beforeunload", ()=>
            #    @db.put(@doc)
            #    return "db updated"
            #)
        )



    # === constants === #
    @SESSION_DB_NAME = 'behaviorsim_sessions'

    @DEFAULT_SESSION = {
        _id: '_default',
        createDate: new Date().toDateString(),
        widgetLayout: 'TODO',  # TODO
        avatar: 'demoUser',
        messages: ['welcome to behaviorSim'],
        notifications: [],
        tasks: [],
        accessed: []
    }
    # === ========= === #

    # === public methods === #
    updateSessionUI: ()->
        # updates the user interface to reflect current session
        $('.u-name').text(@doc._id)
    # === ============== === #

    # === "private" methods === #
    _add_access_point: ()->
        # adds a session accessed logpoint to the db with relevant info
        @doc.accessed.push(Math.floor(new Date().getTime() / 1000))
        @db.put(@doc)
        
    _setup_default: ()->
        # loads up a default session
        @doc = Session.DEFAULT_SESSION
        return

    _logError: (dbId, err)->
        # convenience method for shortening known error logs & showing details on unknown ones
        if err.status == 404
            console.log(dbId + ' session not found')
        else  # other error
            console.log(dbId + ' db load err:', err)
            console.log(err.stack)
    # === ================= === #

try
    window.Session = Session
catch error
    module.exports = Session