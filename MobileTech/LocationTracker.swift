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
    
    var timeStamp : Date {
        get {return object(forKey: "timeStamp") as! Date}
        set { setObject(newValue, forKey: "timeStamp") }
    }
    
    var device : String! {
        get {return object(forKey: "device") as! String}
        set { setObject(newValue, forKey: "device") }
    }
    
    var user : PFUser? {
        get {return object(forKey: "user") as? PFUser}
        set { setObject(newValue!, forKey: "user") }
    }
    
    var location : PFGeoPoint {
        get {return object(forKey: "location") as! PFGeoPoint}
        set { setObject(newValue, forKey: "location") }
    }
    
}
