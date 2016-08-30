//
//  FloatersViewController.swift
//  MobileTech
//
//  Created by Trever on 8/28/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import SwiftSignatureView

class FloatersViewController: UIViewController {
    
    var serviceObject = ServiceObject()
    
    // Notes Floater Panel
    @IBOutlet weak var notesTableView: UITableView!
    @IBOutlet weak var notesView: UIView!
    
    // Render Shadows
    @IBOutlet var shadowViews: [UIView]!
    @IBOutlet var roundedCorners: [UIView]!
    
    // Sig Floater Panel
    @IBOutlet weak var signaturePanel: SwiftSignatureView!
    @IBOutlet weak var sigCustomerName: UILabel!
    @IBOutlet weak var acceptSigButton: UIBarButtonItem!
    @IBOutlet weak var captureSignatureNavigationBar: UINavigationBar!
    @IBOutlet weak var captureSignatureNavigationItem: UINavigationItem!
    @IBOutlet weak var signatureView: UIView!
    @IBOutlet weak var signatureShadow: UIView!
    
    // Parts Floater Panels
    @IBOutlet weak var partsTableView: UITableView!
    
    
    var signatureImage = UIImage()
    
    @IBOutlet weak var test: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FloatersViewController.updateNotes(_:)), name: "UpdateNotesNotificaiton", object: nil)
        
        self.acceptSigButton.tintColor = UIColor.grayColor()
        captureSignatureNavigationItem.rightBarButtonItem?.enabled = false
        
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
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
        
        sigCustomerName.text = "Robert Casad"
        
    }
    
    @IBAction func clearSignature(sender: AnyObject) {
        signaturePanel.clear()
    }
    
    @IBAction func acceptSigAction(sender: AnyObject) {
        let sigImage = signaturePanel.signature
        
        acceptSigButton.tintColor = UIColor.grayColor()
        captureSignatureNavigationItem.rightBarButtonItem?.enabled = false
        
        print("Captured")
    }
    
    
}

extension FloatersViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var number = 0
        
        if tableView == notesTableView {
            if self.serviceObject.notes != nil {
                number = self.serviceObject.notes!.count
            }
        }
        return number
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        
        if tableView == notesTableView {
            return 1
        }
        
        return number
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if tableView == notesTableView {
            cell = self.notesTableView.dequeueReusableCellWithIdentifier("notesCell") as UITableViewCell!
            cell.textLabel!.text = self.serviceObject.notes![indexPath.section].noteContent
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        
        if self.serviceObject.notes?[section].noteTitle != nil {
            title = self.serviceObject.notes![section].noteTitle
        }
        
        return title
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
        }
    }
    
    func updateNotes(notification : NSNotification) {
        let obj = notification.object as! ServiceObject
        self.serviceObject = notification.object as! ServiceObject
        print(obj.notes)
        self.notesTableView.reloadData()
    }
    
}

extension FloatersViewController : SwiftSignatureViewDelegate {
    
    func swiftSignatureViewDidTapInside(view: SwiftSignatureView) {
        
    }
    
    func swiftSignatureViewDidPanInside(view: SwiftSignatureView) {
        self.acceptSigButton.tintColor = UIColor.greenColor()
        self.captureSignatureNavigationItem.rightBarButtonItem?.enabled = true
    }
    
}
