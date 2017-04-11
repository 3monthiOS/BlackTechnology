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
	
	public struct Info {
		public subscript(key: String) -> Any? {
			return Bundle.main.object(forInfoDictionaryKey: key)
		}
	}
	
	public static let info = Info()
	
	public static var name = "Switen"
  
  public static var runMode: RunMode = .debug
  
  public static var bundle: Bundle {
    return Bundle.main
  }
  
  public static var version: String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
  }
  
  public static var build: String {
		return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "0"
  }
  
  public static var lang: String {
    return bundle.preferredLocalizations.first ?? ""
  }
  
}
