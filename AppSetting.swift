//
//  AppSetting.swift
//  HaoFangZi
//
//  Created by 侯伟 on 16/6/22.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation


// MARK: - size
let App_width = UIScreen.main.bounds.width
let App_height = UIScreen.main.bounds.height
/// 屏幕像素比率
let SCREEN_SCALE = UIScreen.main.scale
/// 1个像素
let SIZE_1PX = 1 / SCREEN_SCALE

// MARK: - 网络部分
/// App
let API_PROTOCOL = "http:"
let API_VERSION = 1.0
let APP_CHANNEL_CODE = ""
let APP_VERSION_NAME = ""

//Host地址
let API_HOST = "rsf.qbox.me"
let API_PATH = "application/x-www-form-urlencoded"


// MARK: - 七牛
let QINIU_URL_STATIC = "http://ohc2uub90.bkt.clouddn.com/"
let QINIU_URL_MEDIA = "http://pili-media.huacehuaban.com/"

// MARK: - 融云Token
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境

// MARK: - 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"

// MARK: -  正则表达式
let REGEXP_MOBILES = "^((13[0-9])|(14[4-7])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}|(1705)\\d{7}|(1709)\\d{7}$"

// MARK: - 本地key
let USERGROUPOBJECTKEY = "USERGROUPOBJECTKEY.array.KEY"

struct Constant {
    
    struct AnimationKeys {
        
        static let Scale     = "transform.scale"
        static let Rotation    = "transform.rotation"
        static let KeyFrame  = "contents"
        static let PositionY = "position.y"
        static let Opacity   = "opacity"
    }
}
