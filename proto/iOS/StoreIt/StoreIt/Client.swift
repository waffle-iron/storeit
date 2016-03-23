//
//  Client.swift
//  StoreIt
//
//  Created by Romain Gjura on 16/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import TCPIP

class Client {
    
    private let host: String
    private let port: Int
    private let requestBuilder: RequestBuilder
    
    private var ip: IP?
    private var clientSocket: TCPClientSocket?
    
    var isRunning: Bool = false
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        self.requestBuilder = RequestBuilder()
        
        do {
            self.ip = try IP(address: host, port: port)
            self.clientSocket = try TCPClientSocket(ip: ip!)
            self.isRunning = true
        } catch {
            print("[NetworkManager.Client] Error while initializing socket: the server might not be runnning or the connexion is not established yet.");
        }
    }
  
    func start()  {
        let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)

        dispatch_async(queue) {
            while (!self.clientSocket!.closed) {
                // read
            }
        }
    }
    
    func join(username: String, file: File) {
        let request = requestBuilder.join(username, port: self.port, file: file)
        //print(request)
        
        do {
            try self.clientSocket!.sendString(request)
            try self.clientSocket!.flush()
        } catch {
            print("[NetworkManager.Client] JOIN: Error while writing on socket.")
        }
    }

}