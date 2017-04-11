//
//  DefaultSession.swift
//  Swiften
//
//  Created by Cator Vee on 19/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation
import CoreLocation

open class DefaultSession: BaseSession {

  /** uid */
  open var uid: Int {
    get {
      return int(forKey: "UID")
    }
    set {
      set(newValue, forKey: "UID")
    }
  }
  
  /** authType */
  open var authType: String {
    get {
      return string(forKey: "AUTH_TYPE") ?? ""
    }
    set {
      set(newValue, forKey: "AUTH_TYPE")
    }
  }
  
  /** imei */
  open var imei: String {
    get {
      return string(forKey: "IMEI") ?? ""
    }
    set {
      set(newValue, forKey: "IMEI")
    }
  }
  
  /** Location */
  open var location: CLLocation {
    get {
      let latitude = double(forKey: "LATITUDE")
      let longitude = double(forKey: "LONGITUDE")
      return CLLocation(latitude: latitude, longitude: longitude)
    }
    set {
      write {
        self.set(newValue.coordinate.latitude, forKey: "LATITUDE")
        self.set(newValue.coordinate.longitude, forKey: "LONGITUDE")
      }
    }
  }
  
  /** city */
  open var city: String! {
    get {
      return string(forKey: "CITY")
    }
    set {
      set(newValue, forKey: "CITY")
    }
  }
  
}
