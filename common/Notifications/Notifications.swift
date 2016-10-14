//
//  Notifications.swift
//  aha
//
//  Created by Cator Vee on 12/8/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation
import Swiften

struct Notifications {
	
	static let notificationCenter = NSNotificationCenter.defaultCenter()
	
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
    // 跳转 主页面
    
	class Delegate {
		private let name: String
		
		init(name: String) {
			self.name = name
		}
		
        func post(object: AnyObject? = nil, userInfo: [NSObject : AnyObject]? = nil) {
			if object == nil {
				Log.info("@N>\(name) nil")
			} else {
				Log.info("@N>\(name) \(object!)")
			}
			async {
				notificationCenter.postNotificationName(self.name, object: object, userInfo: userInfo)
			}
		}
		
		func addObserver(observer: AnyObject, selector: Selector, sender object: AnyObject? = nil) {
			Log.info("@N+\(name) \(selector)@\(observer)")
			notificationCenter.addObserver(observer, selector: selector, name: name, object: object)
		}
		
		func removeObserver(observer: AnyObject, sender object: AnyObject? = nil) {
			Log.info("@N-\(name) \(observer)")
			notificationCenter.removeObserver(observer, name: name, object: object)
		}
	}
	
	static func removeAllForObserver(observer: AnyObject) {
		Log.info("@N_\(observer)")
		notificationCenter.removeObserver(observer)
	}
}