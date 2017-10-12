//
//  AppSetting.swift
//  App
//
//  Created by 红军张 on 16/9/9.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import Foundation

// 适配iPhone x 底栏高度_tabBarView.frame = CGRectMake(0, CurrentScreenHeight - TabbarHeight, CurrentScreenWidth, TabbarHeight);
let APP_tabbarHeight = UIApplication.shared.statusBarFrame.size.height > 20 ? 83 : 49

let APP_statusBarHeight = UIApplication.shared.statusBarFrame.size.height

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

// MARK: - 阿里云存储
let ALY_BucketName = "zhj1214"
let ALY_endpoint = "http://oss-cn-hangzhou.aliyuncs.com"
let ALY_AccessKey = "LTAIAzsdrmtOnBFs"
let ALY_SecretKey = "PgoU9Q107rCVBZP8Uz0CurvYTB2R5W"

// MARK: - 融云Token
let RY_APPKEY = "pwe86ga5epot6"                             //开发环境

// MARK: - 百度地图KEY
let BAIDU_KEY = "bSURSrC2l6a3i3C2RhifHmph9OiFAIdB"

// MARK: -  正则表达式
let REGEXP_MOBILES = "^((13[0-9])|(14[4-7])|(15[0-9])|(17[0-9])|(18[0-9]))\\d{8}|(1705)\\d{7}|(1709)\\d{7}$"

// MARK: - 本地key
let USERGROUPOBJECTKEY = "USERGROUPOBJECTKEY.array.KEY"

// 15249685697: cb , 012345678910：CB0 , 13968034167 :ZW ,15225147792 : GF ,18336093422: zhj1214,00000000000 :ZW0
let RCtokenArray = ["18336093422":"/7Ho4V0LAxqx1eeMZvJjIxEwXKiZajUg1lYnzbenGFogaU5Q8wQe3i4cPyJqgjLBrHIfKRaHVIyUG7tyo6E/Z1xb6BKkYi9r","15249685697":"E7V5pupiLPLwKarhAgnPFvyVRNEe+kEOk6zXm2XQoNOfjfi1kG/r4pLOfMim3fF1BmbWapvgkUY=","012345678910":"SaNRAdb1HvDSwXK/4Pejr6UNOrqEnO6vXv8cpipmaDmyq/6rAyPo0sCKcMwKe23s75GUDOcwZk7o2IyVY4SdeQ==","13968034167":"CJov2IWBq7H/CKoaiB9TQgIIlo0WhrAzzoatEDpPkLlXv74SI5Izo46/SCKfcn8Pqg1D6PXiDBY=","00000000000":"QPdoi2Ij1WZcLNpvo+PKIhEwXKiZajUg1lYnzbenGFogaU5Q8wQe3pwszl9J/nnfNFXN0ntL4ZVcW+gSpGIvaw==","15225147792":"LTNPDKoMc06ryzJSygT/e6UNOrqEnO6vXv8cpipmaDk7dLOTy3QFRAwVIhTyu7UORvISmSVEhPUNtzeXCPO/sg=="]
