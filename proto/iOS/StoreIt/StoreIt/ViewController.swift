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

    //let nm = NetworkManager(host: "0.0.0.0", port: 7641);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*if (nm.client.isRunning) {
        	nm.client.start();
        }*/

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        
        //nm.client.join();
        
        // test scan dir and file type
        
        let path = "/Users/gjura_r/Desktop/aaa/"
        let fm = FileManager(path: path)
        //fm.getDirectoryContent(path)
        //fm.buildTree(fm.getDirectoryNestedContent())
        
        
        let test: File = File(path: "aaa/", unique_hash: "", metadata: "", chunks_hashes: [""], kind: 0, files: fm.buildTree("aaa/"))
        
        let rb: RequestBuilder = RequestBuilder()
        let request: String = rb.join("toto", port: 0, file: test)
        
        print(request)
        
        //NSLog(Mapper().toJSONString(test, prettyPrint: true)!)
        
        
        
        //print(content);
        /*for file in content {
            //print("\(file) \(fm.fileType(file).rawValue)");
            let url: NSURL = NSURL(fileURLWithPath: file)
            print(url.pathComponents)
        }*/
        
        // test json conversion
        
        /*let testFile = File(path: "path", unique_hash: "unique_hash", metadata: "metadata", chunks_hashes: ["chunks_hashes"], kind: -1, files: []);
        let testFile2 = File(path: "path", unique_hash: "unique_hash", metadata: "metadata", chunks_hashes: ["chunks_hashes"], kind: 999, files: [testFile]);
        let testJSON = Mapper().toJSONString(testFile2, prettyPrint: true);
        let file = Mapper<File>().map(testJSON);
        
        NSLog(testJSON!);*/
        
        // test login
        /*if (nm != nil) {
        	nm!.client?.read();
            nm!.client?.toto();
        }*/
        //print(nm.client.clientSocket!.closed);
    }

}

