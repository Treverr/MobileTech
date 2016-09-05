//
//  ServiceOrderDetailViewController.swift
//  MobileTech
//
//  Created by Trever on 9/3/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse

class ServiceOrderDetailViewController: UIViewController {
    
    var serviceObject : WorkOrders!
    
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var wtbpTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.customerName.text! = self.serviceObject.customerName
        self.phoneNumber.text! = self.serviceObject.customerPhone
        self.wtbpTextView.text = self.serviceObject.workToBePerformed
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openServiceMain(sender: AnyObject) {
        let checkForPrevious = ServiceObject.query()
        checkForPrevious?.whereKey("relatedWorkOrder", equalTo: self.serviceObject)
        checkForPrevious?.orderByDescending("createdAt")
        checkForPrevious?.findObjectsInBackgroundWithBlock({ (foundPrevious : [PFObject]?, error : NSError?) in
            if error == nil {
                if foundPrevious?.count == 0 {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewControllerWithIdentifier("serviceMain") as! ServiceMainViewController
                    vc.serviceOrderObject = ServiceObject()
                    print(self.serviceObject)
                    vc.workOrderObject = self.serviceObject
                    
                    self.presentViewController(vc, animated: true, completion: nil)
                } else {
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewControllerWithIdentifier("serviceMain") as! ServiceMainViewController
                    vc.serviceOrderObject = ServiceObject()
                    let previousObjs = foundPrevious as! [ServiceObject]
                    vc.serviceOrderObject.relatedService = previousObjs
                    vc.workOrderObject = self.serviceObject
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
