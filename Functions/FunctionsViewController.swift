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
    var functionTitleData = ["渐变","简单滤镜","复杂滤镜1","地图","听歌","录音","看视频","拍照","相册","六","⑦","八","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名","未命名"]
    var imageData = ["http://ohc2uub90.bkt.clouddn.com/public/16-11-28/33057531.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/63784464.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/31166475.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/63869882.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/15652085.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/90098440.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/38827152.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/6871283.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/53000671.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/33057531.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/70368103.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/50374131.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/12350847.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/49087415.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/12596867.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/39233610.jpg","http://ohc2uub90.bkt.clouddn.com/public/16-11-28/61336725.jpg"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        return imageData.count
    }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! QdanCollectionViewCell
    cell.bindData(imageData,functionTitle: functionTitleData,atIndex :indexPath)
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
        if url.hasPrefix("http://") || url.hasPrefix("https://") {
            if Reachability.networkStatus == .notReachable {
                let image = UIImage(named: "chat_image_load_failed")
                return PhotoBrowser.Model.Image(image: image!)
            }else{
                return PhotoBrowser.Model.Urls(url: url, preview:"https://pan.baidu.com/s/1pL51xUj")
            }
        }
        
        var image = UIImage()
        let data = NSData(contentsOfFile: url)
        if data == nil {
            image = UIImage(named: "chat_image_load_failed")!
        }else{
            image = UIImage(data: data!)!
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




extension FunctionsViewController{
//        
//        var request = HTTPTask()
//        let downloadTask = request.download('http://www.test.com/pages_icon_large.png', parameters: nil, progress: {(complete: Double) in
//            println(complete)
//            }, success: {(response: HTTPResponse) in
//                self.downFile(response)
//            }, failure: {(error: NSError, response: HTTPResponse?) in
//                println("failure")
//        })
//        
//        var fileManager = NSFileManager.defaultManager()
//        var bundleURL = NSBundle.mainBundle().bundleURL
//        var contents: NSArray = fileManager.contentsOfDirectoryAtURL(bundleURL, includingPropertiesForKeys: nil, options: .SkipsPackageDescendants, error: nil)!
//        for URL in contents {
//            //println(URL)
//        }
//        if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as? String {
//            var enumerator = fileManager.enumeratorAtPath(path)
//            println("enumrator: \(path) \(enumerator)")
//            while let file: AnyObject = enumerator?.nextObject() {
//                println(file)
//                if let newPath = NSURL(fileURLWithPath: "\(path)/\(file)") {
//                    var image = UIImageView(image: UIImage(contentsOfFile: newPath.path!))
//                    self.view.addSubview(image)
//                }
//            }
//        }
    
        
    
    
//    func downFile(response: NSHTTPURLResponse) {
//        if response.responseObject != nil {
//            //we MUST copy the file from its temp location to a permanent location.
//            if let url = response.responseObject as? NSURL {
//                if let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
//                    if let fileName = response.suggestedFilename {
//                        if let newPath = NSURL(fileURLWithPath: "\(path)/\(fileName)") {
//                            let fileManager = NSFileManager.defaultManager()
//                            println(fileManager.fileExistsAtPath(newPath.path!))
//                            if ( fileManager.fileExistsAtPath(newPath.path!) ) {
//                                println(newPath)
//                                dispatch_async(dispatch_get_main_queue()) {
//                                    var image = UIImageView(image: UIImage(contentsOfFile: newPath.path!))
//                                    self.view.addSubview(image)
//                                    println(image.frame)
//                                }
//                            }else{
//                                fileManager.removeItemAtURL(newPath, error: nil)
//                                fileManager.moveItemAtURL(url, toURL: newPath, error: nil)
//                                println("创建文件")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
//    - (void)downloadFile {
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = [NSURL URLWithString:@"https://consumeprod.alipay.com/record/download.resource"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    [request setHTTPBody:self.useData];
//    [request setHTTPMethod:@"POST"];
//    
//    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:self.cookies];
//    [request setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
//    
//    [request setValue:@"https://consumeprod.alipay.com/record/download.htm?_input_charset=utf-8&suffix=csv&dateRange=sevenDays&tradeType=ALL&status=all&fundFlow=all&beginTime=00%3A00&endDate=2016.11.24&endTime=24%3A00&beginDate=2016.11.18&dateType=createDate&pageNum=1&t=1479955283251&_xbox=true" forHTTPHeaderField:@"Referer"];
//    
//    [request setValue:@"https://consumeprod.alipay.com" forHTTPHeaderField:@"Origin"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
//    [request setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
//    [request setValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
//    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"Mozilla/5.0 (iPhone 6; CPU iPhone OS 10_1_1 like Mac OS X) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0 MQQBrowser/7.1 Mobile/14B100 Safari/8536.25 MttCustomUA/2 QBWebViewType/1" forHTTPHeaderField:@"User-Agent"];
//    [request setValue:@"1" forHTTPHeaderField:@"Upgrade-Insecure-Requests"];
//    [request setValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];
//    
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//    return [documentsDirectoryURL URLByAppendingPathComponent:@"Alipay.zip"];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//    NSLog(@"errorvv: %@", error);
//    NSLog(@"File downloaded to: %@", filePath);
//    if (!error) {
//    [self toast:@"Download  Success !"];
//    }
//    }];
//    [downloadTask resume];
//    }
}
