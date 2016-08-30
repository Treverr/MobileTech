//
//  MainViewController.swift
//
//
//  Created by Trever on 8/27/16.
//
//

import UIKit

class ServiceMainViewController: UIViewController {
    
    @IBOutlet weak var topDrawer: UIView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    
    @IBOutlet weak var notesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topDrawer.layer.shadowColor = UIColor.blackColor().CGColor
        topDrawer.layer.shadowOffset = CGSizeZero
        topDrawer.layer.shadowOpacity = 1
        topDrawer.layer.shadowRadius = 5
        topDrawer.layer.shadowPath = UIBezierPath(rect: topDrawer.bounds).CGPath
        
        customerName.text = "Customer Name"
        customerPhone.text = "(123) 456-7890"
        customerAddress.text = "2225 N. 25th St.\nTerre Haute, IN 47804"
    
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet weak var notesTableView: UITableView!
    
    
    
}