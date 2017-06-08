//
//  ChatListviewcontroller.swift
//  App
//
//  Created by 红军张 on 16/9/12.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
import Alamofire
import RainbowSwift
import SwiftOCR


class ChatListviewcontroller: RCConversationListViewController {
    
    var requwst : ApiService?
    
    @IBOutlet weak var chatBGimage: UIImageView!
    var userId = ""
    let tokenArray = ["/7Ho4V0LAxqx1eeMZvJjIxEwXKiZajUg1lYnzbenGFogaU5Q8wQe3i4cPyJqgjLBrHIfKRaHVIyUG7tyo6E/Z1xb6BKkYi9r","E7V5pupiLPLwKarhAgnPFvyVRNEe+kEOk6zXm2XQoNOfjfi1kG/r4pLOfMim3fF1BmbWapvgkUY=","SaNRAdb1HvDSwXK/4Pejr6UNOrqEnO6vXv8cpipmaDmyq/6rAyPo0sCKcMwKe23s75GUDOcwZk7o2IyVY4SdeQ==","CJov2IWBq7H/CKoaiB9TQgIIlo0WhrAzzoatEDpPkLlXv74SI5Izo46/SCKfcn8Pqg1D6PXiDBY=","QPdoi2Ij1WZcLNpvo+PKIhEwXKiZajUg1lYnzbenGFogaU5Q8wQe3pwszl9J/nnfNFXN0ntL4ZVcW+gSpGIvaw=="]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(1) {
            self.tabBarController?.hidesBottomBarWhenPushed = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "聊天"
        let token = tokenArray[Int(arc4random()%4)]
        
        RCIM.shared().connect(withToken: token,success: { (userId) -> Void in
            self.userId = userId!
            print("登陆成功。当前登录的用户ID：\(String(describing: userId))")
            }, error: { (status) -> Void in
                print("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                print("token错误")
        })

        initChatView()
        requestTest()
        
        print("Red text".red)
        print("Yellow background".onYellow)
       
        
        Log.info(Device.version())
        
        let swiftOCRInstance   = SwiftOCR()
        let image = UIImage(named:"test0")
        swiftOCRInstance.recognize(image!) {recognizedString in
            print("_______________\(recognizedString)")
        }
    }
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
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue])
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.right, Title: "单聊", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(privateChat))
//        createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.Left, Title: "讨论组", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(createDiscussionGroupsChat))
        createDiscussionGroupsChat()
    }
    func createDiscussionGroupsChat(){
        RCIM.shared().createDiscussion("什么鬼", userIdList: ["zhj1214","CB","CB0","ZW","ZW0"], success: { (RCDiscussio) in
            Log.info("创建讨论组成功")
//            let chatWithSelf = AppChatScreenViewController(conversationType: RCConversationType.ConversationType_DISCUSSION, targetId: RCDiscussio.discussionId)
//            chatWithSelf.title = RCDiscussio.discussionName
//            chatWithSelf.targetId = RCDiscussio.discussionId
//            chatWithSelf.hidesBottomBarWhenPushed = true
//            UIViewController.showViewController(chatWithSelf, animated: true)

        }) { (error) in
            Log.info("创建讨论组失败\(error)")
        }
    }
    func privateChat() {
        //打开会话界面
        let chatWithSelf = RCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userId)
        chatWithSelf?.title = "私聊"
        chatWithSelf?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatWithSelf!, animated: true)
    }
    
    func logout() {
        //断开连接并设置不再接收推送消息
        RCIM.shared().disconnect(false)
        self.navigationController?.popViewController(animated: true)
    }
    //重写RCConversationListViewController的onSelectedTableRow事件
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        //打开会话界面
        let chat = AppChatScreenViewController(conversationType: model.conversationType, targetId: model.targetId)
        chat?.title = "聊天界面"
        chat?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chat!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: -- 请求测试
extension ChatListviewcontroller{
    
    func requestTest(){
        HttpClient.default.adapter = AccessTokenAdapter()
        HttpClient.defaultEncoding = JerseyEncoding.default
        HttpClient.errorFieldName = "msg"
        testParam()
    }
    
    func testParam() {
        testObject()
    }
    
    func testObject() {
        Api.testArrayStringBaiDu.call { (response: ApiObjectResponse<MessageBody>) in
            if let value = response.value {
                let json = value.toJSONString()
                Log.info("\(String(describing: json))")
            }
        }
    }

}
