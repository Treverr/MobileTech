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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyAssignedTableViewController.dismissAndRefresh), name: "DismissAndRefreshAssigned", object: nil)
        GlobalViewControllers.MyAssigned = self
    }
    
    override func viewDidAppear(animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(MyAssignedTableViewController.settingsBGTapped(_:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            PFUser.currentUser()?.objectForKey("employee")?.fetchInBackgroundWithBlock({ (emp : PFObject?, error : NSError?) in
                if error == nil {
                    self.employee = emp as! Employee
                    print(self.employee)
                    self.getAssignedOrders()
                    self.updateCurrentLocation()
                }
            })
        }
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
            return "To Do"
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
                self.getETA(address, cell: cell)
            } else {
                cell.travelTime.text = "Calculating..."
            }
        } else {
            cell.travelTime.text = "Unavailable"
        }
        
        return cell
    }
    
    func dismissAndRefresh() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.getAssignedOrders()
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
        self.getAssignedOrders()
    }
    
    @IBAction func refreshManualButton(sender: AnyObject) {
        if PFUser.currentUser() != nil {
                PFUser.currentUser()?.objectForKey("employee")?.fetchInBackgroundWithBlock({ (emp : PFObject?, error : NSError?) in
                    if error == nil {
                        self.employee = emp as! Employee
                        print(self.employee)
                        self.getAssignedOrders()
                        self.updateCurrentLocation()
                    } else {
                        let errorAlert = UIAlertController(title: "Error", message: "Unable to refresh at this time, check the network connectiona and try again. If the issue persists contact IS&T.", preferredStyle: .Alert)
                        let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                        errorAlert.addAction(cancel)
                        self.presentViewController(errorAlert, animated: true, completion: nil)
                    }
                })
            }
    }
    
    func getAssignedOrders() {
        
        for monitored in self.locationManager.monitoredRegions {
            locationManager.stopMonitoringForRegion(monitored)
        }
        
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
        
        let statuses : [String] = ["New", "In Progress", "On Hold", "Assigned"]
        let name = self.employee.firstName.capitalizedString + " " + self.employee.lastName.capitalizedString
        
        let nameQuery = WorkOrders.query()!
        nameQuery.whereKey("technician", equalTo: name)
        nameQuery.whereKey("date", lessThanOrEqualTo: endOfToday!)
        nameQuery.whereKey("status", containedIn: statuses)
        
        let pointerQuery = WorkOrders.query()!
        pointerQuery.whereKey("status", containedIn: statuses)
        pointerQuery.whereKey("date", lessThanOrEqualTo: endOfToday!)
        pointerQuery.whereKey("technicianPointer", equalTo: self.employee)

        
        PFQuery.orQueryWithSubqueries([pointerQuery, nameQuery]).findObjectsInBackgroundWithBlock { (results : [PFObject]?, error : NSError?) in
            if error == nil {
                self.doThingsWithResults(results!)
            } else {
                if error?.code == 100 {
                    self.doThingsWithResults(self.workOrders)
                }
            }
        }
    }
    
    func doThingsWithResults(results : [PFObject]) {
        if results.count == 0 {
            self.workOrders = []
            let noAssigned = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width, self.view.bounds.size.height))
            noAssigned.text = "No Assigned Service Orders"
            noAssigned.textColor = UIColor.grayColor()
            noAssigned.backgroundColor = UIColor.whiteColor()
            noAssigned.numberOfLines = 0
            noAssigned.textAlignment = .Center
            noAssigned.font = (UIFont(name: "Helvetica-Light", size: 24))
            noAssigned.sizeToFit()
            self.tableView.tableFooterView = UIView()
            self.tableView.backgroundView = noAssigned
            self.tableView.separatorStyle = .None
            self.tableView.scrollEnabled = false
            
            let myAssignedSection = NSIndexSet(index: 1)
            self.tableView.reloadSections(myAssignedSection, withRowAnimation: .Automatic)
            
            let masterTableView = self.splitViewController?.viewControllers.first?.childViewControllers.first as! MasterTableViewController
            masterTableView.updateCellBadge("myAssigned", count: (results.count))
            
        } else {
            self.workOrders = results as! [WorkOrders]
            
            self.tableView.tableFooterView = nil
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .SingleLine
            self.tableView.scrollEnabled = true
            
            let masterTableView = self.splitViewController?.viewControllers.first?.childViewControllers.first as! MasterTableViewController
            print(masterTableView)
            
            masterTableView.updateCellBadge("myAssigned", count: (results.count))
            
            let myAssignedSection = NSIndexSet(index: 1)
            self.tableView.reloadSections(myAssignedSection, withRowAnimation: .Automatic)
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
                
                let indexPath = self.tableView.indexPathForCell(cell)
                if indexPath != nil {
                    let identifier = self.workOrders[indexPath!.row].objectId
                    let center = MKPlacemark(placemark: place).coordinate
                    let geoFence = CLCircularRegion(center: center, radius: 100, identifier: identifier!)
                    
                    self.locationManager.startMonitoringForRegion(geoFence)
                    
                    request.source = mkMapItem
                    request.destination = destMapItem
                    request.transportType = .Automobile
                    let directions = MKDirections(request: request)
                    directions.calculateETAWithCompletionHandler { (response : MKETAResponse?, error : NSError?) in
                        print(response?.expectedTravelTime)
                        if response != nil {
                            let travelTime = Int(response!.expectedTravelTime) / 60
                            if travelTime > 60 {
                                let hour = Int(travelTime / 60)
                                let minutes = Int(travelTime - (hour * 60))
                                if hour > 1 {
                                    cell.travelTime.text! = String(hour) + " hrs " + String(minutes) + " mins"
                                } else {
                                    cell.travelTime.text! = String(hour) + " hr " + String(minutes) + " mins"
                                }
                                
                            } else {
                                cell.travelTime.text = String((Int(response!.expectedTravelTime)) / 60) + " mins"
                            }
                        }
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
            loc.timeStamp = location.timestamp
            loc.device = UIDevice.currentDevice().name
            loc.user = PFUser.currentUser()!
            loc.location = PFGeoPoint(location: location)
            
            loc.saveEventually()
        }
    }
    
    func saveTimeLog(workOderObjectID : String, enter : Bool) {
        let timeObj = WorkServiceOrderTimeLog()
        timeObj.timeStamp = NSDate()
        timeObj.device = UIDevice.currentDevice().name
        timeObj.userLoggedIn = PFUser.currentUser()!
        timeObj.relatedWorkOrderObjectID = workOderObjectID
        timeObj.enter = enter
        timeObj.saveEventually()
    }
    
}

extension MyAssignedTableViewController : CLLocationManagerDelegate {
    
    func updateCurrentLocation() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = 100
        self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!) { (placemarks : [CLPlacemark]?, error : NSError?) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.currentLocation = placemark
                self.logLocation(locations.last!)
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        self.locationFailed = true
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.saveTimeLog(region.identifier, enter: true)
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
        self.saveTimeLog(region.identifier, enter: false)
    }
    
}
