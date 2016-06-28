import {logger} from './log.js'
import * as user from './user.js'
import * as protoObjs from './protocol-objects'
import * as auth from './auth.js'

const sendWelcome = (socket, usr, commandUid, handlerFn) => {
  socket.sendObj(new protoObjs.Response(0, 'welcome', commandUid, {
    home: usr.home
  }))
  handlerFn()
}

const join = function(command, arg, socket, handlerFn) {

  // TODO: error checking on JSON
  auth.verifyUserToken(arg.authType, arg.accessToken, (err, email) => {
    if (!err && email !== undefined) {
      user.connectUser(email, socket, (err, usr) => {
        if (err && err.errno === -2) {
          user.createUser(email, (err) => {
            if (err) {
              handlerFn(err)
            }
            else {
              user.connectUser(email, socket, (err, usrAgain) => {
                if (err) {
                  handlerFn({code: 2, msg: 'could not connect user'})
                }
                else {
                  sendWelcome(socket, usrAgain, command.uid, handlerFn)
                }
              })
            }
          })
        }
        else if (err) {
          logger.debug('could not connect user')
          handlerFn({code: 1, msg: 'bad credentials'})
        }
        else {
          sendWelcome(socket, usr, command.uid, handlerFn)
        }
      })
    }
    else {
      logger.debug('could not connect user')
      handlerFn({code: 1, msg: 'bad credentials'})
    }
  })

}

const recast = (command, client) => {

  const uid = command.uid
  const usr = client.getUser()
  command.uid = ++usr.commandUid
  for (const sock in usr.sockets) {
    if (parseInt(sock) === client.uid) {
      continue
    }
    usr.sockets[sock].sendObj(command)
  }

  client.answerSuccess(uid)
}

const add = (command, arg, client) => {
  client.getUser().addTree(arg.files)
  logger.info('user tree: ' + client.getUser().home)
  recast(command, client)
}

const upt = (command, arg, client) => {
  client.getUser().uptTree(arg.files)
  recast(command, client)
}

const mov = (command, arg, client) => {
  client.getUser().renameFile(arg.src, arg.dest)
  recast(command, client)
}

const del = (command, arg, client) => {
  client.getUser().delTree(arg.files)
  recast(command, client)
}

export const parse = function(msg, client) {

  const command = JSON.parse(msg)

  const hmap = {
    'JOIN': join,
    'FADD': add,
    'FUPT': upt,
    'FMOV': mov,
    'FDEL': del
  }

  // TODO: catch the goddam exception
  hmap[command.command](command, command.parameters, client, (err) => {
    if (err) {
      client.answerFailure(command.uid, err)
    }
  })
}
