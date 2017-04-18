//
// Created by Cator Vee on 7/10/16.
// Copyright (c) 2016 Cator Vee. All rights reserved.
//

import Foundation

public enum RestError: Error {
    case httpRequestError(status:Int)
    case resultError(code:Int, message:String)
    case dataError
    case networkError
}
