export class Command {

  constructor(name, parameters) {
    this.uid = 42
    this.command = name
    this.parameters = parameters
  }
}

export class Reponse {
  constructor(code, text, uid, parameters) {
    this.code = code,
    this.text = text,
    this.commandUid = uid,
    this.parameters = parameters
  }
}
