//
//  NoteObject.swift
//  MobileTech
//
//  Created by Trever on 8/30/16.
//  Copyright © 2016 Sparkle Pools, Inc. All rights reserved.
//

import Foundation
import Parse

class NoteObject: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "MobileTechServiceObjectNotes"
    }
    
    var noteTitle : String {
        get { return object(forKey: "noteTitle") as! String }
        set { setObject(newValue, forKey: "noteTitle") }
    }
    
    var noteContent : String {
        get { return object(forKey: "noteContent") as! String }
        set { setObject(newValue, forKey: "noteContent") }
    }
    
    var relatedService : ServiceObject {
        get { return object(forKey: "relatedService") as! ServiceObject }
        set { setObject(newValue, forKey: "relatedService") }
    }
    
    var relatedWorkOder : WorkOrders {
        get { return object(forKey: "relatedWorkOder") as! WorkOrders }
        set { setObject(newValue, forKey: "relatedWorkOder") }
    }
    
}
