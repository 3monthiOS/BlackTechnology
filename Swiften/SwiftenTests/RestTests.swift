//
//  RestTests.swift
//  Swiften
//
//  Created by Cator Vee on 7/11/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import XCTest
@testable import Swiften
import Alamofire

class RestTests: XCTestCase {
    
    var request: RestRequest?
    
    override func setUp() {
        NetworkManager.initNetworkManager()
        Rest.responseMessageField = "obj"
        
        request = RestRequest(options: [:])
        request!.requestBuilder = { (request) in
            let url = "http://127.0.0.1:8000/qc-webapp/qcapi.do?_t=268&j=%7B%22wxappid%22%3A%22wx46de5e4162929de9%22%2C%22openid%22%3A%22oMg0RuH7wfP7ZWCr_kHfA6RYXAtQ%22%2C%22passport%22%3A%228efeba551a1c6df13af606666f57c413%22%2C%22vericode%22%3A%22%22%2C%22url%22%3A%22http%3A%2F%2F127.0.0.1%3A8000%2Fconsumer2%2Fhouse-online.html%3Ffopenid%3D%26memberopenid%3D%26projectid%3D9318%22%2C%22action%22%3A%22%2Fhfz%2FHfzChannelManageAction%2FgetRegisterInfo%22%2C%22requestParam%22%3A%7B%22obj%22%3A%7B%22openid%22%3A%22oMg0RuH7wfP7ZWCr_kHfA6RYXAtQ%22%7D%7D%2C%22xxx%22%3A9060%7D&sign=10ac4efc9a7a5a358ef5b05e074f3d59"
            let manager = NetworkManager.defaultManager
            
            let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
            return manager.request(mutableURLRequest)
        }
    }
    
    func testGet() {
        let expectation = self.expectation(description: "Rest request")
        request?.get { (response: RestResponse<RestBaseModel>) in
            XCTAssertTrue(response.isOK)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 30) { (error) in
            XCTAssertNil(error)
            if error != nil {
                Log.error(error)
            }
        }
    }
    
}
