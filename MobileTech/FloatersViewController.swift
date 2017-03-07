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
        
        NotificationCenter.default.addObserver(self, selector: #selector(FloatersViewController.updateNotes(_:)), name: NSNotification.Name(rawValue: "UpdateNotesNotificaiton"), object: nil)
        
        self.acceptSigButton.tintColor = UIColor.gray
        captureSignatureNavigationItem.rightBarButtonItem?.isEnabled = false
        
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        partsTableView.delegate = self
        partsTableView.dataSource = self
        
        signaturePanel.delegate = self
        signaturePanel.backgroundColor = UIColor.white
        signaturePanel.strokeColor = UIColor.blue
        signaturePanel.strokeAlpha = 1
        
        for view in shadowViews {
            view.layer.bounds = notesView.layer.bounds
            view.frame = notesView.frame
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowOpacity = 0.6
            view.layer.shadowRadius = 15
            view.layer.shadowPath = UIBezierPath(rect: notesView.bounds).cgPath
        }
        
        signatureShadow.layer.bounds = signatureView.layer.bounds
        signatureShadow.frame = signatureView.frame
        signatureShadow.layer.shadowOffset = CGSize.zero
        signatureShadow.layer.shadowOpacity = 0.6
        signatureShadow.layer.shadowRadius = 15
        signatureShadow.layer.shadowPath = UIBezierPath(rect: signatureView.bounds).cgPath
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        let notesQuery = NoteObject.query()
        notesQuery?.whereKey("relatedWorkOder", equalTo: self.workOrderObject)
        notesQuery?.order(byDescending: "createdAt")
        notesQuery?.cachePolicy = .cacheThenNetwork
        notesQuery?.findObjectsInBackground(block: { (foundNotes, error) in
            if error == nil {
                self.notes = foundNotes as! [NoteObject]
                self.notesTableView.reloadData()
            }
        })
    }
    
    @IBAction func clearSignature(_ sender: AnyObject) {
        signaturePanel.clear()
        signatureImage = nil
        self.acceptSigButton.tintColor = UIColor.gray
        self.acceptSigButton.isEnabled = false
    }
    
    @IBAction func acceptSigAction(_ sender: AnyObject) {
        self.signatureImage = signaturePanel.signature
        print(self.signatureImage)
        acceptSigButton.tintColor = UIColor.gray
        captureSignatureNavigationItem.rightBarButtonItem?.isEnabled = false
        
        print("Captured")
    }
    
    func updateNotes(_ notification : Notification) {
        self.notes = notification.object as! [NoteObject]
        self.noteAdded = true
        self.notesTableView.reloadData()
    }
    
    @IBAction func overrideSignature(_ sender: AnyObject) {
        if overrideSignature.isSelected {
            self.overrideSignature.isSelected = false
        } else {
            self.overrideSignature.isSelected = true
        }
        
        self.clearSignature(self)
        
    }
    
    @IBAction func editButtonAction(_ sender: AnyObject) {
        if partsTableView.visibleCells.count > 1 {
            self.partsTableView.setEditing(true, animated: true)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(FloatersViewController.doneEditingParts))
            self.partNavItem.leftBarButtonItem = doneButton
        }
    }
    
    func doneEditingParts() {
        if partsTableView.isEditing {
            self.partsTableView.setEditing(false, animated: true)
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: #selector(FloatersViewController.editButtonAction))
            self.partNavItem.leftBarButtonItem = editButton
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == partsTableView {
            self.partsTableView.beginUpdates()
            self.partsTableView.deleteRows(at: [indexPath], with: .automatic)
            self.parts.remove(at: indexPath.row - 1)
            self.partsTableView.endUpdates()
            print(self.parts)
        }
    }
    
}

extension FloatersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        
        if tableView == notesTableView {
            return 1
        }
        
        if tableView == partsTableView {
            number = self.parts.count + 1
        }
        
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if tableView == notesTableView {
            cell = self.notesTableView.dequeueReusableCell(withIdentifier: "notesCell") as UITableViewCell!
            cell.textLabel!.text = self.notes![indexPath.section].noteContent
        }
        
        if tableView == partsTableView {
            if indexPath.row == 0 {
                cell = self.partsTableView.dequeueReusableCell(withIdentifier: "addPart")! as UITableViewCell
            }
            
            if indexPath.row > 0 {
                cell = self.partsTableView.dequeueReusableCell(withIdentifier: "partsCell")! as UITableViewCell
                cell.textLabel?.text = self.parts[indexPath.row - 1]
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewNote" {
            let vc = segue.destination.childViewControllers.first as! NewNoteTableViewController
            vc.relatedObj = self.serviceObject
            vc.relatedWorkOrder = self.workOrderObject
            if self.notes != nil {
                vc.notes = self.notes!
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == partsTableView {
            if indexPath.row == 0 {
                var text : String
                var partTextField = UITextField()
                let alert = UIAlertController(title: "Add Part", message: nil, preferredStyle: .alert)
                alert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Part Number or description"
                })
                let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
                    self.partsTableView.beginUpdates()
                    let indexToInsert = IndexPath(row: self.parts.count + 1, section: 0)
                    self.parts.append( alert.textFields![0].text! )
                    self.partsTableView.insertRows(at: [indexToInsert], with: .automatic)
                    self.partsTableView.endUpdates()
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                
                alert.addAction(cancelAction)
                alert.addAction(addAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
    
    func swiftSignatureViewDidTapInside(_ view: SwiftSignatureView) {
        
    }
    
    func swiftSignatureViewDidPanInside(_ view: SwiftSignatureView) {
        self.acceptSigButton.tintColor = UIColor.green
        self.captureSignatureNavigationItem.rightBarButtonItem?.isEnabled = true
        
        if self.overrideSignature.isEnabled {
            self.overrideSignature.isSelected = false
        }
        
    }
    
}
