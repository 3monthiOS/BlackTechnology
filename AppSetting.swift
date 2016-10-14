//
//  AppSetting.swift
//  HaoFangZi
//
//  Created by 侯伟 on 16/6/22.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation


#if DEBUG

//融云Token
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境
    
// 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"
//友盟推送
let UMENG_APPKEY = "57b27664e0f55aed98000446"               
let UMENG_CHANNEL_ID = "App Store"
    
    
//友盟分享
    
//微信
let WECHAT_APPID = "wx57cfc2cbf132eaf3"
let WECHAT_APPSECRET = "6aed8af04c3d4e886ee1071c644fbd64"
 // QQ
let QQ_APPID = "1105519380"
let QQ_APPKEY = "mKPx6i6zRXZtd0yQ"
    
let SINA_APPID = ""
let SINA_APPSECRET = ""
let SINA_SECURE_DOMAIN = ""
    
let SITE_URL = "http://www.baidu.com"
let APP_ICON_LINK = "http://web.dev.goodhfz.com/images/wx-hfz-icon.png"
    
let SHARE_DEFAULT_DESC = "内容：分享一个试试"
let SHARE_DEFAULT_TITLE = "好房子app分享"
    

//Host
let API_HOST = "http://mfgjxc.ownhante.com"
let API_PATH = "/qc-webapp/qcapi.do"
    
#else
    
    
//融云Token pwe86ga5epot6
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境
    
// 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"
    
// 友盟推送
let UMENG_APPKEY = "57b27664e0f55aed98000446"               //已经修改为公司账户
let UMENG_CHANNEL_ID = "App Store"

//微信
let WECHAT_APPID = "wx57cfc2cbf132eaf3"                     //已修改为公司账户
let WECHAT_APPSECRET = "6aed8af04c3d4e886ee1071c644fbd64"
//QQ
let QQ_APPID = "1105519380"                                 //已修改为公司账户
let QQ_APPKEY = "mKPx6i6zRXZtd0yQ"
//新浪
let SINA_APPID = ""
let SINA_APPSECRET = ""
let SINA_SECURE_DOMAIN = ""
    
let SITE_URL = "http://www.baidu.com"
let APP_ICON_LINK = "http://web.dev.goodhfz.com/images/wx-hfz-icon.png"
    
let SHARE_DEFAULT_DESC = "内容：分享一个试试"
let SHARE_DEFAULT_TITLE = "好房子app分享"
    
//Host地址
let API_HOST = "qqac.cq.onlyhante.com"
let API_PATH = "/qc-webapp/qcapi.do"
    
#endif


/// App
let API_PROTOCOL = "http:"
let API_VERSION = 1.0
let APP_CHANNEL_CODE = ""
let APP_VERSION_NAME = ""

/// 正则表达式：手机号
let REGEXP_MOBILES = "^((13[0-9])|(14[4-7])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}|(1705)\\d{7}|(1709)\\d{7}$"


