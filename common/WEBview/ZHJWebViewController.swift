//
//  ZHJWebViewController.swift
//  App
//
//  Created by 红军张 on 2017/10/18.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import WebKit
import ObjectMapper
import SwiftyJSON
import CoreLocation
import Alamofire

class ZHJWebViewController: UIViewController  {
    var webView: WebView? = nil
    
    var _urlString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if webView == nil {
            webView = WebView(frame: self.view.frame)
            self.view.addSubview(webView!)
        }
        if let urlString = _urlString {
            let _ = webView?.loadURLString(urlString)
        }
        self.title = webView?.title
    }
    
    func loadURLString(urlString: String) {
        if let webView = webView {
            let _ = webView.loadURLString(urlString)
        } else {
            _urlString = urlString
        }
    }
    
    // MARK: - Navigation
    
    func goHome() {
        if self.navigationController != nil {
            if(self != self.navigationController!.viewControllers.first){
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        //        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func back() {
        guard let webView = webView?.webView else { return }
        if webView.canGoBack {
            webView.goBack()
        } else {
            goHome()
        }
    }
    
    func forward() {
        guard let webView = webView?.webView else { return }
        if webView.canGoForward {
            webView.goForward()
        }
    }
}

