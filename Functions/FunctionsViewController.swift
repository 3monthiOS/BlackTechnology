//
//  FunctionsViewController.swift
//  App
//
//  Created by 红军张 on 16/9/13.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import Swiften
import Alamofire
import AlamofireImage
import AlamofireObjectMapper

class FunctionsViewController: APPviewcontroller {
    
    weak var collectionView: CollectionMjResh!
    var collectionfoot: CollectionReusableViewFooter!
    var collectionHeader: UICollectionReusableView!
    var functionTitleData = ["渐变","简单滤镜","复杂滤镜1","地图","听歌","录音","看视频","拍照","相册","六","上传图片","云相册","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let box = QNUtils.getaccesskey()
        let headers = [
            "Authorization": "QBox \(box)",
            "Content-Type": "application/x-www-form-urlencoded",
        ]
        Log.info("+++++++++++++____________\(headers["Authorization"])")
        //http://rsf.qbox.me/list?bucket=zhj1214
        let bucket = "zhj1214"
        Alamofire.request(.POST, "http://rsf.qbox.me/list?", parameters: ["bucket":bucket], encoding: .URL, headers: headers).responseJSON { (response) in
            if response.result.isSuccess{
                Log.info("成功----------\(response.response)----\(response.response?.allHeaderFields)-\(response.data)-\(response.result)-\(response.debugDescription)-\(response.description)")
            }else{
                Log.info("失败------\(response.result.error)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.title = "功能列表"
      self.navigationController?.navigationBar.translucent = false
        initcollectionMjrefresh()
        initCollectionview()
        initData()
    }
    func initcollectionMjrefresh(){
        collectionView.noDataNotice = "无数据可加载"
        collectionView.refreshDelegate = self
        collectionView.configRefreshable(headerEnabled: true, footerEnabled: true)
//        collectionView.refreshData()
    }
    func initCollectionview(){
        self.view.backgroundColor = rgb(242,245,249)
      
        //注册一个cell
        collectionView.registerNib(UINib(nibName: "QdanCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.registerNib(UINib(nibName: "QdanCollectionViewzeroCell",bundle: nil), forCellWithReuseIdentifier: "cell0")
        
        //注册一个headView
        collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        collectionView.registerNib(UINib(nibName: "CollectionReusableViewHeadre",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")

//        layout.headerReferenceSize = CGSizeZero //CGSizeMake(App_width,44)
//        layout.footerReferenceSize = CGSizeZero //CGSizeMake(App_width,80)
    }
    func initData(){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
}
    //Mark: ------ UICollectionViewDataSource
extension FunctionsViewController: UICollectionViewDataSource{
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrlArray.count
    }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! QdanCollectionViewCell
    cell.bindData(imageUrlArray,functionTitle: functionTitleData,atIndex :indexPath)
    return cell
  }
}

 //Mark: ------ UICollectionViewDelegate
extension FunctionsViewController: UICollectionViewDelegate{
  //返回自定义HeadView或者FootView，我这里以headview为例
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
    if kind == UICollectionElementKindSectionHeader {
      collectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", forIndexPath: indexPath)
      collectionHeader.backgroundColor = UIColor.clearColor()
      return collectionHeader
    }else if kind == UICollectionElementKindSectionFooter{
      collectionfoot = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footerView", forIndexPath: indexPath) as? CollectionReusableViewFooter
      if collectionfoot == nil{
        collectionfoot = NSBundle.mainBundle().loadNibNamed("CollectionReusableViewFooter", owner: nil, options: nil)!.first as? CollectionReusableViewFooter
      }
      collectionfoot.backgroundColor = UIColor.clearColor()
    }
    return collectionfoot
  }
  //点击
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
    switch indexPath.item {
    case 0:
      self.performSegueWithIdentifier("gradient", sender: nil)
    case 1:
      self.performSegueWithIdentifier("filter", sender: nil)
    case 2:
      self.performSegueWithIdentifier("complexFilter", sender: nil)
    case 3:
        let baidu = BaiduMapViewController()
        baidu.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(baidu, animated: true)
    case 10:
        let upload = uploadPicturesView()
        upload.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(upload, animated: true)
    case 11:
        let upload = photoAlbumViewController()
        upload.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(upload, animated: true)
    case 7:
        photobrowserAction(indexPath)
    case 8:
        photobrowserAction(indexPath)
    default:
      break
        }
    }
}
 //Mark: ------ UICollectionViewDelegateFlowLayout
extension FunctionsViewController: UICollectionViewDelegateFlowLayout{
  //返回cell 上下左右的间距
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    return UIEdgeInsetsMake(8, 12, 8, 12)
  }
  
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
    let cellwidth = (App_width - 24 - 24)/4
    let cellHight = (App_width - 24 - 24)/4 * 33/28 - 2
    return CGSize(width: cellwidth,height: cellHight)
  }
}
 //Mark: ------ 刷新代理
extension FunctionsViewController: MJCollectionViewRefreshDelegate{
  func Collection(Collection: CollectionMjResh, refreshDataWithType refreshType: CollectionMjResh.RefreshType) {
    Collection.endRefreshing(num: 11, count: 3, NoDataNoticeViewKinds: 0)
  }
}
//相机 ， 相册 
extension FunctionsViewController: SystemPhotoAlbumDelegate,PhotoBrowserDelegate,PhotoBrowserDataSource{
    func photobrowserAction(indexPath: NSIndexPath) {
        let photo = SystemPhotoAlbum()
        photo.albumDeleagte = self
        switch indexPath.row {
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
            Log.info("有——图片\(image)")
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
            }else{
                Log.info("没有——图片")
            }
        }
    }
}

