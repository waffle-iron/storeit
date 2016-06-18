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
    var command_id: Int
    var command: String
    
    init() {
        self.code = ""
        self.text = ""
        self.command = ""
        self.command_id = -1
    }
    
    init(code: String, text: String, command: String, command_id: Int) {
        self.code = ""
        self.text = ""
        self.command = ""
        self.command_id = -1
    }
    
    required init?(_ map: Map) {
        self.code = ""
        self.text = ""
        self.command = ""
        self.command_id = -1
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        text <- map["text"]
        command_id <- map["command_id"]
        command <- map["command"]
    }
    
}