//
//  WorkOrderModel.swift
//  inSparkle
//
//  Created by Trever on 2/15/16.
//  Copyright © 2016 Sparkle Pools. All rights reserved.
//

import Foundation
import Parse

class WorkOrders : PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "WorkOrders"
    }
    
    var customerName : String! {
        get {return object(forKey: "customerName") as! String}
        set { setObject(newValue, forKey: "customerName") }
    }
    
    var customerAddress : String! {
        get {return object(forKey: "customerAddress") as! String}
        set { setObject(newValue, forKey: "customerAddress") }
    }
    
    var customerPhone : String! {
        get {return object(forKey: "customerPhone") as! String}
        set { setObject(newValue, forKey: "customerPhone") }
    }
    
    var customerAltPhone : String? {
        get {return object(forKey: "customerAltPhone") as? String}
        set { setObject(newValue!, forKey: "customerAltPhone") }
    }
    
    var date : Date! {
        get {return object(forKey: "date") as! Date}
        set { setObject(newValue, forKey: "date") }
    }
    
    var status : String? {
        get {return object(forKey: "status") as? String}
        set { setObject(newValue!, forKey: "status") }
    }
    
    var schedTime : Date? {
        get {return object(forKey: "schedTime") as? Date}
        set { setObject(newValue!, forKey: "schedTime") }
    }
    
    var technician : String? {
        get {return object(forKey: "technician") as? String}
        set { setObject(newValue!, forKey: "technician") }
    }
    
    var workToBePerformed : String? {
        get {return object(forKey: "workToBePerformed") as? String}
        set { setObject(newValue!, forKey: "workToBePerformed") }
    }
    
    var descOfWork : String? {
        get {return object(forKey: "descOfWork") as? String}
        set { setObject(newValue!, forKey: "descOfWork") }
    }
    
    var reccomendation : String? {
        get {return object(forKey: "reccomendation") as? String}
        set { setObject(newValue!, forKey: "reccomendation") }
    }
    
    var tripOneArrive : Date? {
        get {return object(forKey: "tripOneArrive") as? Date}
        set { setObject(newValue!, forKey: "tripOneArrive") }
    }
    
    var tripOneDepart : Date? {
        get {return object(forKey: "tripOneDepart") as? Date}
        set { setObject(newValue!, forKey: "tripOneDepart") }
    }
    
    var tripTwoArrive : Date? {
        get {return object(forKey: "tripTwoArrive") as? Date}
        set { setObject(newValue!, forKey: "tripTwoArrive") }
    }
    
    var tripTwoDepart : Date? {
        get {return object(forKey: "tripTwoDepart") as? Date}
        set { setObject(newValue!, forKey: "tripTwoDepart") }
    }
    
    var unitMake : String? {
        get {return object(forKey: "unitMake") as? String}
        set { setObject(newValue!, forKey: "unitMake") }
    }
    
    var unitModel : String? {
        get {return object(forKey: "unitModel") as? String}
        set { setObject(newValue!, forKey: "unitModel") }
    }
    
    var unitSerial : String? {
        get {return object(forKey: "unitSerial") as? String}
        set { setObject(newValue!, forKey: "unitSerial") }
    }
    
    var parts : NSArray? {
        get {return object(forKey: "parts") as? NSArray}
        set { setObject(newValue!, forKey: "parts") }
    }
    
    var labor : NSArray? {
        get {return object(forKey: "labor") as? NSArray}
        set { setObject(newValue!, forKey: "labor") }
    }
    
    var trips : [[Date : Date]]? {
        get { return object(forKey: "trips") as? [[Date : Date]]}
        set { setObject(newValue!, forKey: "trips") }
    }
}
