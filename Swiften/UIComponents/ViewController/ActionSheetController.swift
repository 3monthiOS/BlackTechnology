//
//  ActionSheetController.swift
//  Swiften
//
//  Created by Cator Vee on 5/26/16.
//  Copyright © 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit

open class ActionSheetController: UIViewController {

    @IBOutlet open var popupView: UIView!
    var dismissButton: UIButton!

    open func presentOverViewController(_ viewController: UIViewController) {
        modalPresentationStyle = .overFullScreen
        view.backgroundColor = UIColor(rgba: 0x00000000)

        dismissButton = UIButton()
        dismissButton.addTarget(self, action: #selector(onDismiss(_:)), for: .touchUpInside)
        dismissButton.frame = view.bounds
        dismissButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(dismissButton, at: 0)

        popupView.alpha = 0
        viewController.present(self, animated: false) { [weak popupView, weak view] in
            guard let view = view, let popupView = popupView else { return }
            let originFrame = popupView.frame
            popupView.frame = CGRect(origin: CGPoint(x: 0, y: view.bounds.size.height), size: originFrame.size)
            UIView.animate(withDuration: 0.25, animations: {
                view.backgroundColor = UIColor(rgba: 0x00000066)
                popupView.alpha = 1
                popupView.frame = originFrame
            })
        }
    }

    func onDismiss(_ sender: UIButton) {
        self.dismissActionSheetController()
    }

    open func dismissActionSheetController(_ completion: (() -> Void)? = nil) {
        UIView.transition (with: self.popupView, duration: 0.25, options: .beginFromCurrentState, animations: {
            self.view.backgroundColor = UIColor(rgba: 0x00000000)
//            self.popupView.alpha = 0
            self.popupView.frame = CGRect(origin: CGPoint(x: 0, y: self.view.bounds.size.height), size: self.popupView.frame.size)
            }, completion: { (finished) in
            self.dismiss(animated: false, completion: completion)
        })
    }
}
