//
//  SaveButtonTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse

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
    
    func save(status: String) {
        let objectToSave = ServiceObject()
        
        if self.floaterViewContoller.signatureImage != nil {
            let data : NSData = UIImagePNGRepresentation(self.floaterViewContoller.signatureImage!)!
            let imageFile = PFFile(name: "customerSignature.png", data: data)
            
            imageFile?.saveInBackgroundWithBlock({ (success : Bool, error : NSError?) in
                if error == nil && success {
                    objectToSave.customerSignature = imageFile!
                    objectToSave.saveInBackground()
                }
            })
        }
        
        if self.floaterViewContoller.parts.count != 0 {
            self.floaterViewContoller.workOrderObject.parts = self.floaterViewContoller.parts
        }
        
        objectToSave.relatedWorkOrder = self.floaterViewContoller.workOrderObject
        
        self.floaterViewContoller.workOrderObject.status = status
        self.floaterViewContoller.workOrderObject.saveInBackground()
        
        objectToSave.saveInBackgroundWithBlock { (success : Bool, error : NSError?) in
            if error == nil && success {
                self.performSegueWithIdentifier("closeService", sender: nil)
            }
        }
    }
    
    @IBAction func saveInProgress(sender: AnyObject) {
        self.save("In Progress")

    }
    
    @IBAction func saveAndComplete(sender: AnyObject) {
        self.save("Completed")
    }
    
}
