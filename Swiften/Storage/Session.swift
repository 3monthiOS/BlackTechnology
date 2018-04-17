//
//  Session.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import CoreLocation
open class Session: LocalStorage {
    /* Tick */
    open var tick: Int {
        let result = integer(forKey: "TICK")
        setObject((result + 1) % Int.max as AnyObject, forKey: "TICK")
        return result
    }
    
    /* deviceId */
    open var deviceId: String {
        get {
            if let udid = string(forKey: "UDID") {
                return udid
            }
            
            let udid = UDID.UDIDString
            setObject(udid as AnyObject, forKey: "UDID")
            
            return udid
        }
        set { setObject(newValue as AnyObject, forKey: "UDID") }
    }
    
    /** uid */
    open var uid: Int {
        get { return integer(forKey: "UID") }
        set { setObject(newValue as AnyObject, forKey: "UID") }
    }
    
    /** authType */
    open var authType: String {
        get { return string(forKey: "AUTH_TYPE", defaultValue: "") }
        set { setObject(newValue as AnyObject, forKey: "AUTH_TYPE") }
    }
    
    /** token */
    open var token: String {
        get { return string(forKey: "TOKEN", defaultValue: "") }
        set { setObject(newValue as AnyObject, forKey: "TOKEN") }
    }
    
    /** imei */
    open var imei: String {
        get { return string(forKey: "IMEI", defaultValue: "") }
        set { setObject(newValue as AnyObject, forKey: "IMEI") }
    }
    
    /** Location */
    open var location: CLLocation {
        get {
            let latitude = double(forKey: "LATITUDE")
            let longitude = double(forKey: "LONGITUDE")
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        set {
            begin()
            setObject(newValue.coordinate.latitude as AnyObject, forKey: "LATITUDE")
            setObject(newValue.coordinate.longitude as AnyObject, forKey: "LONGITUDE")
        }
    }
    
    /** city */
    open var city: String! {
        get { return string(forKey: "CITY", defaultValue: "") }
        set { setObject(newValue as AnyObject, forKey: "CITY") }
    }

}
