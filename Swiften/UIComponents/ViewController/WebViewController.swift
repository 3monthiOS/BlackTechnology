//
//  WebViewController.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

open class WebViewController: UIViewController {
  @IBOutlet public var webView: WebView!
  
  public var url: URL!
  
  override open func viewDidLoad() {
    super.viewDidLoad()
    
    if webView == nil {
      webView = WebView(frame: view.bounds)
      view.addSubview(webView!)
    }
		webView.webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
		
    if let url = url {
      webView.load(URLRequest(url: url))
      self.url = nil
    }
  }
  
  // MARK: - Navigation
  
  open func close() {
    self.hide(animated: true)
  }
  
  open func back() {
		if webView?.canGoBack == true {
      webView.goBack()
    } else {
      close()
    }
  }
  
  open func forward() {
    if webView?.canGoForward == true {
      webView.goForward()
    }
  }
	
	open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "title" {
			title = webView.title
		}
	}
	
	deinit {
		webView.webView.removeObserver(self, forKeyPath: "title")
	}
}

extension WebViewController {
  open class func open(urlString: String?) {
    guard let urlString = urlString else {
      return
    }
    open(url: URL(string: urlString))
  }
  
  open class func open(url: URL?) {
    guard let url = url else {
      return
    }
    let viewController = WebViewController()
		viewController.url = url
    viewController.hidesBottomBarWhenPushed = true
    UIViewController.show(viewController, animated: true)
  }
}
