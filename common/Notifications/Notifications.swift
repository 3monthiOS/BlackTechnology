//
//  Notifications.swift
//  aha
//
//  Created by Cator Vee on 12/8/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation
//import Swiften

struct Notifications {
	
	static let notificationCenter = NotificationCenter.default
	
	// 地理位置信息更新
	static var locationUpdated: Delegate = Delegate(name: "LocationUpdated")
	// 地址更新
	static var placeUpdated: Delegate = Delegate(name: "PlaceUpdated")
	// 聊天消息接收
    static var chatMessageReceived: Delegate = Delegate(name: "ChatMessageReceived")
    // 刷新聊天消息 的定时器
    static var timerChatMessageUpdate: Delegate = Delegate(name: "timerChatMessageUpdate")
	// 聊天消息上传消息
	static var chatMessageUploading: Delegate = Delegate(name: "ChatMessageUploading")
    // 新建聊天会话
    static var conversationStarting: Delegate = Delegate(name: "ConversationStarting")
    // 
    public static let reachabilityChanged: Delegate = Delegate(name: "ReachabilityChanged")
    
	class Delegate {
		fileprivate let name: String
		
		init(name: String) {
			self.name = name
		}
		
        func post(_ object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
			if object == nil {
				Log.info("@N>\(name) nil")
			} else {
				Log.info("@N>\(name) \(object!)")
			}
			async {
				notificationCenter.post(name: Notification.Name(rawValue: self.name), object: object, userInfo: userInfo)
			}
		}
		
		func addObserver(_ observer: AnyObject, selector: Selector, sender object: AnyObject? = nil) {
			Log.info("@N+\(name) \(selector)@\(observer)")
			notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
		}
		
		func removeObserver(_ observer: AnyObject, sender object: AnyObject? = nil) {
			Log.info("@N-\(name) \(observer)")
			notificationCenter.removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
		}
	}
	
	static func removeAllForObserver(_ observer: AnyObject) {
		Log.info("@N_\(observer)")
		notificationCenter.removeObserver(observer)
	}
}
