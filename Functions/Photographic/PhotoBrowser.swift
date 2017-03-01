//
//  PhotoBrowser.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import Photos
import Swiften

class PhotoBrowser {
	static var defaultDelegate: DefaultDelegate!
	class DefaultDelegate: NSObject {
		let TakePhoto = "拍照"
		let PickPhoto = "相册"
//		let SearchPhoto = "网络搜图"

		weak var delegate: PhotoBrowserDelegate!
		var options: PhotoBrowserOptions
		var search: String?

		init(delegate: PhotoBrowserDelegate, options: PhotoBrowserOptions? = nil, search: String? = nil) {
			self.delegate = delegate
			self.options = options ?? PhotoBrowserOptions.photoBrowserOptionsForSingleSelection()
			self.search = search
		}

		func actionHandler(action: UIAlertAction) {
			switch action.title! {
			case TakePhoto:
				PhotoBrowser.showPhotoTaker(delegate, withOptions: options)
			case PickPhoto:
				PhotoBrowser.showPhotoPicker(delegate, withOptions: options)
//			case SearchPhoto: break
//				PhotoBrowser.showPhotoSearcher(delegate, withOptions: options, search: search)
			default: break
			}
			defaultDelegate = nil
		}
	}
// MARK: 途径
	static func showActionSheet(delegate: PhotoBrowserDelegate, withOptions options: PhotoBrowserOptions? = nil, search: String? = nil, title: String = "使用以下应用") {
		defaultDelegate = DefaultDelegate(delegate: delegate, options: options, search: search)

		let actioinSheet = UIAlertController(title: title,
			message: nil,
			preferredStyle: UIAlertControllerStyle.ActionSheet)

		let action1 = UIAlertAction(title: defaultDelegate.TakePhoto, style: .Default, handler: defaultDelegate.actionHandler)
		let action2 = UIAlertAction(title: defaultDelegate.PickPhoto, style: .Default, handler: defaultDelegate.actionHandler)
//		let action3 = UIAlertAction(title: defaultDelegate.SearchPhoto, style: .Default, handler: defaultDelegate.actionHandler)
		actioinSheet.addAction(action1)
		actioinSheet.addAction(action2)
//		actioinSheet.addAction(action3)

		let cancleAction = UIAlertAction(title: getLocString("cancel"), style: .Destructive, handler: nil)
		actioinSheet.addAction(cancleAction)
		UIViewController.topViewController!.presentViewController(actioinSheet, animated: true, completion: nil)
		actioinSheet.view.tintColor = UIColor.darkGrayColor()
	}
// MARK: PhotoBrowser Action
    static func showPhotoPreviewer(delegate: protocol<PhotoBrowserDelegate, PhotoBrowserDataSource>! = nil, options: PhotoBrowserOptions? = nil, currentIndex: Int = 0,isPhotoAlbum: Bool) {
		let controller = PreviewController(delegate: delegate, options: options ?? PhotoBrowserOptions(), currentIndex: currentIndex)
        controller.hidesBottomBarWhenPushed = true
		controller.modalPresentationStyle = .OverFullScreen
        controller.isphotoAlbum = isPhotoAlbum
        UIViewController.showViewController(controller, animated: true)
	}

	static func showPhotoPicker(delegate: PhotoBrowserDelegate!, withOptions options: PhotoBrowserOptions? = nil) {
		requestAuthorizationForPhotoLibrary { // 查看手机相册所有照片  原图 选取 裁剪
			let controller: PickerViewController
			controller = PickerViewController(delegate: delegate, options: options ?? PhotoBrowserOptions.photoBrowserOptionsForSingleSelection())
			controller.modalPresentationStyle = .OverFullScreen
			UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
		}
	}

	static func showPhotoCropper(delegate: PhotoCropperDelegate, withOptions options: PhotoBrowserOptions? = nil, image: UIImage) { // 所给图片  编辑 裁剪 设定比例
		let controller = CropperViewController()
		controller.modalPresentationStyle = .OverFullScreen
		controller.delegate = delegate
		controller.image = image
		controller.options = options ?? PhotoBrowserOptions.photoBrowserOptionsForSingleSelection()
		UIViewController.topViewController?.presentViewController(controller, animated: true, completion: nil)
	}

	static func showPhotoTaker(delegate: PhotoBrowserDelegate, withOptions options: PhotoBrowserOptions? = nil) {
		requestAccessForMediaType(AVMediaTypeVideo) { //开启相机 拍照
			let controller = TakerViewController()
			controller.delegate = delegate
			controller.options = options ?? PhotoBrowserOptions.photoBrowserOptionsForSingleSelection()
			showNavigationController(controller)
		}
	}
	static private func showNavigationController(viewController: UIViewController) {
		let navigationController = UINavigationController(rootViewController: viewController)
		navigationController.modalPresentationStyle = .OverFullScreen
		UIViewController.topViewController?.presentViewController(navigationController, animated: true, completion: nil)
	}
// MARK: 授权
	static func requestAccessForMediaType(mediaType: String, completion: (() -> Void)?) {
		let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
		switch (authStatus) {
		case .NotDetermined:
			AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) -> Void in
                
        
				async {
					if granted {
						completion?()
					} else {
						toast("请在设置中打开访问相机的权限")
					}
				}
			}
		case .Restricted, .Denied:
			toast("请在设置中打开访问相机的权限")
		default:
			completion?()
		}
	}

	static func requestAuthorizationForPhotoLibrary(completion: (() -> Void)?) {
		PHPhotoLibrary.requestAuthorization { (status) -> Void in
			async {
				if status == .Denied || status == .Restricted {
					toast("请在设置中打开访问相片的权限")
				} else {
					completion?()
				}
			}
		}
	}

}
