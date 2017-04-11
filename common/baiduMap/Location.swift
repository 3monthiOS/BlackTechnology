//
// Location.swift
// aha
//
// Created by date13 on 15/12/7.
// Copyright © 2015年 Ledong. All rights reserved.
//

import Foundation
import ObjectMapper

class Location : Mappable {
	var latitude : Double = 0
	var longitude : Double = 0
	var country : String?
	var province : String?
	var district : String?
	var street : String?
	var city : String?
	var zip : String?
	var locName : String?
    var lasttime : Int64? = 0

	init(lat: Double, lng: Double) {
		self.latitude = lat
		self.longitude = lng
	}

	required init?(_ map: Map) {
	}

	func mapping(_ map: Map) {
        latitude <- map["latitude"]
        longitude <- map["longitude"]
		country <- map["country"]
		province <- map["province"]
		district <- map["district"]
		street <- map["street"]
		city <- map["city"]
		zip <- map["zip"]
		locName <- map["locName"]
        lasttime <- map["lasttime"]
	}
}
