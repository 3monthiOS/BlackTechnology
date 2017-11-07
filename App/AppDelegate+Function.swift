//
//  AppDelegate+Function.swift
//  App
//
//  Created by 红军张 on 2017/11/7.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

//MARK: 融云
extension AppDelegate: RCIMConnectionStatusDelegate, RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMReceiveMessageDelegate{
    func initRCIM(){
        RCIM.shared().initWithAppKey(RY_APPKEY)
        //设置监听连接状态
        RCIM.shared().connectionStatusDelegate = self
        //设置消息接收的监听
        RCIM.shared().receiveMessageDelegate = self
        //设置用户信息提供者，需要提供正确的用户信息，否则SDK无法显示用户头像、用户名和本地通知
        RCIM.shared().userInfoDataSource = self
        //设置群组信息提供者，需要提供正确的群组信息，否则SDK无法显示群组头像、群名称和本地通知
        RCIM.shared().groupInfoDataSource = self
        
    }
    //推送处理2
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //注册推送,用于iOS8以上系统
        application.registerForRemoteNotifications()
    }
    
    //推送处理3
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var rcDevicetoken = deviceToken.description
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: "<", with: "")
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: ">", with: "")
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: " ", with: "")
        
        RCIMClient.shared().setDeviceToken(rcDevicetoken)
    }
    
    //推送处理4
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //远程推送的userInfo内容格式请参考官网文档
        //http://www.rongcloud.cn/docs/ios.html#App_接收的消息推送格式
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //本地通知
    }
    
    //监听连接状态变化
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        switch status {
        case .ConnectionStatus_Connected:
            toast("连接成功", duration: nil, position: ToastPosition.bottom, title: "提示", image: UIImage(named: "appIcon1"))
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
    
    //用户信息提供者。您需要在completion中返回userId对应的用户信息，SDK将根据您提供的信息显示头像和用户名
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        //        print("用户信息提供者，getUserInfoWithUserId:\(userId)")
        //简单的示例，根据userId获取对应的用户信息并返回
        //建议您在本地做一个缓存，只有缓存没有该用户信息的情况下，才去您的服务器获取，以提高用户体验
        if (userId == "CB") {
            // 15249685697: cb , 012345678910：CB0 , 13968034167 :ZW ,15225147792 : GF ,18336093422: zhj1214,00000000000 :ZW0
            completion(RCUserInfo(userId: userId, name: "常博", portrait: "http://img2.a0bi.com/upload/ttq/20160924/1474720730902.jpg"))
        } else if (userId == "ZW") {
            completion(RCUserInfo(userId: userId, name: "宗wei", portrait: "http://www.itotii.com/wp-content/uploads/2016/09/07/1473228073_GdOpxKrS.jpg"))
        } else if (userId == "zhj1214"){
            completion(RCUserInfo(userId: userId, name: "小军", portrait: "http://img3.a0bi.com/upload/ttq/20160924/1474720548478.jpg"))
        }else if (userId == "GF"){
            completion(RCUserInfo(userId: userId, name: "高芳", portrait:"http://www.soideas.cn/uploads/allimg/120612/3-www.soideas.cn1206120HQ5.jpg"))
        }else{
            let imageUrl = ["http://img3.a0bi.com/upload/ttq/20160924/1474720548478.jpg","http://img2.a0bi.com/upload/ttq/20160924/1474720730902.jpg","http://www.itotii.com/wp-content/uploads/2016/09/07/1473228073_GdOpxKrS.jpg","http://img2.a0bi.com/upload/ttq/20160924/1474706687409.jpg","http://www.soideas.cn/uploads/allimg/120612/3-www.soideas.cn1206120HQ5.jpg"]
            completion(RCUserInfo(userId: userId, name: "叫小军给你起名字", portrait:imageUrl[Int(arc4random()%4)]))
        }
    }
    
    //群组信息提供者。您需要在Block中返回groupId对应的群组信息，SDK将根据您提供的信息显示头像和群组名
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        print("群组信息提供者，  这里要做缓存 保存一下讨论组 id  和 名称 :\(groupId)")
        //简单的示例，根据groupId获取对应的群组信息并返回
        //建议您在本地做一个缓存，只有缓存没有该群组信息的情况下，才去您的服务器获取，以提高用户体验
        completion(RCGroup(groupId: groupId, groupName: "讨论组", portraitUri: "http://static.open-open.com/news/uploadImg/20160107/20160107084321_658.png"))
    }
    
    //监听消息接收
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if (left != 0) {
            print("收到一条消息，当前的接收队列中还剩余\(left)条消息未接收，您可以等待left为0时再刷新UI以提高性能")
        } else {
            print("收到一条消息")
        }
    }
}

extension AppDelegate {
    //MARK: 注册本地和远程通知
    func registerNotification(_ application: UIApplication) {
        //推送处理1
        if #available(iOS 10.0, *) {
            // 通知扩展按钮  有 普通和 带输入框 2个种类
            // 点击按钮调用  UNUserNotificationCenter 的 didReceive response 代理
            // 普通 和带输入框的有区分 在代理方法已经 写明  请移步 代理方法查看
            let action =   UNNotificationAction(identifier: "normal", title: "测试1", options: .authenticationRequired)
            let action1 = UNTextInputNotificationAction(identifier: "input", title: "回复", options: .destructive, textInputButtonTitle: "发送", textInputPlaceholder: "请回复")
            let category = UNNotificationCategory(identifier: "category", actions: [action,action1], intentIdentifiers: [], options: .customDismissAction)
            
            let center =  UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert,.badge,.sound]) { (Bool, error) in
                
            }
            center.setNotificationCategories([category])
            center.delegate = self
            application.registerForRemoteNotifications()
        } else if #available(iOS 8.0, *) {
            //注册推送,用于iOS8以上系统
            // 通知扩展按钮  iOS9 以上  有 普通和 带输入框 2个种类 behavior属性控制
            // 在锁屏的时候  收到通知 左滑通知 能看到按钮  点击对应调用 handle Action 的代理
            // 带输入框 点击 调用的是 handle Action   withResponseInfo 的代理
            // 本地 和远程同理
            let action1 = UIMutableUserNotificationAction()
            action1.title = "测试1"
            action1.activationMode = .background
            action1.identifier = "test1"
            action1.isDestructive = false
            
            if #available(iOS 9.0, *) {
                action1.behavior = .default
            } else {
                // Fallback on earlier versions
            }
            action1.isAuthenticationRequired = true
            let category1 = UIMutableUserNotificationCategory()
            category1.identifier = "category1"
            category1.setActions([action1], for: .default)
            
            
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(types:[.alert, .badge, .sound], categories: [category1]))
            application.registerForRemoteNotifications()
        } else {
            //注册推送,用于iOS8以下系统
            application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
        }
    }
}
