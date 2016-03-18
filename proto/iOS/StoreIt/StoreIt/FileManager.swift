//
//  FileManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation

enum FileType: Int {
    case Unknown = -1
	case Directory
	case Regular_file
    case Link
}

class FileManager {
    
    let fileManager = NSFileManager.defaultManager();
    let rootDir: String;

    init(rootDir: String) {
        self.rootDir = rootDir;
    }
    
    // Return the type of the file regarding the enum FileType
    func fileType(path: String) -> FileType {
        var isDir : ObjCBool = false

        if (fileManager.fileExistsAtPath(rootDir + path, isDirectory: &isDir)) {
            if isDir {
                return FileType.Directory;
            } else {
                return FileType.Regular_file;
            }
        }
        else {
            // file doesn't exist
            return FileType.Unknown;
        }
    }
    
    // Get recursively and return all the files/directory located at the "rootDir"
    func getDirectoryContent() -> [String] {
    	let dirContent = fileManager.enumeratorAtPath(rootDir);
        var dirContentArray = [String]();
        
        while let item: String = dirContent?.nextObject() as? String {
            dirContentArray += [item];
        }
        
        return dirContentArray;
    }

}