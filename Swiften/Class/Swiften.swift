//
//  Swiften.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation

public let session = Session()

public func initFramework() {
    WebView.swizzle()
}
