//
//  FileManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation
import ObjectMapper
import CryptoSwift

enum FileType: Int {
    case Unknown = -1
	case Directory
	case Regular_file
    case Link
}

class FileManager {
    
    private let fileManager = NSFileManager.defaultManager()
    
    let rootDirPath: String // storeit base directory
    let absoluteRootDirPath: String // storeit directory full path

    init(path: String) {
        let url: NSURL = NSURL(fileURLWithPath: path)
        self.rootDirPath = url.lastPathComponent!
        self.absoluteRootDirPath = url.path!
    }
    
    func buildTree(path: String) -> [String: File] {
        let files: [String] = getDirectoryContent(path)
        var nestedFiles: [String: File] = [String:File]()
        
        for file in files {
            let filePath = "\(path)/\(file)"
            let type = fileType(filePath)

            switch type {
                case .Regular_file :
                    nestedFiles[file] = File(path: filePath,
                                             unique_hash: sha256(filePath),
                                             metadata: "",
                                             chunks_hashes: [""],
                                             kind: type.rawValue,
                                             files: [String:File]())
                case .Directory :
                    nestedFiles[file] = File(path: filePath,
                                             unique_hash: "0",
                                             metadata: "",
                                             chunks_hashes: [""],
                                             kind: type.rawValue,
                                             files: buildTree(filePath))
                default :
                    print("[FileManager] Error while building tree : file type doesn't exist.")
            }
        }
        return nestedFiles
    }
    
    private func fileType(path: String) -> FileType {
        var isDir : ObjCBool = false
        
        if (fileManager.fileExistsAtPath(getFullPath(path), isDirectory: &isDir)) {
            if isDir {
                return FileType.Directory
            } else {
                return FileType.Regular_file
            }
        }
        else {
            return FileType.Unknown
        }
    }
    
    private func getDirectoryContent(path: String) -> [String] {
        let fullPath: String = getFullPath(path)
        
        do {
        	let dirContent = try fileManager.contentsOfDirectoryAtPath(fullPath)
            return dirContent
        } catch {
            print("[FileManager] Error while getting file of \(fullPath) directory")
            return []

        }
    }
    
    private func getDirectoryNestedContent() -> [String] {
    	let dirContent = fileManager.enumeratorAtPath(absoluteRootDirPath);
        var dirContentArray = [String]()
        
        for file in dirContent!.allObjects {
            dirContentArray += [file as! String]
        }
        
        return dirContentArray
    }
    
    // Concatenate absolute path and file path to get full path
    private func getFullPath(path: String) -> String {
        let parentURL: NSURL = NSURL(fileURLWithPath: absoluteRootDirPath).URLByDeletingLastPathComponent!
        let parent: String = parentURL.path!
        return "\(parent)/\(path)"
    }
    
    private func sha256(path: String) -> String {
        let url: NSURL = NSURL(fileURLWithPath: getFullPath(path))
        let data: NSData = NSData(contentsOfURL: url)!
        
        return data.sha256()!.toHexString()
    }

}