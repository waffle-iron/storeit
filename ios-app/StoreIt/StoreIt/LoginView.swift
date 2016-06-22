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
    
    var connectionType: ConnectionType? = nil
    var networkManager: NetworkManager? = nil
    var connectionManager: ConnectionManager? = nil
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
        
        let lastConnexionType = self.plistManager?.getValueWithKey("connextionType")
        print("[LoginView] Last connexion type : \(lastConnexionType). Trying to auto log if possible...")
        
        if (lastConnexionType == ConnectionType.GOOGLE.rawValue) {
            self.initGoogle()
        } else if (lastConnexionType == ConnectionType.FACEBOOK.rawValue && FBSDKAccessToken.currentAccessToken() != nil) {
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
        
        listView.connectionType = self.connectionType
        listView.networkManager = self.networkManager
        listView.connectionManager = self.connectionManager
        listView.fileManager = self.fileManager
        listView.navigationManager = self.navigationManager
    }
    
    func moveToTabBarController() {
        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        self.presentViewController(tabBarController, animated: true, completion: nil)
    }
    
    func logout() {
        if (self.connectionType != nil && self.connectionType! == ConnectionType.FACEBOOK) {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
        } else if (self.connectionType != nil && self.connectionType! == ConnectionType.GOOGLE) {
            self.connectionManager?.forgetTokens()
        }
        
        // TODO: send logout request
        
        self.connectionType = nil
        self.networkManager = nil
        self.connectionManager = nil
        self.fileManager = nil
        self.navigationManager = nil
        
        self.plistManager?.addValueForKey("connextionType", value: ConnectionType.NONE.rawValue)
    }
    
    @IBAction func logoutSegue(segue: UIStoryboardSegue) {
		self.logout()
    }
    
    func initConnexion(host: String, port: Int, path: String) {
    	if (self.networkManager == nil) {
        	self.networkManager = NetworkManager(host: host, port: port);
    	}
        
        if (self.fileManager == nil) {
            self.fileManager = FileManager(path: path) // Path to local synch dir
        }
        
        if (self.navigationManager == nil) {
            self.navigationManager = NavigationManager(rootDirTitle: "StoreIt",
                                                       allItems: (self.fileManager?.getSyncDirTree())!)
        }
    }
    
    // MARK: Login with Facebook
    
    func configureFacebook() {
        FBLoginButton.readPermissions = ["public_profile", "email"]
        FBLoginButton.delegate = self
    }
    
    func initFacebook() {
        self.initConnexion("localhost", port: 7641, path: "/Users/gjura_r/Desktop/demo/")
        self.connectionType = ConnectionType.FACEBOOK
        self.plistManager?.addValueForKey("connextionType", value: ConnectionType.FACEBOOK.rawValue)
        
        self.performSegueWithIdentifier("StoreItSynchDirSegue", sender: nil)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if ((error) != nil) {
            self.logout()
        }
        else if result.isCancelled {
            self.logout()
        }
        else {
            if result.grantedPermissions.contains("email"){
               self.initFacebook()
            }
        }
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        self.connectionType = ConnectionType.FACEBOOK
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.logout()
    }
    
    // MARK: Login with Google
    
    func initGoogle() {
        if (self.connectionManager == nil) {
            self.connectionType = ConnectionType.GOOGLE
            self.connectionManager = ConnectionManager(connectionType: ConnectionType.GOOGLE)
            self.plistManager?.addValueForKey("connextionType", value: ConnectionType.GOOGLE.rawValue)
        }

        self.connectionManager?.authorize(self)
    }
    
    @IBAction func login(sender: AnyObject) {
		self.initGoogle()
    }

}

