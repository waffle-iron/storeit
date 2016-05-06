//
//  ListView.swift
//  StoreIt
//
//  Created by Romain Gjura on 04/05/2016.
//  Copyright © 2016 Romain Gjura. All rights reserved.
//

import UIKit

class ListView: UITableViewController {
    
    var managers: AppDataManagers?
    
    let itemIdentifier = "Item"
    
    var items: [Int] = []
    var  i: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.hidesBackButton = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return createItemCellAtIndexPath(indexPath)
    }
    
    func createItemCellAtIndexPath(indexPath: NSIndexPath) -> Item {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(itemIdentifier) as! Item
        cell.test.text = "\(items[indexPath.row])"
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
    	//print("toto")
    }
    
    @IBAction func upload(sender: AnyObject) {
    	let newIndexPath = NSIndexPath(forRow: items.count, inSection: 0)

        i += 1
        self.items.append(i)
        
        print("SIZE: \(items.count)")

        self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
    }
}
