//
//  LogOutViewController.swift
//
//
//  Created by Trever on 8/31/16.
//
//

import UIKit
import Parse

class LogOutViewController: UIViewController {
    
    var timer : NSTimer?
    
    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error : NSError?) in
            if error == nil {
                let logInVC = UIStoryboard(name: "Log In", bundle: nil).instantiateViewControllerWithIdentifier("logInViewController")
                self.dismissViewControllerAnimated(true, completion: {
                    GlobalViewControllers.MyAssigned.workOrders = []
                    GlobalViewControllers.MyAssigned.presentViewController(logInVC, animated: true, completion: nil)
                })
            }
        }
    }
}
