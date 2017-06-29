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
    // 15249685697: cb , 012345678910：CB0 , 13968034167 :ZW ,15225147792 : GF ,18336093422: zhj1214,00000000000 :ZW0
    let tokenArray = ["18336093422":"/7Ho4V0LAxqx1eeMZvJjIxEwXKiZajUg1lYnzbenGFogaU5Q8wQe3i4cPyJqgjLBrHIfKRaHVIyUG7tyo6E/Z1xb6BKkYi9r","15249685697":"E7V5pupiLPLwKarhAgnPFvyVRNEe+kEOk6zXm2XQoNOfjfi1kG/r4pLOfMim3fF1BmbWapvgkUY=","012345678910":"SaNRAdb1HvDSwXK/4Pejr6UNOrqEnO6vXv8cpipmaDmyq/6rAyPo0sCKcMwKe23s75GUDOcwZk7o2IyVY4SdeQ==","13968034167":"CJov2IWBq7H/CKoaiB9TQgIIlo0WhrAzzoatEDpPkLlXv74SI5Izo46/SCKfcn8Pqg1D6PXiDBY=","00000000000":"QPdoi2Ij1WZcLNpvo+PKIhEwXKiZajUg1lYnzbenGFogaU5Q8wQe3pwszl9J/nnfNFXN0ntL4ZVcW+gSpGIvaw==","15225147792":"LTNPDKoMc06ryzJSygT/e6UNOrqEnO6vXv8cpipmaDk7dLOTy3QFRAwVIhTyu7UORvISmSVEhPUNtzeXCPO/sg=="]
    
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
        createCurrentNagationBaritem()
        // MARK: -- 请求测试
//        requestTest()
    }
    // MARK: -- 导航栏 添加讨论组、单聊按钮
    func createCurrentNagationBaritem() {
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.right, Title: "单聊", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(privateChat))
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.left, Title: "创建讨论组", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(createDiscussionGroupsChat))
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
    // MARK: -- 创建讨论组
    func quitGroupsmembers(){
        let sessionArray = RCIMClient.shared().getConversationList([
            RCConversationType.ConversationType_PRIVATE.rawValue,
            RCConversationType.ConversationType_DISCUSSION.rawValue,
            RCConversationType.ConversationType_GROUP.rawValue,
            RCConversationType.ConversationType_SYSTEM.rawValue,
            RCConversationType.ConversationType_APPSERVICE.rawValue,
            RCConversationType.ConversationType_PUBLICSERVICE.rawValue
            ])
        if let array = sessionArray as? [RCConversation] {
            RCIM.shared().clearGroupUserInfoCache()
            RCIM.shared().clearGroupInfoCache()
            for object in array {
                Log.info("会话id：\(object.targetId) 会话类型\(object.conversationType) 绘画标题:\(object.conversationTitle)")
                let groups = RCGroup()
                groups.groupName = object.conversationTitle
                groups.portraitUri = "http://static.open-open.com/news/uploadImg/20160107/20160107084321_658.png"
                RCIM.shared().refreshGroupInfoCache(groups, withGroupId: object.targetId)
            }
            RCIM.shared().globalNavigationBarTintColor = UIColor.red
            
//            RCIM.shared().quitDiscussion(array[1].targetId, success: { (groups) in
//                Log.info("退出成功---\(String(describing: groups?.discussionName))")
//            }) { (error) in
//                Log.info("退出讨论组失败\(error)")
//            }
        }
    }

    // MARK: -- 创建讨论组
    func createDiscussionGroupsChat(){
        var userarray = [User]()
        for u in tokenArray {
            let userobj = User()
            userobj.userphone = u.key
            userobj.rcToken = u.value
            userarray.append(userobj)
        }
        let membervc = ShowGroupsMembersController()
        membervc.userData = userarray
        self.navigationController?.present(membervc, animated: false, completion: nil)
    }
    // MARK: -- 单聊
    func privateChat() {
        //打开会话界面
        let chatWithSelf = RCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: user.rcUserId)
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
