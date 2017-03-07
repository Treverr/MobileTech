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
        noteTitleTextField.addTarget(self, action: #selector(NewNoteTableViewController.textFieldDidChange(_:)), for: .editingChanged)
        noteTextView.delegate = self

    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: Date())
        
        let employee = PFUser.current()?.object(forKey: "employee") as! Employee
        let employeeName = employee.firstName + " " + employee.lastName
        
        self.noteObject.noteTitle = self.noteTitleTextField.text!
        self.noteObject.noteContent = self.noteTextView.text + "\n\n\n" + employeeName + " - " + dateString

        self.noteObject.relatedWorkOder = self.relatedWorkOrder
        
        if self.notes != nil {
            self.notes?.insert(self.noteObject, at: 0)
        } else {
            self.notes = [self.noteObject]
        }
        
        self.noteObject.saveEventually()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateNotesNotificaiton"), object: self.notes)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidChange(_ textField : UITextField) {
        if textField == noteTitleTextField {
            if !noteTitleTextField.text!.isEmpty {
                noteTitleRequiredView.isHidden = true
            } else {
                noteTitleRequiredView.isHidden = false
            }
        }
    }
}

extension NewNoteTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == noteTitleTextField {
            self.noteTextView.becomeFirstResponder()
        }
        
        return true
    }
    
}

extension NewNoteTableViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == noteTextView {
            if !noteTextView.text.isEmpty {
                noteContentRequiredView.isHidden = true
            } else {
                noteContentRequiredView.isHidden = false
            }
        }
    }
    
    
    
}
