//
//  FloatersViewController.swift
//  MobileTech
//
//  Created by Trever on 8/28/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import SwiftSignatureView
import CoreLocation
import Parse

class FloatersViewController: UIViewController, CLLocationManagerDelegate {
    
    var serviceObject = ServiceObject()
    var workOrderObject = WorkOrders()
    
    // Notes Floater Panel
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var notesView: UIView!
    var noteAdded : Bool = false
    
    // Render Shadows
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet var roundedCorners: [UIView]!
    @IBOutlet weak var overrideSignature: UIButton!
    
    // Sig Floater Panel
    @IBOutlet weak var signaturePanel: SwiftSignatureView!
    @IBOutlet weak var sigCustomerName: UILabel!
    @IBOutlet weak var acceptSigButton: UIBarButtonItem!
    @IBOutlet weak var captureSignatureNavigationBar: UINavigationBar!
    @IBOutlet weak var captureSignatureNavigationItem: UINavigationItem!
    @IBOutlet weak var signatureView: UIView!
    @IBOutlet weak var signatureShadow: UIView!
    var signatureImage : UIImage?
    var notes : [NoteObject]?
    
    // Parts Floater Panels
    @IBOutlet weak var partsTableView: UITableView!
    var parts = [String]()
    
    // Parts Navigation Bar
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var partNavigationBar: UINavigationBar!
    @IBOutlet weak var partNavItem: UINavigationItem!
    var origEditButton : UIBarButtonItem!
    
    @IBOutlet weak var test: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FloatersViewController.updateNotes(_:)), name: "UpdateNotesNotificaiton", object: nil)
        
        self.acceptSigButton.tintColor = UIColor.grayColor()
        captureSignatureNavigationItem.rightBarButtonItem?.enabled = false
        
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        partsTableView.delegate = self
        partsTableView.dataSource = self
        
        signaturePanel.delegate = self
        signaturePanel.backgroundColor = UIColor.whiteColor()
        signaturePanel.strokeColor = UIColor.blueColor()
        signaturePanel.strokeAlpha = 1
        
        for view in shadowViews {
            view.layer.bounds = notesView.layer.bounds
            view.frame = notesView.frame
            view.layer.shadowOffset = CGSizeZero
            view.layer.shadowOpacity = 0.6
            view.layer.shadowRadius = 15
            view.layer.shadowPath = UIBezierPath(rect: notesView.bounds).CGPath
        }
        
        signatureShadow.layer.bounds = signatureView.layer.bounds
        signatureShadow.frame = signatureView.frame
        signatureShadow.layer.shadowOffset = CGSizeZero
        signatureShadow.layer.shadowOpacity = 0.6
        signatureShadow.layer.shadowRadius = 15
        signatureShadow.layer.shadowPath = UIBezierPath(rect: signatureView.bounds).CGPath
        
        for view in roundedCorners {
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
        }
        
        origEditButton = self.partNavItem.leftBarButtonItem
        
        self.sigCustomerName.text = self.workOrderObject.customerName
        
        if self.workOrderObject.parts != nil {
            self.parts = self.workOrderObject.parts as! [String]
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let notesQuery = NoteObject.query()
        notesQuery?.whereKey("relatedWorkOder", equalTo: self.workOrderObject)
        notesQuery?.orderByDescending("createdAt")
        notesQuery?.cachePolicy = .CacheThenNetwork
        notesQuery?.findObjectsInBackgroundWithBlock({ (foundNotes : [PFObject]?, error : NSError?) in
            if error == nil {
                self.notes = foundNotes as! [NoteObject]
                self.notesTableView.reloadData()
            }
        })
    }
    
    @IBAction func clearSignature(sender: AnyObject) {
        signaturePanel.clear()
        signatureImage = nil
        self.acceptSigButton.tintColor = UIColor.grayColor()
        self.acceptSigButton.enabled = false
    }
    
    @IBAction func acceptSigAction(sender: AnyObject) {
        self.signatureImage = signaturePanel.signature
        print(self.signatureImage)
        acceptSigButton.tintColor = UIColor.grayColor()
        captureSignatureNavigationItem.rightBarButtonItem?.enabled = false
        
        print("Captured")
    }
    
    func updateNotes(notification : NSNotification) {
        self.notes = notification.object as! [NoteObject]
        self.noteAdded = true
        self.notesTableView.reloadData()
    }
    
    @IBAction func overrideSignature(sender: AnyObject) {
        if overrideSignature.selected {
            self.overrideSignature.selected = false
        } else {
            self.overrideSignature.selected = true
        }
        
        self.clearSignature(self)
        
    }
    
    @IBAction func editButtonAction(sender: AnyObject) {
        if partsTableView.visibleCells.count > 1 {
            self.partsTableView.setEditing(true, animated: true)
            let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: nil, action: #selector(FloatersViewController.doneEditingParts))
            self.partNavItem.leftBarButtonItem = doneButton
        }
    }
    
    func doneEditingParts() {
        if partsTableView.editing {
            self.partsTableView.setEditing(false, animated: true)
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: nil, action: #selector(FloatersViewController.editButtonAction))
            self.partNavItem.leftBarButtonItem = editButton
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == partsTableView {
            self.partsTableView.beginUpdates()
            self.partsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            self.parts.removeAtIndex(indexPath.row - 1)
            self.partsTableView.endUpdates()
            print(self.parts)
        }
    }
    
}

extension FloatersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var number = 1
        
        if tableView == notesTableView {
            if self.notes != nil {
                number = self.notes!.count
            } else  {
                number = 0
            }
        }
        
        return number
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        
        if tableView == notesTableView {
            return 1
        }
        
        if tableView == partsTableView {
            number = self.parts.count + 1
        }
        
        return number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if tableView == notesTableView {
            cell = self.notesTableView.dequeueReusableCellWithIdentifier("notesCell") as UITableViewCell!
            cell.textLabel!.text = self.notes![indexPath.section].noteContent
        }
        
        if tableView == partsTableView {
            if indexPath.row == 0 {
                cell = self.partsTableView.dequeueReusableCellWithIdentifier("addPart")! as UITableViewCell
            }
            
            if indexPath.row > 0 {
                cell = self.partsTableView.dequeueReusableCellWithIdentifier("partsCell")! as UITableViewCell
                cell.textLabel?.text = self.parts[indexPath.row - 1]
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView == notesTableView {
            var title = ""
            
            if self.notes?[section].noteTitle != nil {
                title = self.notes![section].noteTitle
            }
            return title
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewNote" {
            let vc = segue.destinationViewController.childViewControllers.first as! NewNoteTableViewController
            vc.relatedObj = self.serviceObject
            vc.relatedWorkOrder = self.workOrderObject
            if self.notes != nil {
                vc.notes = self.notes!
            }
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == partsTableView {
            if indexPath.row == 0 {
                var text : String
                var partTextField = UITextField()
                let alert = UIAlertController(title: "Add Part", message: nil, preferredStyle: .Alert)
                alert.addTextFieldWithConfigurationHandler({ (textField) in
                    textField.placeholder = "Part Number or description"
                })
                let addAction = UIAlertAction(title: "Add", style: .Default, handler: { (action) in
                    self.partsTableView.beginUpdates()
                    let indexToInsert = NSIndexPath(forRow: self.parts.count + 1, inSection: 0)
                    self.parts.append( alert.textFields![0].text! )
                    self.partsTableView.insertRowsAtIndexPaths([indexToInsert], withRowAnimation: .Automatic)
                    self.partsTableView.endUpdates()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                
                alert.addAction(cancelAction)
                alert.addAction(addAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == partsTableView {
            if indexPath.row > 0 {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    
}

extension FloatersViewController : SwiftSignatureViewDelegate {
    
    func swiftSignatureViewDidTapInside(view: SwiftSignatureView) {
        
    }
    
    func swiftSignatureViewDidPanInside(view: SwiftSignatureView) {
        self.acceptSigButton.tintColor = UIColor.greenColor()
        self.captureSignatureNavigationItem.rightBarButtonItem?.enabled = true
        
        if self.overrideSignature.enabled {
            self.overrideSignature.selected = false
        }
        
    }
    
}
