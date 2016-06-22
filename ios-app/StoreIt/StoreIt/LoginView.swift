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
    
    var connexionType: ConnexionType? = nil
    var networkManager: NetworkManager? = nil
    var connexionManager: ConnexionManager? = nil
    var fileManager: FileManager? = nil
    var navigationManager: NavigationManager? = nil
    var plistManager: PListManager? = nil
    
    @IBOutlet weak var FBLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureFacebook()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidLoad()
        
        self.configureFacebook()
        
        let lastConnextionType = self.plistManager?.getValueWithKey("connextionType")
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
        
        listView.navigationItem.title = self.navigationManager?.rootDirTitle
        
        listView.connexionType = self.connexionType
        listView.networkManager = self.networkManager
        listView.connexionManager = self.connexionManager
        listView.fileManager = self.fileManager
        listView.navigationManager = self.navigationManager
    }
    
    func moveToTabBarController() {
        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    @IBAction func logoutSegue(segue: UIStoryboardSegue) {
        if (self.connexionType != nil && self.connexionType! == ConnexionType.FACEBOOK) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else if (self.connexionType != nil && self.connexionType! == ConnexionType.GOOGLE) {
            self.connexionManager?.forgetTokens()
        }
        
        // TODO: send logout request
        
         self.connexionType = nil
         self.networkManager = nil
         self.connexionManager = nil
         self.fileManager = nil
         self.navigationManager = nil
        
        self.plistManager?.addValueForKey("connextionType", value: ConnexionType.NONE.rawValue)
    }
    
    // MARK: Login with Facebook
    
    func configureFacebook() {
        FBLoginButton.readPermissions = ["public_profile", "email"]
        FBLoginButton.delegate = self
    }
    
    func initFacebook() {
        if (self.networkManager == nil) {
            self.networkManager = NetworkManager(host: "localhost", port: 8001);
        }
        
        if (self.fileManager == nil) {
            self.fileManager = FileManager(path: "/Users/gjura_r/Desktop/demo/") // Path to synch dir
        }
        
        if (self.navigationManager == nil) {
            self.navigationManager = NavigationManager(rootDirTitle: "StoreIt", allItems: (self.fileManager?.getSyncDirTree())!)
        }
        self.connexionType = ConnexionType.FACEBOOK
        self.plistManager?.addValueForKey("connextionType", value: ConnexionType.FACEBOOK.rawValue)
        self.performSegueWithIdentifier("StoreItSynchDirSegue", sender: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            self.connexionType = nil
        }
        else if result.isCancelled {
            self.connexionType = nil
        }
        else {
            if result.grantedPermissions.contains("email"){
               self.initFacebook()
            }
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        self.connexionType = ConnexionType.FACEBOOK
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    // MARK: Login with Google
    
    func initGoogle() {
        if (self.networkManager == nil) {
            self.networkManager = NetworkManager(host: "localhost", port: 7641);
        }
        
        if (self.connexionManager == nil) {
            self.connexionType = ConnexionType.GOOGLE
            self.connexionManager = ConnexionManager(connexionType: ConnexionType.GOOGLE)
            self.plistManager?.addValueForKey("connextionType", value: ConnexionType.GOOGLE.rawValue)
        }
        
        if (self.fileManager == nil) {
            self.fileManager = FileManager(path: "/Users/gjura_r/Desktop/demo/") // Path to synch dir
        }
        
        if (self.navigationManager == nil) {
            self.navigationManager = NavigationManager(rootDirTitle: "StoreIt", allItems: (self.fileManager?.getSyncDirTree())!)
        }
        
        self.connexionManager?.authorize(self)
    }
    
    @IBAction func login(sender: AnyObject) {
		self.initGoogle()
    }

}

