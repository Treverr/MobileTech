//
//  QRLogInScanViewController.swift
//  MobileTech
//
//  Created by Trever on 8/31/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes_Swift

class QRLogInScanViewController: RSCodeReaderViewController {
    
    var dispatched : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self
        
        self.barcodesHandler = { barcodes in
            if !self.dispatched {
                self.dispatched = true
                
                for barcode in barcodes {
                    let barcodeValue = barcode.stringValue
                    NSNotificationCenter.defaultCenter().postNotificationName("QRLogIn", object: barcodeValue)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    break
                }
            }
        }
    }
    
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
