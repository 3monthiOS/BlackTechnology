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
//import SwiftOCR

class ChatListviewcontroller: RCConversationListViewController {
    
    var request : ApiService?
    
    @IBOutlet weak var chatBGimage: UIImageView!
    var userId = ""
    let tokenArray = ["15225147792":"/7Ho4V0LAxqx1eeMZvJjIxEwXKiZajUg1lYnzbenGFogaU5Q8wQe3i4cPyJqgjLBrHIfKRaHVIyUG7tyo6E/Z1xb6BKkYi9r","18336093422":"E7V5pupiLPLwKarhAgnPFvyVRNEe+kEOk6zXm2XQoNOfjfi1kG/r4pLOfMim3fF1BmbWapvgkUY=","15249685697":"SaNRAdb1HvDSwXK/4Pejr6UNOrqEnO6vXv8cpipmaDmyq/6rAyPo0sCKcMwKe23s75GUDOcwZk7o2IyVY4SdeQ==","13968034167":"CJov2IWBq7H/CKoaiB9TQgIIlo0WhrAzzoatEDpPkLlXv74SI5Izo46/SCKfcn8Pqg1D6PXiDBY=","012345678910":"QPdoi2Ij1WZcLNpvo+PKIhEwXKiZajUg1lYnzbenGFogaU5Q8wQe3pwszl9J/nnfNFXN0ntL4ZVcW+gSpGIvaw=="]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delay(1) {
            self.tabBarController?.hidesBottomBarWhenPushed = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let token = tokenArray[user.userphone!] ?? tokenArray["012345678910"]
        // MARK: -- 用户登录
        RCIM.shared().connect(withToken: token,success: { (userId) -> Void in
            self.userId = userId!
            Log.info("登陆成功。当前登录的用户ID：\(String(describing: userId))")
            self.createDiscussionGroupsChat()
            }, error: { (status) -> Void in
                Log.info("登陆的错误码为:\(status.rawValue)")
            }, tokenIncorrect: {
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                Log.info("token错误")
        })
        initChatView()
        // MARK: -- 请求测试
//        requestTest()
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
        self.setCollectionConversationType([RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue])
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.right, Title: "单聊", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(privateChat))
//        createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.Left, Title: "讨论组", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(createDiscussionGroupsChat))
    }
    // MARK: -- 创建讨论组
    func createDiscussionGroupsChat(){
        RCIM.shared().createDiscussion("什么鬼讨论组", userIdList: ["zhj1214","CB","CB0","ZW","ZW0"], success: { (RCDiscussio) in
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
    // MARK: -- 单聊
    func privateChat() {
        //打开会话界面
        let chatWithSelf = RCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: userId)
        chatWithSelf?.title = "私聊"
        chatWithSelf?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatWithSelf!, animated: true)
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
        self.navigationController?.pushViewController(chat!, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: -- 连接状态监听器  如果使用的 IMLib 通过 setRCConnectionStatusChangeDelegate 方法来设置连接状态的监听。
extension ChatListviewcontroller: RCIMConnectionStatusDelegate{
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        switch status {
        case .ConnectionStatus_Connected:
            toast("连接成功", duration: nil, position: ToastPosition.bottom, title: "提示", image: UIImage(gifName: "gif131"))
        case .ConnectionStatus_NETWORK_UNAVAILABLE:
            toast("当前网络不可用",position: ToastPosition.bottom)
        case .ConnectionStatus_Cellular_3G_4G:
            toast("当前设备切换到 3G 或 4G 高速网络",position: ToastPosition.bottom)
        case .ConnectionStatus_WIFI:
            toast("当前设备切换到 WIFI 网络",position: ToastPosition.bottom)
        case .ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT:
            toast("当前用户在其他设备上登录，此设备被踢下线",position: ToastPosition.bottom)
        case .ConnectionStatus_TOKEN_INCORRECT:
            toast("Token无效",position: ToastPosition.bottom)
        case .ConnectionStatus_DISCONN_EXCEPTION:
            toast("与服务器的连接已断开",position: ToastPosition.bottom)
        case .ConnectionStatus_SignUp:
            toast("已注销",position: ToastPosition.bottom)
        default:
            return
        }
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
