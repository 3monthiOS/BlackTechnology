//
//  AppChatScreenViewController.swift
//  App
//
//  Created by 红军张 on 16/9/28.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class AppChatScreenViewController: RCConversationViewController {

    var RCDiscussionview: RCDiscussion?
    override func viewDidLoad() {
        super.viewDidLoad()

        initChatscreenview()
    }

    func initChatscreenview(){
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        conversationType = RCConversationType.ConversationType_DISCUSSION
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//        targetId = "targetIdYouWillChatIn"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
