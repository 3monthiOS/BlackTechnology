//
// Created by Cator Vee on 7/26/16.
// Copyright (c) 2016 Cator Vee. All rights reserved.
//

import Foundation
import WebKit

extension WebView: WKUIDelegate {
  
  public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    return uiDelegate?.webView?(webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
  }
  
  @available(iOS 9.0, *)
  public func webViewDidClose(_ webView: WKWebView) {
    uiDelegate?.webViewDidClose?(webView)
  }
  
  public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    alert(message, completion: completionHandler)
  }
  
  public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    confirm(message, completion: completionHandler)
  }
  
  public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt message: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    prompt(message, title: nil, text: defaultText, completion: completionHandler)
  }
	
	@available(iOS 10.0, *)
	public func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
		return uiDelegate?.webView?(webView, shouldPreviewElement: elementInfo) ?? false
	}
	
	@available(iOS 10.0, *)
	public func webView(_ webView: WKWebView, previewingViewControllerForElement elementInfo: WKPreviewElementInfo, defaultActions previewActions: [WKPreviewActionItem]) -> UIViewController? {
		return uiDelegate?.webView?(webView, previewingViewControllerForElement: elementInfo, defaultActions: previewActions)
	}
	
	@available(iOS 10.0, *)
	public func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController) {
		uiDelegate?.webView?(webView, commitPreviewingViewController: previewingViewController)
	}
}
