//
//  uploadPicturesView.swift
//  App
//
//  Created by 红军张 on 2016/11/30.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
//import Swiften

class uploadPicturesView: APPviewcontroller {

    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var showImageview: UIImageView!
    @IBOutlet weak var PhotoAlbumBtn: UIButton!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    
    fileprivate var avatarKey = "key"
    fileprivate var avatarData : Data?
 
    override func setup() {
        super.setup()
        showImageview.contentMode = .scaleAspectFill
        showImageview.layer.masksToBounds = true
        contentView?.addSubview(text)
        contentView?.addSubview(cameraBtn)
        contentView?.addSubview(PhotoAlbumBtn)
        contentView?.addSubview(uploadBtn)
    }

    @IBAction func chouse(_ sender: AnyObject) {
        self.photobrowserAction(8)
    }
    @IBAction func camera(_ sender: AnyObject) {
        self.photobrowserAction(7)
    }
    
    @IBAction func uploadimage(_ sender: AnyObject) {
        if let data = avatarData {
            // 上传图片
            prompt("为了上传文件规范，请为上传文件重命名（加上文件.后缀扩展名），才能上传。", title: "上传文件", text: "", placeholder: "请输入上传文件名称去掉末尾空格") { (callback) in
                if let name = callback {
                    ALY?.uploadObjectAsync(fileName: name, data: data, callback: { [weak self](url) in
                        async({ 
                            self?.text.text = url
                            loader.removeLoader()
                        })
                        Log.info("上传成功，获取的链接：\(url)")
                        
                    })
                    loader = WavesLoader.showLoader(with: path())
                }
            }
        } else {
          alert("请选择上传的图片")
        }
        //  上传本地文件
//        locationfileiscache(fileName, complate: { (path) in // 根据文件名字找到文件路径 生成data
//            put.uploadingData = NSData(contentsOfFile: path)! as Data
//            uploadData(obj: put, fileName: fileName, callback: callback)
//        })
    }
    
    func writefile(){ // 先读取后写入 File
        let path: String = Bundle.main.path(forResource: "uploadPicturesTable", ofType: ".geojson")!
        let nsUrl = NSURL(fileURLWithPath: path)
        var jsonArray = [String: Any]()
        var urlArray = [String]()
        do {
            let data: Data = try Data(contentsOf: nsUrl as URL)
            jsonArray = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
            print("json: \(jsonArray)")
            urlArray = jsonArray["coordinates"] as! [String]
        }
        catch {
            Log.info("云相册读取文件失败")
        }

        //  写入
        urlArray.append("001")
        jsonArray["coordinates"] = urlArray
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            var da = NSMutableData()
            da = jsonData as! NSMutableData
            Log.info("写入地址： \(path) 写入数据 \(jsonArray)")
            if da.write(toFile: "uploadPicturesTable.geojson", atomically: true) {
                Log.info("写入成功")
            }
//            try! jsonData.write(to: nsUrl as URL, options: Data.WritingOptions.noFileProtection)
        }
        catch {
            Log.info("云相册写入文件失败")
        }
       
    }
    
    func saveUpdata(_ key: String,value: [String]){
        if !key.isEmpty{
            if !value.isEmpty{
                if session.object(forKey: key) != nil{
                    session.setObject(value as AnyObject, forKey: key)
                }else{
                    session.setObject(value as AnyObject, forKey: key)
                }
            }
        }
    }
    // MARK: Overwrite system methods.
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        enableInteractivePopGestureRecognizer = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        enableInteractivePopGestureRecognizer = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension uploadPicturesView: SystemPhotoAlbumDelegate,PhotoBrowserDelegate,PhotoBrowserDataSource{
    func photobrowserAction(_ index: Int) {
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
    
    func getImageSucessful(_ image: UIImage) {
        Log.info("有——图片")
//        let imageSize = CGSize(width: image.size.width,height: image.size.height)
//        let iamgeData = image.af_imageScaled(to: imageSize)
//        guard let
//            data = iamgeData.data,
//            let key = QNUtils.keyForImage(image)
//            else {
//                return
//        }
//        self.avatarData = data as Data
//        self.avatarKey = key
        showImageview.image = image
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser.PreviewController, photoModelAtIndex index: Int) -> PhotoBrowser.Model {
        let url = getProjectJsonFile()[index]
        var img : UIImage?
        // 网络图片
        if !url.isEmpty {
            if let str = url.components(separatedBy: "/").last{
                locationfileiscache(str, complate: { (callback) in
                    if !callback.isEmpty{
                        guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: callback)) else {return}
                        img = UIImage(gifData: imageData)
                    }else{
                        //                        Log.info("我没有找到：————————\(str)")
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
                if let image = image{
                    let imageSize = CGSize(width: image.size.width,height: image.size.height)
                    let iamgeData = image.af_imageScaled(to: imageSize)
//                    guard let
//                        data = iamgeData.data,
//                        let key = QNUtils.keyForImage(image)
//                        else {
//                            return
//                    }
//                    self.avatarData = data as Data
//                    self.avatarKey = key
                    self.showImageview.image = image
                }
            }else{
                Log.info("没有——图片")
            }
        }
    }
}

/**   七牛上传
 let token = QNUtils.generateToken()
 if let data = avatarData {
 let key = avatarKey
 QNUtils.putData(data, withKey: key, token: token, resourceType: .image) { (result) in
 switch result {
 case .success(let url, _, _):
 //更新用户表
 Log.error("上传成功\(url)")
 self.text.text = url
 self.imageUrlData.append(url)
 self.saveUpdata("funcationupdateimageUrlData", value: self.imageUrlData)
 
 case .failure( _):
 Log.error("上传头像失败")
 }
 }
 }

 var imageUrlData: [String] = []{
 willSet{
 if session.object(forKey: "funcationupdateimageUrlData") != nil{
 imageUrlData = session.object(forKey: "funcationupdateimageUrlData") as! [String]
 }else{
 imageUrlData = [""]
 imageUrlData = session.setObject(imageUrlData as AnyObject, forKey: "funcationupdateimageUrlData") as! [String]
 }
 }
 }
 
 */


