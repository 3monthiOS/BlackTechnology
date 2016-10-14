//
//  AHApiError.swift
//  aha
//
//  Created by Cator Vee on 12/9/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation

enum LDApiError: ErrorType {
	case HttpRequestError(status: Int)
	case ApiError(code: Int, message: String)
	case DataError
}