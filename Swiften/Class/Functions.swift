//
//  Functions.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit

public func toast(_ message: String?, in view: UIView? = nil, duration: TimeInterval? = nil, position: ToastPosition? = nil, title: String? = nil, image: UIImage? = nil, style: ToastStyle? = nil, completion: ((_ didTap: Bool) -> Void)? = nil) {
    guard let view = view ?? UIApplication.shared.keyWindow else { return }
    let manager = ToastManager.shared
    view.makeToast(message, duration: duration ?? manager.duration, position: position ?? manager.position, title: title, image: image, style: style, completion: completion)
}

public func spin(in view: UIView, at position: ToastPosition = .center) {
    view.makeToastActivity(position)
}

public func spin(in view: UIView, at position: CGPoint) {
    view.makeToastActivity(position)
}

public func spin(in view: UIView, stop: Bool) {
    if stop {
        view.hideToastActivity()
    } else {
        spin(in: view)
    }
}
