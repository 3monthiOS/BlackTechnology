//
//  PhotoBrowser+CropperViewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import UIKit
import Swiften

extension PhotoBrowser {
    
    class CropperViewController: UIViewController, UIActionSheetDelegate {
        
        var image: UIImage!
        var options: PhotoBrowserOptions!
//        var isPhotoEdit = false
        var isTakerview = false
        weak var delegate: PhotoCropperDelegate!
        
        private var cropView: PECropView!
        
        private var confirmButton: UIBarButtonItem!
        private var resetButton: UIBarButtonItem!
        private var constrainButton: UIBarButtonItem!
        
        // MARK: - UIViewController
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            automaticallyAdjustsScrollViewInsets = false
            title = "裁剪"
            
            view.backgroundColor = UIColor.blackColor()
            view.clipsToBounds = true
            
            // Init Crop View
            cropView = PECropView(frame: view.bounds)
            cropView.image = image
            view.addSubview(cropView)
            
//            if !isPhotoEdit {
//                // Init navbar
//                createBarButtonItemAtPosition(.Right, text: "取消", action: #selector(CropperViewController.handleCancelButtonTap(_:)))
//            }
            // Init Toolbar
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            confirmButton = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(CropperViewController.handleConfirmButtonTap(_:)))
            resetButton = UIBarButtonItem(title: "重置", style: .Plain, target: self, action: #selector(CropperViewController.handleResetButtonTap(_:)))
            if options.keepingCropAspectRatio {
                toolbarItems = [resetButton, flexibleSpace, confirmButton]
            } else {
                constrainButton = UIBarButtonItem(title: "尺寸", style: .Plain, target: self, action: #selector(CropperViewController.handleConstrainButtonTap(_:)))
                toolbarItems = [resetButton, flexibleSpace, constrainButton, flexibleSpace, confirmButton]
            }
        }
        
        override func viewWillAppear(animated: Bool) {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide)
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.setToolbarHidden(false, animated: true)
        }
        
        override func prefersStatusBarHidden()->Bool {
            
            return true
            
        }
        override func viewDidAppear(animated: Bool) {
            if options.cropAspectRatio > 0 {
                cropView.cropAspectRatio = options.cropAspectRatio
            }
            cropView.keepingCropAspectRatio = options.keepingCropAspectRatio
        }
        
        override func viewWillDisappear(animated: Bool) {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
        }
        
        override func shouldAutorotate() -> Bool {
            return options.shouldSupportLandscape
        }
        
        override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
            return options.shouldSupportLandscape ? .All : .Portrait
        }
        
        // MARK: - Layout
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            cropView.frame = view.bounds
        }
        
        // MARK: - Actions
        
        func handleCancelButtonTap(sender: UIButton) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        func handleConfirmButtonTap(sender: UIButton) {
            let image = cropView.croppedImage
            image.contentType = .JPEG
            delegate?.photoCropper(self, didFinishCroppingImage: image, transform: cropView.rotation, cropRect: cropView.zoomedCropRect)
            closeViewControllerJumpChatcontroller(false)
        }
        func closeViewControllerJumpChatcontroller(animated: Bool) {
            if let controller = navigationController where controller.viewControllers.count > 1 {
                if isTakerview {
                    dismissViewControllerAnimated(animated, completion: nil)
                }else{
                    let vc = controller.viewControllers[controller.viewControllers.count-3]
                    controller.popToViewController(vc, animated: false)
                }
            } else {
                dismissViewControllerAnimated(animated, completion: nil)
            }
//            toast("发送成功")
        }
        func handleResetButtonTap(sender: UIButton) {
            self.cropView.resetCropRectAnimated(true)
            if options.cropAspectRatio > 0 {
                self.cropView.cropAspectRatio = options.cropAspectRatio
            }
        }
        
        func handleConstrainButtonTap(sender: UIButton) {
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle:"取消", destructiveButtonTitle: nil, otherButtonTitles:"原图","1 x 1","3 x 2","4 x 3","16 x 9", "自定义")
            actionSheet.showInView(view)
        }
        
        func localizedString(key: String, _ comment: String!) -> String {
            return PECropViewController.bundle().localizedStringForKey(key, value: comment, table: "Localizable")
        }
        
        // MARK: - UIActionSheetDelegate
        
        func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
            guard buttonIndex != actionSheet.cancelButtonIndex else { return }
            
            switch buttonIndex {
            case 1: // Original
                var cropRect = self.cropView.cropRect
                let size = self.cropView.image.size
                let width = size.width
                let height = size.height
                var ratio: CGFloat
                if width < height {
                    ratio = width / height
                    cropRect.size = CGSizeMake(CGRectGetHeight(cropRect) * ratio, CGRectGetHeight(cropRect))
                } else {
                    ratio = height / width
                    cropRect.size = CGSizeMake(CGRectGetWidth(cropRect), CGRectGetWidth(cropRect) * ratio)
                }
                self.cropView.cropRect = cropRect
            case 2: // Square
                self.cropView.cropAspectRatio = 1
            case 3: // 3 x 2
                self.cropView.cropAspectRatio = 3 / 2
            case 4: // 4 x 3
                self.cropView.cropAspectRatio = 4 / 3
                //                let ratio: CGFloat = 3 / 4
                //                var cropRect = self.cropView.cropRect
                //                let width = CGRectGetWidth(cropRect)
                //                cropRect.size = CGSizeMake(width, width * ratio)
            //                self.cropView.cropRect = cropRect
            case 5: // 16 x 9
                self.cropView.cropAspectRatio = 16 / 9
                //                let ratio: CGFloat = 9 / 16
                //                var cropRect = self.cropView.cropRect
                //                let width = CGRectGetWidth(cropRect)
                //                cropRect.size = CGSizeMake(width, width * ratio)
            //                self.cropView.cropRect = cropRect
            case 6: // Exchange
                self.cropView.cropAspectRatio = 1 / self.cropView.cropAspectRatio
            default: break
            }
        }
    }
}
