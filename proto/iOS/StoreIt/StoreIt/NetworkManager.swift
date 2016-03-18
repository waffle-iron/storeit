//
//  NetworkManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation

class NetworkManager {
    
    let host: String;
    let port: Int;
    let server: Server;
    let client: Client;
    
    init(host: String, port: Int) {
        self.host = host;
        self.port = port;
        self.server = Server(host: host, port: port);
        self.client = Client(host: host, port: port);
    }
    
}