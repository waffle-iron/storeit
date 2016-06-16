//
//  ViewController.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginView: UIViewController, FBSDKLoginButtonDelegate {

    var managers: AppDataManagers = AppDataManagers()
    var isLogged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: If token exists, maybe move to the next view
        
        // forget tokens / logout to display authorization screen (for demonstration purpose)
        managers.connexionManager?.forgetTokens()
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        }
        //
        
        self.addFBStylizedButton()
        
        managers.networkManager = NetworkManager(host: "localhost", port: 8001);
        managers.fileManager = FileManager(path: "/Users/gjura_r/Desktop/demo/") // Path to synch dir
    }

    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let listView = (segue.destinationViewController as! StoreItSynchDirectoryView)
        
        listView.navigationItem.title = self.managers.navigationManager!.rootDirTitle
        listView.managers = self.managers
    }
    
    // MARK: Login with Facebook
    
    func addFBStylizedButton() {
        let FB_Button : FBSDKLoginButton = FBSDKLoginButton()
        
        self.view.addSubview(FB_Button)
        FB_Button.center = self.view.center
        FB_Button.readPermissions = ["public_profile", "email", "user_friends"]
        FB_Button.delegate = self

    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            managers.connexionType = nil
        }
        else if result.isCancelled {
            managers.connexionType = nil
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                if (managers.navigationManager == nil) {
                    managers.navigationManager = NavigationManager(rootDirTitle: "StoreIt", allItems: (self.managers.fileManager?.getSyncDirTree())!)
                }
                
                self.isLogged = true
                self.performSegueWithIdentifier("storeitSynchDirSegue", sender: nil)
            }
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        managers.connexionType = ConnexionType.FACEBOOK
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    // MARK: Login with Google
    
    @IBAction func login(sender: AnyObject) {
        
        if (managers.connexionManager == nil) {
            self.managers.connexionType = ConnexionType.GOOGLE
            managers.connexionManager = ConnexionManager(connexionType: ConnexionType.GOOGLE)
        }
        
        if (managers.navigationManager == nil) {
            managers.navigationManager = NavigationManager(rootDirTitle: "StoreIt", allItems: (self.managers.fileManager?.getSyncDirTree())!)
        }
        
        managers.connexionManager?.authorize(self)
    }

}

