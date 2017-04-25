//
//  ApiRequest.swift
//  aha
//
//  Created by Cator Vee on 12/9/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
//import Swiften
import SwiftyJSON
import SnapKit

typealias ApiRequestParams = [String: AnyObject]
typealias ApiRequestOptions = [String: Any]

@objc class ApiRequest: NSObject {

    static let defaultOptions: ApiRequestOptions = [
        "dataType": ApiDataTypes.JSON // 返回数据类型
    ]

    static var loadingCount = 0
    static var loadingView: UIView?

    fileprivate let tid: Int
    fileprivate var startTime: TimeInterval = 0.0

    let action: String
    let settings: ApiSettings

    var params: ApiRequestParams
    var options: ApiRequestOptions

    var quiet: ApiRequest {
        self.options["quiet"] = true
        return self
    }

    var request: DataRequest?

    init(action: String, settings: ApiSettings) {
        self.action = action
        self.settings = settings
        self.tid = session.tick
        self.options = ApiRequest.defaultOptions
        self.params = [:]
    }

    func reset() -> ApiRequest {
        options = ApiRequest.defaultOptions
        params = [:]
        return self
    }

    /// 设置options
    func updateOptions(_ options: ApiRequestOptions) -> ApiRequest {
        for (key, value) in options {
            self.options[key] = value
        }
        return self
    }

    func updateOptions(fromDictionary options: [String:AnyObject]) -> ApiRequest {
        for (key, value) in options {
            self.options[key] = value
        }
        return self
    }

    /// 设置params
    func updateParams(_ params: [String: AnyObject]?, start: Int? = nil, limit: Int? = nil) -> ApiRequest {
        if let newParams = params {
            for (key, value) in newParams {
                self.params[key] = value
            }
        }
        if start != nil || limit != nil {
            self.params["offset"] = (start  ?? 0 ) as AnyObject
            self.params["size"] = (limit  ?? 20) as AnyObject
        }
        return self
    }

    /// 取消API请求
    func cancel() {
        request?.cancel()
    }

    /// 调用前准备
    func prepare<T>(
        _ method: HTTPMethod,
        params: [String: AnyObject]? = nil,
        start: Int? = nil,
        limit: Int? = nil,
        callback: @escaping (_ response: ApiResponse<T>) -> Void)
        -> ApiRequest
    {
        if params == nil && start == nil && limit == nil {
            return call(method, callback)
        } else {
            return updateParams(params, start: start, limit: limit).call(method, callback)
        }
    }

    /// 调用API请求
    func call<T>(_ method: HTTPMethod, _ callback: @escaping (_ response: ApiResponse<T>) -> Void) -> ApiRequest {
        
        #if DEBUG
            startTime = NSDate.timeIntervalSinceReferenceDate()
        #endif

        var urlString = buiUrlString()
        if let urlParams = options["urlParams"] as? String {
            if !urlString.contains("?") {
                urlString += "?"
            }
            urlString += urlParams
        }
        
        guard let url = URL(string: urlString) else { return self }
        let dataType = self.options["dataType"] as! ApiDataTypes
        let manager = NetworkManager.defaultManager
        let mutableURLRequest = NSMutableURLRequest(url: url)
        mutableURLRequest.httpMethod = method.rawValue
        if Reachability.networkStatus != .notReachable {
            mutableURLRequest.cachePolicy = .reloadIgnoringLocalCacheData
        }else{
            mutableURLRequest.cachePolicy = .returnCacheDataDontLoad
        }
        let openid = session.openid.isEmpty ? "oMg0RuKRW8g4UlI3lJ6jS_NGboeM" : session.openid
        let passport = session.passport.isEmpty ? "05ec02b9e2f2312bf6c34dda7698a99c" : session.passport
        
        var j: JSON = [
                "wxappid": session.appid,
                "openid": openid,
                "passport": passport,
                "action": action,
                "requestParam": params
//                "xxx": arc4random()%10000
        ]
        if let vericode = options["vericode"] as? String {
            j["vericode"].string = vericode
        }
        let jString = j.jsonString 
        let sign = jString.md5
        var parameters: [String: AnyObject] = [ "_t": tid as AnyObject, "j": jString as AnyObject, "sign": sign as AnyObject ]
        if let ljsonp = options["ljsonp"] as? Bool,
               let japi = options["japi"] as? String,
               let jdomain = options["jdomain"] as? String, ljsonp {
            parameters["jdomain"] = jdomain as AnyObject
            parameters["japi"] = japi as AnyObject
        }
        
        do {
            let encodedURLRequest = try? openid.encode(mutableURLRequest as! URLRequestConvertible, with: parameters)
            request = manager?.request(encodedURLRequest!)
        } catch  {
            Log.debug("哈哈哈哈")
        }
        Log.info("api[\(self.tid)]: \(request!.debugDescription)")
        startLoading()
        switch dataType {
        case .JSON:
            Log.debug("JSON")
            request!.responseObject { (response: DataResponse <ApiResponse<T>>) in
                self.handleJSON(response: response, callback: callback)
            }
        default:
            Log.error("api: unsupported data type (\(dataType))")
            stopLoading()
        }
        return self
    }

    fileprivate func handleJSON<T>(response: DataResponse <ApiResponse<T>>, callback: (_ response: ApiResponse<T>) -> Void) {
        Log.info("api[\(self.tid)]: \(response.response == nil ? "nil" : response.response!.debugDescription) Data: \((response.data?.count)!) bytes, Time: \(round((Date.timeIntervalSinceReferenceDate - startTime) * 10000) / 10) ms")
        switch response.result {
        case .success(let value):
            value.rawData = response.data!
            if let httpResponse = response.response {
                value.headers = httpResponse.allHeaderFields
            }
            if value.isOK {
                if let cacheKey = self.options["cacheKey"] as? CacheManager.Key {
                    cache[cacheKey.rawValue] = Mapper<T>().toJSONString(value.msg!)
                }
                Log.debug("api[\(self.tid)]: (Raw String) \(value.rawString)")
            } else {
                Log.error("api[\(self.tid)]: ApiError[\(value.code)] \(value.errorMessage ?? "")")
            }
            
            callback(value)
        case .failure(let error):
            let value = ApiResponse<T>()
            if let statusCode = response.response?.statusCode {
                if statusCode >= 200 && statusCode < 400 {
                    value.error = ApiError.httpRequestError(status: (response.response?.statusCode)!)
                    Log.error("api[\(self.tid)]: \(statusCode) Http Request Error")
                    callback(value)
                    stopLoading()
                    return
                }
            }
            Log.error("api[\(self.tid)]: \(error)")
            value.error = ApiError.dataError
            callback(value)
        }
        stopLoading()
    }
}

// MARK: - 载入动画

extension ApiRequest {

    fileprivate func startLoading() {
        guard let window = UIApplication.shared.keyWindow else { return }
        if let quiet = self.options["quiet"] as? Bool, quiet {
            return
        }
        sync {
            if ApiRequest.loadingCount == 0 {
                if ApiRequest.loadingView == nil {
                    ApiRequest.loadingView = UIView(frame: window.bounds)
                } else {
                    ApiRequest.loadingView!.removeFromSuperview()
                }
                
                let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                ApiRequest.loadingView!.addSubview(indicatorView)
                
                indicatorView.snp.makeConstraints({ (make) in
                    make.centerX.equalTo(0)
                    make.centerY.equalTo(0)
                })
                indicatorView.startAnimating()

                window.addSubview(ApiRequest.loadingView!)
            }
            ApiRequest.loadingCount += 1
        }
    }

    fileprivate func stopLoading() {
        if let quiet = self.options["quiet"] as? Bool, quiet {
            return
        }
        sync {
            ApiRequest.loadingCount -= 1
            if ApiRequest.loadingCount <= 0 {
                ApiRequest.loadingCount = 0
                guard let loadingView = ApiRequest.loadingView else { return }
                for view in loadingView.subviews {
                    if let indicatorView = view as? UIActivityIndicatorView {
                        indicatorView.stopAnimating()
                    }
                    view.removeFromSuperview()
                }
                loadingView.removeFromSuperview()
            }
        }
    }

}

// MARK: - 标准HTTP Method调用

extension ApiRequest {

    /// 调用GET请求
    func get<T>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ response: ApiResponse<T>) -> Void) -> ApiRequest {
        return prepare(.get, params: params, start: start, limit: limit, callback: callback)
    }

    /// 调用POST请求
    func post<T>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ response: ApiResponse<T>) -> Void) -> ApiRequest {
        return prepare(.post, params: params, start: start, limit: limit, callback: callback)
    }

    /// 调用PUT请求
    func put<T>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ response: ApiResponse<T>) -> Void) -> ApiRequest {
        return prepare(.put, params: params, start: start, limit: limit, callback: callback)
    }

    /// 调用DELETE请求
    func delete<T>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ response: ApiResponse<T>) -> Void) -> ApiRequest {
        return prepare(.delete, params: params, start: start, limit: limit, callback: callback)
    }

}

// MARK: - 默认异常错误的调用方式

extension ApiRequest {
    /// 调用GET请求
    func get<T: Mappable>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ data: T) -> Void) -> ApiRequest {
        return self.get(params, start: start, limit: limit) { (response: ApiResponse<T>) in
            _ = response.failureDefault().success {
                callback($0)
            }
        }
    }

    /// 调用POST请求
    func post<T: Mappable>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ data: T) -> Void) -> ApiRequest {
        return self.post(params, start: start, limit: limit) { (response: ApiResponse<T>) in
           _ = response.failureDefault().success {
                callback($0)
            }
        }
    }

    /// 调用PUT请求
    func put<T: Mappable>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ data: T) -> Void) -> ApiRequest {
        return self.put(params, start: start, limit: limit) { (response: ApiResponse<T>) in
            _ = response.failureDefault().success {
                callback($0)
            }
        }
    }

    /// 调用DELETE请求
    func delete<T: Mappable>(_ params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: @escaping (_ data: T) -> Void) -> ApiRequest {
        return self.delete(params, start: start, limit: limit) { (response: ApiResponse<T>) in
            _ = response.failureDefault().success {
                callback($0)
            }
        }
    }
}

// MARK: - 其他接口请求

extension ApiRequest {

    /// 调用POST请求(提交JSON字符串)
    func post<T>(jsonString: String, callback: @escaping (_ response: ApiResponse<T>) -> Void) {
        let url = URL(string: buiUrlString())!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"

        request.httpBody = jsonString.data // try! NSJSONSerialization.dataWithJSONObject(jsonContent, options: [])
        let r = NetworkManager.defaultManager.request(request as! URLRequestConvertible).responseObject { (response: DataResponse <ApiResponse<T>>) in
            self.handleJSON(response: response, callback: callback)
        }
        Log.info("api[\(self.tid)]: \(r.debugDescription)")
    }
    // 生成URL字符串
    func buiUrlString() -> String {
        return settings.baseURL
    }
    //	生成URL字符串
    func buiUrlString(method: HTTPMethod) -> String {
        var result = path
        if result.rangeOfString("{") != nil {
            for (key, value) in params {
                if let range = result.rangeOfString("{\(key)}") {
                    result = result.stringByReplacingCharactersInRange(range, withString: "\(value)")
                    params[key] = nil
                }
            }
        }
        
        result = "\(settings.baseURL)\(result)?_t=\(self.tid)"
        
        result += "&uid=\(session.uid)"
        
        if !session.token.isEmpty {
            result += "&token=\(session.token)"
        }
        if !session.deviceId.isEmpty {
            result += "&device=\(session.deviceId)"
        }
        if !session.imei.isEmpty {
            result += "&imei=\(session.imei)"
        }
        if !session.city.isEmpty {
            result += "&city=\(session.city.urlEncode)"
        }
//        if !session.theme {
//            result += "&theme=\(session.theme)"
//        }
        
        if (method == .get || method == .delete) {
            for (key, value) in params {
                if let array = value as? [String] {
                    for item in array {
                        result += "&\(key)=\(item.urlEncode)"
                    }
                    params[key] = nil
                }
            }
        }
        return "\(result)&apiversion=\(session.apiVersion)&latitude=\(session.location.coordinate.latitude)&longitude=\(session.location.coordinate.longitude)"
    }


}
