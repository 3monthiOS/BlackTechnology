//
//  App.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

public struct App {

    public enum RunMode {
        case debug, test, release
    }

    public static var runMode: RunMode = .debug
    
    public static var bundle: Bundle {
        return Bundle.main
    }
    
    public static var version: String {
        return bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    public static var buildNumber: Int {
        return Int(bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0") ?? 0
    }
    
    public static var lang: String {
        return bundle.preferredLocalizations.first ?? ""
    }
    
}
