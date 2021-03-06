//
//  PhotoBrowser+View.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/8/3.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import AlamofireImage
import MobileCoreServices
import Photos
import AssetsLibrary
//import Swiften

extension PhotoBrowser {
    
    class View: UIView, UIScrollViewDelegate, UIActionSheetDelegate {
        
        let minimumZoomScale: CGFloat = 1.0
        let maximumZoomScale: CGFloat = 4.0
        
        var buttonIndexSave = Int.max
        var buttonIndexOrigin = Int.max
        
        var placeholderImage: UIImage?
        
        var imageView: UIImageView!
        var scrollView: UIScrollView!
        
        fileprivate var indicatorView: UIActivityIndicatorView!
        
        var model: Model!
        
        var needsSetup = true
        var imageLoaded = false
        var originImageLoaded = false {
            didSet {
                delegate?.photoViewDidUpdate(self)
            }
        }
        fileprivate var actionSheetShowed = false
        
        weak var delegate: PhotoBrowserViewDelegate!
        
        // MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            // Init ScrollView
            scrollView = UIScrollView()
            scrollView.delegate = self
            scrollView.clipsToBounds = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            self.addSubview(scrollView)
            
            // Init ImageView
            imageView = UIImageView()
            imageView.isHidden = true
            scrollView.addSubview(imageView)
            
            // Init Gesture Recognizer
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(View.handleDoubleTap(_:)))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            doubleTapGestureRecognizer.numberOfTouchesRequired = 1
            self.addGestureRecognizer(doubleTapGestureRecognizer)
            
            let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(View.handleSingleTap(_:)))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            singleTapGestureRecognizer.numberOfTouchesRequired = 1
            self.addGestureRecognizer(singleTapGestureRecognizer)
            
            singleTapGestureRecognizer.require(toFail: doubleTapGestureRecognizer) //双击失败以后才会执行单击的操作
            
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(View.handleLongPress(_:)))
            self.addGestureRecognizer(longPressGestureRecognizer)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        deinit {
            imageView.af_cancelImageRequest()
        }
        
        // MARK: Setup
        
        func setup(_ model: Model) {
            needsSetup = false
            self.model = model
            switch model {
            case .urls(let url, let preview):
                originImageLoaded = (url == preview)
                loadImageWithUrl(preview)
            case .asset(let asset):
                originImageLoaded = false
                loadImageWithAsset(asset)
            case .image(let image):
                imageLoaded = true
                originImageLoaded = true
                imageView.image = image
                imageView.isHidden = false
            }
        }
        
        func reset() {
            needsSetup = true
            originImageLoaded = false
            imageLoaded = false
            model = nil
            imageView.image = nil
            inactivate()
        }
        
        func inactivate() {
            scrollView.setZoomScale(1.0, animated: true)
            adjustImageViewCenter()
        }
        // MARK: Load Image
        func loadImageWithAsset(_ asset: PHAsset) {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            let screenSize = UIScreen.main.bounds.size
            let size = CGSize(width: screenSize.width * SCREEN_SCALE, height: screenSize.height * SCREEN_SCALE)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: options) { (obj, info) -> Void in
                guard let image = obj else { return }
                
                let orientation = info?["PHImageFileOrientationKey"] as? Int ?? 0
                let himage = UIImage(cgImage: image.cgImage!, scale: SCREEN_SCALE, orientation: UIImageOrientation(rawValue: orientation)!)
                
                self.imageView.image = himage
                self.imageView.isHidden = false
                self.imageLoaded = true
                
                self.adjustFrames()
                
                if  let UTIKey = info?["PHImageFileUTIKey"] as? String {
                    if UTIKey == "com.compuserve.gif" {
                        self.loadOriginImage()
                    }
                }
            }
            
        }
        
        func loadImageWithUrl(_ url: String, completion: ((UIImage?) -> Void)? = nil) {
            self.indicatorStart()
            NetworkManager.defaultManager.request(url).responseData { (response :DataResponse<Data>) in
                switch response.result {
                case .success:
                    let image = UIImage(data: response.data!)
                    image?.contentType = UIImage.ContentType.contentType(mimeType: response.response?.mimeType)
//                    image.contentType = UIImage.ContentType.contentType(mimeType: response.response?.MIMEType)
                    if !self.originImageLoaded {
                        // 如果是动态GIF图，则预览图就是原图
                        self.originImageLoaded = (image?.classForCoder.description() == "_UIAnimatedImage")
                    }
                    self.imageView.image = image
                    self.imageView.isHidden = false
                    self.imageLoaded = true
                case .failure(let error):
                    if !self.originImageLoaded {
                        self.indicatorStop()
                        self.loadOriginImage(completion)
                        return
                    }
                    Log.error(error)
                }
                
                self.indicatorStop()
                
                self.adjustFrames()
                
                completion?(self.imageView.image)
                
                if !self.originImageLoaded {
                    guard let model = self.model else {return}
                    switch model {
                    case .urls(url: _, preview: _):
                        if Reachability.networkStatus != .reachableViaWiFi {
                            self.loadOriginImage()
                        }
                    default: break
                    }
                }

            }
//            NetworkManager.defaultManager.request(url).response { (response :DataResponse) in
//                            }
//            NetworkManager.sharedInstace.defaultManager.request(.GET, url).responseImage { (response: Alamofire.Response<AlamofireImage.Image, NSError>) in
//                
//                
//                
//                
//            }
        }
        
        func loadOriginImage(_ completion: ((UIImage?) -> Void)? = nil) {
            guard let model = self.model else {return}
            if !originImageLoaded {
                originImageLoaded = true
                switch model {
                case .urls(let url, _):
                    loadImageWithUrl(url) { completion?($0) }
                case .asset(let asset):
                    PHImageManager.default().requestImageData(for: asset, options: nil) { (data, dataUTI, orientation, info) -> Void in
                        if data != nil {
                            let contentType = UIImage.ContentType.contentTypeWithImageData(imageData: data! as NSData)
                            var image: UIImage?
                            switch contentType {
                            case .GIF: break
//                                image = UIImageWithAnimatedGIFData(data)
                            default:
                                image = UIImage(data: data!)
                            }
                            if image != nil {
                                image!.contentType = contentType
                                self.imageView.image = image
                            }
                            completion?(image)
                        } else {
                            completion?(self.imageView.image)
                        }
                    }
                case .image(let image):
                    completion?(image)
                }
            } else {
                completion?(imageView.image)
            }
        }
        
        fileprivate func indicatorStart() {
            indicatorStop()
            indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
            indicatorView.startAnimating()
            indicatorView.center = self.bounds.center
            self.addSubview(indicatorView)
        }
        
        fileprivate func indicatorStop() {
            if self.indicatorView != nil {
                self.indicatorView.stopAnimating()
                self.indicatorView.removeFromSuperview()
                self.indicatorView = nil
            }
        }
        
        // MARK: Layout
        
        override func layoutSubviews() {
            super.layoutSubviews()
            adjustFrames()
        }
        
//        private func adjustFrames() {
//            guard imageView.image != nil else { return }
//            
//            scrollView.frame = bounds
//            
//            let containerSize = scrollView.frame.size
//            let imageSize = imageView.image!.size
//            
//            var width = imageSize.width
//            var height = imageSize.height
//            
//            if width > containerSize.width {
//                height *= containerSize.width / width
//                width = containerSize.width
//            }
//            else if width<containerSize.width && width>containerSize.width*0.6
//            {
//                height *= containerSize.width / width
//                width = containerSize.width
//            }
//            if height > containerSize.height {
//                width *= containerSize.height / height
//                height = containerSize.height
//            }
//            
//            imageView.frame = CGRect(origin: CGPointZero, size: CGSize(width: width, height: height))
//            imageView.center = scrollView.frame.center
//            
//            let zoomScaleX = imageSize.width / containerSize.width
//            let zoomScaleY = imageSize.height / containerSize.height
//            
//            scrollView.minimumZoomScale = minimumZoomScale
//            scrollView.maximumZoomScale = max(zoomScaleX, zoomScaleY, maximumZoomScale)
//            scrollView.zoomScale = 1.0
//            scrollView.contentOffset = CGPointZero
//        }
        // MARK: Layout
        fileprivate func adjustFrames() {
            guard imageView.image != nil else {
                return
            }
            imageView.isHidden = false
            scrollView.frame = self.bounds
            
            let containerSize = self.scrollView.frame.size
            let imageSize = imageView.image!.size
            
            var width = imageSize.width
            var height = imageSize.height
            
            if width > containerSize.width {
                height *= containerSize.width / width
                width = containerSize.width
            } else if width < containerSize.width && width > containerSize.width * 0.6 {
                height *= containerSize.width / width
                width = containerSize.width
            }else if width < containerSize.width && width < containerSize.width * 0.6 {
                height *= containerSize.width / width
                width = containerSize.width
            }else if width == containerSize.width {// image不为 nil 此情况特殊  还不知道是因为什么
                height *= width / containerSize.width
                width = containerSize.width
            }
            if height > containerSize.height {
                width *= containerSize.height / height
                height = containerSize.height
            }
            
            imageView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
            imageView.center = CGPoint(x: scrollView.frame.center.x, y: scrollView.frame.center.y)
            
            let zoomScaleX = imageSize.width / containerSize.width
            let zoomScaleY = imageSize.height / containerSize.height
            
            scrollView.minimumZoomScale = minimumZoomScale
            scrollView.maximumZoomScale = max(zoomScaleX, zoomScaleY, maximumZoomScale)
            scrollView.zoomScale = 1.0
            scrollView.contentOffset = CGPoint.zero
        }

        // MARK: - Gesture Recognizer
        
        func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
            guard imageLoaded else {
                return
            }
            let touchPoint = recognizer.location(in: self)
            if scrollView.zoomScale <= 1.0 {
                let scaleX = touchPoint.x + self.scrollView.contentOffset.x
                let scaleY = touchPoint.y + self.scrollView.contentOffset.y
                scrollView.zoom(to: CGRect(x: scaleX - 10, y: scaleY - 10, width: 10, height: 10), animated: true)
            } else {
                scrollView.setZoomScale(1.0, animated: true)
            }
            adjustImageViewCenter()
        }
        func handleOnthecross(_ recognizer: UITapGestureRecognizer) {
            guard imageLoaded else {
                return
            }
        }
        func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
            if let delegate = delegate {
                delegate.photoViewDidSingleTap(self)
            }
        }
        
        func handleLongPress(_ recognizer: UITapGestureRecognizer) {
            guard !actionSheetShowed else { return }
            guard let model: Model = model else { return }
            actionSheetShowed = true
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
            var buttonIndex = 1
            switch model {
            case .urls(_, _), .image(_):
                actionSheet.addButton(withTitle: "保存图片")
                buttonIndexSave = buttonIndex
                buttonIndex += 1
            case .asset(_): break
            }
            if !originImageLoaded {
                actionSheet.addButton(withTitle: "显示原图")
                buttonIndexOrigin = buttonIndex
                buttonIndex += 1
            }
            if buttonIndex > 1 {
                actionSheet.show(in: self)
            }
        }
        
        // MARK: - Save Image
        
        func saveImage() {
            if let model: Model = model {
                switch model {
                case .urls(let url, _):
                    saveImageFromUrl(url)
                    return
                default: break
                }
            }
            
            if let image = imageView.image {
                //				UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
                if let data = image.data {
                    let library = ALAssetsLibrary()
                    library.writeImageData(toSavedPhotosAlbum: data as Data!, metadata: nil) { url, error in
                        if let err = error {
                            toast("图片保存失败")
                            Log.error(err)
                        } else {
                            toast("图片已保存")
                        }
                    }
                    return
                }
            }
            toast("图片保存失败")
        }
        
        func saveImageFromUrl(_ url: String) {
            NetworkManager.defaultManager.request(url).response { (DefaultDataResponse) -> Void in
                if DefaultDataResponse.error  == nil {
                    let library = ALAssetsLibrary()
                    library.writeImageData(toSavedPhotosAlbum: DefaultDataResponse.data, metadata: nil) { url, error in
                        if let err = error {
                            toast("图片保存失败")
                            Log.error(err)
                        } else {
                            toast("图片已保存")
                        }
                    }
                } else {
                    toast("图片保存失败")
                    Log.error(DefaultDataResponse.error)
                }

            }
//            NetworkManager.defaultManager.request(.GET, url).response { (request, response, data, error) -> Void in
//                           }
        }
        
        //		func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        //			if let err = error {
        //				self.makeToast(message: "图片保存失败")
        //				Log.debug(err)
        //			} else {
        //				self.makeToast(message: "图片已保存")
        //			}
        //		}
        
        // MARK: - UIActionSheetDelegate
        
        func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
            switch buttonIndex {
            case buttonIndexSave:
                loadOriginImage { _ in self.saveImage()
                }
            case buttonIndexOrigin:
                loadOriginImage()
            default:
                break
            }
        }
        
        func actionSheet(_ actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
            actionSheetShowed = false
        }
        
        // MARK: UIScrollViewDelegate
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
        
        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            adjustImageViewCenter()
        }
        
        func adjustImageViewCenter() {
            let size = scrollView.bounds.size
            let contentSize = scrollView.contentSize
            let offsetX = (size.width > contentSize.width ? size.width : contentSize.width) * 0.5
            let offsetY = (size.height > contentSize.height ? size.height : contentSize.height) * 0.5
            imageView.center =  CGPoint(x: offsetX, y: offsetY)
        }
        
    }
    
}
