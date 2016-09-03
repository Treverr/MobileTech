//
//  SaveButtonTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit

class SaveButtonTableViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveAndComplete: UIButton!
    
    var floaterViewContoller : FloatersViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView.reloadData()
        preferredContentSize.height = self.tableView.contentSize.height
        
        if floaterViewContoller.signatureImage == nil && floaterViewContoller.overrideSignature.selected == false {
            self.saveAndComplete.tintColor = UIColor.grayColor()
            self.saveAndComplete.userInteractionEnabled = false
        }
        
        if floaterViewContoller.signatureImage != nil && floaterViewContoller.noteAdded == true {
            self.saveButton.tintColor = UIColor.grayColor()
            self.saveButton.userInteractionEnabled = false
        }
        
        if (floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.selected == true) && floaterViewContoller.noteAdded == true {
            self.saveButton.tintColor = UIColor.grayColor()
            self.saveButton.userInteractionEnabled = false
        }
        
        if floaterViewContoller.noteAdded == false {
            self.saveAndComplete.tintColor = UIColor.grayColor()
            self.saveAndComplete.userInteractionEnabled = false
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String = "Missing Required Fields:\n"
        
        if floaterViewContoller.signatureImage == nil && floaterViewContoller.overrideSignature.selected == false {
            title += "     • Customer Signature\n"
        }
        
        if floaterViewContoller.noteAdded == false {
            title += "     • Notes\n"
        }
        
        print((floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.selected == true), floaterViewContoller.noteAdded == true)
        if (floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.selected == true) && floaterViewContoller.noteAdded == true {
            title = ""
        }
        
        return title
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.selected == true) && floaterViewContoller.noteAdded == true {
            return 10
        } else {
            return self.tableView.sectionHeaderHeight
        }
    }
    
    @IBAction func saveInProgress(sender: AnyObject) {
        let objectToSave = ServiceObject()
        
        if self.floaterViewContoller.signatureImage != nil {
            objectToSave.customerSignature = self.floaterViewContoller.signatureImage
        }
        
        if self.floaterViewContoller.serviceObject.parts != nil {
            objectToSave.parts = self.floaterViewContoller.serviceObject.parts
        }
        
        objectToSave.relatedWorkOrder = self.floaterViewContoller.workOrderObject
        
        objectToSave.saveInBackgroundWithBlock { (success : Bool, error : NSError?) in
            if error == nil && success {
                self.floaterViewContoller.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    @IBAction func saveAndComplete(sender: AnyObject) {
        self.performSegueWithIdentifier("closeService", sender: nil)
        self.dismissViewControllerAnimated(true) {
        }
    }
    
}