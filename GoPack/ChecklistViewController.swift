//
//  ViewController.swift
//  GoPack
//
//  Created by Hu Chen on 1/12/15.
//  Copyright © 2015 Hu Chen. All rights reserved.
//

import UIKit
import MaterialKit

class ChecklistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: FabButton!

    let items = [
        Item(title: "test title", note: nil, status: .Active),
        Item(title: "test long long title with some long text and it should be long", note: "test long long title with some long text and it should be long", status: .Hidden),
        Item(title: "Battery", note: nil, status: .Completed),
        Item(title: "good stuff", note: nil, status: .Active),
        Item(title: "test title", note: nil, status: .Active),
        Item(title: "test long long title with some long text and it should be long", note: "test long long title with some long text and it should be long", status: .Hidden),
        Item(title: "Battery", note: nil, status: .Completed),
        Item(title: "good stuff", note: nil, status: .Active),
        Item(title: "test title", note: nil, status: .Active),
        Item(title: "test long long title with some long text and it should be long", note: "test long long title with some long text and it should be long", status: .Hidden),
        Item(title: "Battery", note: nil, status: .Completed),
        Item(title: "good stuff", note: nil, status: .Active)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ChecklistViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(_tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ChecklistViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let checklistItemCell = cell as? ChecklistItemCell {
            checklistItemCell.item = items[indexPath.row]
        }
        
        return cell
    }
}

