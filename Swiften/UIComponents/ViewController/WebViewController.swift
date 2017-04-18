//
//  WebViewController.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit

open class WebViewController: UIViewController {
    @IBOutlet open var webView: WebView!

    fileprivate var URL: Foundation.URL!

    override open func viewDidLoad() {
        super.viewDidLoad()

        if webView == nil {
            webView = WebView(frame: view.bounds)
            view.addSubview(webView!)
        }

        if let URL = URL {
            load(from: URL)
            self.URL = nil
        }
    }

    open func load(from URL: Foundation.URL) {
        if webView != nil {
            load(URLRequest(url: URL))
        } else {
            self.URL = URL
        }
    }

    open func load(_ request: URLRequest) {
        webView.loadRequest(request)
    }

    // MARK: - Navigation

    open func close() {
        self.closeViewControllerAnimated(true)
    }

    open func back() {
        guard let webView = webView?.webView else { return }
        if webView.canGoBack {
            webView.goBack()
        } else {
            close()
        }
    }

    open func forward() {
        guard let webView = webView?.webView else { return }
        if webView.canGoForward {
            webView.goForward()
        }
    }

}

extension WebViewController {
    public class func open(urlString: String?) {
        guard let urlString = urlString else { return }
        open(URL: Foundation.URL(string: urlString))
    }

    public class func open(URL: Foundation.URL?) {
        guard let URL = URL else { return }
        let controller = WebViewController()
        controller.load(from: URL)
        controller.hidesBottomBarWhenPushed = true
        UIViewController.showViewController(controller, animated: true)
    }
}
