//
//  BaseSession.swift
//  Swiften
//
//  Created by Cator Vee on 19/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation

open class BaseSession: LocalStorage {
  /* Tick */
  open var tick: Int {
    let result = int(forKey: "TICK")
    set((result + 1) % Int.max, forKey: "TICK")
    return result
  }
  
  /* deviceId */
  open var deviceId: String {
    get {
      if let udid = string(forKey: "UDID") {
        return udid
      }
      let udid = UDID().udidString
      set(udid, forKey: "UDID")
      return udid
    }
    set {
      set(newValue, forKey: "UDID")
    }
  }
  
  /** token */
  open var token: String {
    get {
      return string(forKey: "TOKEN") ?? ""
    }
    set {
      set(newValue, forKey: "TOKEN")
    }
  }
  
}
