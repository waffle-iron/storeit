let uid = 0

export class Command {

  constructor(name, parameters) {
    this.uid = uid++
    this.command = name
    this.parameters = parameters
  }
}

export class Response {
  constructor(code, text, uid, parameters) {
    this.code = code,
    this.text = text,
    this.commandUid = uid,
    this.parameters = parameters
  }
}

export const makeFileObj = (path, IPFSHash, files) => {

  if (IPFSHash === undefined) {
    IPFSHash = null
  }
  if (files === undefined) {
    files = null
  }

  return {
    path,
    metadata: null,
    IPFSHash,
    isDir: IPFSHash == null,
    files,
  }
}
