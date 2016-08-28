//
//  MainViewController.swift
//  
//
//  Created by Trever on 8/27/16.
//
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topDrawer: UIView!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerPhone: UILabel!
    @IBOutlet weak var customerAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        topDrawer.layer.shadowColor = UIColor.blackColor().CGColor
        topDrawer.layer.shadowOffset = CGSizeZero
        topDrawer.layer.shadowOpacity = 1
        topDrawer.layer.shadowRadius = 5
        topDrawer.layer.shadowPath = UIBezierPath(rect: topDrawer.bounds).CGPath
        
        customerName.text = "Robert Casad"
        customerPhone.text = "(812) 239-4599"
        customerAddress.text = "10009 S Turner Dr.\nRosedale, IN 47874"
    }

}
