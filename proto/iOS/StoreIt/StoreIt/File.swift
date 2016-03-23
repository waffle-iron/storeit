//
//  File.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import ObjectMapper

class File: Mappable {
    
    var path: String
    var metadata: String
    var unique_hash: String
    var kind: Int
    var chunks_hashes: [String]
    var files: [String: File]
    
    init() {
        self.path = ""
        self.unique_hash = ""
        self.metadata = ""
        self.chunks_hashes = [""]
        self.files = [String: File]()
        self.kind = -1
    }

    init(path: String, unique_hash: String, metadata: String, chunks_hashes: [String], kind: Int, files: [String: File]) {
        self.path = path
        self.unique_hash = unique_hash
        self.metadata = metadata
        self.chunks_hashes = chunks_hashes
        self.files = files
        self.kind = kind
    }
    
   required init?(_ map: Map) {
        self.path = ""
    	self.metadata = ""
    	self.unique_hash = ""
    	self.kind = -1
    	self.chunks_hashes = []
    	self.files = [String:File]()
    }
    
    func mapping(map: Map) {
    	path <- map["path"]
        metadata <- map["metadata"]
        unique_hash <- map["unique_hash"]
        kind <- map["kind"]
        chunks_hashes <- map["chunks_hashes"]
        files <- map["files"]
    }
}