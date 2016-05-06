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

    //let nm = NetworkManagervarst: "localhost", port: 8001);
    var isLogged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func login(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if (appDelegate.connexionManger == nil) {
        	appDelegate.connexionManger = ConnexionManager(connexionType: ConnexionType.GOOGLE)
        }

        appDelegate.connexionManger?.forgetTokens() // forget tokens to display authorization screen
        
        appDelegate.connexionManger?.authorize(self)
        
        
        //if (nm.client.isConnected()) {
        //    nm.client.join()
        //}
        
        /*let path = "/Users/gjura_r/Desktop/aaa/"
         let fm = FileManager(path: path)
         
         let toto: File = File(path: path, unique_hash: "0", metadata: "0", chunks_hashes: [""], kind: 0, files: fm.buildTree("aaa/"))
         nm.client.join("cli1", hosted_hashes: [], file: toto)
         */
        //NSLog(Mapper().toJSONString(test, prettyPrint: true)!)
    }

}

