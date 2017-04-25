//
//  AHApiDataTypes.swift
//  aha
//
//  Created by Cator Vee on 12/9/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation

enum ApiDataTypes: String {
	case JSON, HTML, XML, Text
	
	var mime: String {
		switch self {
		case .JSON: return "application/json"
		case .XML: return "application/xml, text/xml"
		case .HTML: return "text/html"
		case .Text: return "text/plain"
		}
	}
}
