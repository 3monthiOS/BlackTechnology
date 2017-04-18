//
//  AHApiError.swift
//  aha
//
//  Created by Cator Vee on 12/9/15.
//  Copyright © 2015 Ledong. All rights reserved.
//

import Foundation

enum LDApiError: Error {
	case httpRequestError(status: Int)
	case apiError(code: Int, message: String)
	case dataError
}
