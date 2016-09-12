//
//  MainViewController.swift
//
//
//  Created by Trever on 8/27/16.
//
//

import UIKit
import CoreLocation

class ServiceMainViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var topDrawer: UIView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notesView: UIView!
    
    @IBOutlet weak var container: UIView!
    
    var floaterPanelViewController : FloatersViewController!
    
    var serviceOrderObject : ServiceObject!
    var workOrderObject : WorkOrders!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topDrawer.layer.shadowColor = UIColor.blackColor().CGColor
        topDrawer.layer.shadowOffset = CGSizeZero
        topDrawer.layer.shadowOpacity = 1
        topDrawer.layer.shadowRadius = 5
        
        self.customerName.text = self.workOrderObject.customerName
        self.customerPhone.text = self.workOrderObject.customerPhone
        self.customerAddress.text = self.workOrderObject.customerAddress
    
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet weak var notesTableView: UITableView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "floaters" {
            self.floaterPanelViewController = segue.destinationViewController as! FloatersViewController
            self.floaterPanelViewController.serviceObject = self.serviceOrderObject
            self.floaterPanelViewController.workOrderObject = self.workOrderObject
        }
        
        if segue.identifier == "save" {
            let destVC = segue.destinationViewController as! SaveButtonTableViewController
            destVC.floaterViewContoller = self.floaterPanelViewController
        }
    }
    
    @IBAction func shouldCloseService(segue : UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true) { 
            NSNotificationCenter.defaultCenter().postNotificationName("DismissAndRefreshAssigned", object: nil)
        }
    }
    

}