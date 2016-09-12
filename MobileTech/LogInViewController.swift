//
//  LogInViewController.swift
//  MobileTech
//
//  Created by Trever on 8/31/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class LogInViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sparkleConnect: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var activeField = UITextField()
    var hasKeyboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sparkleConnect.delegate = self
        self.password.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogInViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogInViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LogInViewController.QRLogIn(_:)), name: "QRLogIn", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo
        let keyboardFrame = info![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboard = self.view.convertRect(keyboardFrame!, fromView: self.view.window)
        let height = self.view.frame.size.height
        let toolbarHeight = height - keyboard.origin.y
        
        if ((keyboard.origin.y + keyboard.size.height) > height) {
            self.hasKeyboard = true
        }
        
        if hasKeyboard {
            let contentInset = UIEdgeInsetsMake(0, 0, toolbarHeight, 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            
            self.scrollView.scrollRectToVisible(self.password.frame, animated: true)
        } else {
            let contentInset = UIEdgeInsetsMake(0, 0, keyboard.height, 0)
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
            self.scrollView.scrollRectToVisible(self.password.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentinset = UIEdgeInsetsZero
        scrollView.contentInset = contentinset
        scrollView.scrollIndicatorInsets = contentinset
    }
    
    @IBAction func qrAction(sender: AnyObject) {
        
    }
    
    @IBAction func QRLogIn(notification : NSNotification) {
        let barcode = notification.object as! String
        let barcodeArray = barcode.componentsSeparatedByString(" ")
        self.sparkleConnect.text = barcodeArray[0]
        self.password.text = barcodeArray[1]
        self.logIn()
    }
    
    func logIn() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
        if !self.sparkleConnect.text!.isEmpty && !self.password.text!.isEmpty {
            
            self.sparkleConnectAnimation()
            
            PFUser.logInWithUsernameInBackground(self.sparkleConnect.text!, password: self.password.text!, block: { (user : PFUser?, error : NSError?) in
                if error == nil && user != nil {
                    self.loadingUI.stopAnimation()
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
            
        } else if self.password.text!.isEmpty && self.sparkleConnect.text!.isEmpty {
            alert.title = "SparkleConnect & password Required"
            alert.message = "A SparkleConnect and Password is required to log in."
            let okayButton = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
                self.sparkleConnect.becomeFirstResponder()
            })
            alert.addAction(okayButton)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if self.sparkleConnect.text!.isEmpty {
            alert.title = "SparkleConnect Required"
            alert.message = "A SparkleConnect is required to log in."
            let okayButton = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
                self.sparkleConnect.becomeFirstResponder()
            })
            alert.addAction(okayButton)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if self.password.text!.isEmpty {
            alert.title = "Password Required"
            alert.message = "Password is required to log in."
            let okayButton = UIAlertAction(title: "Okay", style: .Default, handler: { (action) in
                self.password.becomeFirstResponder()
            })
            alert.addAction(okayButton)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signInButton(sender: AnyObject) {
        if self.password.isFirstResponder() {
            self.password.resignFirstResponder()
        }
        if self.sparkleConnect.isFirstResponder() {
            self.sparkleConnect.resignFirstResponder()
        }
        self.logIn()
    }
    
    var loadingUI : NVActivityIndicatorView!
    var loadingBackground = UIView()
    var label = UILabel()
    
    func sparkleConnectAnimation() {
        let screenSize = UIScreen.mainScreen().bounds.size
        let x = (screenSize.width / 2)
        let y = (screenSize.height / 2)
        
        self.loadingBackground.backgroundColor = UIColor.blackColor()
        self.loadingBackground.frame = CGRectMake(0, 0, 300, 125)
        self.loadingBackground.center = CGPointMake(x, y - 100)
        self.loadingBackground.layer.cornerRadius = 5
        self.loadingBackground.layer.opacity = 0.75
        
        self.loadingUI = NVActivityIndicatorView(frame: CGRectMake(x, y, 100, 50))
        self.loadingUI.center = self.loadingBackground.center
        
        label.frame = loadingBackground.frame
        label.center = CGPointMake(self.loadingBackground.center.x, self.loadingBackground.center.y + 35)
        label.text = "Authenticating with SparkleConnect...."
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        self.view.addSubview(loadingBackground)
        self.view.addSubview(loadingUI)
        self.view.addSubview(label)
        
        loadingUI.type = .BallBeat
        loadingUI.color = UIColor.whiteColor()
        loadingUI.startAnimation()
        
    }
    
}

extension LogInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == password {
            textField.resignFirstResponder()
            self.logIn()
            return true
        }
        
        if textField == sparkleConnect {
            password.becomeFirstResponder()
            return true
        }
        
        return true
    }
    
    
}
