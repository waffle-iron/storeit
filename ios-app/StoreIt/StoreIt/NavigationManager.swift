//
//  NavigationManager.swift
//  StoreIt
//
//  Created by Romain Gjura on 19/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import Foundation

class NavigationManager {
    
    let rootDirTitle: String
    
    private var storeItSynchDir: [String: File]
    private var indexes: [String]
    
    var items: [String]
    private var currentDirectory: [String: File]
    
    init(rootDirTitle: String, allItems: [String: File]) {
        self.rootDirTitle = rootDirTitle
        self.storeItSynchDir = allItems
        self.indexes = []
        self.currentDirectory = allItems
        self.items = Array(allItems.keys)
    }
    
    func setItems(allItems: [String: File]) {
        self.storeItSynchDir = allItems
        self.currentDirectory = allItems
        self.items = Array(allItems.keys)
    }

    func getFileObjectAtIndex() -> [String: File] {
        let cpyIndexes = self.indexes
        var cpyStoreItSynchDir: [String: File] = self.storeItSynchDir
        
        if (indexes.isEmpty == false) {
            for index in cpyIndexes {
                cpyStoreItSynchDir = (cpyStoreItSynchDir[index]?.files)!
            }
            return cpyStoreItSynchDir
        }
        
        return self.storeItSynchDir
    }
    
    
    func getSelectedFileAtRow(indexPath: NSIndexPath) -> File {
        let selectedRow: String = self.items[indexPath.row]
        let selectedFile: File = self.currentDirectory[selectedRow]!
        
        return selectedFile
    }
    
    func isSelectedFileAtRowADir(indexPath: NSIndexPath) -> Bool {
        let selectedFile: File = self.getSelectedFileAtRow(indexPath)
        return selectedFile.isDir
    }
    
    func getTargetName(target: File) -> String {
        let url: NSURL = NSURL(fileURLWithPath: target.path)
        return url.lastPathComponent!
    }
    
    func goToNextDir(target: File) -> String {
        let targetName = self.getTargetName(target)
        
        self.indexes.append(targetName)
        self.currentDirectory = self.getFileObjectAtIndex()
        self.items = Array(target.files.keys)

        return targetName
    }
    
    func goPreviousDir() {
        self.indexes.popLast()
        self.currentDirectory = self.getFileObjectAtIndex()
        self.items = Array(self.currentDirectory.keys)
    }
    
}