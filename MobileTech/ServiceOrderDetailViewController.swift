//
//  ServiceOrderDetailViewController.swift
//  MobileTech
//
//  Created by Trever on 9/3/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class ServiceOrderDetailViewController: UIViewController {
    
    var serviceObject : WorkOrders!
    
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var wtbpTextView: UITextView!
    
    let locationManager = CLLocationManager()
    var currentLocation : CLPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customerName.text! = self.serviceObject.customerName
        self.phoneNumber.text! = self.serviceObject.customerPhone
        self.wtbpTextView.text = self.serviceObject.workToBePerformed
        
        if self.currentLocation == nil {
            self.getDirections.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openServiceMain(_ sender: AnyObject) {
//        let checkForPrevious = ServiceObject.query()
//        checkForPrevious?.whereKey("relatedWorkOrder", equalTo: self.serviceObject)
//        checkForPrevious?.orderByDescending("createdAt")
//        checkForPrevious?.findObjectsInBackgroundWithBlock({ (foundPrevious : [PFObject]?, error : NSError?) in
//            if error == nil {
//                if foundPrevious?.count == 0 {
//                    let sb = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = sb.instantiateViewControllerWithIdentifier("serviceMain") as! ServiceMainViewController
//                    vc.serviceOrderObject = ServiceObject()
//                    print(self.serviceObject)
//                    vc.workOrderObject = self.serviceObject
//                    
//                    self.presentViewController(vc, animated: true, completion: nil)
//                } else {
//                    let sb = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = sb.instantiateViewControllerWithIdentifier("serviceMain") as! ServiceMainViewController
//                    vc.serviceOrderObject = ServiceObject()
//                    let previousObjs = foundPrevious as! [ServiceObject]
//                    vc.serviceOrderObject.relatedService = previousObjs
//                    vc.workOrderObject = self.serviceObject
//                    self.presentViewController(vc, animated: true, completion: nil)
//                }
//            }
//        })
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "serviceMain") as! ServiceMainViewController
        vc.serviceOrderObject = ServiceObject()
        print(self.serviceObject)
        vc.workOrderObject = self.serviceObject
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var getDirections: UIButton!
    
    @IBAction func getDirectionsAction(_ sender: AnyObject) {
        self.askMapsToDisplayDirections()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func askMapsToDisplayDirections() {
        
        CLGeocoder().geocodeAddressString(self.serviceObject.customerAddress) { (placemarks, error) in
            if let place = placemarks?[0] {
                let destMapItem = MKMapItem(placemark: MKPlacemark(placemark: place))
                
                let currentLocationCoordinate = self.currentLocation?.location?.coordinate
                
                destMapItem.name = self.serviceObject.customerName + "'s House"
                destMapItem.phoneNumber = self.serviceObject.customerPhone
                
                let region = MKCoordinateRegionMakeWithDistance(currentLocationCoordinate!, 10000, 10000)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
                ]
                MKMapItem.openMaps(with: [destMapItem], launchOptions: options)
                
            }
        }
    }
}
