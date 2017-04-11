//
//  LoginUser.swift
//  HaoFangZi
//
//  Created by xpming on 16/7/11.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 
 HTTP状态码	含义
 200	列举成功。
 400	请求报文格式错误。
 401	管理凭证无效。
 599	服务端操作失败。
 如遇此错误，请将完整错误信息（包括所有HTTP响应头部）通过邮件发送给我们。

 */
class QNlistData: Mappable {
    //用户ID
    var id: Int?
    //有剩余条目则返回非空字符串，作为下一次列举的参数传入。如果没有剩余条目则返回空字符串。
    var marker: String?
    //所有目录名的数组，如没有指定delimiter参数则不输出。
    var commonPrefixes: [String]?
    //所有返回条目的数组，如没有剩余条目则为空数组。
    var items: [QNlistItms]?

    init() {

    }

    required init?(_ map: Map) {

    }

    func mapping(_ map: Map) {
        id <- map["id"]
        marker <- map["marker"]
        commonPrefixes <- map["commonPrefixes"]
        items <- map["items"]
    }

}

class QNlistItms: Mappable{
    //资源名。
    var key: String?
    //上传时间，单位：100纳秒，其值去掉低七位即为Unix时间。
    var putTime: Int64?
    //资源内容的大小，单位：字节。
    var hash: String?
    //文件的HASH值，使用qetag算法计算。
    var fsize: Int64?
    //资源的 MIME 类型。
    var mimeType: String?
    //资源内容的唯一属主标识，请参考上传策略。
    var customer: String?
    
    required init?(_ map: Map) {
        
    }
    
     func mapping(_ map: Map) {
        
        key <- map["key"]
        
        putTime <- map["putTime"]
        
        hash <- map["hash"]
        
        fsize <- map["fsize"]
        
        mimeType <- map["mimeType"]
        
        customer <- map["customer"]
        
    }
}
