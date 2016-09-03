//
//  MyAssignedTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse

class MyAssignedTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var tapBGGesture = UITapGestureRecognizer()
    var workOrders = [WorkOrders]()
    var employee : Employee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if self.employee == nil {
            if PFUser.currentUser() != nil {
                PFUser.currentUser()?.objectForKey("employee")?.fetchIfNeededInBackgroundWithBlock({ (emp : PFObject?, error : NSError?) in
                    if error == nil {
                        self.employee = emp as! Employee
                        print(self.employee)
                        self.getAssignedOrders()
                    }
                })
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(MyAssignedTableViewController.settingsBGTapped(_:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return self.workOrders.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Priority"
        case 1:
            return "Assigned"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("assignedCell") as! MyAssignedTableViewCell
        
        cell.customerName.text! = self.workOrders[indexPath.row].customerName
        cell.address.text! = self.workOrders[indexPath.row].customerAddress
        
        
        return cell
    }
    
    func settingsBGTapped(sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            guard let presentedView = presentedViewController?.view else {
                return
            }
            if !CGRectContainsPoint(presentedView.bounds, sender.locationInView(presentedView)) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
            }
        }
    }
    
    func getAssignedOrders() {
        
        let userQuery = WorkOrders.query()
        userQuery!.whereKey("technicianPointer", equalTo: self.employee)
        userQuery!.whereKey("status", equalTo: "Assigned")
        
        let name = self.employee.firstName.capitalizedString + " " + self.employee.lastName.capitalizedString
        let nameQuery = WorkOrders.query()
        nameQuery!.whereKey("technician", equalTo: name)
        nameQuery!.whereKey("status", equalTo: "Assigned")
        
        PFQuery.orQueryWithSubqueries([userQuery!, nameQuery!]).findObjectsInBackgroundWithBlock { (results : [PFObject]?, error : NSError?) in
            if error == nil {
                self.workOrders = results! as! [WorkOrders]
                self.tableView.reloadData()
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewWillDisappear(animated: Bool) {
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }
}
