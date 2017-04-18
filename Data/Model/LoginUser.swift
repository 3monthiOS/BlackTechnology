//
//  LoginUser.swift
//  HaoFangZi
//
//  Created by xpming on 16/7/11.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginUser: Mappable {
    //用户ID
    var id: Int?
    //用户状态码
    var state: Int?
    //国籍
    var country: String?
    //账户
    var openid: String?
    //
    var passport: String?
    //
    var ggroupid: Int?
    //
    var appid: String?
    //注册时间
    var createTime: Double?
    //所在城市
    var city: String?
    //昵称
    var nickname: String?
    //
    var uuid: String?
    //性别
    var sex: String?
    //省份
    var province: String?
    //用户图标
    var headImgURL: String?
    //
    var subscribeTime: Double?
    //
    var dmconsume: Int?
    //
    var subscribe_time: Int?
    //
    var gappid: Int?
    //
    var balance: Int?
    //
    var pointTotal: Int?
    //
    var dmpointamount: Int?
    // 
    var dmpointconsume: Int?
    //
    var dmpointbalance: Int?

    init() {

    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        state <- map["state"]
        country <- map["country"]
        openid <- map["openid"]
        passport <- map["passport"]
        appid <- map["appid"]
        ggroupid <- map["ggroupid"]
        createTime <- map["createtime"]
        city <- map["city"]
        nickname <- map["nickname"]
        uuid <- map["uuid"]
        sex <- map["sex"]
        province <- map["province"]
        headImgURL <- map["headimgurl"]
        subscribeTime <- map["subscribetime"]
        dmconsume <- map["dmconsume"]
        subscribe_time <- map["subscribe_time"]
        gappid <- map["gappid"]
        balance <- map["balance"]
        pointTotal <- map["pointtotal"]
        dmpointamount <- map["dmpointamount"]
        dmpointconsume <- map["dmpointconsume"]
        dmpointbalance <- map["dmpointbalance"]
    }

}

class UserInfo:Mappable{
    
    var role :Array<Any>?
    
    var user:LoginUser?
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        
        role <- map["role"]
        
        user <- map["user"]
    }
}
