//
// Created by Cator Vee on 7/26/16.
// Copyright (c) 2016 Cator Vee. All rights reserved.
//

import Foundation
import WebKit

extension WebView {
	
	/*! @abstract A copy of the configuration with which the web view was
	initialized. */
	open var configuration: WKWebViewConfiguration { return webView.configuration }
	
	/*! @abstract The web view's back-forward list. */
	open var backForwardList: WKBackForwardList { return webView.backForwardList }
	
	/*! @abstract Navigates to a requested URL.
	@param request The request specifying the URL to which to navigate.
	@result A new navigation for the given request.
	*/
	@discardableResult
	open func load(_ request: URLRequest) -> WKNavigation? {
		return webView.load(request)
	}
	
	/*! @abstract Navigates to the requested file URL on the filesystem.
	@param URL The file URL to which to navigate.
	@param readAccessURL The URL to allow read access to.
	@discussion If readAccessURL references a single file, only that file may be loaded by WebKit.
	If readAccessURL references a directory, files inside that file may be loaded by WebKit.
	@result A new navigation for the given file URL.
	*/
	@available(iOS 9.0, *)
	@discardableResult
	open func loadFileURL(_ URL: URL, allowingReadAccessTo readAccessURL: URL) -> WKNavigation? {
		return webView.loadFileURL(URL, allowingReadAccessTo: readAccessURL)
	}
	
	/*! @abstract Sets the webpage contents and base URL.
	@param string The string to use as the contents of the webpage.
	@param baseURL A URL that is used to resolve relative URLs within the document.
	@result A new navigation.
	*/
	@discardableResult
	open func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
		return webView.loadHTMLString(string, baseURL: baseURL)
	}
	
	/*! @abstract Sets the webpage contents and base URL.
	@param data The data to use as the contents of the webpage.
	@param MIMEType The MIME type of the data.
	@param encodingName The data's character encoding name.
	@param baseURL A URL that is used to resolve relative URLs within the document.
	@result A new navigation.
	*/
	@available(iOS 9.0, *)
	@discardableResult
	open func load(_ data: Data, mimeType MIMEType: String, characterEncodingName: String, baseURL: URL) -> WKNavigation? {
		return webView.load(data, mimeType: MIMEType, characterEncodingName: characterEncodingName, baseURL: baseURL)
	}
	
	/*! @abstract Navigates to an item from the back-forward list and sets it
	as the current item.
	@param item The item to which to navigate. Must be one of the items in the
	web view's back-forward list.
	@result A new navigation to the requested item, or nil if it is already
	the current item or is not part of the web view's back-forward list.
	@seealso backForwardList
	*/
	@discardableResult
	open func go(to item: WKBackForwardListItem) -> WKNavigation? {
		return webView.go(to: item)
	}
	
	/*! @abstract The page title.
	@discussion @link WKWebView @/link is key-value observing (KVO) compliant
	for this property.
	*/
	open var title: String? { return webView.title }
	
	/*! @abstract The active URL.
	@discussion This is the URL that should be reflected in the user
	interface.
	@link WKWebView @/link is key-value observing (KVO) compliant for this
	property.
	*/
	open var url: URL? { return webView.url }
	
	/*! @abstract A Boolean value indicating whether the view is currently
	loading content.
	@discussion @link WKWebView @/link is key-value observing (KVO) compliant
	for this property.
	*/
	open var isLoading: Bool { return webView.isLoading }
	
	/*! @abstract An estimate of what fraction of the current navigation has been completed.
	@discussion This value ranges from 0.0 to 1.0 based on the total number of
	bytes expected to be received, including the main document and all of its
	potential subresources. After a navigation completes, the value remains at 1.0
	until a new navigation starts, at which point it is reset to 0.0.
	@link WKWebView @/link is key-value observing (KVO) compliant for this
	property.
	*/
	open var estimatedProgress: Double { return webView.estimatedProgress }
	
	/*! @abstract A Boolean value indicating whether all resources on the page
	have been loaded over securely encrypted connections.
	@discussion @link WKWebView @/link is key-value observing (KVO) compliant
	for this property.
	*/
	open var hasOnlySecureContent: Bool { return webView.hasOnlySecureContent }
	
	/*! @abstract A SecTrustRef for the currently committed navigation.
	@discussion @link WKWebView @/link is key-value observing (KVO) compliant
	for this property.
	*/
	@available(iOS 10.0, *)
	open var serverTrust: SecTrust? { return webView.serverTrust }
	
	/*! @abstract A Boolean value indicating whether there is a back item in
	the back-forward list that can be navigated to.
	@discussion @link WKWebView @/link is key-value observing (KVO) compliant
	for this property.
	@seealso backForwardList.
	*/
	open var canGoBack: Bool { return webView.canGoBack }
	
	/*! @abstract A Boolean value indicating whether there is a forward item in
	the back-forward list that can be navigated to.
	@discussion @link WKWebView @/link is key-value observing (KVO) compliant
	for this property.
	@seealso backForwardList.
	*/
	open var canGoForward: Bool { return webView.canGoForward }
	
	/*! @abstract Navigates to the back item in the back-forward list.
	@result A new navigation to the requested item, or nil if there is no back
	item in the back-forward list.
	*/
	@discardableResult
	open func goBack() -> WKNavigation? {
		return webView.goBack()
	}
	
	/*! @abstract Navigates to the forward item in the back-forward list.
	@result A new navigation to the requested item, or nil if there is no
	forward item in the back-forward list.
	*/
	@discardableResult
	open func goForward() -> WKNavigation? {
		return webView.goForward()
	}
	
	/*! @abstract Reloads the current page.
	@result A new navigation representing the reload.
	*/
	@discardableResult
	open func reload() -> WKNavigation? {
		return webView.reload()
	}
	
	/*! @abstract Reloads the current page, performing end-to-end revalidation
	using cache-validating conditionals if possible.
	@result A new navigation representing the reload.
	*/
	@discardableResult
	open func reloadFromOrigin() -> WKNavigation? {
		return webView.reloadFromOrigin()
	}
	
	/*! @abstract Stops loading all resources on the current page.
	*/
	open func stopLoading() {
		return webView.stopLoading()
	}
	
	/* @abstract Evaluates the given JavaScript string.
	@param javaScriptString The JavaScript string to evaluate.
	@param completionHandler A block to invoke when script evaluation completes or fails.
	@discussion The completionHandler is passed the result of the script evaluation or an error.
	*/
	open func evaluateJavaScript(_ javaScriptString: String, completionHandler: ((Any?, Error?) -> Swift.Void)? = nil) {
		webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler)
	}
	
	/*! @abstract A Boolean value indicating whether horizontal swipe gestures
	will trigger back-forward list navigations.
	@discussion The default value is NO.
	*/
	open var allowsBackForwardNavigationGestures: Bool {
		get {
			return webView.allowsBackForwardNavigationGestures
		}
		set {
			webView.allowsBackForwardNavigationGestures = newValue
		}
	}
	
	/*! @abstract The custom user agent string or nil if no custom user agent string has been set.
	*/
	@available(iOS 9.0, *)
	open var customUserAgent: String? {
		get {
			return webView.customUserAgent
		}
		set {
			webView.customUserAgent = newValue
		}
	}
	
	/*! @abstract A Boolean value indicating whether link preview is allowed for any
	links inside this WKWebView.
	@discussion The default value is YES on Mac and iOS.
	*/
	@available(iOS 9.0, *)
	open var allowsLinkPreview: Bool {
		get {
			return webView.allowsLinkPreview
		}
		set {
			webView.allowsLinkPreview = newValue
		}
	}
	
	/*! @abstract The scroll view associated with the web view.
	*/
	open var scrollView: UIScrollView { return webView.scrollView }

}
