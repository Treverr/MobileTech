//
//  ServiceObject.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import Foundation
import Parse

class ServiceObject: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "MobileTechServiceObjects"
    }
    
    var relatedService : [ServiceObject]? {
        get { return objectForKey("relatedService") as? [ServiceObject] }
        set { setObject(newValue!, forKey: "relatedService") }
    }
    
    var parts : [String]? {
        get { return objectForKey("parts") as? [String] }
        set { setObject(newValue!, forKey: "parts") }
    }
    
    var customerSignature : PFFile? {
        get { return objectForKey("customerSignature") as? PFFile }
        set { setObject(newValue!, forKey: "customerSignature") }
    }
    
    var trips : [[NSDate : NSDate]]? {
        get { return objectForKey("trips") as? [[NSDate : NSDate]]}
        set { setObject(newValue!, forKey: "trips") }
    }
    
    var status : String {
        get { return objectForKey("status") as! String}
        set { setObject(newValue, forKey: "status") }
    }
    
    var relatedWorkOrder : WorkOrders! {
        get { return objectForKey("relatedWorkOrder") as! WorkOrders}
        set { setObject(newValue, forKey: "relatedWorkOrder") }
    }
    
}