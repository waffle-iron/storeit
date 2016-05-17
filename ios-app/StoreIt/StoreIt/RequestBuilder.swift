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
    
    init() {}
        
    // REQUESTS
    
    func join(connexionType: ConnexionType, email: String, token: String, file: File) -> String {
        return "JOIN \(connexionType.rawValue) \(email) \(token) \(fileObjectToJSON(file))"
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