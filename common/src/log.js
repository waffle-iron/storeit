import winston from '../../desktop-app/node_modules/winston'

export const logger = new winston.Logger({
  transports: [
    new winston.transports.Console({
      json: false,
      timestamp: false,
      colorize: 'all'
    }),
    //new winston.transports.File({ filename: __dirname + '/debug.log', json: false })
  ],
  exceptionHandlers: [
    new winston.transports.Console({
      json: false,
      timestamp: true
    }),
    //new winston.transports.File({ filename: __dirname + '/exceptions.log', json: false })
  ],
  exitOnError: false
})

export const ifnerr = (err, errMsg, successMsg, resolve) => {
  if (err) {
    logger.error(`${errMsg} ${err}`)
  }
  else {
    if (successMsg) {
      logger.info(successMsg)
    }
    if (resolve) {
      resolve()
    }
  }
}
