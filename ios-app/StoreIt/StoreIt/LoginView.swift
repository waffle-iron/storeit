//
//  ViewController.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit
import ObjectMapper
import FBSDKLoginKit

// TODO: try to merged initGoogle and initFacebook

class LoginView: UIViewController, FBSDKLoginButtonDelegate {

    var managers: AppDataManagers = AppDataManagers()
    let plistManager: PListManager = PListManager()
    
    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureFacebook()
        
        let lastConnextionType = self.plistManager.getValueWithKey("connextionType")
        print("[LoginView] Last connexion type : \(lastConnextionType). Trying to auto log if possible...")
        
        if (lastConnextionType == ConnexionType.GOOGLE.rawValue) {
            self.initGoogle()
        } else if (lastConnextionType == ConnexionType.FACEBOOK.rawValue && FBSDKAccessToken.currentAccessToken() != nil) {
         	// TODO: check expiration of Facebook token
            self.initFacebook()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let tabBarController = segue.destinationViewController as! UITabBarController
        let navigationController = tabBarController.viewControllers![0] as! UINavigationController
        let listView = navigationController.viewControllers[0] as! StoreItSynchDirectoryView
        
        listView.navigationItem.title = self.managers.navigationManager!.rootDirTitle
        listView.managers = self.managers
    }
    
    func moveToTabBarController() {
        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    @IBAction func logoutSegue(segue: UIStoryboardSegue) {
        if (managers.connexionType! == ConnexionType.FACEBOOK) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else if (managers.connexionType! == ConnexionType.GOOGLE) {
            managers.connexionManager?.forgetTokens()
        }
        
        // TODO: send logout request
        
        self.managers.connexionType = nil
        self.managers.networkManager = nil
        self.managers.connexionManager = nil
        self.managers.fileManager = nil
        self.managers.navigationManager = nil
        
        self.plistManager.addValueForKey("connextionType", value: ConnexionType.NONE.rawValue)
    }
    
    // MARK: Login with Facebook
    
    func configureFacebook() {
        FBLoginButton.readPermissions = ["public_profile", "email"]
        FBLoginButton.delegate = self
    }
    
    func initFacebook() {
        if (self.managers.networkManager == nil) {
            self.managers.networkManager = NetworkManager(host: "localhost", port: 8001);
        }
        
        if (self.managers.fileManager == nil) {
            self.managers.fileManager = FileManager(path: "/Users/gjura_r/Desktop/demo/") // Path to synch dir
        }
        
        if (self.managers.navigationManager == nil) {
            self.managers.navigationManager = NavigationManager(rootDirTitle: "StoreIt", allItems: (self.managers.fileManager?.getSyncDirTree())!)
        }
        self.managers.connexionType = ConnexionType.FACEBOOK
        self.plistManager.addValueForKey("connextionType", value: ConnexionType.FACEBOOK.rawValue)
        self.performSegueWithIdentifier("StoreItSynchDirSegue", sender: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            self.managers.connexionType = nil
        }
        else if result.isCancelled {
            self.managers.connexionType = nil
        }
        else {
            if result.grantedPermissions.contains("email"){
               self.initFacebook()
            }
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        self.managers.connexionType = ConnexionType.FACEBOOK
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    // MARK: Login with Google
    
    func initGoogle() {
        if (self.managers.networkManager == nil) {
            self.managers.networkManager = NetworkManager(host: "localhost", port: 8001);
        }
        
        if (self.managers.connexionManager == nil) {
            self.managers.connexionType = ConnexionType.GOOGLE
            self.managers.connexionManager = ConnexionManager(connexionType: ConnexionType.GOOGLE)
            self.plistManager.addValueForKey("connextionType", value: ConnexionType.GOOGLE.rawValue)
        }
        
        if (self.managers.fileManager == nil) {
            self.managers.fileManager = FileManager(path: "/Users/gjura_r/Desktop/demo/") // Path to synch dir
        }
        
        if (self.managers.navigationManager == nil) {
            self.managers.navigationManager = NavigationManager(rootDirTitle: "StoreIt", allItems: (self.managers.fileManager?.getSyncDirTree())!)
        }
        
        self.managers.connexionManager?.authorize(self)
    }
    
    @IBAction func login(sender: AnyObject) {
		self.initGoogle()
    }

}

