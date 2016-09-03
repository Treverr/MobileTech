//
//  EmployeeModel.swift
//  MobileTech
//
//  Created by Trever on 9/3/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import Foundation
import Parse

class Employee: PFObject, PFSubclassing {
    
    class func parseClassName() -> String {
        return "Employees"
    }
    
    var pinNumber : String? {
        get {return objectForKey("pinNumber") as? String}
        set { setObject(newValue!, forKey: "pinNumber") }
    }
    
    var firstName : String {
        get {return objectForKey("firstName") as! String}
        set { setObject(newValue, forKey: "firstName") }
    }
    
    var lastName : String {
        get {return objectForKey("lastName") as! String}
        set { setObject(newValue, forKey: "lastName") }
    }
    
    var messages : Bool {
        get {return objectForKey("messages") as! Bool}
        set { setObject(newValue, forKey: "messages") }
    }
    
    var userPoint : PFUser? {
        get {return objectForKey("userPointer") as? PFUser}
        set { setObject(newValue!, forKey: "userPointer") }
    }
    
    var active : Bool {
        get { return objectForKey("active") as! Bool }
        set { setObject(newValue, forKey: "active") }
    }
}