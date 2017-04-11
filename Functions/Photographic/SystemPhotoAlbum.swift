//
//  SystemPhotoAlbum.swift
//  HaoFangZi
//
//  Created by 红军张 on 16/7/15.
//  Copyright © 2016年 侯伟. All rights reserved.
//

import Foundation
import UIKit
import Swiften

protocol SystemPhotoAlbumDelegate {
    func getImageSucessful(_ image: UIImage)
}

class SystemPhotoAlbum: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var choseImage: UIImage?
    var isphotocall = true
    var albumDeleagte: SystemPhotoAlbumDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if isphotocall {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                allowsEditing = false
                sourceType = .camera
            } else {
                alert("未发现相机")
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            allowsEditing = true
            sourceType = .photoLibrary
        }
        delegate = self
    }

    // cancel后执行的方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    // 拍照完了会调用
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String:AnyObject]?) {
        print("拍照完毕")
        choseImage = image
        sendImageData()
        picker.dismiss(animated: true, completion: nil)
    }

    // 选择照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        // TODO: 照片选择模式不科学
        let key = allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage
        guard let image = info[key] as? UIImage else {
            alert("获取照片失败")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        choseImage = image
        sendImageData()
        picker.dismiss(animated: true, completion: nil)
    }

    func sendImageData() {
        if let image = self.choseImage {
            self.albumDeleagte?.getImageSucessful(image)
        }
    }

}

