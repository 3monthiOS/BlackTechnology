//
//  RequestAddress.swift
//  App
//
//  Created by 红军张 on 2017/4/25.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation


extension Api {
    static let test = api("test.json", defaultParameters: ["default": "dtxx"])
    static let testArray = api("testArray.json")
    static let testString = api("testString.json")
    static let testArrayString = api("testArrayString.json")
    
    static let testArrayStringBaiDu = api("https://httpbin.org/get")
    
    static func testParam(name: String) -> ApiService { return api("test.json?age=10", defaultParameters: ["name": name]) }
}
