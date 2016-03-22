//
//  Client.swift
//  StoreIt
//
//  Created by Romain Gjura on 16/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import TCPIP
import SwiftSockets
import CocoaAsyncSocket

class Client {
    
    let host: String
    let port: Int
    let requestBuilder: RequestBuilder
    
    var ip: IP?
    var clientSocket: TCPClientSocket?
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
        self.requestBuilder = RequestBuilder()
        
        do {
            self.ip = try IP(address: host, port: port);
            self.clientSocket = try TCPClientSocket(ip: ip!);
        } catch {
            print("[NetworkManager.Client] Error while initializing socket: the server might not be runnning, or wrong port or host are given.");
        }
    }
  
    func start()  {
        let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);

        dispatch_async(queue) {
            while (!self.clientSocket!.closed) {
                // read
            }
        }
    }
    
    func join() {
        let testFile = File(path: "./", unique_hash: "unique_hash", metadata: "0", chunks_hashes: ["chunks_hashes"], kind: 0, files: [])
        let request = requestBuilder.join("cli1", port: self.port, chunk_hashes: [], file: testFile)
        print(request)
        do {
            try self.clientSocket!.sendString(request)
            try self.clientSocket!.flush()
        } catch {
            print("[NetworkManager.Client] Error while writing on socket; Request : JOIN.")
        }
    
    }

}