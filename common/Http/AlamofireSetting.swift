//
//  AlfireManager.swift
//  aha
//
//  Created by feng will on 15/11/20.
//  Copyright © 2015年 Ledong. All rights reserved.
//
import Foundation
import Alamofire
import AlamofireImage
import Swiften

class NetworkManager {
    static let sharedInstace = NetworkManager()
    
    static let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
    
    static func initNetworkManager() {
        URLCache.activate()
        
        var headers = Alamofire.Manager.defaultHTTPHeaders
        headers["Cache-Control"] = "private"
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30 // 网络超时时间
        configuration.HTTPAdditionalHeaders = headers
        configuration.HTTPAdditionalHeaders!["User-Agent"] = WebView.userAgent
        configuration.HTTPCookieStorage = cookieStorage
        configuration.URLCache = URLCache.sharedURLCache()
        configuration.requestCachePolicy = .ReturnCacheDataElseLoad
        
        let manager = Alamofire.Manager(configuration: configuration)
        
        let sharedImageDownloader = ImageDownloader(sessionManager: manager)
        
        UIImageView.af_sharedImageDownloader = sharedImageDownloader
        UIButton.af_sharedImageDownloader = sharedImageDownloader
    }
    
    static func removeAllCookies() {
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                //dispatch_sync(dispatch_get_main_queue()) {
                    cookieStorage.deleteCookie(cookie)
                //}
            }
        }
    }
    
    let defaultManager: Alamofire.Manager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//            "dev.ahasou.com": .PinCertificates(
//                certificates: ServerTrustPolicy.certificatesInBundle(),
//                validateCertificateChain: true,
//                validateHost: true
//            )
//            ,
            api.host: .DisableEvaluation,
            "api.datamarket.azure.com": .DisableEvaluation
        ]
        
        var headers = Alamofire.Manager.defaultHTTPHeaders
        headers["Cache-Control"] = "private"
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 30 // 网络超时时间
        configuration.HTTPAdditionalHeaders = headers
        configuration.HTTPAdditionalHeaders!["User-Agent"] = WebView.userAgent
        configuration.HTTPCookieStorage = cookieStorage
        configuration.URLCache = URLCache.sharedURLCache()
        
        return Alamofire.Manager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
}