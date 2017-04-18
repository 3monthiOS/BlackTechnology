//
//  WebView.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import WebKit

open class WebView: UIView {

    // MARK:- statics

    fileprivate static var _userAgent: String!
    open static var userAgent: String {
        if _userAgent == nil {
            _userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent") ?? ""
        }
        let netType = Reachability.networkStatus.description
        let ua = "\(_userAgent) Aha/\(App.version) NetType/\(netType) Language/\(App.lang)"
        UserDefaults.standard.register(defaults: ["UserAgent": ua])
        return ua
    }

    open static var defaultProcessPool = WKProcessPool()
    open static var defaultConfiguration: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.processPool = defaultProcessPool
        config.userContentController = UserContentController()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 9.0, *) {
            config.websiteDataStore = WKWebsiteDataStore.default()
            config.requiresUserActionForMediaPlayback = false
        } else {
            config.mediaPlaybackRequiresUserAction = false
        }
        return config
    }

    // MARK: properties

    open var loadingProgressBar = UIProgressView()
    open var loadingProgressBarHidden: Bool = false {
        didSet {
            loadingProgressBar.isHidden = loadingProgressBarHidden
        }
    }

    open weak var serviceDelegate: WebViewServiceDelegate?
    open weak var navigationDelegate: WKNavigationDelegate?
    open weak var UIDelegate: WKUIDelegate?
    open var webView: WKWebView!

    // MARK: - init

    convenience init() {
        self.init(frame: CGRect.zero, configuration: WebView.defaultConfiguration)
    }

    override convenience init(frame: CGRect) {
        self.init(frame: frame, configuration: WebView.defaultConfiguration)
    }

    public init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame)
        self.setup(configuration)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup(WebView.defaultConfiguration)
    }

    fileprivate func setup(_ config: WKWebViewConfiguration) {
        // Setup WebView
        webView = WKWebView(frame: bounds, configuration: config)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(webView)

        // Setup User Content Controller
        if let userContentController = webView.configuration.userContentController as? UserContentController {
            userContentController.webView = self
        }

        // Setup User Agent
        if #available(iOS 9.0, *) {
            webView.customUserAgent = WebView.userAgent
        }

        // Setup Loading ProgressBar
        self.addSubview(loadingProgressBar)
        loadingProgressBar.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)
        loadingProgressBar.autoresizingMask = [.flexibleWidth]

        // Setup Navigation Delegate
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        // Setup UI Delegate
        webView.uiDelegate = self
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

    // MARK: - Custom Methods

    func loadURLString(_ urlString: String) -> WKNavigation? {
        if let url = Foundation.URL(string: urlString) {
            return loadRequest(URLRequest(url: url))
        }
        return nil
    }

    // MARK: - Observe Value For KeyPath

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey:Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.loadingProgressBar.progress = Float(0.1 + self.webView.estimatedProgress * 0.9)
        }
    }

}
