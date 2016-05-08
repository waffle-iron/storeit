//
//  ViewController.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit
import ObjectMapper
import p2_OAuth2

class LoginView: UIViewController {

    var managers: AppDataManagers = AppDataManagers()
    var isLogged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managers.networkManager = NetworkManager(host: "localhost", port: 8001);
        managers.fileManager = FileManager(path: "/Users/gjura_r/Desktop/aaa/") // Path to synch dir
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
        let listView = (segue.destinationViewController as! ListView)
        listView.managers = self.managers
    }
    
    @IBAction func login(sender: AnyObject) {
        
        if (managers.connexionManager == nil) {
            managers.connexionManager = ConnexionManager(connexionType: ConnexionType.GOOGLE)
        }
        
        managers.connexionManager?.forgetTokens() // forget tokens to display authorization screen
        managers.connexionManager?.authorize(self)
    }

}

