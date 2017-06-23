//
//  BaiduLocationManager.swift
//  grapefruit
//
//  Created by MaoMarco on 16/2/17.
//  Copyright © 2016年 Ledong. All rights reserved.
//

import Foundation
//import Swiften

class BaiduLocationManager {
    
    fileprivate struct Singleton {
        static var running = true
        static var inited = false
        static var allowed = false
        static let locationManager = BMKLocationService()
        static let locationServiceDelegate = LocationServiceDelegate()
    }
    
    class LocationServiceDelegate: NSObject, BMKLocationServiceDelegate {
        
        func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
//            Log.info("BMK: heading is \(userLocation.heading)")
        }
        
        func didUpdate (_ userLocation: BMKUserLocation!) {
            let location = userLocation.location
            Log.info("location update: \(String(describing: location))")
            session.location = location!
            Notifications.locationUpdated.post(location)
        }
        
        func didFailToLocateUserWithError(_ error: Error!) {
            Log.error("BMK: \(error)")
        }
    }
    
    class func locationServiceIsEnabledAndAuthorized() -> Bool {
        return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied
    }
    
    class func startLocationService(){
        if Singleton.running {
            stopLocationService()
        }
        
        if !Singleton.inited {
            Singleton.locationManager.delegate = Singleton.locationServiceDelegate
            Singleton.inited = true
        }
        
        if locationServiceIsEnabledAndAuthorized() {
            Singleton.running = true
            Singleton.locationManager.startUserLocationService()
        } else {
            delay(1) {
                self.startLocationService()
            }
        }
    }
    
    class func stopLocationService() {
        if Singleton.running {
            Singleton.locationManager.stopUserLocationService()
            Singleton.running = false
        }
    }

}
