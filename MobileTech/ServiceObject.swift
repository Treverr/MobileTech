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
    
    var notes : [NoteObject]? {
        get { return objectForKey("notes") as? [NoteObject] }
        set { setObject(newValue!, forKey: "notes") }
    }
    
    var parts : [String]? {
        get { return objectForKey("parts") as? [String] }
        set { setObject(newValue!, forKey: "parts") }
    }
    
    var customerSignature : UIImage? {
        get { return objectForKey("customerSignature") as? UIImage }
        set { setObject(newValue!, forKey: "customerSignature") }
    }
    
    var trips : [NSDate : NSDate]? {
        get { return objectForKey("trips") as? [NSDate : NSDate]}
        set { setObject(newValue!, forKey: "trips") }
    }
    
    var status : String {
        get { return objectForKey("status") as! String}
        set { setObject(newValue, forKey: "status") }
    }
    
}