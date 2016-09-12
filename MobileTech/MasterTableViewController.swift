//
//  MasterTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse

class MasterTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        self.tableView.tableFooterView = view
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: .None)
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() == nil {
            let logInView = UIStoryboard(name: "Log In", bundle: nil).instantiateViewControllerWithIdentifier("logInViewController")
            self.presentViewController(logInView, animated: true, completion: nil)
        }
    }
    
    func updateCellBadge(cellIdentifier : String, count : Int) {
        let cells = self.tableView.visibleCells
        var cellToBadge : UITableViewCell!
        
        for cell in cells {
            if cell.reuseIdentifier == cellIdentifier {
                cellToBadge = cell
            }
        }
        
        let indexPath = self.tableView.indexPathForCell(cellToBadge)
        
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
        
        cellToBadge = self.tableView.cellForRowAtIndexPath(indexPath!)
        print(cellToBadge)
        if count > 0 {
            cellToBadge.accessoryView = label
        } else {
            cellToBadge.accessoryType = .None
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            cell.selected = true
        }
    }
    
}
