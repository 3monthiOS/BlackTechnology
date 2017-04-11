//
//  WebView+EmbedService.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol WebViewServiceDelegate: NSObjectProtocol {
  func webView(_ webView: WebView, didCallService service: String, withStatus status: Bool, result: Any, options: JSON)
  func webView(_ webView: WebView, didCancelService service: String, withOptions options: JSON)
}

extension WebView {
  
  open class EmbedService: NSObject {
    
    public weak var userContentController: UserContentController!
		
    public init(userContentController: UserContentController) {
      self.userContentController = userContentController
    }
    
    public func process(_ serviceName: String, options: JSON) {
			let selector = Selector("call_\(serviceName):")
      if self.responds(to: selector) {
        Log.info("embed service: \(options.jsonString)")
        self.performSelector(inBackground: selector, with: options)
      } else {
        Log.error("unknown embed service: \(options.jsonString)")
      }
    }
    
    public func callback(_ success: Bool, result: Any, options: JSON, evaluateJavaScript: Bool = true) {
      guard let webView = userContentController.webView else { return }
			
			let serviceNameKey = userContentController!.compatible ? userContentController!.compatibleServiceNameKey : userContentController!.serviceNameKey
      let serviceName = options[serviceNameKey].stringValue
      webView.serviceDelegate?.webView(webView, didCallService: serviceName, withStatus: success, result: result, options: options)
      
      guard evaluateJavaScript else { return }
			
			let json: JSON
			if userContentController!.compatible {
				json = JSON(["success": success, "msg": result])
			} else {
				json = JSON(["success": success, "result": result])
			}
      let result = json.rawString(.utf8, options: JSONSerialization.WritingOptions()) ?? ""
      if let webView = userContentController!.webView.webView {
        let callbackFunction = success ? options["success"] : options["fail"]
        if let funcname = callbackFunction.string {
          Log.info("embed service: \(serviceName) \(success ? "success" : "fail") \(funcname)()")
          webView.evaluateJavaScript("\(funcname)(\(result))", completionHandler: nil)
        }
        if let funcname = options["complete"].string {
          Log.info("embed service: \(serviceName) complete \(funcname)()")
          webView.evaluateJavaScript("\(funcname)(\(result))", completionHandler: nil)
        }
      }
    }
    
    public func cancel(_ options: JSON) {
      guard let webView = userContentController?.webView else { return }
			
			let serviceNameKey = userContentController!.compatible ? userContentController!.compatibleServiceNameKey : userContentController!.serviceNameKey
      let serviceName = options[serviceNameKey].stringValue
      webView.serviceDelegate?.webView(webView, didCancelService: serviceName, withOptions: options)
      
      if let webView = webView.webView, let funcname = options["cancel"].string {
        Log.info("embed service: \(serviceName) cancel \(funcname)()")
        webView.evaluateJavaScript("\(funcname)()", completionHandler: nil)
      }
    }
    
    // MARK: - getAppVersion
    public func call_getAppVersion(_ options: Any) {
      callback(true, result: ["version": App.version, "build": App.build], options: options as! JSON)
    }
    
  }
  
}
