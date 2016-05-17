//
//  StoreItSynchDirectoryView.swift
//  StoreIt
//
//  Created by Romain Gjura on 13/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit

class StoreItSynchDirectoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var list: UITableView!
    
    enum CellIdentifiers: String {
        case Directory = "directoryCell"
        case File = "fileCell"
    }
    
    var items: [String]?
    var lastDir: [String: File]?
    var currentDir: [String: File]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.list.delegate = self
        self.list.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        
        if (self.navigationItem.title == "StoreIt") {
            self.navigationItem.hidesBackButton = true
        } else {
            self.navigationItem.hidesBackButton = false
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let direction: File? = sender as? File
        
        if (segue.identifier == "nextDirSegue") {
        
            let listView = (segue.destinationViewController as! StoreItSynchDirectoryView)
            
            listView.lastDir = self.currentDir
            listView.currentDir = direction?.files
            listView.items = Array(direction!.files.keys)
            listView.navigationItem.title = NSURL(fileURLWithPath: direction!.path).lastPathComponent!
            
            //listView.managers = self.managers
        }
        else if (segue.identifier == "showFileSegue") {
            let fileView = segue.destinationViewController
            
            fileView.navigationItem.title = NSURL(fileURLWithPath: direction!.path).lastPathComponent!
        }
    }
    
    
    func getFileTypeAtRow(indexPath: NSIndexPath) -> FileType {
        let selectedRow: String = self.items![indexPath.row]
        let selectedFile: File = currentDir![selectedRow]!
        let fileType: FileType = FileType(rawValue: selectedFile.kind)!
        
        return fileType
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         let selectedRow: String = self.items![indexPath.row]
         let selectedFile: File = currentDir![selectedRow]!
         let fileType: FileType = FileType(rawValue: selectedFile.kind)!
         
         switch fileType {
             case .RegularFile:
                self.performSegueWithIdentifier("showFileSegue", sender: selectedFile)
             	break
             case .Directory:
             	self.performSegueWithIdentifier("nextDirSegue", sender: selectedFile)
             default:
             	break
         }
     
     }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return createItemCellAtIndexPath(indexPath)
    }
    
    func createItemCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        let fileType: FileType = getFileTypeAtRow(indexPath)
        
        switch fileType {
            case .Directory:
                let cell = self.list.dequeueReusableCellWithIdentifier(CellIdentifiers.Directory.rawValue) as! DirectoryCell
                cell.itemName.text = "\(items![indexPath.row])"
                return cell
        	case .RegularFile:
            	let cell = self.list.dequeueReusableCellWithIdentifier(CellIdentifiers.File.rawValue) as! FillCell
                cell.itemName.text = "\(items![indexPath.row])"
            	return cell
        	default:
                return UITableViewCell() // TODO: create some kind of default cell
            }
    }
    
}