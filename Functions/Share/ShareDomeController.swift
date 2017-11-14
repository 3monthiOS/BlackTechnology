//
//  ShareDomeController.swift
//  App
//
//  Created by 红军张 on 2017/6/21.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class ShareDomeController: UIViewController {

    @IBOutlet weak var contenttext: UITextView!
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var labelSharetype: UILabel!
    @IBOutlet weak var textFild: UITextField!
    var shareData: ShareObject?
    
    //   模仿微博分享 的图片
    var ScreenshotsPictures: UIImage?
    var QrCodeImage: UIImage?
    var mergedImagesData: Data?
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareData = ShareObject()
        //友盟初始化
        SocialUtils.initSocial()
        
        let tag = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        tag.numberOfTapsRequired = 1
        /////设置允许交互属性
        photoImage.isUserInteractionEnabled = true
        photoImage.addGestureRecognizer(tag)
        
        let photo = SystemPhotoAlbum()
        photo.albumDeleagte = self
        
        // 监听截屏的通知
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userDidTakeScreenshot), name: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil)
    }
    ///////////模仿微博截屏分享、、、、、
    func MergedImages(image0: UIImage,image1: UIImage) -> UIImage? {
        let size = CGSize(width: App_width, height: image0.size.height + image1.size.height)
        
        UIGraphicsBeginImageContext(size)
        image0.draw(in: CGRect(x: 0, y: 0, width: image0.size.width, height: image0.size.height))
        image1.draw(in: CGRect(x: 0, y: image0.size.height, width: image1.size.width, height: image1.size.height))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    func userDidTakeScreenshot(){
        Log.info("检测到截屏")
        self.ScreenshotsPictures = self.screenSnapshot(save: false)
        self.QrCodeImage = QRcode()
        if let QR = self.QrCodeImage {
            mergedImagesData = MergedImages(image0: self.ScreenshotsPictures!, image1: QR)?.data as Data?
        }
    }
    func QRcode() -> UIImage {
        let  ciimg = generateQRCodeImage("http://www.baidu.com")
        return resizeCode(image: ciimg,size: CGSize(width: 200, height: 200))
    }
    
    func generateQRCodeImage(_ code: String)-> CIImage {
        let data = code.data(using: String.Encoding.utf8)
        let filter: CIFilter? = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        return filter!.outputImage!
    }
    
    func resizeCode(image: CIImage , size: CGSize)-> UIImage {
        let extent = image.extent
        let scaleWidth: CGFloat = size.width / extent.width
        let scaleHeight: CGFloat = size.height / extent.height
        let width: size_t = size_t(extent.width * scaleWidth)
        let height: size_t = size_t(extent.height * scaleHeight)
        // 拿到 CIContext 将 CIImage 转化成CGImage
        let content: CIContext  = CIContext()
        let imageRef: CGImage = content.createCGImage(image, from: extent)!
        //  拿到 CGContext  将 CGImage 尺寸绘制成 需要尺寸
        let colorSpaceRef: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let contentRef: CGContext = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpaceRef, bitmapInfo: CGImageAlphaInfo.none.rawValue)!
        contentRef.interpolationQuality = .none
        contentRef.scaleBy(x: scaleWidth, y: scaleHeight)
        contentRef.draw(imageRef, in: extent)
        let imageRefResized: CGImage = contentRef.makeImage()!
        // 将 CGImage 转化成 UIImage
        return UIImage(cgImage: imageRefResized)
    }
    //////、、、、、、、、、、、、、、、、、
    func screenSnapshot(save: Bool) -> UIImage? {
        
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if save { UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil) }
        
        return image
    }
    
    func choseImage() {
        confirm("是否从相册选取图片。否，拍照选取", title: "图片来源") { (isok) in
            isok ? PhotoBrowser.showPhotoPicker(self as PhotoBrowserDelegate, withOptions: PhotoBrowserOptions.photoBrowserOptionsForSingleSelection()) : PhotoBrowser.showPhotoTaker(self as PhotoBrowserDelegate)
        }
    }
    
    @IBAction func btnClick() {
        if contenttext.text.isEmpty || (textFild.text?.isEmpty)!{alert("没有分享内容无法分享");return}
        // 确定分享类型 在赋值
        if (QrCodeImage != nil) {
            shareData?.img = mergedImagesData
        } else {
            shareData?.img = photoImage?.image?.data as Data?
        }
        shareData?.thumbnailImg = UIImage(named: "分享缩略图")?.data as Data? // 根据友盟api缩略图必填
        if !(labelSharetype.text?.isEmpty)! {
            shareData?.ContentObject = labelSharetype.text
        }
        shareData?.content = contenttext.text
        shareData?.title = textFild.text
        SocialUtils.showUI(Viewcontroller: self, contentObject: shareData!)
    }
    @IBAction func sharetypeclick(_ sender: Any) {
        let btn = sender as! UIButton
        switch btn.tag {
        case 10:
            self.labelSharetype.text = "Image"
        case 11:
            self.labelSharetype.text = "music"
        case 12:
            self.labelSharetype.text = "video"
        case 13:
            self.labelSharetype.text = "Emotion"
        case 14:
            self.labelSharetype.text = "webpage"
        case 15:
            self.labelSharetype.text = "Email"
        default:
            self.labelSharetype.text = "text"
        }
    }
}
extension ShareDomeController : UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        contenttext.text = ""
        return true
    }
}
extension ShareDomeController :UMSocialShareMenuViewDelegate {
    func umSocialShareMenuViewDidAppear() {
        Log.info("分享面板将要展示")
    }
    func umSocialShareMenuViewDidDisappear() {
        Log.info("分享面板将要消失")
    }
    func umSocialParentView(_ defaultSuperView: UIView!) -> UIView! {
        Log.info("切换 分享面板的 父view")
        return self.view
    }
}
extension ShareDomeController: SystemPhotoAlbumDelegate,PhotoBrowserDelegate,PhotoBrowserDataSource{
    func getImageSucessful(_ image: UIImage) {
        Log.info("有——图片\(image)")
        self.photoImage.image = image
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser.PreviewController, photoModelAtIndex index: Int) -> PhotoBrowser.Model {
        let url = getProjectJsonFile()[index]
        var img : UIImage?
        // 网络图片
        if !url.isEmpty{
            if let str = url.components(separatedBy: "/").last{
                locationfileiscache(str, complate: { (callback) in
                    if !callback.isEmpty{
                        guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: callback)) else {return}
                        img = UIImage(gifData: imageData)
                    }else{
                        img = UIImage(named: "Placeholder Image")!
                    }
                })
            }
        }
        // 本地图片
        var image = UIImage()
        let data = try? Data(contentsOf: URL(fileURLWithPath: url))
        if data == nil {
            image = UIImage(named: "Placeholder Image")!
        }else{
            image = UIImage(data: data!)!
        }
        if let img = img {
            return PhotoBrowser.Model.image(image: img)
        }
        return PhotoBrowser.Model.image(image: image)
    }
    
    func numberOfPhotosInPhotoBrowser(_ photoBrowser: PhotoBrowser.PreviewController) -> Int {
        return getProjectJsonFile().count
    }
    
    func photoBrowser(_ viewController: UIViewController, didSelect selection: PhotoBrowser.Selection) {
        selection.getImage { (image) in
            if image != nil {
                Log.info("有——图片")
                self.photoImage.image = image
            }else{
                Log.info("没有——图片")
            }
        }
    }

}
