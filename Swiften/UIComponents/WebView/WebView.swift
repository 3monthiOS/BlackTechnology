//
//  WebView.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import WebKit
import ReachabilitySwift

public class WebView: UIView {
  
  // MARK:- statics
  
  public static var defaultProcessPool = WKProcessPool()
  public static var defaultConfiguration: WKWebViewConfiguration {
    let config = WKWebViewConfiguration()
    config.processPool = defaultProcessPool
    config.userContentController = UserContentController()
    config.allowsInlineMediaPlayback = true
		if #available(iOS 10.0, *) {
			config.websiteDataStore = .default()
			config.mediaTypesRequiringUserActionForPlayback = []
		} else if #available(iOS 9.0, *) {
      config.websiteDataStore = .default()
      config.requiresUserActionForMediaPlayback = false
    } else {
      config.mediaPlaybackRequiresUserAction = false
    }
    return config
  }
  
  // MARK: properties
	
	public var progressBar = UIProgressView()
	public var showProgressBarWhenLoading = true
  
  public weak var serviceDelegate: WebViewServiceDelegate?
  public weak var navigationDelegate: WKNavigationDelegate?
  public weak var uiDelegate: WKUIDelegate?
	
  public var webView: WKWebView!
  
  // MARK: - init
  
  public convenience init() {
    self.init(frame: CGRect.zero, configuration: WebView.defaultConfiguration)
  }
  
  public override convenience init(frame: CGRect) {
    self.init(frame: frame, configuration: WebView.defaultConfiguration)
  }
  
  public init(frame: CGRect, configuration: WKWebViewConfiguration) {
    super.init(frame: frame)
    setupWebView(configuration)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupWebView(WebView.defaultConfiguration)
  }
  
  private func setupWebView(_ config: WKWebViewConfiguration) {
    // Setup WebView
    webView = WKWebView(frame: bounds, configuration: config)
    webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(webView)
    
    // Setup User Content Controller
    if let userContentController = webView.configuration.userContentController as? UserContentController {
      userContentController.webView = self
    }
    
    // Setup Loading ProgressBar
    addSubview(progressBar)
		webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
		
    // Setup Navigation Delegate
    webView.navigationDelegate = self
		
    // Setup UI Delegate
    webView.uiDelegate = self
  }
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		let y = webView.scrollView.contentInset.top
		let width = bounds.size.width
		progressBar.frame = CGRect(x: 0, y: y, width: width, height: 1)
	}
  
  deinit {
    webView.removeObserver(self, forKeyPath: "estimatedProgress")
  }
  
  // MARK: - Custom Methods
  
  func load(urlString: String) -> WKNavigation? {
    guard let url = URL(string: urlString) else {
      return nil
    }
		return load(URLRequest(url: url))
  }
  
  // MARK: - Observe Value For KeyPath
  
  override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey:Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
			if showProgressBarWhenLoading {
				progressBar.progress = Float(0.1 + webView.estimatedProgress * 0.9)
			}
    }
  }
  
}
