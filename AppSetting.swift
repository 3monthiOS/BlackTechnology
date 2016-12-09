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
var imageUrlArray = ["http://ohc2uub90.bkt.clouddn.com/public/16-11-28/33057531.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/63784464.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/31166475.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/63869882.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/15652085.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/90098440.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/38827152.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/6871283.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/53000671.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/70368103.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/50374131.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/12350847.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/49087415.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/12596867.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/39233610.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/61336725.jpg"]

/// App
let API_PROTOCOL = "http:"
let API_VERSION = 1.0
let APP_CHANNEL_CODE = ""
let APP_VERSION_NAME = ""

// 七牛
let QINIU_URL_STATIC = "http://ohc2uub90.bkt.clouddn.com/"
let QINIU_URL_MEDIA = "http://pili-media.huacehuaban.com/"

//融云Token
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境

// 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"

//Host地址
let API_HOST = "rsf.qbox.me"
let API_PATH = "application/x-www-form-urlencoded"
    

/// 正则表达式：手机号
let REGEXP_MOBILES = "^((13[0-9])|(14[4-7])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}|(1705)\\d{7}|(1709)\\d{7}$"


