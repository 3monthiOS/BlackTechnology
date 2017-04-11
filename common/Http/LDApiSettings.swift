//
// AHApiWrapper.swift
// aha
//
// Created by Cator Vee on 12/9/15.
// Copyright © 2015 Ledong. All rights reserved.
//

import Foundation

class LDApiSettings {

    let baseURL: String
    let baseWebURL: String
    let host: String

    
    /// 获取上传令牌 [GET]
    var qiniuUploadToken: LDApiRequest { return getRequest("upload/{resourceType}/gettoken") }
    /// 修改用户信息 [POST]
    var updateUserInfo: LDApiRequest {return getRequest("user/modify")}
    /// 列举七牛历史上传资料
    var getQNlistdata: LDApiRequest {return getRequest("user/modify")}
//    var getAppId: LDApiRequest { return getRequest("/global/App/getAppid") }
//    /// 城市列表
//    var cityList: LDApiRequest { return getRequest("/global/App/queryAppCity") }
//    /// 登录
//    var login: LDApiRequest { return getRequest("/hfz/HfzCommAction/getRegisterByMobile") }
//    /// 获取用户信息
//    var userInfo: LDApiRequest { return getRequest("/global/User/getUserInfo") }
//    /// 用户报备
//    var mobileRecommend: LDApiRequest{return getRequest("/hfz/HfzAppAction/queryHfzCust")}
//
//    /// 获取验证码
//    var vericode: LDApiRequest { return getRequest("/global/App/getHfzVericode") }
//    
//    /// 获取系统会话列表
//    var conversationList: LDApiRequest { return getRequest("/hfz/HfzAppAction/queryHfzNotic") }
//    /// 获取群组会话列表
//    var groupConversationList: LDApiRequest { return getRequest("/hfz/HfzChannelManageAction/listMyGroup") }
//
//    //发起点名
//    var createRollCall:LDApiRequest{ return getRequest("/hfz/HfzAppAction/createSign") }
//    
//    
////    //获取点名信息
////    var getRollCallInfo:LDApiRequest {return getRequest("/hfz/HfzAppAction/getSign")}
//    
//    //点名发送位置
//    var sendRollCallLocation:LDApiRequest {return getRequest("/hfz/HfzAppAction/signLog")}
//    
//    //获取点名详情
//    var getRollCallDetails:LDApiRequest {return getRequest("/hfz/HfzAppAction/listSignLog")}
//    
//    //获取群成员列表
//    var getGroupMemberList:LDApiRequest {return getRequest("/hfz/HfzChannelManageAction/listGroupMembers")}
//
//    //分享后 增加积分
//    var shareUpdUserPoint:LDApiRequest {return getRequest("/hfz/HfzTeamManageAction/updUserPoint")}
    
    init() {
        self.baseURL = "\(API_PROTOCOL)//\(API_HOST)\(API_PATH)"
        self.baseWebURL = "http://\(API_HOST)/"
        self.host = API_HOST
    }

    func buildWebLink(_ path: String) -> String {
        return "\(baseWebURL)\(path)"
    }

    func getRequest(_ action: String, params: LDApiRequestParams? = nil, options: LDApiRequestOptions? = nil) -> LDApiRequest {
        let request = LDApiRequest(action: action, settings: self)
        if let newOptions = options {
            request.updateOptions(newOptions)
        }
        if let newParams = params {
            request.updateParams(newParams)
        }
        return request
    }

}
