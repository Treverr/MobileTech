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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topDrawer.layer.shadowColor = UIColor.blackColor().CGColor
        topDrawer.layer.shadowOffset = CGSizeZero
        topDrawer.layer.shadowOpacity = 1
        topDrawer.layer.shadowRadius = 5        
        customerName.text = "Customer Name"
        customerPhone.text = "(123) 456-7890"
        customerAddress.text = "2225 N. 25th St.\nTerre Haute, IN 47804"
    
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet weak var notesTableView: UITableView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "floaters" {
            self.floaterPanelViewController = segue.destinationViewController as! FloatersViewController
        }
        
        if segue.identifier == "save" {
            let destVC = segue.destinationViewController as! SaveButtonTableViewController
            destVC.floaterViewContoller = self.floaterPanelViewController
        }
    }
    
    @IBAction func shouldCloseService(segue : UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}