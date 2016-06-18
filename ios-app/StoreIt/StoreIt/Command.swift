//
//  Command.swift
//  StoreIt
//
//  Created by Romain Gjura on 18/06/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import ObjectMapper

class Command : Mappable {
    
    var uid: Int
    var command: String
    var parameters: [String:Any]
    
    init() {
        self.uid = -1
        self.command = ""
        self.parameters = [String:Any]()
    }
    
    init(uid: Int, command: String, parameters: [String:Any]) {
        self.uid = uid
        self.command = command
        self.parameters = parameters
    }
    
    required init?(_ map: Map) {
        self.uid = -1
        self.command = ""
        self.parameters = [String:Any]()
    }
    
    func mapping(map: Map) {
        uid <- map["uid"]
        command <- map["command"]
        parameters <- map["parameters"]
    }

}