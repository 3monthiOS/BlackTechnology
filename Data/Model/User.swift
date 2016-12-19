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
    /*过期无用*/
    var id: Int!

    var avatar = ""
    var city = ""
    var birthday = ""
    var age = 0
    var department = ""
    var firstLoginTime = ""
    var geohash = ""
    var gmtCreate = ""
    var gmtModify = ""
    var isAuth = 0
    var lastLoginTime = ""
    var latitude = 0
    var isRegister = 0
    var longitude = 0
    var mobile = ""
    var msid = ""
    var nickname = ""
    var occupation = ""
    var personintro = ""
    var province = ""
    var realName = ""
    var goldCoins = 0
    var school = ""
    var sex = 1
    var userType = ""
    var comment = ""
    var trendNum: Int = 0
    var photoImg: UIImage?

    /// 0=彼此都没有拉黑；1=主动拉黑对方；2=被对方拉黑了
    var defriendStatus: Int?
    /// 0(无惩罚),1(惩罚中)
    var punishStatus: Int?
    /// 0(无),1(冻结),2(禁言)
    var punishLevel: Int?
    /// 惩罚结束时间
    var punishEndTime: Double?
    
    /// 用户信息完成度
    var completion: String = "0%"
    /// 粉丝
    var fansNum: Int = 0
    /// 关注
    var followNum: Int = 0
    /// 是否被当前用户关注
    var isFollow: Int = 0
    /// user detail好像并没下发
    var relationship: Int?
    /// 是否加V (1已加,0未加)
    var vSign = 0

    var hasV: Bool { return self.vSign == 1 }


    init() {

    }

    required init?(_ map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        nickname <- map["nickname"]
        mobile <- map["mobile"]
        city <- map["city"]
        birthday <- map["birthday"]
        goldCoins <- map["goldCoins"]
        avatar <- map["avatar"]
        department <- map["department"]
        firstLoginTime <- map["firstLoginTime"]
        geohash <- map["geohash"]
        gmtCreate <- map["gmtCreate"]
        gmtModify <- map["gmtModify"]
        isAuth <- map["isAuth"]
        isRegister <- map["isRegister"]
        lastLoginTime <- map["lastLoginTime"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        msid <- map["msid"]
        occupation <- map["occupation"]
        personintro <- map["personintro"]
        province <- map["province"]
        realName <- map["realName"]
        school <- map["school"]
        sex <- map["sex"]
        userType <- map["userType"]

        completion <- map["completion"]
        fansNum <- map["fansNum"]
        followNum <- map["followNum"]

        isFollow <- map["isFollow"]
        trendNum <- map["trendNum"]
        relationship <- map["relationship"]
        comment <- map["comment"]

        /// 是否加V (1已加,0未加)
        vSign <- map["vSign"]

        
        defriendStatus <- map["defriendStatus"]
        punishStatus <- map["punishStatus"]
        punishLevel <- map["punishLevel"]
        punishEndTime <- map["punishEndTime"]
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
