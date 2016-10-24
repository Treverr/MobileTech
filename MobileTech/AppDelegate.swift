//
//  AppDelegate.swift
//  MobileTech
//
//  Created by Trever on 8/27/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    var player : AVAudioPlayer!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.registerSubclass()
        
        let parseConfig = ParseClientConfiguration {
            $0.server = "http://insparklepools.com:1337/parse"
            $0.applicationId = "inSparkle"
        }
        
        Parse.enableLocalDatastore()
        Parse.initializeWithConfiguration(parseConfig)
        
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .AuthorizedAlways:
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.distanceFilter = 100
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
        
        // Enable this for silent background audio to keep the app alive
        let path = NSBundle.mainBundle().pathForResource("silence", ofType: "wav")!
        let audioURL = NSURL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOfURL: audioURL)
            player.numberOfLoops = (-1)
            player.prepareToPlay()
        } catch {
            
        }
        
        let session : AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, withOptions: .MixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            
        }
        
        player.play()
        
        IQKeyboardManager.sharedManager().disabledDistanceHandlingClasses.append(LogInViewController.self)
        IQKeyboardManager.sharedManager().enable = true
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        
//        if let date = NSUserDefaults.standardUserDefaults().objectForKey("autoLogOutDate") as? NSDate {
//            if date.isLessThanDate(NSDate()) {
//                PFUser.logOutInBackgroundWithBlock({ (error : NSError?) in
//                    if error == nil {
//                        let sb = UIStoryboard(name: "Log In", bundle: nil)
//                        let vc = sb.instantiateViewControllerWithIdentifier("logInViewController")
//                        GlobalViewControllers.MyAssigned.presentViewController(vc, animated: true, completion: nil)
//                    }
//                })
//            }
//        }
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerSubclass() {
        NoteObject.registerSubclass()
        ServiceObject.registerSubclass()
        LocationTracker.registerSubclass()
        WorkOrders.registerSubclass()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .Denied, .Restricted:
            let alertController = UIAlertController(
                title: "Roberts Gonna be PISSED",
                message: "In order for Robert not to be pissed, open settings and set location services to 'Always'.",
                preferredStyle: .Alert)
            let openSettigs = UIAlertAction(title: "Open Settings", style: .Default, handler: { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            alertController.addAction(openSettigs)
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if location.horizontalAccuracy < 20 {
                let loc = LocationTracker()
                loc.timeStamp = location.timestamp
                loc.device = UIDevice.currentDevice().name
                if PFUser.currentUser() != nil {
                    loc.user = PFUser.currentUser()
                }
                loc.location = PFGeoPoint(location: location)
                loc.saveEventually()
            }
        }
    }
}

class GlobalViewControllers : NSObject {
    
    static var MyAssigned : MyAssignedTableViewController!
    
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
}

