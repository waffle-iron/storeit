//
//  IpfsManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 24/06/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import SwiftIpfsApi
import SwiftMultihash

class IpfsManager {
    
    private let ipfs: IpfsApi?
    
    init?() {
        do {
			self.ipfs = try IpfsApi(host: "127.0.0.1", port: 5001)
        } catch let err as NSError {
            print("[IPFS] Error when initializing IFPS... (error: \(err))")
            return nil
        }
    }
    
    func get(hash: String, completionHandler: ([UInt8] -> Void)) {
        do {
        	let multihash = try fromB58String(hash)
        	try self.ipfs!.get(multihash, completionHandler: completionHandler)
        }
        catch let err as NSError { print("[IPFS.GET] error: \(err)") }
    }
    
}