//
//  MasterTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        self.tableView.tableFooterView = view
        

    }
    
    override func viewDidAppear(animated: Bool) {
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        updateCellBadge(cell!, count: 14)
    }
    
    func updateCellBadge(cell : UITableViewCell, count : Int) {
        var cell : UITableViewCell!
        
        let label = UILabel()
        let fontSize : CGFloat = 14
        label.font = UIFont.systemFontOfSize(fontSize)
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.redColor()
        label.text = String(count)
        label.sizeToFit()
        
        var frame : CGRect = label.frame
        frame.size.height += (0.4 * fontSize)
        frame.size.width = (Int(label.text!) <= 9 ) ? frame.size.height : frame.size.width + fontSize
        label.frame = frame
        
        label.layer.cornerRadius = frame.size.height / 2.0
        label.clipsToBounds = true
        
        cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
        cell.accessoryType = .None
        cell.accessoryView = label
        
    }

}
