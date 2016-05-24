//
//  StoreItSynchDirectoryView.swift
//  StoreIt
//
//  Created by Romain Gjura on 13/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit

class StoreItSynchDirectoryView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(uploadFile))
        
        // if we're at root dir, we can't go back to login view with back navigation controller button
        if (self.navigationItem.title == managers?.navigationManager!.rootDirTitle) {
            self.navigationItem.hidesBackButton = true
        } else {
            self.navigationItem.hidesBackButton = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        print("Image as been picked: \(image)")
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    // clean this function !!
    func uploadFile() {
        let actionSheet = UIAlertController(title: "Importer un fichier", message: "Importez une photo ou une vidéo depuis votre appareil ou prenez une photo ou une vidéo directement avec celui-ci", preferredStyle: .ActionSheet)

        let cancelActionButton = UIAlertAction(title: "Annuler", style: .Cancel) { action -> Void in
            print("Annuler")
        }
        
        let uploadFromLibrary = UIAlertAction(title: "Depuis mes photos et vidéos", style: .Default) { action -> Void in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
        let uploadFromCamera = UIAlertAction(title: "Depuis l'appareil photo", style: .Default) { action -> Void in
            print("Upload from Caméra")
        }
        
        actionSheet.addAction(cancelActionButton)
        actionSheet.addAction(uploadFromLibrary)
        actionSheet.addAction(uploadFromCamera)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
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
        return false // segues are triggered manually
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