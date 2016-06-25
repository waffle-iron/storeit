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
    
    func add(filePath:String, completionHandler: ([MerkleNode] -> ())) {
        do {
            try self.ipfs!.add(filePath, completionHandler: completionHandler)
        }
        catch let err as NSError { print("[IPFS.ADD] error: \(err)") }
    }
    
    private func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func add2(filePath: String) {
        let CRLF = "\r\n"
        let url = NSURL(string: "http://127.0.0.1:5001/api/v0/add?stream-cannels=true")
        let boundary = self.generateBoundaryString()
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = NSData(contentsOfFile: filePath)
        let fileName = NSURL(fileURLWithPath: filePath).lastPathComponent!
        
        let body = NSMutableData()
        
        body.appendData("--\(boundary)\(CRLF)".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Disposition : file; name=\"file\"; filename=\"\(fileName)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Transfer-Encoding: binary\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("Content-Type: application/octet-stream\(CRLF)\(CRLF)".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(data!)
        body.appendData("\(CRLF)".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("--\(boundary)--\(CRLF)".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print(dataString)
            
        }
        
        task.resume()
    }
    
}