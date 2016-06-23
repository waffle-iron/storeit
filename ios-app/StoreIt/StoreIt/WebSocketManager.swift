//
//  WebSocketManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 03/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import Starscream
import ObjectMapper

class WebSocketManager {
    
    let url: NSURL
    let ws: WebSocket
    let navigationManager: NavigationManager
    let logoutFunction: () -> Void
    
    init(host: String, port: Int, navigationManager: NavigationManager, logoutFunction: () -> Void) {
        self.url = NSURL(string: "ws://\(host):\(port)/")!
        self.ws = WebSocket(url: url)
        self.navigationManager = navigationManager
        self.logoutFunction = logoutFunction
        self.eventsInitializer()
    }
    
    private func eventsInitializer() {
        self.ws.onConnect = {
        	print("[Client.WebSocketManager] WebSocket is connected to \(self.url)")
        }

        self.ws.onDisconnect = { (error: NSError?) in
        	print("[Client.WebSocketManager] Websocket is disconnected from \(self.url) with error: \(error?.localizedDescription)")
            self.logoutFunction()
        }
        
        self.ws.onText = { (request: String) in
            //print("[Client.WebSocketManager] Client recieved a request : \(request)")
			
            let command: ResponseResolver? = Mapper<ResponseResolver>().map(request)
            
            // Server has responded
            if (command?.command == "JOIN") {
                let response: Response? = Mapper<Response>().map(request)
                let home: File? = response?.parameters!["home"]
                
                self.navigationManager.setItems((home?.files)!)
            }
            
            // Server sent a command (FADD, FUPT, FDEL)
            else if (command != nil && CommandInfos().SERVER_TO_CLIENT_CMD.contains(command!.command)) {
                let _: Command? = Mapper<Command<FilesParameters>>().map(request)
                // Do funny stuff with command here
            }
                
            // We don't know what the server wants
            else {
                print("[Client.Client.WebSocketManager] Request cannot be processed")
            }
        }
        
        self.ws.onData = { (data: NSData) in
            print("[Client.WebSocketManager] Client recieved some data: \(data.length)")
        }
        
        self.ws.connect()
    }
    
    func sendRequest(request: String) {
        if (self.ws.isConnected) {
            self.ws.writeString(request)
        } else {
            print("[Client.WebSocketManager] Client can't send request \(request) to \(url), WS is disconnected")
        }
    }

}