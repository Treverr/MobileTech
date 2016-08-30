//
//  NotesTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/28/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit

class NewNoteTableViewController: UITableViewController {
    
    var noteObject = NoteObject()
    var relatedObj : ServiceObject!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteTitleRequiredView: UIView!
    @IBOutlet weak var noteContentRequiredView: UIView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(NSDate())
        
        self.noteObject.noteTitle = self.noteTitleTextField.text!
        self.noteObject.noteContent = self.noteTextView.text + "\n\n\n" + "Employee Name" + " - " + dateString

        
        self.noteObject.relatedService = self.relatedObj
        
        if self.relatedObj.notes != nil {
            self.relatedObj.notes?.append(self.noteObject)
        } else {
            self.relatedObj.notes = [self.noteObject]
        }
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateNotesNotificaiton", object: self.relatedObj)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
