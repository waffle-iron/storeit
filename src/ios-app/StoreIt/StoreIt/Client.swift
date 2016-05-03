//
//  Client.swift
//  StoreIt
//
//  Created by Romain Gjura on 16/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import Starscream

class Client {
    
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
    
    func join() {
        //let request = requestBuilder.join(username, port: self.port, hosted_hashes: hosted_hashes,file: file)
        self.WSManager.sendRequest("insert_join_request_here")
    }

}