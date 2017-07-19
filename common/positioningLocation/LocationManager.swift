//
//  LocationManager.swift
//  Maintenance
//
//  Created by 小幺和大土豆 on 15/12/8.
//  Copyright © 2015年 ST. All rights reserved.
//

import UIKit
import CoreLocation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


typealias locationAddress = ((_ address: String) -> ())

class LocationManager: NSObject {
  
  static let sharedInstance = LocationManager()
  fileprivate var _locationManager: CLLocationManager!
  var address: String!
  var addressHandle: locationAddress?
  var hasGetAddress: Bool = false
  
  fileprivate override init() {
    super.init()
    _locationManager = CLLocationManager()
  }
  
  private func startUpdateLocation() {
    
    if !CLLocationManager.locationServicesEnabled() {
      let alert = UIAlertController(title: "定位服务当前可能尚未打开，请设置打开！", message: "", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
      alert.addAction(UIAlertAction(title: "设置", style: .default, handler: { (ac) in
        self.toSetting()
      }))
      UIViewController.topViewController?.present(alert, animated: true, completion: nil)
      return
    }
    
    if CLLocationManager.authorizationStatus().hashValue == 2 {
      let alert = UIAlertController(title: "请在【定位服务】>【App】中打开开关", message: "", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: nil))
      alert.addAction(UIAlertAction(title: "设置", style: .default, handler: { (ac) in
        self.toSetting()
      }))
      UIViewController.topViewController?.present(alert, animated: true, completion: nil)
      return
    }
  
    if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
      _locationManager.requestWhenInUseAuthorization()
    } else {
      _locationManager.delegate = self
      _locationManager.desiredAccuracy = kCLLocationAccuracyBest
      let distance = 50.0
      _locationManager.distanceFilter = distance
      _locationManager.startUpdatingLocation()
    }
  }
  private func toSetting() {
    let url = URL(string: "prefs:root=LOCATION_SERVICES")
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.open(url)
    }
  }
  
  private func stopUpdateLocation() {
    _locationManager.stopUpdatingLocation()
  }
  
  private func getReverseGeocodeWithCoordiate(_ coordiate:CLLocationCoordinate2D) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: coordiate.latitude, longitude: coordiate.longitude)
    geocoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
      if error != nil {
        return
      }
      if placemarks?.count > 0 {
        let placemark = placemarks?.first
        guard let _ = placemark else { return }
        self.address = placemark!.name!
        self.hasGetAddress = true
        addressHandle?(address)
      }
      stopUpdateLocation()
    }
  }
}
// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.first
    let coordinate = location?.coordinate
    if !hasGetAddress {
      getReverseGeocodeWithCoordiate(coordinate!)
    }
  }
}
