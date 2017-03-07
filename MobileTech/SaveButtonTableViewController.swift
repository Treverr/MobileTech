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
        
        if floaterViewContoller.signatureImage == nil && floaterViewContoller.overrideSignature.isSelected == false {
            self.saveAndComplete.tintColor = UIColor.gray
            self.saveAndComplete.isUserInteractionEnabled = false
        }
        
        if floaterViewContoller.signatureImage != nil && floaterViewContoller.noteAdded == true {
            self.saveButton.tintColor = UIColor.gray
            self.saveButton.isUserInteractionEnabled = false
        }
        
        if (floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.isSelected == true) && floaterViewContoller.noteAdded == true {
            self.saveButton.tintColor = UIColor.gray
            self.saveButton.isUserInteractionEnabled = false
        }
        
        if floaterViewContoller.noteAdded == false {
            self.saveAndComplete.tintColor = UIColor.gray
            self.saveAndComplete.isUserInteractionEnabled = false
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title : String = "Missing Required Fields:\n"
        
        if floaterViewContoller.signatureImage == nil && floaterViewContoller.overrideSignature.isSelected == false {
            title += "     • Customer Signature\n"
        }
        
        if floaterViewContoller.noteAdded == false {
            title += "     • Notes\n"
        }
        
        print((floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.isSelected == true), floaterViewContoller.noteAdded == true)
        if (floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.isSelected == true) && floaterViewContoller.noteAdded == true {
            title = ""
        }
        
        return title
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (floaterViewContoller.signatureImage != nil || floaterViewContoller.overrideSignature.isSelected == true) && floaterViewContoller.noteAdded == true {
            return 10
        } else {
            return self.tableView.sectionHeaderHeight
        }
    }
    
    func save(_ status: String) {
        let objectToSave = ServiceObject()
        
        if self.floaterViewContoller.signatureImage != nil {
            let data : Data = UIImagePNGRepresentation(self.floaterViewContoller.signatureImage!)!
            let imageFile = PFFile(name: "customerSignature.png", data: data)
                        
            imageFile?.saveInBackground(block: { (success, error) in
                    objectToSave.customerSignature = imageFile!
                    objectToSave.saveEventually()
            })
        }
        
        if self.floaterViewContoller.parts.count != 0 {
            self.floaterViewContoller.workOrderObject.parts = self.floaterViewContoller.parts as NSArray?
        }
        
        objectToSave.relatedWorkOrder = self.floaterViewContoller.workOrderObject
        
        self.floaterViewContoller.workOrderObject.status = status
        self.floaterViewContoller.workOrderObject.saveEventually()
        
        objectToSave.saveEventually()
        self.performSegue(withIdentifier: "closeService", sender: nil)

    }
    
    @IBAction func saveInProgress(_ sender: AnyObject) {
        self.save("In Progress")

    }
    
    @IBAction func saveAndComplete(_ sender: AnyObject) {
        self.save("Completed")
    }
    
}
