//
//  LoginUser.swift
//  HaoFangZi
//
//  Created by xpming on 16/7/11.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import ObjectMapper

class QNlistItms: Mappable {
    /*
     
     {
     "marker": "<marker string>",
     "commonPrefixes": [
     "xxx",
     "yyy"
     ],
     "items": [
     {
     "key"：     "<key           string>",
     "putTime":   <filePutTime   int64>,
     "hash":     "<fileETag      string>",
     "fsize":     <fileSize      int64>,
     "mimeType": "<mimeType      string>",
     "customer": "<endUserId     string>"
     },
     ...
     ]
     }
     
     */
    //用户ID
    var id: Int?

    var marker: String?

    var commonPrefixes: [String]?

    var items: [Diction]?
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

    required init?(_ map: Map) {

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
    
    var role  = []
    
    var user:LoginUser?
    
    required init?(_ map: Map) {
        
    }
    
     func mapping(map: Map) {
        
        role <- map["role"]
        
        user <- map["user"]
    }
}
