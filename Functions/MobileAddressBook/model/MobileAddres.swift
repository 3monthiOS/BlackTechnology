//
//  MobileAddres.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/7.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import ObjectMapper

class MobileAddress: Mappable {
	/*
	 通讯录属性
	 */
	// 昵称
	var name: String = ""
    //    id
	var id: Int = 0
    //    openid
	var openid: String = ""
    //    createtime
	var createtime: Double = 0
	// 头像
	var avatars: UIImage?
	// 电话
	var mobile: String = ""
	// 邮箱
	var Email: String = ""
	// 地址
	var Address: String = ""
	// 公司
	var currentContact: String = ""

	init() {

	}

	required init?(_ map: Map) {

	}

	func mapping(map: Map) {

		Email <- map["Email"]

		currentContact <- map["Organization"]

		Address <- map["Address"]

		name <- map["fullName"]

		avatars <- map["TX"]

		mobile <- map["Phone"]
        
        id <- map["id"]
        
        openid <- map["openid"]
        
        createtime <- map["createtime"]
	}
}
class MobileRecommend: Mappable {
	/*
	 平台推送客源 参数
	 */
    
    var total:Int?
    
    var list : [MobileAddresObject]?


	init() {

	}

	required init?(_ map: Map) {

	}

	func mapping(map: Map) {
        
        total <- map["total"]
        list <- map["list"]

	}
}
class MobileAddresObject: Mappable {
    /*
     通讯录属性
     */
    // 昵称
    var name: String = ""
    //    id
    var id: Int = 0
    //    openid
    var openid: String = ""
    // 头像
    var avatars: UIImage?
    // 电话
    var mobile: String = ""
    // 邮箱
    var Email: String = ""
    // 地址
    var Address: String = ""
    
    init() {
        
    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        Email <- map["Email"]
        
        
        Address <- map["Address"]
        
        name <- map["name"]
        
        avatars <- map["TX"]
        
        mobile <- map["mobile"]
        
        id <- map["id"]
        
        openid <- map["openid"]
        
    }
}

