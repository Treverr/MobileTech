//
//  NotesTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/28/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse

class NewNoteTableViewController: UITableViewController {
    
    var noteObject = NoteObject()
    var relatedObj : ServiceObject!
    var relatedWorkOrder : WorkOrders!
    var notes : [NoteObject]!
    
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var noteTitleRequiredView: UIView!
    @IBOutlet weak var noteContentRequiredView: UIView!

    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitleTextField.delegate = self
        noteTitleTextField.addTarget(self, action: #selector(NewNoteTableViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        noteTextView.delegate = self

    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let dateString = dateFormatter.stringFromDate(NSDate())
        
        let employee = PFUser.currentUser()?.objectForKey("employee") as! Employee
        let employeeName = employee.firstName + " " + employee.lastName
        
        self.noteObject.noteTitle = self.noteTitleTextField.text!
        self.noteObject.noteContent = self.noteTextView.text + "\n\n\n" + employeeName + " - " + dateString

        self.noteObject.relatedWorkOder = self.relatedWorkOrder
        
        if self.notes != nil {
            self.notes?.insert(self.noteObject, atIndex: 0)
        } else {
            self.notes = [self.noteObject]
        }
        
        self.noteObject.saveEventually()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateNotesNotificaiton", object: self.notes)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidChange(textField : UITextField) {
        if textField == noteTitleTextField {
            if !noteTitleTextField.text!.isEmpty {
                noteTitleRequiredView.hidden = true
            } else {
                noteTitleRequiredView.hidden = false
            }
        }
    }
}

extension NewNoteTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == noteTitleTextField {
            self.noteTextView.becomeFirstResponder()
        }
        
        return true
    }
    
}

extension NewNoteTableViewController : UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        if textView == noteTextView {
            if !noteTextView.text.isEmpty {
                noteContentRequiredView.hidden = true
            } else {
                noteContentRequiredView.hidden = false
            }
        }
    }
    
    
    
}
