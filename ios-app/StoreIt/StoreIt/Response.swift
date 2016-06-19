//
//  Response.swift
//  StoreIt
//
//  Created by Romain Gjura on 18/06/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import ObjectMapper

class Response : Mappable {
    
    var code: String
    var text: String
    var commandUid: Int
    var command: String
    
    init() {
        self.code = ""
        self.text = ""
        self.command = ""
        self.commandUid = -1
    }
    
    init(code: String, text: String, command: String, command_id: Int) {
        self.code = ""
        self.text = ""
        self.command = ""
        self.commandUid = -1
    }
    
    required init?(_ map: Map) {
        self.code = ""
        self.text = ""
        self.command = ""
        self.commandUid = -1
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        text <- map["text"]
        commandUid <- map["commandUid"]
        command <- map["command"]
    }
    
}