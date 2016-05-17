//
//  ListView.swift
//  StoreIt
//
//  Created by Romain Gjura on 04/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit

class ListView: UITableViewController {
    
    var managers: AppDataManagers?
    
    let itemIdentifier = "Item"
    
    var rootDir: [String: File] = [:]
    var lastDir: [String: File] = [:]
    var currentDir: [String: File] = [:]
    
    var items: [String] = ["toto", "titi"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        /*let allItems : [String: File] = (self.managers?.fileManager?.getSyncDirTree())!
        let currentItems : [String] = Array(allItems.keys)
        
        self.lastDir = allItems
        self.rootDir = allItems
        self.currentDir = allItems
        self.items = currentItems
        self.tableView.reloadData()*/
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeCurrentDirectory(selectedDir: File) {
        self.lastDir = self.currentDir
        self.currentDir = selectedDir.files
        
        let newItems: [String] = Array(selectedDir.files.keys)
        self.items = Array(newItems)
        self.tableView.reloadData()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let backItem = UIBarButtonItem()
        backItem.title = "Something Else"
        self.navigationItem.backBarButtonItem = backItem
        return false
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Something Else"
        self.title = "toto"
        self.navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed

    }*/
    
   /* override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow: String = self.items[indexPath.row]
        let selectedFile: File = currentDir[selectedRow]!
        let fileType: FileType = FileType(rawValue: selectedFile.kind)!
        
        switch fileType {
            case .RegularFile:
            	break
        	case .Directory:
            	self.changeCurrentDirectory(selectedFile)
            default:
            	break
            }
     
    }*/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return createItemCellAtIndexPath(indexPath)
    }
    
    func createItemCellAtIndexPath(indexPath: NSIndexPath) -> Item {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(itemIdentifier) as! Item
        cell.test.text = "\(items[indexPath.row])"
        return cell
    }
    
    @IBAction func upload(sender: AnyObject) {
    	/*let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)

        i += 1
        self.items.append(i)
        
        print("SIZE: \(items.count)")

        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)*/
    }
}
