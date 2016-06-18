//
//  NetworkManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import ObjectMapper

class NetworkManager {
    
    let host: String
    let port: Int
    
    private let WSManager: WebSocketManager
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        self.WSManager = WebSocketManager(host: host, port: port)
    }
    
    func isConnected() -> Bool {
        return WSManager.ws.isConnected
    }
    
    func join(authType: String, accessToken: String, home: File) {
        var parameters = [String:Any]()
        
        parameters["authType"] = authType
        parameters["accessToken"] = accessToken
        parameters["home"] = home
        
        let joinCommand = Command(uid: CommandInfos().JOIN.0, command: CommandInfos().JOIN.1, parameters: parameters)
        let jsonJoinCommand = Mapper().toJSONString(joinCommand)
        
        self.WSManager.sendRequest(jsonJoinCommand!)
    }
    
    
}