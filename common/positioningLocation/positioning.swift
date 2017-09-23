//
//  positioning.swift
//  App
//
//  Created by 红军张 on 2017/7/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftLocation

public extension CLLocation {
    
    public var shortDesc: String {
        return "- lat,lng=\(self.coordinate.latitude),\(self.coordinate.longitude), h-acc=\(self.horizontalAccuracy) mts\n"
    }
    
}

class locationServiceUser {
    
    static let sharedInstance = locationServiceUser()
    
    var FormattedAddressLines: String = ""
    var State: String = ""
    var Country: String = ""
    var SubLocality: String = ""
    var Thoroughfare: String = ""
    var SubThoroughfare: String = "" {
        didSet{
            if let userinfos: User = cache.object(forKey: CacheManager.Key.User.rawValue) {
                user = userinfos
                user.FormattedAddressLines = locationUser.FormattedAddressLines
                user.country = locationUser.Country
                user.province = "省份暂时未赋值"
                user.city = locationUser.State
                user.SubLocality = locationUser.SubLocality
                user.Thoroughfare = locationUser.Thoroughfare
                Log.info(user.FormattedAddressLines)
            }
        }
    }
    private var timeoutNumber = 0
    //    private init() {}
    
    //MARK: 根据 精度 地址获取的位置
    func LocationMonitoringUser(){
        if timeoutNumber > 3 {   // 快速获取 经纬度，但是精度不高
            Location.onReceiveNewLocation = { location in
                print("新位置：\(location.shortDesc)" as Any)
                self.PositiveGeocoding(location: location)
            }
            return
        }
        let x = Location.getLocation(accuracy: .block, frequency: .oneShot, success: { (_, location) in
            print("获取最精确的地址经纬度 \(location)")
            self.PositiveGeocoding(location: location)
        }) { (request, last, error) in
            request.cancel() // stop continous location monitoring on error
            toast("获取地址失败 \(error)-----\(String(describing: last))---\(request)")
        }
        
        x.register(observer: LocObserver.onAuthDidChange(.main, { (request, oldAuth, newAuth) in
            if newAuth.description == "Restricted" || newAuth.description == "Denied" {
                x.cancel()
                alert("请检查你的app定位功能是否打开")
            }
        }))
    }
    //MARK: 反地理编码
    func ReverseGeocoding(address: String){
        Location.getLocation(forAddress: address, timeout: 60, cancelOnError: true, success: { placemark in
            toast("反地理编码成功-- 纬度：\(String(describing: placemark[0].location?.coordinate.latitude)) 经度：\(String(describing: placemark[0].location?.coordinate.longitude))")
        }) { error in
            toast("反地理编码失败 \(error)")
        }
    }
    //MARK: 地理编码
    func PositiveGeocoding(location: CLLocation){
        //        let loc = CLLocation(latitude: 31.04560000, longitude: 121.39970000) po placemarks[0].addressDictionary
        Location.getPlacemark(forLocation: location,  timeout: 60, success: { [weak self] placemarks in
            let dic = placemarks.first?.addressDictionary
            self?.FormattedAddressLines = (placemarks.first?.addressDictionary?["FormattedAddressLines"] as! [String])[0]  // 详细地址
            self?.Country = dic?["Country"] as! String // 国家
            self?.State = dic?["City"] as! String // 城市
            self?.SubLocality = dic?["SubLocality"] as! String // 区县
            self?.Thoroughfare = dic?["Thoroughfare"] as! String // 街道
            self?.SubThoroughfare = dic?["SubThoroughfare"] as! String // 街道牌号
            if self?.FormattedAddressLines == "地址未知" {
                self?.timeoutNumber += 1
                self?.LocationMonitoringUser()
            }else{
                self?.timeoutNumber = 0
            }
        }) { error in
            print("未找到此地址\(error)")
            self.timeoutNumber += 1
            self.LocationMonitoringUser()
        }
    }
    //MARK: 转动一定角度 就会触发 (更新用户标题)
    func didUpdateUserHeading() {
        do {
            try Location.getContinousHeading(filter: 0.5, success: { heading in
                print("New heading value \(heading)")
            }) { error in
                print("Failed to update heading \(error)")
            }
        } catch {
            print("Cannot start heading updates: \(error)")
        }
    }
    //MARK:
    //            Location.onAddNewRequest = { req in
    //            print("一个新的定位请求被 添加 \(req)")
    //            }
    //            Location.onRemoveRequest = { req in
    //            print("一个新的定位请求被 移除 \(req)")
    //            }
}
