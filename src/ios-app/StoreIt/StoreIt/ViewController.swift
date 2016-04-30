//
//  ViewController.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit
import ObjectMapper

class ViewController: UIViewController {

    let nm = NetworkManager(host: "0.0.0.0", port: 7641);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if (nm.client.isRunning) {
        	nm.client.start();
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        
        let path = "/Users/gjura_r/Desktop/aaa/"
        let fm = FileManager(path: path)
        
        let toto: File = File(path: path, unique_hash: "0", metadata: "0", chunks_hashes: [""], kind: 0, files: fm.buildTree("aaa/"))
        nm.client.join("cli1", hosted_hashes: [], file: toto)
        
        //NSLog(Mapper().toJSONString(test, prettyPrint: true)!)
    }

}

