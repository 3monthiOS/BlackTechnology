//
//  WebView+EmbedService.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

public protocol WebViewServiceDelegate: NSObjectProtocol {
    func webView(_ webView: WebView, didCallService service: String, withStatus status: Bool, message: Any, options: WebView.EmbedService.Options)
    func webView(_ webView: WebView, didCancelService service: String, withOptions options: WebView.EmbedService.Options)
}

extension WebView {

    open class EmbedService: NSObject {

        public typealias Options = [String: AnyObject]

        open weak var userContentController: UserContentController?
        fileprivate var optionsDict = [String: Options]()

        public init(userContentController: UserContentController) {
            self.userContentController = userContentController
        }

        open func process(_ methodName: String, options: JSON) {
            let selector = Selector("call_\(methodName):")
            if self.responds(to: selector) {
                Log.info("embed service: \(options.jsonString)")
                self.performSelector(inBackground: selector, with: options.object)
            } else {
                Log.error("unknown embed service: \(options.jsonString)")
            }
        }

        open func callback(_ success: Bool, msg: Any, options: Options, evaluateJavaScript: Bool = true) {
            guard let webView = userContentController?.webView else { return }

            let methodName = options[userContentController!.methodKey] as! String
            webView.serviceDelegate?.webView(webView, didCallService: methodName, withStatus: success, message: msg, options: options)

            guard evaluateJavaScript else { return }

            let result = JSON(["success": success, "msg": msg as AnyObject]).jsonString
            if let webView = userContentController!.webView.webView {
                let callbackFunction = success ? options["success"]: options["fail"]
                if let funcname = callbackFunction as? String {
                    Log.info("embed service: \(success ? "success" : "fail") \(funcname)(\(methodName))")
                    webView.evaluateJavaScript("\(funcname)(\(result))", completionHandler: nil)
                }
                if let complete = options["complete"] as? String {
                    Log.info("embed service: complete \(complete)(\(methodName))")
                    webView.evaluateJavaScript("\(complete)(\(result))", completionHandler: nil)
                }
            }
        }

        open func cancel(_ options: Options) {
            guard let webView = userContentController?.webView else { return }

            let methodName = options[userContentController!.methodKey] as! String
            webView.serviceDelegate?.webView(webView, didCancelService: methodName, withOptions: options)

            if let webView = webView.webView, let funcname = options["cancel"] as? String {
                Log.info("embed service: cancel")
                webView.evaluateJavaScript("\(funcname)()", completionHandler: nil)
            }
        }

        // MARK: - getAppVersion
        func call_getAppVersion(_ options: Options) {
            callback(true, msg: [
                "versionCode": App.buildNumber,
                "versionName": App.version
                ], options: options)
        }

    }

}
