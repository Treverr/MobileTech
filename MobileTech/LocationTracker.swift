//
//  LocationTracker.swift
//  MobileTech
//
//  Created by Trever on 9/5/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import Foundation
import Parse

class LocationTracker: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "LocationLog"
    }
    
    var timeStamp : NSDate {
        get {return objectForKey("timeStamp") as! NSDate}
        set { setObject(newValue, forKey: "timeStamp") }
    }
    
    var device : String! {
        get {return objectForKey("device") as! String}
        set { setObject(newValue, forKey: "device") }
    }
    
    var user : PFUser {
        get {return objectForKey("user") as! PFUser}
        set { setObject(newValue, forKey: "user") }
    }
    
    var location : PFGeoPoint {
        get {return objectForKey("location") as! PFGeoPoint}
        set { setObject(newValue, forKey: "location") }
    }
    
}
