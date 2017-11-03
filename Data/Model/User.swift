//
//  User.swift
//  aha
//
//  Created by feng will on 15/11/23.
//  Copyright © 2015年 Ledong. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
    
    // 用户ID
    var id: Int?
    //
    var appid: String?
    //
    var uuid: String?
    // 用户状态码  1 代表登录
    var state: Int?
    // 是不是第一次登陆
    var one_t: Int?
    // 护照
    var passport: String?
    // 性别
    var sex: String?
    // 年龄
    var age = 0
    // 国籍
    var country: String?
    // 省份
    var province: String?
    // 所在城市
    var city: String?
    // 区县
    var SubLocality: String?
    // 街道
    var Thoroughfare: String?
    // 详细地址
    var FormattedAddressLines: String?
    // 用户图标
    var headImgURL: String?
    // 账户
    var accountid: String?
    // 手机号
    var userphone: String?
    // 密码
    var password: String?
    // 昵称
    var nickname: String?
    // 注册时间
    var createTime: Double?
    
    // 第三方 用户信息
    var thirdName: String?
    var thirdPortrait: String?
    
    // 融云 组 id
    var rcGroupid: String?
    // 融云 token
    var rcToken: String?
    // 融云 name
    var rcName: String?
    // 融云 userid
    var rcUserId: String?
    

    init() {

    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        
        id <- map["id"]
        appid <- map["appid"]
        uuid <- map["uuid"]
        state <- map["state"]
        one_t <- map["one_t"]
        country <- map["country"]
        passport <- map["passport"]
        sex <- map["sex"]
        age <- map["age"]
        province <- map["province"]
        city <- map["city"]
        headImgURL <- map["headImgURL"]
        accountid <- map["accountid"]
        userphone <- map["userphone"]
        nickname <- map["nickname"]
        password <- map["password"]
        createTime <- map["createTime"]
        rcGroupid <- map["rcGroupid"]
        rcToken <- map["rcToken"]
        rcName <- map["rcName"]
        rcUserId <- map["rcUserId"]
        thirdName <- map["thirdName"]
        thirdPortrait <- map["thirdPortrait"]
        
    }

    /**
     * 拍照并更新用户头像
     */
//    func takeAndUpdateHeadImage(completion: ((UIImage) -> Void)?) {
//        // 获取照片
//        LDImageTaker.takeImage(0, completion: { image in
//
//            let imageSize = CGSize(width: image.size.width, height: image.size.height)
//            let iamgeData = image.af_imageScaledToSize(imageSize)
//
//            guard let
//            data = iamgeData.data,
//                key = LDQNUtils.keyForImage(image)
//            else {
//                return
//            }
//            // 上传到七牛服务器
//            LDQNUtils.putData(data, withKey: key, resourceType: .Image) { result in
//                switch result {
//                case .Success(let url, _, _):
//                    // 更新用户表
//                    api.updateUserInfo.post(["avatar": url, "userId": self.id]) {
//                        (response: LDApiResponse<User>) in
//
//                        response.success { user in
//                            let image = UIImage(data: data)!
//
//                            self.avatar = user.avatar
//
//                            if self.id == auth.user?.id {
//                                auth.user = self
//                                Notifications.userInfoChange.post(["avatar": image])
//                            }
//
//                            toast(getLocString("modifySuccess"))
//
//                            completion?(image)
//                        }
//
//                        response.failure({ (error) -> Void in
//                            toast(response.errorMessage)
//                        })
//                    }
//                case .Failure(_):
//                    Log.error("上传头像失败")
//                }
//            }
//        })
//    }
}
