//
//  FirstViewController.swift
//  App
//
//  Created by 红军张 on 2016/12/16.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var zhjtable: ZHJtableview!
    var dataArray = [["2","8","2","3","4","5","6","7","8","9","1","2"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBarHidden = false
//        self.navigationController?.navigationBar.translucent = false
//        self.navigationItem.title = "我的个人信息"
        initZHJtableview()
//        configureTable()
    }
    func initZHJtableview(){
        zhjtable.tableveiwData = dataArray
        zhjtable.needRefreshControl = [true,true]
        zhjtable.delgate = self
        zhjtable.dataSources = self
    }
    fileprivate func configureTable(){
        zhjtable.estimatedRowHeight = 44
        zhjtable.rowHeight = UITableViewAutomaticDimension
    }
    fileprivate func randomNum()-> CGFloat{
        return CGFloat(arc4random() % 255) / 255.0
    }
    
    fileprivate func randomColor()-> UIColor{
        return UIColor(red: randomNum() , green: randomNum(), blue: randomNum(), alpha: 1.0)
    }
    
    //创建高斯模糊效果的背景
    func createBlurBackground (_ image:UIImage,view:UIView,blurRadius:Float) {
        //处理原始NSData数据
        let originImage = CIImage(cgImage: image.cgImage!)
        //创建高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")
        filter!.setValue(originImage, forKey: kCIInputImageKey)
        filter!.setValue(NSNumber(value: blurRadius as Float), forKey: "inputRadius")
        //生成模糊图片
        let context = CIContext(options: nil)
        let result:CIImage = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let blurImage = UIImage(cgImage: context.createCGImage(result, from: result.extent)!)
        //将模糊图片加入背景
        let blurImageView = UIImageView(frame: view.frame)
        blurImageView.clipsToBounds = true
        blurImageView.contentMode = UIViewContentMode.scaleAspectFill
        //        blurImageView.autoresizingMask = [.FlexibleWidth ,.FlexibleHeight]
        blurImageView.image = blurImage
        view.addSubview(blurImageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
//MARK:------- MJ
extension FirstViewController : ZHJtableviewDelgate{
    func bindtableViewRefresh(_ tableView: TableViewMjResh, refreshDataWithType refreshType: TableViewMjResh.RefreshType) {
        // 这里是下拉刷新的回调 用于请求数据
        dataArray[0].append(String(arc4random()%100))
        tableView.endRefreshing(num: dataArray.count, count: 1)
    }
    func bindCellData(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell? {
        
        //        let cell = tableView.dequeueReusableCellWithIdentifier("autoCell", forIndexPath: indexPath)
        
        //        let titleName =  cell.contentView.viewWithTag(10)as! UILabel
        //        let techonlogys = ["渐变","简单滤镜","复杂滤镜"]
        //        if indexPath.row > (techonlogys.count - 1){
        //        titleName.text  =  Array(count: Int(arc4random()%50), repeatedValue: "军").joinWithSeparator(".")
        //        }else{
        //           titleName.text = techonlogys[indexPath.row]
        //        }
        
        
        let identifier = "cell0"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.value2,reuseIdentifier: identifier)
        }
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        if indexPath.row == 6{
            cell?.textLabel?.text = "退出登录"
        }
        return cell
    }
    func didSelectRowAtIndexPath(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.row == 6{
            user.state = 0
            user.one_t = 1
            cache.setObject(user, forKey: CacheManager.Key.User.rawValue)
            alert("您已退出登录")
        }
    }
}
//MARK:------- UITableViewDataSource
extension FirstViewController: ZHJtableviewDataSource {
    
    func bindHeaderView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView()
        view.frame = CGRect(x: 0, y: 0, width: App_width + 25, height: 20)
        return view
    }
}
