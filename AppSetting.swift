//
//  AppSetting.swift
//  HaoFangZi
//
//  Created by 侯伟 on 16/6/22.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation

let App_width = UIScreen.mainScreen().bounds.width
let App_height = UIScreen.mainScreen().bounds.height
/// 屏幕像素比率
let SCREEN_SCALE = UIScreen.mainScreen().scale
/// 1个像素
let SIZE_1PX = 1 / SCREEN_SCALE
//网络GIF图片
let imageUrlArray = ["https://pan.baidu.com/s/1i5ocH2t","https://pan.baidu.com/s/1nvxxZ65","https://pan.baidu.com/s/1o8TPYD8","https://pan.baidu.com/s/1cgP2J8","https://pan.baidu.com/s/1hsAzvDE","https://pan.baidu.com/s/1skUP72X","https://pan.baidu.com/s/1sliwFq1","https://pan.baidu.com/s/1pLIY9RX","https://pan.baidu.com/s/1jIHMP5G","https://pan.baidu.com/s/1nvM01V7","https://pan.baidu.com/s/1ge6N0Jp","https://pan.baidu.com/s/1gfv8r1x","https://pan.baidu.com/s/1o7WX9VG"]

/// App
let API_PROTOCOL = "http:"
let API_VERSION = 1.0
let APP_CHANNEL_CODE = ""
let APP_VERSION_NAME = ""

#if DEBUG
//融云Token
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境
    
// 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"
    
//Host
let API_HOST = "http://mfgjxc.ownhante.com"
let API_PATH = "/qc-webapp/qcapi.do"
    
#else
    
//融云Token pwe86ga5epot6
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境
// 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"

//Host地址
let API_HOST = "qqac.cq.onlyhante.com"
let API_PATH = "/qc-webapp/qcapi.do"
    
#endif

/// 正则表达式：手机号
let REGEXP_MOBILES = "^((13[0-9])|(14[4-7])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}|(1705)\\d{7}|(1709)\\d{7}$"


