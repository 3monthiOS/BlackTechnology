//
//  LoginUser.swift
//  HaoFangZi
//
//  Created by xpming on 16/7/11.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import ObjectMapper
//import Swiften
//import Realm
import RealmSwift

class UserDB: Object {
    //用户ID
    var id: Int?
    //
    var appid: String?
    //
    var uuid: String?
    //用户状态码
    var state: Int?
    //国籍
    var country: String?
    //护照
    var passport: String?
    //性别
    var sex: String?
    //省份
    var province: String?
    //所在城市
    var city: String?
    //用户图标
    var headImgURL: String?
    //账户
    var openid: String?
    //
    var userphone: Int?
    //昵称
    var nickname: String?
    //密码
    var password: String?
    //注册时间
    var createTime: Double?

    // 融云 组 id
    var groupid: Int?
    
}

