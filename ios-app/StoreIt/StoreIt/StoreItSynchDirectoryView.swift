//
//  StoreItSynchDirectoryView.swift
//  StoreIt
//
//  Created by Romain Gjura on 13/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit

// TODO: maybe import interface texts from a file for different languages ?

class StoreItSynchDirectoryView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var list: UITableView!
    
    var alertControllerManager: AlertControllerManager?
    
    var connexionType: ConnexionType? = nil
    var networkManager: NetworkManager? = nil
    var connexionManager: ConnexionManager? = nil
    var fileManager: FileManager? = nil
    var navigationManager: NavigationManager? = nil
    
    enum CellIdentifiers: String {
        case Directory = "directoryCell"
        case File = "fileCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.list.delegate = self
        self.list.dataSource = self

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(uploadOptions))

        // if we're at root dir, we can't go back to login view with back navigation controller button
        
        if (self.navigationItem.title == navigationManager!.rootDirTitle) {
            self.navigationItem.hidesBackButton = true
        } else {
            self.navigationItem.hidesBackButton = false
        }
        
        self.alertControllerManager = AlertControllerManager(title: "Importer un fichier", message: nil)
        self.addActionsToActionSheet()
    }
    
    // function triggered when back button of navigation bar is pressed
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if (parent == nil) {
            self.navigationManager?.goPreviousDir()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: segues management
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return false // segues are triggered manually
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let target: File? = sender as? File

        if (segue.identifier == "nextDirSegue") {
        
            let listView = (segue.destinationViewController as! StoreItSynchDirectoryView)
            let targetPath = (self.navigationManager?.goToNextDir(target!))!
            
            listView.navigationItem.title = targetPath
            
            listView.connexionType = self.connexionType
            listView.networkManager = self.networkManager
            listView.connexionManager = self.connexionManager
            listView.fileManager = self.fileManager
            listView.navigationManager = self.navigationManager
        }
        else if (segue.identifier == "showFileSegue") {
            let fileView = segue.destinationViewController
            
            fileView.navigationItem.title = self.navigationManager?.getTargetName(target!)
        }
    }

	// MARK: Creation and management of table cells
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.navigationManager?.items.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return createItemCellAtIndexPath(indexPath)
    }
    
    // Function triggered when a cell is selected
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedFile: File = (navigationManager?.getSelectedFileAtRow(indexPath))!
        let isDir: Bool = (self.navigationManager?.isSelectedFileAtRowADir(indexPath))!
        
        if (isDir) {
            self.performSegueWithIdentifier("nextDirSegue", sender: selectedFile)
        } else {
            self.performSegueWithIdentifier("showFileSegue", sender: selectedFile)
        }
    }
    
    func createItemCellAtIndexPath(indexPath: NSIndexPath) -> UITableViewCell {
        
        let isDir: Bool = (self.navigationManager?.isSelectedFileAtRowADir(indexPath))!
        let items: [String] = (self.navigationManager?.items)!
        
        if (isDir) {
            let cell = self.list.dequeueReusableCellWithIdentifier(CellIdentifiers.Directory.rawValue) as! DirectoryCell
            cell.itemName.text = "\(items[indexPath.row])"
            return cell
        } else {
            let cell = self.list.dequeueReusableCellWithIdentifier(CellIdentifiers.File.rawValue) as! FillCell
            cell.itemName.text = "\(items[indexPath.row])"
            return cell
        }
    }
    
    // MARK: Action sheet creation and management
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        print("Image as been picked: \(image)") // Do some funny stuff here with ipfs
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func pickImageFromLibrary(action: UIAlertAction) -> Void {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }

    func takeImageWithCamera(action: UIAlertAction) -> Void {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            let camera = UIImagePickerController()
            
            camera.allowsEditing = false
            camera.sourceType = UIImagePickerControllerSourceType.Camera
            camera.delegate = self
            
            self.presentViewController(camera, animated: true, completion: nil)
        }
    }
    
    func addActionsToActionSheet() {
        self.alertControllerManager!.addActionToUploadActionSheet("Annuler", style: .Cancel, handler: nil)
        self.alertControllerManager!.addActionToUploadActionSheet("Depuis mes photos et vidéos", style: .Default, handler: pickImageFromLibrary)
        self.alertControllerManager!.addActionToUploadActionSheet("Depuis l'appareil photo", style: .Default, handler: takeImageWithCamera)
    }
    
    func uploadOptions() {
        self.presentViewController(self.alertControllerManager!.uploadActionSheet, animated: true, completion: nil)
    }
}