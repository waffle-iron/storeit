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
    
    var managers: AppDataManagers?
    
    enum CellIdentifiers: String {
        case Directory = "directoryCell"
        case File = "fileCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.list.delegate = self
        self.list.dataSource = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: nil)
        
        // if we're at root dir, we can't go back to login view with back navigation controller button
        if (self.navigationItem.title == managers?.navigationManager!.rootDirTitle) {
            self.navigationItem.hidesBackButton = true
        } else {
            self.navigationItem.hidesBackButton = false
        }
    }
    
    // function triggered when back button of navigation bar is pressed
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if (parent == nil) {
            self.managers?.navigationManager!.goPreviousDir()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false // segues triggered manually
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let target: File? = sender as? File
        
        if (segue.identifier == "nextDirSegue") {
        
            let listView = (segue.destinationViewController as! StoreItSynchDirectoryView)
            let targetPath = (self.managers?.navigationManager!.goToNextDir(target!))!
            
            listView.navigationItem.title = targetPath
            listView.managers = self.managers
        }
        else if (segue.identifier == "showFileSegue") {
            let fileView = segue.destinationViewController
            
            fileView.navigationItem.title = self.managers?.navigationManager!.getTargetName(target!)
        }
    }
    
    // Function triggered when a cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
         let selectedFile: File = (managers?.navigationManager!.getSelectedFileAtRow(indexPath))!
         let fileType: FileType = (managers?.navigationManager!.getSelectedFileTypeAtRow(indexPath))!
         
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

	/* Creation of table cells */
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (managers?.navigationManager!.items.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return createItemCellAtIndexPath(indexPath)
    }
    
    // Return a specific type of cell regarding the type of File object (directory, file...)
    func createItemCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        let fileType: FileType = (managers?.navigationManager!.getSelectedFileTypeAtRow(indexPath))!
        let items: [String] = (managers?.navigationManager!.items)!
        
        switch fileType {
            case .Directory:
                let cell = self.list.dequeueReusableCellWithIdentifier(CellIdentifiers.Directory.rawValue) as! DirectoryCell
                cell.itemName.text = "\(items[indexPath.row])"
                return cell
        	case .RegularFile:
            	let cell = self.list.dequeueReusableCellWithIdentifier(CellIdentifiers.File.rawValue) as! FillCell
                cell.itemName.text = "\(items[indexPath.row])"
            	return cell
        	default:
                return UITableViewCell() // TODO: create some kind of default cell
            }
    }
    
    /* ** */
    
}