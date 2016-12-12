//
//  uploadPicturesView.swift
//  App
//
//  Created by 红军张 on 2016/11/30.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Swiften

class uploadPicturesView: UIViewController {

    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var showImageview: UIImageView!
    @IBOutlet weak var chouseBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    //
    private var avatarKey = "key"
    private var avatarData : NSData?
    var user: User?
    var imageUrlData: [String] = []{
        willSet{
            if session.object(forKey: "funcationupdateimageUrlData") != nil{
                imageUrlData = session.object(forKey: "funcationupdateimageUrlData") as! [String]
            }else{
                imageUrlData = [""]
                imageUrlData = session.setObject([""], forKey: "funcationupdateimageUrlData") as! [String]
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        showImageview.contentMode = .ScaleAspectFill
        showImageview.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    @IBAction func chouse(sender: AnyObject) {
        self.photobrowserAction(8)
    }
    @IBAction func camera(sender: AnyObject) {
        self.photobrowserAction(7)
    }
    
    @IBAction func uploadimage(sender: AnyObject) {
        let token = QNUtils.generateToken()
        if let data = avatarData {
            let key = avatarKey
            QNUtils.putData(data, withKey: key, token: token, resourceType: .Image) { (result) in
                switch result {
                case .Success(let url, _, _):
                    //更新用户表
                    Log.error("上传成功\(url)")
                    self.text.text = url
                    self.imageUrlData.append(url)
                    self.saveUpdata("funcationupdateimageUrlData", value: self.imageUrlData)
                case .Failure( _):
                    Log.error("上传头像失败")
                }
            }
        }
    }
    func saveUpdata(key: String,value: [String]){
        if !key.isEmpty{
            if !value.isEmpty{
                if session.object(forKey: key) != nil{
                    session.setObject(value, forKey: key)
                }else{
                    session.setObject(value, forKey: key)
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension uploadPicturesView: SystemPhotoAlbumDelegate,PhotoBrowserDelegate,PhotoBrowserDataSource{
    func photobrowserAction(index: Int) {
        let photo = SystemPhotoAlbum()
        photo.albumDeleagte = self
        switch index {
        case 8:
            PhotoBrowser.showPhotoPicker(self, withOptions: PhotoBrowserOptions.photoBrowserOptionsForSingleSelection())
        case 7:
            //打开相机
            PhotoBrowser.showPhotoTaker(self)
        default:
            break
        }
    }
    
    func getImageSucessful(image: UIImage) {
        Log.info("有——图片")
        let imageSize = CGSize(width: image.size.width,height: image.size.height)
        let iamgeData = image.af_imageScaledToSize(imageSize)
        guard let
            data = iamgeData.data,
            key = QNUtils.keyForImage(image)
            else {
                return
        }
        self.avatarData = data
        self.avatarKey = key
        showImageview.image = image
    }
    
    func photoBrowser(photoBrowser: PhotoBrowser.PreviewController, photoModelAtIndex index: Int) -> PhotoBrowser.Model {
        let url = imageUrlArray[index]
        var img : UIImage?
        // 网络图片
        if !url.isEmpty{
            if let str = url.componentsSeparatedByString("/").last{
                locationfileiscache(str, complate: { (callback) in
                    if !callback.isEmpty{
                        guard let imageData = NSData(contentsOfFile: callback) else {return}
                        img = UIImage.gifWithData(imageData)!
                    }else{
                        //                        Log.info("我没有找到：————————\(str)")
                        img = UIImage(named: "chat_image_load_failed")!
                    }
                })
            }
        }
        // 本地图片
        var image = UIImage()
        let data = NSData(contentsOfFile: url)
        if data == nil {
            image = UIImage(named: "chat_image_load_failed")!
        }else{
            image = UIImage(data: data!)!
        }
        if let img = img {
            return PhotoBrowser.Model.Image(image: img)
        }
        return PhotoBrowser.Model.Image(image: image)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: PhotoBrowser.PreviewController) -> Int {
        return imageUrlArray.count ?? 0
    }
    
    func photoBrowser(viewController: UIViewController, didSelect selection: PhotoBrowser.Selection) {
        selection.getImage { (image) in
            if image != nil {
                Log.info("有——图片")
                if let image = image{
                    let imageSize = CGSize(width: image.size.width,height: image.size.height)
                    let iamgeData = image.af_imageScaledToSize(imageSize)
                    guard let
                        data = iamgeData.data,
                        key = QNUtils.keyForImage(image)
                        else {
                            return
                    }
                    self.avatarData = data
                    self.avatarKey = key
                    self.showImageview.image = image
                }
            }else{
                Log.info("没有——图片")
            }
        }
    }
}




