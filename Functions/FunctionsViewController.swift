//
//  FunctionsViewController.swift
//  App
//
//  Created by 红军张 on 16/9/13.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
//import Swiften
import Alamofire
import AlamofireImage
import AlamofireObjectMapper
import SwiftyGif

class FunctionsViewController: APPviewcontroller {
    
    weak var collectionView: CollectionMjResh!
    var collectionfoot: CollectionReusableViewFooter!
    var collectionHeader: UICollectionReusableView!
    dynamic var isAinmationStatus = true
    
    var functionTitleData = ["渐变","简单滤镜","复杂滤镜1","地图","听歌","录音","看视频","拍照","相册","通讯录","上传图片","云相册","视频录制","GIF","TableViewAnimation","LTDemo","放射变换","转场动画","本地通知","UIStackView","分享","原生分享","二维码和条形码","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        QNcheck()
        delay(UInt64(0.3)) {
            self.tabBarController?.hidesBottomBarWhenPushed = false
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func setup() {
        super.setup()
        self.navigationController?.navigationBar.isTranslucent = false
        
        initcollectionMjrefresh()
        initCollectionview()
        initData()
    }
    func initcollectionMjrefresh(){
        collectionView.noDataNotice = "无数据可加载"
        collectionView.refreshDelegate = self
        collectionView.configRefreshable(headerEnabled: true, footerEnabled: true)
        contentView?.addSubview(collectionView)
    }
    func initCollectionview(){
        self.view.backgroundColor = rgb(242,245,249)
      
        //注册一个cell
        collectionView.register(UINib(nibName: "QdanCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.register(UINib(nibName: "QdanCollectionViewzeroCell",bundle: nil), forCellWithReuseIdentifier: "cell0")
        
        //注册一个headView
        collectionView!.register(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        collectionView.register(UINib(nibName: "CollectionReusableHeadre",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")

//        layout.headerReferenceSize = CGSizeZero //CGSizeMake(App_width,44)
//        layout.footerReferenceSize = CGSizeZero //CGSizeMake(App_width,80)
        
        
    }
    func initData(){
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isAinmationStatus" {
            //            self.btn.stopAnimating()
        }
    }
    
    //- openContact
    func call_openContact() {
        let controller = MobileAddressBooks()
        controller.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    // 七牛验证
    func QNcheck(){
        //        let box = QNUtils.getaccesskey()
        //        let headers = [
        //            "Authorization": "QBox \(box)",
        //            "Content-Type": "application/x-www-form-urlencoded",
        //        ]
        //        Log.info("+++++++++++++____________\(headers["Authorization"])")
        //        //http://rsf.qbox.me/list?bucket=zhj1214
        //        let bucket = "zhj1214"
        //        Alamofire.request(.POST, "http://rsf.qbox.me/list?", parameters: ["bucket":bucket], encoding: .URL, headers: headers).responseJSON { (response) in
        //            if response.result.isSuccess{
        //                Log.info("成功----------\(response.response)----\(response.response?.allHeaderFields)-\(response.data)-\(response.result)-\(response.debugDescription)-\(response.description)")
        //            }else{
        //                Log.info("失败------\(response.result.error)")
        //            }
        //        }
    }
}
    //Mark: ------ UICollectionViewDataSource
extension FunctionsViewController: UICollectionViewDataSource{
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getProjectJsonFile().count
    }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! QdanCollectionViewCell
    self.addObserver(cell, forKeyPath: "isAinmationStatus", options: .new, context: nil)
    cell.bindData(getProjectJsonFile(),functionTitle: functionTitleData,atIndex :indexPath, VC: self)
    return cell
  }
  
}

extension FunctionsViewController: UIScrollViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isAinmationStatus = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isAinmationStatus = true
    }
}
 //Mark: ------ UICollectionViewDelegate
extension FunctionsViewController: UICollectionViewDelegate{
  //返回自定义HeadView或者FootView，我这里以headview为例
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
    if kind == UICollectionElementKindSectionHeader {
      collectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", for: indexPath)
      collectionHeader.backgroundColor = UIColor.clear
      return collectionHeader
    }else if kind == UICollectionElementKindSectionFooter{
      collectionfoot = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath) as? CollectionReusableViewFooter
      if collectionfoot == nil{
        collectionfoot = Bundle.main.loadNibNamed("CollectionReusableViewFooter", owner: nil, options: nil)!.first as? CollectionReusableViewFooter
      }
      collectionfoot.backgroundColor = UIColor.clear
    }
    return collectionfoot
  }
  //点击
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    switch indexPath.item {
    case 0:
      self.performSegue(withIdentifier: "gradient", sender: nil)
    case 1:
      self.performSegue(withIdentifier: "filter", sender: nil)
    case 2:
      self.performSegue(withIdentifier: "complexFilter", sender: nil)
    case 3:
        let baidu = BaiduMapViewController()
        
        self.navigationController?.pushViewController(baidu, animated: true)
    case 5:
        let baidu = RecordingVoiceController()
        self.tabBarController?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(baidu, animated: true)
        
    case 7:
        photobrowserAction(indexPath)
    case 8:
        photobrowserAction(indexPath)
    case 9:
        //        MobileAddressBookbuttonclick(100)
        call_openContact()
    case 10:
        let upload = uploadPicturesView()
        self.navigationController?.pushViewController(upload, animated: true)
    case 11:
        let upload = QNPhotoController()
        self.navigationController?.pushViewController(upload, animated: true)
    case 12:
      let vc = VideoRecorderViewController()
      navigationController?.pushViewController(vc, animated: true)
    case 13:
        let vc = GifDetailController()
        vc.imageData = getProjectJsonFile()
        navigationController?.pushViewController(vc, animated: true)
    case 14:
        let vc = TableviewCoustom()
        navigationController?.pushViewController(vc, animated: true)
    case 15:
        let vc = LTDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    case 16:
        let vc = RadiationTransformationController()
        navigationController?.pushViewController(vc, animated: true)
    case 17:
        let controller = UIViewController.loadViewControllerFromStoryboard("starwars", storyboardID: "IntroViewController") as! IntroViewController
        self.present(controller, animated: true, completion: nil)
    case 18 :
      let vc = LocalNotificationVC()
      navigationController?.pushViewController(vc, animated: true)
    case 19 :
      if #available(iOS 9.0, *) {
        let vc = StackViewTestVC()
        navigationController?.pushViewController(vc, animated: true)
      } else {
        alert("请使用9.0 以上的系统！")
      }
    case 20:
        let vc = ShareDomeController()
        navigationController?.pushViewController(vc, animated: true)
    case 21:
      let vc = NativeShareTestVC()
      navigationController?.pushViewController(vc, animated: true)
    case 22 :
      let vc = QRcodeAndBarCodeVC()
     
      navigationController?.pushViewController(vc, animated: true)
        default:
      break
        }
    self.tabBarController?.hidesBottomBarWhenPushed = true
    }
}

 //Mark: ------ UICollectionViewDelegateFlowLayout
extension FunctionsViewController: UICollectionViewDelegateFlowLayout{
  //返回cell 上下左右的间距
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
    return UIEdgeInsetsMake(8, 12, 8, 12)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
    let cellwidth = (App_width - 24 - 24)/4
    let cellHight = (App_width - 24 - 24)/4 * 33/28 - 2
    return CGSize(width: cellwidth,height: cellHight)
  }
}
 //Mark: ------ 刷新代理
extension FunctionsViewController: MJCollectionViewRefreshDelegate{
  func Collection(_ Collection: CollectionMjResh, refreshDataWithType refreshType: CollectionMjResh.RefreshType) {
    Collection.endRefreshing(num: 11, count: 3, NoDataNoticeViewKinds: 0)
  }
}
//相机 ， 相册 
extension FunctionsViewController: SystemPhotoAlbumDelegate,PhotoBrowserDelegate,PhotoBrowserDataSource{
    func photobrowserAction(_ indexPath: IndexPath) {
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
    
    func getImageSucessful(_ image: UIImage) {
            Log.info("有——图片\(image)")
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
            }else{
                Log.info("没有——图片")
            }
        }
    }
}

