//
//  PhotoBrowser+TakerViewController.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/4.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Swiften

extension PhotoBrowser {

	class TakerViewController: APPviewcontroller, PhotoBrowserViewDelegate, PhotoCropperDelegate {

		var options: PhotoBrowserOptions!
		var backgroundColor = UIColor.blackColor()

		private let captureSession = AVCaptureSession()
		private let stillImageOutput = AVCaptureStillImageOutput()
		private var input: AVCaptureDeviceInput!

		weak var delegate: PhotoBrowserDelegate!

		private var previewLayer: AVCaptureVideoPreviewLayer!
		private var cameraPreview: UIView!
		private var stopButton: UIButton!
		private var takeButton: UIButton!
		private var FlipButton: UIButton!
		private var photoView: View!
        private var focusCursor: UIImageView!

		private var confirmButton: UIBarButtonItem!
		private var retakeButton: UIBarButtonItem!
		private var cropButton: UIBarButtonItem!

		private var viewInited = false
		private var isEditing = false
		private var buttonsHidden = false
		private var isUsingFrontFacingCameraBack = true
		private var isUseFlip = true
		private let buttonSize = CGSize(width: 60, height: 44)

		// MARK: - UIViewControll

        override func prefersStatusBarHidden()->Bool {
            
            return true
            
        }
		override func viewDidLoad() {
			super.viewDidLoad()

			title = "相机"

			automaticallyAdjustsScrollViewInsets = false
			view.backgroundColor = backgroundColor
		}

		override func viewWillAppear(animated: Bool) {
			let authStatus = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
			switch (authStatus) {
			case .NotDetermined:
				AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { (granted) -> Void in
					async {
						if granted {
							self.initView()
						} else {
							self.dismissViewControllerAnimated(true, completion: nil)
							toast("请在设置中打开访问相机的权限")
						}
					}
				}
			case .Restricted, .Denied:
				self.dismissViewControllerAnimated(true, completion: nil)
				toast("请在设置中打开访问相机的权限")
			default:
				initView()
			}
		}

		func initView() {
			let rect = view.bounds

			photoView = View(frame: rect)
			photoView.delegate = self
			view.addSubview(photoView)

			cameraPreview = UIView(frame: rect)
			cameraPreview.backgroundColor = backgroundColor
			self.view.addSubview(self.cameraPreview)

			stopButton = UIButton()
			stopButton.setTitle("取消", forState: .Normal)
			stopButton.setTitleColor(rgb(128, 128, 128), forState: .Highlighted)
			stopButton.addTarget(self, action: #selector(TakerViewController.handleStopButtonTap(_:)), forControlEvents: .TouchUpInside)

			takeButton = UIButton()
			takeButton.setImage(UIImage(named: "Photo_1"), forState: .Normal)
			takeButton.setImage(UIImage(named: "Photo_2"), forState: .Highlighted)
			takeButton.clipsToBounds = true
			takeButton.layer.cornerRadius = 32
			takeButton.addTarget(self, action: #selector(TakerViewController.handleTakeButtonTap(_:)), forControlEvents: .TouchUpInside)

            focusCursor = UIImageView()
			focusCursor.layer.masksToBounds = true
            focusCursor.layer.borderColor = rgb(254, 209, 5).CGColor
            focusCursor.layer.borderWidth = 1
			focusCursor.alpha = 0

			FlipButton = UIButton()
			FlipButton.setImage(UIImage(named: "button_反向2"), forState: .Normal)
			FlipButton.setImage(UIImage(named: "button_反向1"), forState: .Highlighted)
			FlipButton.addTarget(self, action: #selector(TakerViewController.switchCameraSegmentedControlClick), forControlEvents: .TouchUpInside)

			initCaptureSession()

			// Init navbar
            createBarButtonItemAtPosition(.Right, Title: "取消", normalImage: UIImage(), highlightImage: UIImage(), action: #selector(TakerViewController.handleCancelButtonTap(_:)))

			// Init Toolbar
			let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
			confirmButton = UIBarButtonItem(title: "选取", style: .Plain, target: self, action: #selector(TakerViewController.handleConfirmButtonTap(_:)))
			retakeButton = UIBarButtonItem(title: "重拍", style: .Plain, target: self, action: #selector(TakerViewController.handleRetakeButtonTap(_:)))
			cropButton = UIBarButtonItem(title: "裁剪", style: .Plain, target: self, action: #selector(TakerViewController.handleCropButtonTap(_:)))
			toolbarItems = [retakeButton, flexibleSpace, cropButton, flexibleSpace, confirmButton]

			viewInited = true
		}

		// MARK: - Layout

		override func viewWillLayoutSubviews() {
			super.viewWillLayoutSubviews()
			if viewInited {
				adjustFrames()
			}
		}

		func adjustFrames() {
			let rect = view.bounds

			if let _ = cameraPreview.superview {
				cameraPreview.frame = rect
				stopButton.frame = CGRect(origin: CGPoint(x: 10, y: rect.size.height - buttonSize.height - 30), size: buttonSize)
				takeButton.frame = CGRect(x: (rect.size.width - 64) * 0.5, y: rect.size.height - 64 - 20, width: 64, height: 64)
				FlipButton.frame = CGRect(x: (rect.size.width + 161) * 0.5, y: rect.size.height - 64 - 20, width: 84, height: 64)
				focusCursor.frame =  CGRect(x: 0, y: 0, width: 90, height: 90)
			}

			if let _ = photoView.superview {
				photoView.frame = rect
			}
		}

		// MARK: Capture Session

		func initCaptureSession() {
			setFullscreen(true, animated: true)
			async({
				var devices = AVCaptureDevice.devices()
				if self.isUsingFrontFacingCameraBack {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
				} else {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Front }
				}
				if let captureDevice = devices.first as? AVCaptureDevice {

					do {
						self.input = try AVCaptureDeviceInput(device: captureDevice)
					} catch let error as NSError {
						Log.error(error.localizedDescription)
						self.view.makeToast(error.localizedDescription)
						return false
					}
					self.initUIdata()
					return true
				}
				return false
			}) {
				guard let success = $0 as? Bool where success else {
					toast("未找到可用设备")
					self.dismissViewControllerAnimated(true, completion: nil)
					return
				}
                self.cameraPreview.layer.addSublayer(self.previewLayer)
                self.cameraPreview.addSubview(self.focusCursor)
                self.cameraPreview.addSubview(self.stopButton)
				self.cameraPreview.addSubview(self.takeButton)
				self.cameraPreview.addSubview(self.FlipButton)
				
				self.addGenstureRecognizer()
				self.captureSession.startRunning()
			}
		}

		func stopCaptureSessioin() {
			self.captureSession.stopRunning()
			self.captureSession.removeInput(self.input)
			self.captureSession.removeOutput(self.stillImageOutput)
			self.cameraPreview.removeFromSuperview()
			self.previewLayer.removeFromSuperlayer()
			self.stopButton.removeFromSuperview()
			self.takeButton.removeFromSuperview()
			self.FlipButton.removeFromSuperview()
			self.focusCursor.removeFromSuperview()
			self.setFullscreen(false, animated: true)
		}
		func initUIdata() {
			let rect = view.bounds
			if isUseFlip {
				self.captureSession.addInput(self.input)
			}
			self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto

			self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			if self.captureSession.canAddOutput(self.stillImageOutput) {
				self.captureSession.addOutput(self.stillImageOutput)
			}

			self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
			if let previewLayer = self.previewLayer {
				previewLayer.bounds = rect
				previewLayer.position = CGPointMake(self.view.bounds.midX, self.view.bounds.midY)
				previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
			}
			self.flashButtonClick()
		}
		// MARK: Camera Button Handler

		func handleStopButtonTap(sender: UIButton) {
			self.stopCaptureSessioin()
			if photoView.model == nil {
				self.dismissViewControllerAnimated(true, completion: nil)
			}
		}

		func handleTakeButtonTap(sender: UIButton) {
			guard captureSession.running else { return }
			self.stopButton.removeFromSuperview()
			self.takeButton.removeFromSuperview()
			self.FlipButton.removeFromSuperview()
			self.focusCursor.removeFromSuperview()
			if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
				stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
					(imageDataSampleBuffer, error) -> Void in
					let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
					let img = UIImage(data: imageData)
					img?.contentType = .JPEG

					self.stopCaptureSessioin()

					self.photoView.setup(.Image(image: img!))
					self.photoView.setNeedsLayout()
					self.isEditing = true
				}
			}
		}

		// MARK: Navbar Button Handler

		func handleCancelButtonTap(sender: UIButton) {
			dismissViewControllerAnimated(true, completion: nil)
		}

		// MARK: Toolbar Button Handler

		func handleConfirmButtonTap(sender: UIButton) {
			close()
		}

		func handleRetakeButtonTap(sender: UIButton) {
			view.addSubview(cameraPreview)
			initCaptureSession()
		}

		func handleCropButtonTap(sender: UIButton) {
			photoView.loadOriginImage {
				guard let image = $0 else { return }
				// LDPhotoBrowser.showPhotoCropper(self, image: image)
				let controller = CropperViewController()
				controller.delegate = self
				controller.options = self.options
				controller.image = image
                controller.isTakerview = true
				self.navigationController?.showViewController(controller, sender: nil)
			}
		}

		func close() {
			let model: Model = photoView.model
			switch model {
			case .Image(let image):
				if options.requireCroppedImage {
					photoView.loadOriginImage {
						guard let image = $0 else { return }
						let controller = CropperViewController()
						controller.delegate = self
						controller.options = self.options
						controller.image = image
						self.navigationController?.showViewController(controller, sender: nil)
					}
					return
				}

				delegate.photoBrowser(self, didSelect: .Single(-1, .Image(image: image)))
			default: break
			}

			self.dismissViewControllerAnimated(true, completion: nil)
		}

		// MARK: - LDPhotoCropperDelegate

		func photoCropper(photoCropper: PhotoBrowser.CropperViewController, didFinishCroppingImage croppedImage: UIImage, transform: CGAffineTransform, cropRect: CGRect) {
			guard let delegate = delegate else { return }
			delegate.photoBrowser(self, didSelect: .Single(-1, .Image(image: croppedImage)))
		}

		// MARK: - LDPhotoBrowserViewDelegate

		func photoViewDidSingleTap(view: PhotoBrowser.View) {
			if isEditing {
				setFullscreen(!fullscreen, animated: true)
			}
		}

		func photoViewDidUpdate(view: PhotoBrowser.View) {
			// nothing
		}
		// MARK: - 设置闪光灯
		func flashButtonClick() {
			let devices = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
			do {
				try devices.lockForConfiguration()
			} catch _ {
				toast("锁定异常")
			}
			if devices.hasFlash {
				if isUsingFrontFacingCameraBack {
					devices.flashMode = AVCaptureFlashMode.Auto
				} else {
					devices.flashMode = AVCaptureFlashMode.Off
				}
			}
			devices.unlockForConfiguration()
		}
		// MARK: - 设置镜头翻转
		func switchCameraSegmentedControlClick() {
			isUseFlip = false
			async({ () -> AnyObject! in
				var devices = AVCaptureDevice.devices()
				if self.isUsingFrontFacingCameraBack {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Front }
				} else {
					devices = AVCaptureDevice.devices().filter { $0.hasMediaType(AVMediaTypeVideo) && $0.position == AVCaptureDevicePosition.Back }
				}
                self.previewLayer.session.beginConfiguration()
				let input: AVCaptureInput?
				if let captureDevice = devices.first as? AVCaptureDevice {
					do {
						input = try AVCaptureDeviceInput(device: captureDevice)
					} catch let error as NSError {
						Log.error(error.localizedDescription)
						self.view.makeToast(error.localizedDescription)
						return false
					}
					for oldInput: AVCaptureInput in self.previewLayer.session.inputs as! [AVCaptureInput] {
						self.previewLayer.session.removeInput(oldInput)
					}
					self.previewLayer.session.addInput(input)
                    self.previewLayer.session.commitConfiguration()
					return true
				}
				return false
			}) { (isok) in
				self.view.hideToastActivity()
				guard let success = isok as? Bool where success else {
					toast("旋转失败")
					return
				}
				self.isUsingFrontFacingCameraBack = !self.isUsingFrontFacingCameraBack
				self.flashButtonClick()
			}
		}

		func focusWithMode(focusMode: AVCaptureFocusMode, exposureMode: AVCaptureExposureMode, point: CGPoint) {
			let captureDevice = self.input.device
			do {
				try captureDevice.lockForConfiguration()
			} catch {
				Log.info("上锁失败")
			}
			if captureDevice.isFocusModeSupported(focusMode) {
				captureDevice.focusMode = AVCaptureFocusMode.AutoFocus
			}
			if captureDevice.focusPointOfInterestSupported {
				captureDevice.focusPointOfInterest = point
			}
			if captureDevice.isExposureModeSupported(exposureMode) {
				captureDevice.exposureMode = AVCaptureExposureMode.AutoExpose
			}
			if captureDevice.exposurePointOfInterestSupported {
				captureDevice.exposurePointOfInterest = point
			}
            captureDevice.unlockForConfiguration()
            
		}
		func addGenstureRecognizer() {
			let tap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
			self.cameraPreview.addGestureRecognizer(tap)
		}
		func setFocusCursorWithPoint(point: CGPoint) {
			self.focusCursor.center = point
			self.focusCursor.transform = CGAffineTransformMakeScale(1.5, 1.5)
			self.focusCursor.alpha = 1.0
			UIView.animateWithDuration(0.4, animations: {
				self.focusCursor.transform = CGAffineTransformIdentity
			}) { (isok) in
				if isok {
					self.focusCursor.alpha = 0
				}
			}
		}
		func tapScreen(tapGesture: UITapGestureRecognizer) {
			let point = tapGesture.locationInView(self.cameraPreview)
			let cameraPoint = self.previewLayer.captureDevicePointOfInterestForPoint(point)
			self.setFocusCursorWithPoint(point)
			self.focusWithMode(AVCaptureFocusMode.AutoFocus, exposureMode: AVCaptureExposureMode.AutoExpose, point: cameraPoint)
		}
	}

}
