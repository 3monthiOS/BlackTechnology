//
//  ApiService.swift
//  Swiften
//
//  Created by Cator Vee on 08/03/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import SwiftyJSON

// MARK: - ApiServiceDelegate

public protocol ApiServiceDelegate: class {
	var urlPrefix: String { get }
	func requestWillSend(_ apiService: ApiService, request: inout URLRequest) throws
	func requestDidSend(_ apiService: ApiService, request: DataRequest)
	func responseDidReceive<T>(_ apiService: ApiService, response: ApiBaseResponse<T>)
}

// MARK: - ApiError

public enum ApiError: Error {
	case unacceptableCode(code: Int, message: String?)
}

// MARK: - ApiMessage

public class ApiBaseMessage: Mappable {
	public var code = -1
	public var token: String?
	public var errmsg: String?
	
	public required init?(map: Map) {
		// nothing
	}
	
	public func mapping(map: Map) {
		code <- map[HttpClient.codeFieldName]
		token <- map[HttpClient.tokenFieldName]
		errmsg <- map[HttpClient.errorFieldName]
	}
}

public class ApiMessage<T>: ApiBaseMessage {
	public var msg: T?
	
	public override func mapping(map: Map) {
		super.mapping(map: map)
		msg <- map[HttpClient.messageFieldName]
	}
}

public class ApiArrayMessage<T>: ApiBaseMessage {
	public var msg: [T]?
	
	public override func mapping(map: Map) {
		super.mapping(map: map)
		msg <- map[HttpClient.messageFieldName]
	}
}

public class ApiObjectMessage<T: Mappable>: ApiBaseMessage {
	public var msg: T?
	
	public override func mapping(map: Map) {
		super.mapping(map: map)
		msg <- map[HttpClient.messageFieldName]
	}
}

public class ApiObjectArrayMessage<T: Mappable>: ApiBaseMessage {
	public var msg: [T]?
	
	public override func mapping(map: Map) {
		super.mapping(map: map)
		msg <- map[HttpClient.messageFieldName]
	}
}

// MARK: - ApiResponse

public class ApiBaseResponse<Value: Mappable> {
	fileprivate var dataResponse: DataResponse<Value>
	
	/// HTTP响应内容的JSON对象
	open var json: JSON? {
		guard let data = data else {
			return nil
		}
		return JSON(data: data)
	}
	
	public init(_ dataResponse: DataResponse<Value>) {
		self.dataResponse = dataResponse
	}
}

extension ApiBaseResponse {
	/// The URL request sent to the server.
	public var request: URLRequest? { return dataResponse.request }
	
	/// The server's response to the URL request.
	public var response: HTTPURLResponse? { return dataResponse.response }
	
	/// The data returned by the server.
	public var data: Data? { return dataResponse.data }
	
	/// The result of response serialization.
	public var result: Result<Value> { return dataResponse.result }
	
	/// The timeline of the complete lifecycle of the request.
	public var timeline: Timeline { return dataResponse.timeline }
	
	/// Returns the associated value of the result if it is a success, `nil` otherwise.
	public var value: Value? { return dataResponse.value }
	
	/// Returns the associated error value if the result if it is a failure, `nil` otherwise.
	public var error: Error? {
		if let error = dataResponse.error {
			return error
		}
		if let value = value as? ApiBaseMessage, value.code != 0 {
			return ApiError.unacceptableCode(code: value.code, message: value.errmsg)
		}
		return nil
	}
}

extension ApiBaseResponse: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String { return dataResponse.description }
	public var debugDescription: String { return dataResponse.debugDescription }
}

public class ApiObjectResponse<Value: Mappable>: ApiBaseResponse<ApiObjectMessage<Value>> {
	public var msg: Value? {
		if let value = value, value.code == 0 {
			return value.msg
		}
		return nil
	}
}

public class ApiObjectArrayResponse<Value: Mappable>: ApiBaseResponse<ApiObjectArrayMessage<Value>> {
	public var msg: [Value]? {
		if let value = value, value.code == 0 {
			return value.msg
		}
		return nil
	}
}

public class ApiResponse<Value>: ApiBaseResponse<ApiMessage<Value>> {
	public var msg: Value? {
		if let value = value, value.code == 0 {
			return value.msg
		}
		return nil
	}
}

public class ApiArrayResponse<Value>: ApiBaseResponse<ApiArrayMessage<Value>> {
	public var msg: [Value]? {
		if let value = value, value.code == 0 {
			return value.msg
		}
		return nil
	}
}

// MARK: - ApiService

public struct ApiService {
	public weak var delegate: ApiServiceDelegate?
	public let path: String
	public let parameters: Parameters?
	
	public init(path: String, delegate: ApiServiceDelegate, defaultParameters parameters: Parameters? = nil) {
		self.path = path
		self.delegate = delegate
		self.parameters = parameters
	}
	
	@discardableResult
	public func request(method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = HttpClient.defaultEncoding, headers: HTTPHeaders? = nil) -> DataRequest {
		var parameters = parameters
		if let defaultParameters = self.parameters {
			if parameters == nil {
				parameters = defaultParameters
			} else {
				for (key, value) in defaultParameters {
					if parameters![key] == nil {
						parameters![key] = value
					}
				}
			}
		}
		let url = buildUrlString(method: method, parameters: &parameters)
		
		var request: DataRequest
		do {
			let originalRequest = try URLRequest(url: url, method: method, headers: headers)
			var encodedURLRequest = try encoding.encode(originalRequest, with: parameters)
			try delegate?.requestWillSend(self, request: &encodedURLRequest)
			request = HttpClient.default.request(encodedURLRequest)
		} catch {
			request = HttpClient.default.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
		}
		
		delegate?.requestDidSend(self, request: request)
		return request.validate()
	}
	
	private func buildUrlString(method: HTTPMethod, parameters: inout Parameters?) -> String {
		var url = (delegate?.urlPrefix ?? "") + path
		if parameters != nil && url.contains("{") {
			for (key, value) in parameters! {
				if let range = url.range(of: "{\(key)}") {
					url.replaceSubrange(range, with: "\(value)")
					parameters![key] = nil
				}
			}
		}
		return url
	}
}

extension ApiService {
	@discardableResult
	public func call<T>(method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = HttpClient.defaultEncoding, headers: HTTPHeaders? = nil, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiResponse<T>) -> Void) -> DataRequest {
		let req = request(method: method, parameters: parameters, encoding: encoding, headers: headers)
		return req.responseApiService(self, queue: queue, completionHandler: completionHandler)
	}
	
	@discardableResult
	public func call<T>(method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = HttpClient.defaultEncoding, headers: HTTPHeaders? = nil, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiArrayResponse<T>) -> Void) -> DataRequest {
		let req = request(method: method, parameters: parameters, encoding: encoding, headers: headers)
		return req.responseApiService(self, queue: queue, completionHandler: completionHandler)
	}
	
	@discardableResult
	public func call<T>(method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = HttpClient.defaultEncoding, headers: HTTPHeaders? = nil, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiObjectResponse<T>) -> Void) -> DataRequest {
		let req = request(method: method, parameters: parameters, encoding: encoding, headers: headers)
		return req.responseApiService(self, queue: queue, completionHandler: completionHandler)
	}
	
	@discardableResult
	public func call<T>(method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = HttpClient.defaultEncoding, headers: HTTPHeaders? = nil, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiObjectArrayResponse<T>) -> Void) -> DataRequest {
		let req = request(method: method, parameters: parameters, encoding: encoding, headers: headers)
		return req.responseApiService(self, queue: queue, completionHandler: completionHandler)
	}
}

extension DataRequest {
	@discardableResult
	public func responseApiService<T>(_ apiService: ApiService, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiResponse<T>) -> Void) -> Self {
		return responseObject(queue: queue) { (response: DataResponse<ApiMessage<T>>) in
			let apiResponse = ApiResponse(response)
			apiService.delegate?.responseDidReceive(apiService, response: apiResponse)
			completionHandler(apiResponse)
		}
	}
	
	@discardableResult
	public func responseApiService<T>(_ apiService: ApiService, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiArrayResponse<T>) -> Void) -> Self {
		return responseObject(queue: queue) { (response: DataResponse<ApiArrayMessage<T>>) in
			let apiResponse = ApiArrayResponse(response)
			apiService.delegate?.responseDidReceive(apiService, response: apiResponse)
			completionHandler(apiResponse)
		}
	}
	
	@discardableResult
	public func responseApiService<T>(_ apiService: ApiService, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiObjectResponse<T>) -> Void) -> Self {
		return responseObject(queue: queue) { (response: DataResponse<ApiObjectMessage<T>>) in
			let apiResponse = ApiObjectResponse(response)
			apiService.delegate?.responseDidReceive(apiService, response: apiResponse)
			completionHandler(apiResponse)
		}
	}
	
	@discardableResult
	public func responseApiService<T>(_ apiService: ApiService, queue: DispatchQueue? = nil, completionHandler: @escaping (ApiObjectArrayResponse<T>) -> Void) -> Self {
		return responseObject(queue: queue) { (response: DataResponse<ApiObjectArrayMessage<T>>) in
			let apiResponse = ApiObjectArrayResponse(response)
			apiService.delegate?.responseDidReceive(apiService, response: apiResponse)
			completionHandler(apiResponse)
		}
	}
}
