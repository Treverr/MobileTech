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
        
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LogInViewController.QRLogIn(_:)), name: NSNotification.Name(rawValue: "QRLogIn"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let info = notification.userInfo
        let keyboardFrame = (info![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboard = self.view.convert(keyboardFrame!, from: self.view.window)
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
    
    func keyboardWillHide(_ notification: Notification) {
        let contentinset = UIEdgeInsets.zero
        scrollView.contentInset = contentinset
        scrollView.scrollIndicatorInsets = contentinset
    }
    
    @IBAction func qrAction(_ sender: AnyObject) {
        
    }
    
    @IBAction func QRLogIn(_ notification : AnyObject) {
        let code = notification.object
        let userPass = (code! as AnyObject).components(separatedBy: " ")
        let user = userPass[0]
        let pass = userPass[1]
        self.sparkleConnect.text = user
        self.password.text = pass
        self.logIn()
    }
    
    func logIn() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if !self.sparkleConnect.text!.isEmpty && !self.password.text!.isEmpty {
            
            self.sparkleConnectAnimation()
            
            PFUser.logInWithUsername(inBackground: self.sparkleConnect.text!, password: self.password.text!, block: { (user, error) in
                if error == nil && user != nil {
                    self.loadingUI.stopAnimating()
                    self.dismiss(animated: true, completion: {
                        let cal = Calendar.current
                        let startOfTomorrow = cal.startOfDay(for: Date().addingTimeInterval(60*60*24*1))
                        UserDefaults.standard.set(startOfTomorrow, forKey: "autoLogOutDate")
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "DismissAndRefreshAssigned"), object: nil)
                    })
                } else if error != nil {
                    let errorCode = error as! NSError
                    switch errorCode.code {
                    case 101:
                        self.loadingUI.stopAnimating()
                        self.loadingBackground.removeFromSuperview()
                        self.label.removeFromSuperview()
                        
                        let errorAlert = UIAlertController(title: "Invalid Username or Password", message: "Please try again.", preferredStyle: .alert)
                        let okayButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        errorAlert.addAction(okayButton)
                        self.present(errorAlert, animated: true, completion: nil)
                    default:
                        break
                    }
                }
            })
            
        } else if self.password.text!.isEmpty && self.sparkleConnect.text!.isEmpty {
            alert.title = "SparkleConnect & password Required"
            alert.message = "A SparkleConnect and Password is required to log in."
            let okayButton = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.sparkleConnect.becomeFirstResponder()
            })
            alert.addAction(okayButton)
            self.present(alert, animated: true, completion: nil)
        } else if self.sparkleConnect.text!.isEmpty {
            alert.title = "SparkleConnect Required"
            alert.message = "A SparkleConnect is required to log in."
            let okayButton = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.sparkleConnect.becomeFirstResponder()
            })
            alert.addAction(okayButton)
            self.present(alert, animated: true, completion: nil)
        } else if self.password.text!.isEmpty {
            alert.title = "Password Required"
            alert.message = "Password is required to log in."
            let okayButton = UIAlertAction(title: "Okay", style: .default, handler: { (action) in
                self.password.becomeFirstResponder()
            })
            alert.addAction(okayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signInButton(_ sender: AnyObject) {
        if self.password.isFirstResponder {
            self.password.resignFirstResponder()
        }
        if self.sparkleConnect.isFirstResponder {
            self.sparkleConnect.resignFirstResponder()
        }
        self.logIn()
    }
    
    var loadingUI : NVActivityIndicatorView!
    var loadingBackground = UIView()
    var label = UILabel()
    
    func sparkleConnectAnimation() {
        let screenSize = UIScreen.main.bounds.size
        let x = (screenSize.width / 2)
        let y = (screenSize.height / 2)
        
        self.loadingBackground.backgroundColor = UIColor.black
        self.loadingBackground.frame = CGRect(x: 0, y: 0, width: 300, height: 125)
        self.loadingBackground.center = CGPoint(x: x, y: y - 100)
        self.loadingBackground.layer.cornerRadius = 5
        self.loadingBackground.layer.opacity = 0.75
        
        self.loadingUI = NVActivityIndicatorView(frame: CGRect(x: x, y: y, width: 100, height: 50))
        self.loadingUI.center = self.loadingBackground.center
        
        label.frame = loadingBackground.frame
        label.center = CGPoint(x: self.loadingBackground.center.x, y: self.loadingBackground.center.y + 35)
        label.text = "Authenticating with SparkleConnect...."
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        self.view.addSubview(loadingBackground)
        self.view.addSubview(loadingUI)
        self.view.addSubview(label)
        
        loadingUI.type = .ballBeat
        loadingUI.color = UIColor.white
        loadingUI.startAnimating()
        
    }
    
}

extension LogInViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
