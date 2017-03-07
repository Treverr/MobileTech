//
//  MasterTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class MasterTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        self.tableView.tableFooterView = view
        
        self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() == nil {
            let logInView = UIStoryboard(name: "Log In", bundle: nil).instantiateViewController(withIdentifier: "logInViewController")
            self.present(logInView, animated: true, completion: nil)
        }
    }
    
    func updateCellBadge(_ cellIdentifier : String, count : Int) {
        let cells = self.tableView.visibleCells
        var cellToBadge : UITableViewCell!
        
        for cell in cells {
            if cell.reuseIdentifier == cellIdentifier {
                cellToBadge = cell
            }
        }
        
        let indexPath = self.tableView.indexPath(for: cellToBadge)
        
        let label = UILabel()
        let fontSize : CGFloat = 14
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.red
        label.text = String(count)
        label.sizeToFit()
        
        var frame : CGRect = label.frame
        frame.size.height += (0.4 * fontSize)
        frame.size.width = (Int(label.text!) <= 9 ) ? frame.size.height : frame.size.width + fontSize
        label.frame = frame
        
        label.layer.cornerRadius = frame.size.height / 2.0
        label.clipsToBounds = true
        
        cellToBadge = self.tableView.cellForRow(at: indexPath!)
        print(cellToBadge)
        if count > 0 {
            cellToBadge.accessoryView = label
        } else {
            cellToBadge.accessoryView = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0) {
            cell.isSelected = true
        }
    }
    
}
