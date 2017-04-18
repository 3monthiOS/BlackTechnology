//
//  AHApiResponse.swift
//  aha
//
//  Created by Cator Vee on 12/9/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON
//import Swiften


class LDApiResponse<T: Mappable>: Mappable {
	
	var isOK: Bool {
		return code == 0 && (msg != nil || errorMessage != nil) && error == nil
	}
	
	var code = -1
	var msg: T?
    var errorMessage: String?
	var flag = 0
	var contentType = ""
    var isSubscribe = 0
    var passport = ""
    var openid = ""
	
	var rawData: Data!
	var rawString: String! {
		return String(data: rawData, encoding: String.Encoding.utf8)
	}
    var json: JSON? {
        return isOK ? JSON(data: rawData)["obj"] : nil
    }
    var headers: [AnyHashable: Any]?

	var error: LDApiError?
	
	init() {

	}
	
	required init?(map: Map) {

	}
	
	func mapping(map: Map) {
		code <- map["code"]
        errorMessage <- map["errmsg"]
        flag <- map["flag"]
        contentType <- map["contentType"]
        isSubscribe <- map["issubscribe"]
        passport <- map["passport"]
        openid <- map["openid"]
		if code == 0 {
            msg <- map["obj"]
			let value = map.currentValue
            if value is String || value is Bool || value is Int || value is Array<AnyObject> {
                msg = T(map)
            }
		} else {
			error = LDApiError.apiError(code: code, message: errorMessage ?? "")
			Log.error("api: ApiError[\(code)] \(errorMessage ?? "")")
		}
	}
    
	func success( _ callback: @noescape (_ msg: T) -> Void) -> LDApiResponse {
		guard isOK else {return self}
//        session.openid = openid
//        session.passport = passport
		callback(msg!)
        return self
	}
	
	func failure( _ callback: @noescape (_ error: LDApiError) -> Void) -> LDApiResponse {
		guard !isOK else {return self}
		if let error = self.error {
			callback(error)
		} else if msg == nil {
			callback(LDApiError.dataError)
		}
        //100000("未登录或登录超时，请重新登录")，100007("用户已在其他设备登录")，100019("用户已被冻结")
//        if self.code == 100000 || self.code == 100007 || self.code == 100019{
//            let storyboard = UIStoryboard(name: "Bootstrape", bundle: nil)
//            let login = storyboard.instantiateViewControllerWithIdentifier("LoginNavigation")
//            UIApplication.sharedApplication().keyWindow?.rootViewController = login
//        }
        return self
	}
	
	func failureDefault() -> LDApiResponse {
		self.failure { error in
            // 忽略的错误代码列表
            // 999981 远程服务调用超时
//            if self.code == 999981 {
//                return
//            }
			switch error {
			case .apiError(_, let message):
				//alert(message, title: "提示")
                toast(message)
			case .dataError, .httpRequestError(_):
				//alert("网络不给力", title: "提示")
                toast("网络不给力")
			}
            // 返回到登录界面的情况
            // 100000 未登录或登录超时，请重新登录
            // 100007 用户已在其他设备登录
            // 100019 用户已被冻结
            // 100009 用户token缓存为空
//            if self.code == 100000 || self.code == 100007 || self.code == 100019 || self.code == 100009 {
//                let storyboard = UIStoryboard(name: "Bootstrape", bundle: nil)
//                let login = storyboard.instantiateViewControllerWithIdentifier("LoginNavigation")
//                UIApplication.sharedApplication().keyWindow?.rootViewController = login
//            }
		}
		return self
	}
	
}
