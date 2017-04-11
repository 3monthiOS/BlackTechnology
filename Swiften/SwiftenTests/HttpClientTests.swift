//
//  HttpClientTests.swift
//  Swiften
//
//  Created by Cator Vee on 25/02/2017.
//  Copyright © 2017 Cator Vee. All rights reserved.
//

import XCTest
import Alamofire
import AlamofireImage
import ObjectMapper
import Swiften

public class MessageWrapper<T: Mappable>: Mappable {
	public var code = -1
	public var msg: T?
	public var token: String?
	
	public required init?(map: Map) {
		// nothing
	}
	
	public func mapping(map: Map) {
		code <- map["code"]
		msg <- map["msg"]
		token <- map["token"]
	}
}

class MessageBody: Mappable {
	var name: String?
	var age: Int?
	
	required init?(map: Map) {
		// nothing
	}
	
	func mapping(map: Map) {
		name <- map["name"]
		age <- map["age"]
	}
}

class AccessTokenAdapter: RequestAdapter {
	func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
		var urlRequest = urlRequest
		urlRequest.setValue("xxxx", forHTTPHeaderField: "tttt")
		return urlRequest
	}
}

class Api: ApiServiceDelegate {
	public static let `default` = Api()
	
	var urlPrefix: String {
		return "http://127.0.0.1:8000/"
	}
	
	func requestWillSend(_ apiService: ApiService, request: inout URLRequest) throws {
		print(">>>>>>>>>>>>>> requestWillSend")
		print(request.debugDescription)
		request.setValue("dddd", forHTTPHeaderField: "xxxyyy")
		print("<<<<<<<<<<<<<< requestWillSend")
	}
	
	func requestDidSend(_ apiService: ApiService, request: DataRequest) {
		print(">>>>>>>>>>>>>> requestDidSend")
		print(request.debugDescription)
		print("<<<<<<<<<<<<<< requestDidSend")
	}
	
	func responseDidReceive<T>(_ apiService: ApiService, response: ApiBaseResponse<T>) {
		print(">>>>>>>>>>>>>> responseDidReceive")
		print(response.debugDescription)
		print("<<<<<<<<<<<<<< responseDidReceive")
	}
	
	public static func api(_ path: String, defaultParameters parameters: Parameters? = nil) -> ApiService {
		return ApiService(path: path, delegate: Api.default, defaultParameters: parameters)
	}
}

extension Api {
	static let test = api("test.json", defaultParameters: ["default": "dtxx"])
	static let testArray = api("testArray.json")
	static let testString = api("testString.json")
	static let testArrayString = api("testArrayString.json")
	static func testParam(name: String) -> ApiService { return api("test.json?age=10", defaultParameters: ["name": name]) }
}

extension Api {
	open static let sharedCookieStorage = HTTPCookieStorage.shared
	
	open static func initHttpClient() {
		FileURLCache.activate()
		
		
		let serverTrustPolicies: [String: ServerTrustPolicy] = [
			"test.catorv.com": .disableEvaluation,
			]
		let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
		
		// 初始化图片下载器
		let configuration = URLSessionConfiguration.default
		configuration.requestCachePolicy = .returnCacheDataElseLoad
		let manager = Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: serverTrustPolicyManager)
		let sharedImageDownloader = ImageDownloader(sessionManager: manager)
		UIImageView.af_sharedImageDownloader = sharedImageDownloader
		UIButton.af_sharedImageDownloader = sharedImageDownloader
		
		// 初始化默认网络请求
		let defaultConfiguration = URLSessionConfiguration.default
		defaultConfiguration.timeoutIntervalForRequest = 30
		defaultConfiguration.httpCookieStorage = sharedCookieStorage
		HttpClient.default = Alamofire.SessionManager(
			configuration: defaultConfiguration,
			serverTrustPolicyManager: serverTrustPolicyManager
		)
	}
	
	static func removeAllCookies() {
		if let cookies = sharedCookieStorage.cookies {
			for cookie in cookies {
				sharedCookieStorage.deleteCookie(cookie)
			}
		}
	}
}

class HttpClientTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		HttpClient.default.adapter = AccessTokenAdapter()
		HttpClient.defaultEncoding = JerseyEncoding.default
		HttpClient.errorFieldName = "msg"
	}
	
	func testJson() {
		let exp = expectation(description: "")
		
		Api.test.call { (response: ApiResponse<String>) in
			XCTAssertEqual(response.json?["msg"]["name"].string, "cator")
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testObject() {
		let exp = expectation(description: "")
		
		Api.test.call { (response: ApiObjectResponse<MessageBody>) in
			if let value = response.value {
				let json = value.toJSONString()
				XCTAssertEqual(json, "{\"code\":0,\"token\":\"hhhaaacccddkekkaksdjfskjfsj\",\"msg\":{\"name\":\"cator\",\"age\":38}}")
				XCTAssertEqual(response.msg?.name, "cator")
				XCTAssertEqual(response.json?["msg"]["name"].string, "cator")
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testArray() {
		let exp = expectation(description: "")
		
		Api.testArray.call { (response: ApiObjectArrayResponse<MessageBody>) in
			if let value = response.value {
				let json = value.toJSONString()
				XCTAssertEqual(json, "{\"code\":0,\"token\":\"hhhaaacccddkekkaksdjfskjfsj\",\"msg\":[{\"name\":\"cator\",\"age\":38},{\"name\":\"cator2\",\"age\":40}]}")
				XCTAssertEqual(response.msg?.count, 2)
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testStringResponse() {
		let exp = expectation(description: "")
		
		Api.testString.call { (response: ApiResponse<String>) in
			if let value = response.value {
				let json = value.toJSONString()
				XCTAssertEqual(json, "{\"code\":0,\"token\":\"hhhaaacccddkekkaksdjfskjfsj\",\"msg\":\"cator vee\"}")
				XCTAssertEqual(response.msg, "cator vee")
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testStringArrayResponse() {
		let exp = expectation(description: "")
		
		Api.testArrayString.call { (response: ApiArrayResponse<String>) in
			if let value = response.value {
				let json = value.toJSONString()
				XCTAssertEqual(json, "{\"code\":0,\"token\":\"hhhaaacccddkekkaksdjfskjfsj\",\"msg\":[\"cator\",\"vee\"]}")
				XCTAssertEqual(response.msg?.count, 2)
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testUrlParam() {
		let exp = expectation(description: "")
		
		Api.api("test{type}.json").call(parameters: ["type": "String", "test": true]) { (response: ApiResponse<String>) in
			XCTAssertEqual(response.msg, "cator vee")
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testParam() {
		let exp = expectation(description: "")
		
		Api.testParam(name: "cator").call(parameters: ["test": true]) { (response: ApiResponse<String>) in
			let urlComponents = URLComponents(url: response.request!.url!, resolvingAgainstBaseURL: false)!
			for queryItem in urlComponents.queryItems! {
				switch queryItem.name {
				case "name":
					XCTAssertEqual(queryItem.value, "cator")
				case "age":
					XCTAssertEqual(queryItem.value, "10")
				case "test":
					XCTAssertEqual(queryItem.value, "true")
				default:
					break
				}
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testError() {
		let exp = expectation(description: "")
		
		Api.api("testError.json").call { (response: ApiResponse<String>) in
			XCTAssertNil(response.msg)
			if let error = response.error as? ApiError, case let ApiError.unacceptableCode(code, message) = error {
				XCTAssertEqual(code, -1)
				XCTAssertEqual(message, "error message")
			} else {
				XCTFail()
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
	func testHttpError() {
		let exp = expectation(description: "")
		
		Api.api("testHttpError.json").call { (response: ApiResponse<String>) in
			XCTAssertNil(response.msg)
			if let error = response.error as? AFError, case let AFError.responseValidationFailed(reason: .unacceptableStatusCode(code)) = error {
					XCTAssertEqual(code, 404)
			} else {
				XCTFail()
			}
			exp.fulfill()
		}
		
		waitForExpectations(timeout: 10.0) { error in
			if let error = error {
				XCTFail(error.localizedDescription)
			}
		}
	}

}
