//
//  RequestBuilder.swift
//  StoreIt
//
//  Created by Romain Gjura on 20/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestBuilder {
    
    private enum RequestString{
        case JOIN
    }
    
    init() {}
        
    // REQUESTS
    
    func join(username: String, port: Int, file: File) -> String {
        let args: String = "\(username) \(port) \(fileObjectToJSON(file))"
        
        return "\(RequestString.JOIN) \(size(args)) \(args)"
    }
    
    // TOOLS
    
    private func fileObjectToJSON(file: File) -> String {
        return Mapper().toJSONString(file)!
    }
    
    private func size(str: String) -> Int {
        return str.characters.count
    }
    
    private func chunkHashesToStr(chunk_hashes: [String], separator: String) -> String {
        return chunk_hashes.isEmpty ? "None" : chunk_hashes.joinWithSeparator(separator)
    }
}