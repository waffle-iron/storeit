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
    
    enum RequestString : String {
        case Join = "JOIN"
    }
    
    // REQUESTS
    
    func join(username: String, port: Int, chunk_hashes: [String], file: File) -> String {
        return "\(RequestString.Join.rawValue) \(username) \(port) \(chunkHashesToStr(chunk_hashes, separator: ":")) \(fileObjectToJSON(file))";
    }
    
    // TOOLS
    
    func chunkHashesToStr(chunk_hashes: [String], separator: String) -> String {
        return chunk_hashes.isEmpty ? "None" : chunk_hashes.joinWithSeparator(separator);
    }
    
    func fileObjectToJSON(file: File) -> String {
        return Mapper().toJSONString(file)!;
    }
    
}