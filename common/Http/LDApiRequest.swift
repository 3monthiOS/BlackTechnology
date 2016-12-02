//
//  LDApiRequest.swift
//  aha
//
//  Created by Cator Vee on 12/9/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Swiften
import SwiftyJSON
import SnapKit

typealias LDApiRequestParams = [String: AnyObject]
typealias LDApiRequestOptions = [String: Any]

@objc class LDApiRequest: NSObject {

    static let defaultOptions: LDApiRequestOptions = [
        "dataType": LDApiDataTypes.JSON // 返回数据类型
    ]

    static var loadingCount = 0
    static var loadingView: UIView?

    private let tid: Int
    private var startTime: NSTimeInterval = 0.0

    let action: String
    let settings: LDApiSettings

    var params: LDApiRequestParams
    var options: LDApiRequestOptions

    var quiet: LDApiRequest {
        self.options["quiet"] = true
        return self
    }

    var request: Request?

    init(action: String, settings: LDApiSettings) {
        self.action = action
        self.settings = settings
        self.tid = session.tick
        self.options = LDApiRequest.defaultOptions
        self.params = [:]
    }

    func reset() -> LDApiRequest {
        options = LDApiRequest.defaultOptions
        params = [:]
        return self
    }

    /// 设置options
    func updateOptions(options: LDApiRequestOptions) -> LDApiRequest {
        for (key, value) in options {
            self.options[key] = value
        }
        return self
    }

    func updateOptions(fromDictionary options: [String:AnyObject]) -> LDApiRequest {
        for (key, value) in options {
            self.options[key] = value
        }
        return self
    }

    /// 设置params
    func updateParams(params: [String: AnyObject]?, start: Int? = nil, limit: Int? = nil) -> LDApiRequest {
        if let newParams = params {
            for (key, value) in newParams {
                self.params[key] = value
            }
        }
        if start != nil || limit != nil {
            self.params["offset"] = start ?? 0
            self.params["size"] = limit ?? 20
        }
        return self
    }

    /// 取消API请求
    func cancel() {
        request?.cancel()
    }

    /// 调用前准备
    func prepare<T>(
        method: Alamofire.Method,
        params: [String: AnyObject]? = nil,
        start: Int? = nil,
        limit: Int? = nil,
        callback: (response: LDApiResponse<T>) -> Void)
        -> LDApiRequest
    {
        if params == nil && start == nil && limit == nil {
            return call(method, callback)
        } else {
            return updateParams(params, start: start, limit: limit).call(method, callback)
        }
    }

    /// 调用API请求
    func call<T>(method: Alamofire.Method, _ callback: (response: LDApiResponse<T>) -> Void) -> LDApiRequest {
        
        #if DEBUG
            startTime = NSDate.timeIntervalSinceReferenceDate()
        #endif

        var urlString = buildUrlString()
        if let urlParams = options["urlParams"] as? String {
            if !urlString.containsString("?") {
                urlString += "?"
            }
            urlString += urlParams
        }
        
        guard let url = NSURL(string: urlString) else { return self }

        let dataType = self.options["dataType"] as! LDApiDataTypes

        let manager = NetworkManager.sharedInstace.defaultManager
        let encoding: ParameterEncoding = (method != .GET) ? .JSON : .URL

        let mutableURLRequest = NSMutableURLRequest(URL: url)

        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.cachePolicy = Reachability.networkStatus != .notReachable ? .ReloadIgnoringCacheData : .ReturnCacheDataDontLoad

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

        var parameters: [String: AnyObject] = [ "_t": tid, "j": jString, "sign": sign ]

        if let ljsonp = options["ljsonp"] as? Bool,
               japi = options["japi"] as? String,
               jdomain = options["jdomain"] as? String
            where ljsonp {
            parameters["jdomain"] = jdomain
            parameters["japi"] = japi
        }

        let encodedURLRequest = encoding.encode(mutableURLRequest, parameters: parameters).0
        //
        request = manager.request(encodedURLRequest)

        Log.info("api[\(self.tid)]: \(request!.debugDescription)")

        startLoading()

        switch dataType {
        case .JSON:
            request!.responseObject { (response: Alamofire.Response<LDApiResponse<T>, NSError>) in
                self.handleJSON(response: response, callback: callback)
            }
        default:
            Log.error("api: unsupported data type (\(dataType))")
            stopLoading()
        }

        return self
    }

    private func handleJSON<T>(response response: Alamofire.Response<LDApiResponse<T>, NSError>, callback: (response: LDApiResponse<T>) -> Void) {
        Log.info("api[\(self.tid)]: \(response.response == nil ? "nil" : response.response!.debugDescription) Data: \((response.data?.length)!) bytes, Time: \(round((NSDate.timeIntervalSinceReferenceDate() - startTime) * 10000) / 10) ms")
        switch response.result {
        case .Success(let value):
            value.rawData = response.data!
            if let httpResponse = response.response {
                value.headers = httpResponse.allHeaderFields
            }
            if value.isOK {
                if let cacheKey = self.options["cacheKey"] as? LDCacheSettings.Key {
                    cache[cacheKey] = Mapper<T>().toJSONString(value.msg!)
                }
                Log.debug("api[\(self.tid)]: (Raw String) \(value.rawString)")
            } else {
                Log.error("api[\(self.tid)]: ApiError[\(value.code)] \(value.errorMessage ?? "")")
            }

            callback(response: value)
        case .Failure(let error):
            let value = LDApiResponse<T>()
            if let statusCode = response.response?.statusCode {
                if statusCode >= 200 && statusCode < 400 {
                    value.error = LDApiError.HttpRequestError(status: (response.response?.statusCode)!)
                    Log.error("api[\(self.tid)]: \(statusCode) Http Request Error")
                    callback(response: value)
                    stopLoading()
                    return
                }
            }
            Log.error("api[\(self.tid)]: \(error)")
            value.error = LDApiError.DataError
            callback(response: value)
        }
        stopLoading()
    }

    // 生成URL字符串
    func buildUrlString() -> String {
        return settings.baseURL
    }
}

// MARK: - 载入动画

extension LDApiRequest {

    private func startLoading() {
        guard let window = UIApplication.sharedApplication().keyWindow else { return }
        if let quiet = self.options["quiet"] as? Bool where quiet {
            return
        }
        sync {
            if LDApiRequest.loadingCount == 0 {
                if LDApiRequest.loadingView == nil {
                    LDApiRequest.loadingView = UIView(frame: window.bounds)
                } else {
                    LDApiRequest.loadingView!.removeFromSuperview()
                }
                
                let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
                LDApiRequest.loadingView!.addSubview(indicatorView)
                
                indicatorView.snp_makeConstraints(closure: { (make) in
                    make.centerX.equalTo(0)
                    make.centerY.equalTo(0)
                })
                indicatorView.startAnimating()

                window.addSubview(LDApiRequest.loadingView!)
            }
            LDApiRequest.loadingCount += 1
        }
    }

    private func stopLoading() {
        if let quiet = self.options["quiet"] as? Bool where quiet {
            return
        }
        sync {
            LDApiRequest.loadingCount -= 1
            if LDApiRequest.loadingCount <= 0 {
                LDApiRequest.loadingCount = 0
                guard let loadingView = LDApiRequest.loadingView else { return }
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

extension LDApiRequest {

    /// 调用GET请求
    func get<T>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (response: LDApiResponse<T>) -> Void) -> LDApiRequest {
        return prepare(.GET, params: params, start: start, limit: limit, callback: callback)
    }

    /// 调用POST请求
    func post<T>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (response: LDApiResponse<T>) -> Void) -> LDApiRequest {
        return prepare(.POST, params: params, start: start, limit: limit, callback: callback)
    }

    /// 调用PUT请求
    func put<T>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (response: LDApiResponse<T>) -> Void) -> LDApiRequest {
        return prepare(.PUT, params: params, start: start, limit: limit, callback: callback)
    }

    /// 调用DELETE请求
    func delete<T>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (response: LDApiResponse<T>) -> Void) -> LDApiRequest {
        return prepare(.DELETE, params: params, start: start, limit: limit, callback: callback)
    }

}

// MARK: - 默认异常错误的调用方式

extension LDApiRequest {
    /// 调用GET请求
    func get<T: Mappable>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (data: T) -> Void) -> LDApiRequest {
        return self.get(params, start: start, limit: limit) { (response: LDApiResponse<T>) in
            response.failureDefault().success {
                callback(data: $0)
            }
        }
    }

    /// 调用POST请求
    func post<T: Mappable>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (data: T) -> Void) -> LDApiRequest {
        return self.post(params, start: start, limit: limit) { (response: LDApiResponse<T>) in
            response.failureDefault().success {
                callback(data: $0)
            }
        }
    }

    /// 调用PUT请求
    func put<T: Mappable>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (data: T) -> Void) -> LDApiRequest {
        return self.put(params, start: start, limit: limit) { (response: LDApiResponse<T>) in
            response.failureDefault().success {
                callback(data: $0)
            }
        }
    }

    /// 调用DELETE请求
    func delete<T: Mappable>(params: [String: AnyObject]? = nil, start: Int? = nil, limit: Int? = nil, callback: (data: T) -> Void) -> LDApiRequest {
        return self.delete(params, start: start, limit: limit) { (response: LDApiResponse<T>) in
            response.failureDefault().success {
                callback(data: $0)
            }
        }
    }
}

// MARK: - 其他接口请求

extension LDApiRequest {

    /// 调用POST请求(提交JSON字符串)
    func post<T>(jsonString jsonString: String, callback: (response: LDApiResponse<T>) -> Void) {
        let url = NSURL(string: buildUrlString())!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"

        request.HTTPBody = jsonString.data // try! NSJSONSerialization.dataWithJSONObject(jsonContent, options: [])
        let r = NetworkManager.sharedInstace.defaultManager.request(request).responseObject { (response: Alamofire.Response<LDApiResponse<T>, NSError>) in
            self.handleJSON(response: response, callback: callback)
        }
        Log.info("api[\(self.tid)]: \(r.debugDescription)")
    }

}
