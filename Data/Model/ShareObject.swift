//
//  ShareObject.swift
//  App
//
//  Created by 红军张 on 2017/6/20.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation
import ObjectMapper

class ShareObject: Mappable {
    
    // 标题
    var title: String?
    // 描述
    var describe: String?
    // 内容
    var content: String?
    // 图片
    var img: Data?
    // 缩略图
    var thumbnailImg: Data?
    // 图片url
    var img_url: String?
    // 缩略图url
    var thumbnailImg_url: String?
    // 平台类型
    var type: UMSocialPlatformType?
    // 分享对象
    var ContentObject: String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        describe <- map["describe"]
        content <- map["content"]
        img <- map["img"]
        thumbnailImg <- map["thumbnailImg"]
        img_url <- map["img_url"]
        thumbnailImg_url <- map["thumbnailImg_url"]
        type <- map["type"]
        ContentObject <- map["ContentObject"]
    }
}
