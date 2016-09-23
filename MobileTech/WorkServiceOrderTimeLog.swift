//
//  WorkServiceOrderTimeLog.swift
//  MobileTech
//
//  Created by Trever on 9/6/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import Foundation
import Parse

class WorkServiceOrderTimeLog : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "WorkServiceOrderTimeLog"
    }
    
    var timeStamp : NSDate {
        get {return objectForKey("timeStamp") as! NSDate}
        set { setObject(newValue, forKey: "timeStamp") }
    }
    
    var enter : Bool {
        get {return objectForKey("enter") as! Bool}
        set { setObject(newValue, forKey: "enter") }
    }

    var relatedWorkOrderObjectID : String! {
        get {return objectForKey("relatedWorkOrderObjectID") as! String}
        set { setObject(newValue, forKey: "relatedWorkOrderObjectID") }
    }
    
    var relatedServiceOrderObj : ServiceObject? {
        get {return objectForKey("relatedServiceOrderObj") as? ServiceObject}
        set { setObject(newValue!, forKey: "relatedServiceOrderObj") }
    }
    
    var userLoggedIn : PFUser {
        get {return objectForKey("userLoggedIn") as! PFUser}
        set { setObject(newValue, forKey: "userLoggedIn") }
    }
    
    var device : String {
        get {return objectForKey("device") as! String}
        set { setObject(newValue, forKey: "device") }
    }

}
