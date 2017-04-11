//
// Created by Cator Vee on 7/26/16.
// Copyright (c) 2016 Cator Vee. All rights reserved.
//

import Foundation
import WebKit

extension WebView: WKNavigationDelegate {
  public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard let url = navigationAction.request.url else {
      decisionHandler(.cancel)
      return
    }
		UserAgent.apply(webView)
    let urlString = url.absoluteString
    if urlString.contains("//itunes.apple.com/") || !urlString.hasPrefix("//") && !urlString.hasPrefix("http:") && !urlString.hasPrefix("https:") {
      UIApplication.shared.openURL(url)
      decisionHandler(.cancel)
    } else if navigationDelegate?.webView?(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler) == nil {
      decisionHandler(.allow)
    }
  }
  
  public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    if navigationDelegate?.webView?(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler) == nil {
      decisionHandler(.allow)
    }
  }
  
  public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    Log.info("webview: \(webView.url!.absoluteString)")
    if showProgressBarWhenLoading {
      progressBar.isHidden = false
      progressBar.progress = 0.1
    }
    navigationDelegate?.webView?(webView, didStartProvisionalNavigation: navigation)
  }
  
  public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    navigationDelegate?.webView?(webView, didReceiveServerRedirectForProvisionalNavigation: navigation)
  }
  
  public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
    Log.error("webview didFailProvisionalNavigation: \(error)")
    navigationDelegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
  }
  
  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		if showProgressBarWhenLoading {
			progressBar.isHidden = true
			progressBar.progress = 1
		}
    navigationDelegate?.webView?(webView, didFinish: navigation!)
  }
  
  public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    navigationDelegate?.webView?(webView, didCommit: navigation)
  }
  
  public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    navigationDelegate?.webView?(webView, didFail: navigation, withError: error)
  }
  
  public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		if navigationDelegate?.webView?(webView, didReceive: challenge, completionHandler: completionHandler) == nil {
      guard let hostName = webView.url?.host else {
        completionHandler(.cancelAuthenticationChallenge, nil);
        return
      }
      
      let authenticationMethod = challenge.protectionSpace.authenticationMethod
      if authenticationMethod == NSURLAuthenticationMethodDefault
        || authenticationMethod == NSURLAuthenticationMethodHTTPBasic
        || authenticationMethod == NSURLAuthenticationMethodHTTPDigest {
        let title = "身份认证"
        let message = "\(hostName)需要您的用户名和密码"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField {
          $0.placeholder = "用户名"
        }
        alertController.addTextField {
          $0.placeholder = "密码"
          $0.isSecureTextEntry = true
        }
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
          let username = alertController.textFields![0].text ?? ""
          let password = alertController.textFields![1].text ?? ""
          let credential = URLCredential(user: username, password: password, persistence: .none)
          completionHandler(.useCredential, credential)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
          completionHandler(.cancelAuthenticationChallenge, nil)
        }))
        async {
          UIViewController.topViewController?.present(alertController, animated: true, completion: nil)
        }
      } else if authenticationMethod == NSURLAuthenticationMethodServerTrust {
        completionHandler(.performDefaultHandling, nil)
      } else {
        completionHandler(.cancelAuthenticationChallenge, nil)
      }
    }
  }
  
  @available(iOS 9.0, *)
  public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
    navigationDelegate?.webViewWebContentProcessDidTerminate?(webView)
  }
}
