//
//  Functions.swift
//  Swiften
//
//  Created by Cator Vee on 5/24/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import Toast_Swift

public func alert(_ message: String, title: String? = nil, buttonTitle: String = "我知道了", completion: (() -> Void)? = nil) {
  let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
  controller.addAction(UIAlertAction(title: buttonTitle, style: .default) { action in
    controller.dismiss(animated: true, completion: completion)
  })
  UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

public func confirm(_ message: String, title: String! = nil, completion: @escaping (Bool) -> Void) {
  let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
  controller.addAction(UIAlertAction(title: "否", style: .cancel) { action in
    controller.dismiss(animated: true, completion: nil)
    completion(false)
  })
  controller.addAction(UIAlertAction(title: "是", style: .default) { action in
    controller.dismiss(animated: true, completion: nil)
    completion(true)
  })
  UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

public func prompt(_ message: String, title: String! = nil, text: String! = nil, placeholder: String! = nil, completion: @escaping (String?) -> Void) {
  let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
  controller.addAction(UIAlertAction(title: "取消", style: .cancel) { action in
    controller.dismiss(animated: true, completion: nil)
    completion(nil)
  })
  controller.addAction(UIAlertAction(title: "确定", style: .default) { action in
    controller.dismiss(animated: true, completion: nil)
    completion(controller.textFields?[0].text ?? "")
  })
  controller.addTextField { textField in
    if let value = text {
      textField.text = value
    }
    if let placeholder = placeholder {
      textField.placeholder = placeholder
    }
  }
  UIViewController.topViewController?.present(controller, animated: true, completion: nil)
}

public func toast(_ message: String?, in view: UIView? = nil, duration: TimeInterval? = nil, position: ToastPosition? = nil, title: String? = nil, image: UIImage? = nil, style: ToastStyle? = nil, completion: ((_ didTap: Bool) -> Void)? = nil) {
  guard let view = view ?? UIApplication.shared.keyWindow else {
    return
  }
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
