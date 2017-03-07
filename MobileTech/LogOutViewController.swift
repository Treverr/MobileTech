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
    
    var timer : Timer?
    
    @IBAction func logOutButton(_ sender: AnyObject) {
        PFUser.logOutInBackground { (error) in
            if error == nil {
                let logInVC = UIStoryboard(name: "Log In", bundle: nil).instantiateViewController(withIdentifier: "logInViewController")
                self.dismiss(animated: true, completion: {
                    GlobalViewControllers.MyAssigned.workOrders = []
                    GlobalViewControllers.MyAssigned.present(logInVC, animated: true, completion: nil)
                })
            }
        }
    }
}
