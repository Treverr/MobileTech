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
        NotificationCenter.default.addObserver(self, selector: #selector(MyAssignedTableViewController.dismissAndRefresh), name: NSNotification.Name(rawValue: "DismissAndRefreshAssigned"), object: nil)
        GlobalViewControllers.MyAssigned = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tapBGGesture = UITapGestureRecognizer(target: self, action: #selector(MyAssignedTableViewController.settingsBGTapped(_:)))
        tapBGGesture.delegate = self
        tapBGGesture.numberOfTapsRequired = 1
        tapBGGesture.cancelsTouchesInView = false
        self.view.window!.addGestureRecognizer(tapBGGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            (PFUser.current()?.object(forKey: "employee") as AnyObject).fetchInBackground(block: { (emp, error) in
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return self.workOrders.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Priority"
        case 1:
            return "To Do"
        default:
            return ""
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignedCell") as! MyAssignedTableViewCell
        let address = self.workOrders[indexPath.row].customerAddress
        
        cell.customerName.text! = self.workOrders[indexPath.row].customerName
        cell.address.text! = self.workOrders[indexPath.row].customerAddress
        
        if !self.locationFailed {
            if self.currentLocation != nil {
                self.getETA(address!, cell: cell)
            } else {
                cell.travelTime.text = "Calculating..."
            }
        } else {
            cell.travelTime.text = "Unavailable"
        }
        
        return cell
    }
    
    func dismissAndRefresh() {
        self.dismiss(animated: true, completion: nil)
        self.getAssignedOrders()
    }
    
    func settingsBGTapped(_ sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.ended{
            guard let presentedView = presentedViewController?.view else {
                return
            }
            if !presentedView.bounds.contains(sender.location(in: presentedView)) {
                self.dismiss(animated: true, completion: { () -> Void in
                })
            }
        }
        self.getAssignedOrders()
    }
    
    @IBAction func refreshManualButton(_ sender: AnyObject) {
        if PFUser.current() != nil {
            (PFUser.current()?.object(forKey: "employee") as AnyObject).fetchInBackground(block: { (emp, error) in
                if error == nil {
                    self.employee = emp as! Employee
                    print(self.employee)
                    self.getAssignedOrders()
                    self.updateCurrentLocation()
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "Unable to refresh at this time, check the network connectiona and try again. If the issue persists contact IS&T.", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    errorAlert.addAction(cancel)
                    self.present(errorAlert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func getAssignedOrders() {
        
        for monitored in self.locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: monitored)
        }
        
        let timeZone = TimeZone(abbreviation: "UTC")
        let date = Date()
        let components = (Calendar.current as NSCalendar).components([.day, .month, .year], from: date)
        
        let day = components.day
        let month = components.month
        let year = components.year
        
        var start = Calendar.current.dateComponents(in: timeZone!, from: Date())
        start.day = day
        start.month = month
        start.year = year
        start.hour = 0
        start.minute = 0
        start.second = 0
        let startOfToday = Calendar.current.date(from: start)
        
        var end = Calendar.current.dateComponents(in: timeZone!, from: Date())
        end.day = day
        end.month = month
        end.year = year
        end.hour = 23
        end.minute = 59
        end.second = 59
        let endOfToday = Calendar.current.date(from: end)
        
        let statuses : [String] = ["New", "In Progress", "On Hold", "Assigned"]
        let name = self.employee.firstName.capitalized + " " + self.employee.lastName.capitalized
        
        let nameQuery = WorkOrders.query()!
        nameQuery.whereKey("technician", equalTo: name)
        nameQuery.whereKey("date", lessThanOrEqualTo: endOfToday!)
        nameQuery.whereKey("status", containedIn: statuses)
        
        let pointerQuery = WorkOrders.query()!
        pointerQuery.whereKey("status", containedIn: statuses)
        pointerQuery.whereKey("date", lessThanOrEqualTo: endOfToday!)
        pointerQuery.whereKey("technicianPointer", equalTo: self.employee)
        
        
        PFQuery.orQuery(withSubqueries: [pointerQuery, nameQuery]).findObjectsInBackground { (results, error) in
            if error == nil {
                self.doThingsWithResults(results!)
            } else {
                let errorCode = (error as! NSError).code
                if errorCode == 100 {
                    self.doThingsWithResults(self.workOrders)
                }
            }
        }
    }
    
    func doThingsWithResults(_ results : [PFObject]) {
        if results.count == 0 {
            self.workOrders = []
            let noAssigned = UILabel(frame: CGRect(x: 0,y: 0,width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            noAssigned.text = "No Assigned Service Orders"
            noAssigned.textColor = UIColor.gray
            noAssigned.backgroundColor = UIColor.white
            noAssigned.numberOfLines = 0
            noAssigned.textAlignment = .center
            noAssigned.font = (UIFont(name: "Helvetica-Light", size: 24))
            noAssigned.sizeToFit()
            self.tableView.tableFooterView = UIView()
            self.tableView.backgroundView = noAssigned
            self.tableView.separatorStyle = .none
            self.tableView.isScrollEnabled = false
            
            let myAssignedSection = IndexSet(integer: 1)
            self.tableView.reloadSections(myAssignedSection, with: .automatic)
            
            let masterTableView = self.splitViewController?.viewControllers.first?.childViewControllers.first as! MasterTableViewController
            masterTableView.updateCellBadge("myAssigned", count: (results.count))
            
        } else {
            self.workOrders = results as! [WorkOrders]
            
            self.tableView.tableFooterView = nil
            self.tableView.backgroundView = nil
            self.tableView.separatorStyle = .singleLine
            self.tableView.isScrollEnabled = true
            
            let masterTableView = self.splitViewController?.viewControllers.first?.childViewControllers.first as! MasterTableViewController
            print(masterTableView)
            
            masterTableView.updateCellBadge("myAssigned", count: (results.count))
            
            let myAssignedSection = IndexSet(integer: 1)
            self.tableView.reloadSections(myAssignedSection, with: .automatic)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.view.window!.removeGestureRecognizer(tapBGGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let vc = segue.destination as! ServiceOrderDetailViewController
            vc.serviceObject = self.workOrders[indexPath!.row]
            vc.currentLocation = self.currentLocation
        }
    }
    
    func getETA(_ destination : String, cell : MyAssignedTableViewCell) {
        
        var destMapItem : MKMapItem!
        var eta : TimeInterval!
        
        CLGeocoder().geocodeAddressString(destination) { (placemarks, error) in
            print(placemarks)
            if let place = placemarks?[0] {
                print(place)
                destMapItem = MKMapItem(placemark: MKPlacemark(placemark: place))
                
                let mkPlace = MKPlacemark(placemark: self.currentLocation!)
                let mkMapItem = MKMapItem(placemark: mkPlace)
                let request = MKDirectionsRequest()
                
                let indexPath = self.tableView.indexPath(for: cell)
                if indexPath != nil {
                    let identifier = self.workOrders[indexPath!.row].objectId
                    let center = MKPlacemark(placemark: place).coordinate
                    let geoFence = CLCircularRegion(center: center, radius: 100, identifier: identifier!)
                    
                    print(self.locationManager.monitoredRegions)
                    
                    self.locationManager.startMonitoring(for: geoFence)
                    
                    request.source = mkMapItem
                    request.destination = destMapItem
                    request.transportType = .automobile
                    let directions = MKDirections(request: request)
                    directions.calculateETA { (response, error) in
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
    
    func formatAddressFromPlacemark(_ placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as!
            [String]).joined(separator: ", ")
    }
    
    func logLocation(_ location : CLLocation) {
        let loc = LocationTracker()
        loc.timeStamp = location.timestamp
        loc.device = UIDevice.current.name
        loc.user = PFUser.current()
        loc.location = PFGeoPoint(location: location)
        loc.saveEventually()
    }
    
    func saveTimeLog(_ workOderObjectID : String, enter : Bool) {
        let timeObj = WorkServiceOrderTimeLog()
        timeObj.timeStamp = Date()
        timeObj.device = UIDevice.current.name
        timeObj.userLoggedIn = PFUser.current()!
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
        self.locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!) { (placemarks, error) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.currentLocation = placemark
                self.logLocation(locations.last!)
                self.tableView.reloadData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationFailed = true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.saveTimeLog(region.identifier, enter: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
        self.saveTimeLog(region.identifier, enter: false)
    }
    
}
