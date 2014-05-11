
def registerUserConnection(user,ws):
    # saves user websocket connetion so that updates to the user object can push to the client
    user.websocket = ws


def parse(message, wsock):
    # parses the given string as a message dict containing
    mesDict = eval(str(message))
    try:
        simID  = mesDict['sID']
        userID = mesDict['uID']
        cmd    = mesDict['cmd']
        data   = mesDict['dat']
    except KeyError:
        print 'malformed message!'

    except TypeError as e:
        if e.message == "'NoneType' object has no attribute '__getitem__'":
            # it's likely that pesky onclose message I can't fix... ignore for now
            print 'connection closed'
        else:
            raise
    # TODO: call message parser sort of like:
    _parse(cmd, data, userID, wsock)


def _parse(cmd, data, user, websock):
    # takes appropriate action on the given command and data string
    if cmd == 'hello':
        registerUserConnection(user, websock)

    else:
        print "UNKNOWN CLIENT MESSAGE: cmd=",cmd,"data=",data," from user ",user