//
//  MyAssignedTableViewController.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class MyAssignedTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var tapBGGesture = UITapGestureRecognizer()
    var workOrders = [WorkOrders]()
    var employee : Employee!
    
    let locationManager = CLLocationManager()
    var currentLocation : CLPlacemark? = nil
    var locationFailed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.updateCurrentLocation()
        
        
        if self.employee == nil {
            if PFUser.currentUser() != nil {
                PFUser.currentUser()?.objectForKey("employee")?.fetchIfNeededInBackgroundWithBlock({ (emp : PFObject?, error : NSError?) in
                    if error == nil {
                        self.employee = emp as! Employee
                        print(self.employee)
                        self.getAssignedOrders()
                    }
                })
            }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(MyAssignedTableViewController.settingsBGTapped(_:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
        
        NSTimer.scheduledTimerWithTimeInterval(600, target: self, selector: #selector(MyAssignedTableViewController.updateCurrentLocation), userInfo: nil, repeats: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return self.workOrders.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Priority"
        case 1:
            return "Assigned"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("assignedCell") as! MyAssignedTableViewCell
        let address = self.workOrders[indexPath.row].customerAddress
        
        cell.customerName.text! = self.workOrders[indexPath.row].customerName
        cell.address.text! = self.workOrders[indexPath.row].customerAddress
        
        if !self.locationFailed {
            if self.currentLocation != nil {
                cell.travelTime.text = String(self.getETA(address, cell: cell)) + " mins"
            } else {
                cell.travelTime.text = "Calculating..."
            }
        } else {
            cell.travelTime.text = "Unavailable"
        }
        
        return cell
    }
    
    func settingsBGTapped(sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended{
            guard let presentedView = presentedViewController?.view else {
                return
            }
            if !CGRectContainsPoint(presentedView.bounds, sender.locationInView(presentedView)) {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                })
            }
        }
    }
    
    func getAssignedOrders() {
        let timeZone = NSTimeZone(abbreviation: "UTC")
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components([.Day, .Month, .Year], fromDate: date)
        
        let day = components.day
        let month = components.month
        let year = components.year
        
        let start = NSCalendar.currentCalendar().componentsInTimeZone(timeZone!, fromDate: NSDate())
        start.day = day
        start.month = month
        start.year = year
        start.hour = 0
        start.minute = 0
        start.second = 0
        let startOfToday = NSCalendar.currentCalendar().dateFromComponents(start)
        
        let end = NSCalendar.currentCalendar().componentsInTimeZone(timeZone!, fromDate: NSDate())
        end.day = day
        end.month = month
        end.year = year
        end.hour = 23
        end.minute = 59
        end.second = 59
        let endOfToday = NSCalendar.currentCalendar().dateFromComponents(end)
        
        print(startOfToday, endOfToday)
        
        let userQuery = WorkOrders.query()
        userQuery!.whereKey("technicianPointer", equalTo: self.employee)
        userQuery!.whereKey("date", greaterThanOrEqualTo: startOfToday!)
        userQuery!.whereKey("date", lessThanOrEqualTo: endOfToday!)
        userQuery!.whereKey("status", notEqualTo: "Completed")
        
        let name = self.employee.firstName.capitalizedString + " " + self.employee.lastName.capitalizedString
        let nameQuery = WorkOrders.query()
        nameQuery!.whereKey("technician", equalTo: name)
        nameQuery!.whereKey("status", equalTo: "Assigned")
        nameQuery!.whereKey("date", greaterThanOrEqualTo: startOfToday!)
        nameQuery!.whereKey("date", lessThanOrEqualTo: endOfToday!)
        nameQuery!.whereKey("status", notEqualTo: "Completed")
        
        PFQuery.orQueryWithSubqueries([userQuery!, nameQuery!]).findObjectsInBackgroundWithBlock { (results : [PFObject]?, error : NSError?) in
            if error == nil {
                self.workOrders = results! as! [WorkOrders]
                self.tableView.reloadData()
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewWillDisappear(animated: Bool) {
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let vc = segue.destinationViewController as! ServiceOrderDetailViewController
            vc.serviceObject = self.workOrders[indexPath!.row]
            vc.currentLocation = self.currentLocation
        }
    }
    
    func getETA(destination : String, cell : MyAssignedTableViewCell) {
        
        var destMapItem : MKMapItem!
        var eta : NSTimeInterval!
        
        CLGeocoder().geocodeAddressString(destination) { (placemarks : [CLPlacemark]?, error : NSError?) in
            print(placemarks)
            if let place = placemarks?[0] {
                print(place)
                destMapItem = MKMapItem(placemark: MKPlacemark(placemark: place))
                
                let mkPlace = MKPlacemark(placemark: self.currentLocation!)
                let mkMapItem = MKMapItem(placemark: mkPlace)
                let request = MKDirectionsRequest()
                
                request.source = mkMapItem
                request.destination = destMapItem
                request.transportType = .Automobile
                let directions = MKDirections(request: request)
                directions.calculateETAWithCompletionHandler { (response : MKETAResponse?, error : NSError?) in
                    print(response?.expectedTravelTime)
                    let travelTime = Int(response!.expectedTravelTime) / 60
                    if travelTime > 60 {
                        let hour = Int(travelTime / 60)
                        let minutes = Int(travelTime - (hour * 60))
                        cell.travelTime.text! = String(hour) + " hr " + String(minutes) + " mins"
                    } else {
                        cell.travelTime.text = String((Int(response!.expectedTravelTime)) / 60) + " mins"
                    }
                    
                }
            }
        }
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joinWithSeparator(", ")
    }
    
    func logLocation(location : CLLocation) {
        if PFUser.currentUser() != nil {
            let loc = LocationTracker()
            loc.device = UIDevice.currentDevice().name
            loc.user = PFUser.currentUser()!
            loc.location = PFGeoPoint(location: location)
            
            loc.saveInBackground()
        }
    }
    
}

extension MyAssignedTableViewController : CLLocationManagerDelegate {
    
    func updateCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!) { (placemarks : [CLPlacemark]?, error : NSError?) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.logLocation(locations.last!)
                self.currentLocation = placemark
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationFailed = true
    }
    
}
