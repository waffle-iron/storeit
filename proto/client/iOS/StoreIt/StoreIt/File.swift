//
//  File.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation

class File {
    
    var path: String
    var metadata: String
    var unique_hash: String
    var kind: Int
    var chunks_hashes: String
    var files: [File]
    
    init(path: String, unique_hash: String, metadata: String, chunks_hashes: String, kind: Int, files: [File]) {
        self.path = path;
        self.unique_hash = unique_hash;
        self.metadata = metadata;
        self.chunks_hashes = chunks_hashes;
        self.files = files;
        self.kind = kind;
    }
    
}