//
//  UserAgent.swift
//  Swiften
//
//  Created by Cator Vee on 11/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation
import WebKit
import ReachabilitySwift

public struct UserAgent {
	private static var browserUserAgent: String!
	public static var string: String {
		if browserUserAgent == nil {
			browserUserAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
		}
		let netType: String
		if let reachabilityStatus = Reachability()?.currentReachabilityStatus {
			switch reachabilityStatus {
			case .reachableViaWiFi:
				netType = "WiFi"
			case .reachableViaWWAN:
				netType = "WWAN"
			case .notReachable:
				netType = "NoConnection"
			}
		} else {
			netType = "Unknown"
		}
		return "\(browserUserAgent!) \(App.name)/\(App.version) NetType/\(netType) Language/\(App.lang)"
	}
	
	public static func apply(_ webView: WKWebView) {
		let userAgentString = UserAgent.string
		UserDefaults.standard.register(defaults: ["UserAgent": userAgentString])
		if #available(iOS 9.0, *) {
			webView.customUserAgent = userAgentString
		}
	}
}
