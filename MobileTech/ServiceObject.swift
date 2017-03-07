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
        get { return object(forKey: "relatedService") as? [ServiceObject] }
        set { setObject(newValue!, forKey: "relatedService") }
    }
    
    var parts : [String]? {
        get { return object(forKey: "parts") as? [String] }
        set { setObject(newValue!, forKey: "parts") }
    }
    
    var customerSignature : PFFile? {
        get { return object(forKey: "customerSignature") as? PFFile }
        set { setObject(newValue!, forKey: "customerSignature") }
    }
    
    var trips : [[Date : Date]]? {
        get { return object(forKey: "trips") as? [[Date : Date]]}
        set { setObject(newValue!, forKey: "trips") }
    }
    
    var status : String {
        get { return object(forKey: "status") as! String}
        set { setObject(newValue, forKey: "status") }
    }
    
    var relatedWorkOrder : WorkOrders! {
        get { return object(forKey: "relatedWorkOrder") as! WorkOrders}
        set { setObject(newValue, forKey: "relatedWorkOrder") }
    }
    
}
