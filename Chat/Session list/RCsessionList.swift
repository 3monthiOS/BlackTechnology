//
//  RCsessionList.swift
//  App
//
//  Created by 红军张 on 2017/11/8.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import Alamofire

class RCsessionListcontroller: RCConversationListViewController {
    
    var request : ApiService?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let bar = self.tabBarController as! RAMAnimatedTabBarController
        bar.hideAndShowCustomIcons(isHidden: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = RCtokenArray[user.userphone!] ?? RCtokenArray["012345678910"]
        // MARK: -- 用户登录
        RCIM.shared().connect(withToken: token,success: { (userId) -> Void in
            user.rcUserId = userId!
            Log.info("登陆成功。当前登录的用户ID：\(String(describing: userId))")
            self.quitGroupsmembers()
        }, error: { (status) -> Void in
            Log.info("登陆的错误码为:\(status.rawValue)")
        }, tokenIncorrect: {
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            Log.info("token错误")
        })
        initChatView()
    }

    // MARK: -- 会话类型展示
    func initChatView(){
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        //设置需要显示哪些类型的会话
        self.setDisplayConversationTypes([RCConversationType.ConversationType_PRIVATE.rawValue,
                                          RCConversationType.ConversationType_DISCUSSION.rawValue,
                                          RCConversationType.ConversationType_CHATROOM.rawValue,
                                          RCConversationType.ConversationType_GROUP.rawValue,
                                          RCConversationType.ConversationType_APPSERVICE.rawValue,
                                          RCConversationType.ConversationType_SYSTEM.rawValue])
        //设置需要将哪些类型的会话在会话列表中聚合显示
        self.setCollectionConversationType([RCConversationType.ConversationType_CHATROOM.rawValue,
                                            RCConversationType.ConversationType_SYSTEM.rawValue])
    }
    // MARK: -- 获取到所有的会话列表
    func quitGroupsmembers(){
        let _ = RCIMClient.shared().getConversationList([
            RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_PUBLICSERVICE.rawValue
            ])
        //        if let array = sessionArray as? [RCConversation] {
        
        //            for object in array {
        //                Log.info("会话id：\(object.targetId) 会话类型\(object.conversationType) 绘画标题:\(object.conversationTitle)")
        //                let groups = RCGroup()
        //                groups.groupName = object.conversationTitle
        //                groups.portraitUri = "http://static.open-open.com/news/uploadImg/20160107/20160107084321_658.png"
        //                RCIM.shared().refreshGroupInfoCache(groups, withGroupId: object.targetId)
        //            }
        RCIM.shared().globalNavigationBarTintColor = UIColor.red
        
        //            RCIM.shared().quitDiscussion(array[1].targetId, success: { (groups) in
        //                Log.info("退出成功---\(String(describing: groups?.discussionName))")
        //            }) { (error) in
        //                Log.info("退出讨论组失败\(error)")
        //            }
        //        }
    }

    // MARK: -- 断开连接并设置不再接收推送消息
    func logout() {
        RCIM.shared().disconnect(false)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: -- 重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        //打开会话界面
        let chat = AppChatScreenViewController(conversationType: model.conversationType, targetId: model.targetId)
        chat?.title = "聊天界面"
        let bar = self.tabBarController as! RAMAnimatedTabBarController
        bar.hideAndShowCustomIcons(isHidden: true)
        self.navigationController?.pushViewController(chat!, animated: true)
    }
}


