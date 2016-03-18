//
//  ViewController.swift
//  StoreIt
//
//  Created by Romain Gjura on 14/03/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: AnyObject) {
        let path = "/Users/gjura_r/Desktop/";
        let fm = FileManager(rootDir: path);
        let content = fm.getDirectoryContent();
        //print(content);
        for file in content {
            print(file + " " + "\(fm.fileType(file).rawValue)");
        }
    }

}

