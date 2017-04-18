//
// Created by Cator Vee on 7/10/16.
// Copyright (c) 2016 Cator Vee. All rights reserved.
//

import Foundation
import UIKit

open class LoadingIndicator {
    fileprivate var count = 0
    fileprivate var view: UIView?

    open func startLoading() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        async {
            if self.count == 0 {
                if self.view == nil {
                    self.view = UIView(frame: window.bounds)
                } else {
                    self.view!.removeFromSuperview()
                }

                window.addSubview(self.view!)
            }
            self.count += 1
        }
    }

    open func stopLoading() {
        async {
            self.count -= 1
            if self.count <= 0 {
                self.count = 0
                guard let loadingView = self.view else {
                    return
                }
                loadingView.removeFromSuperview()
            }
        }
    }
}
