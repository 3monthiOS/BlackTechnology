//
//  Myviewcontroller.swift
//  App
//
//  Created by 红军张 on 16/9/13.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

class Myviewcontroller: APPviewcontroller{
    
    weak var Mytabview: LDTableView!
    var dataArray = ["2","8","2","3","4","5","6","7","8","9","1","2"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationItem.title = "我"
        initMjrefresh()
        configureTable()
    }
    
    func initMjrefresh(){
        self.Mytabview.noDataNotice = "无数据可加载"
        self.Mytabview.refreshTableDelegate = self
        self.Mytabview.configRefreshable(headerEnabled: true, footerEnabled: true)
        self.Mytabview.refreshData()
    }
    
    private func configureTable(){
        Mytabview.estimatedRowHeight = 44
        Mytabview.rowHeight = UITableViewAutomaticDimension
    }
    private func randomNum()-> CGFloat{
        return CGFloat(arc4random() % 255) / 255.0
    }
    
    private func randomColor()-> UIColor{
        return UIColor(red: randomNum() , green: randomNum(), blue: randomNum(), alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

//MARK:------- MJ
extension Myviewcontroller : MJTableViewRefreshDelegate{
    func tableView(tableView: LDTableView, refreshDataWithType refreshType: LDTableView.RefreshType) {
        // 这里是下拉刷新的回调 用于请求数据
        dataArray.append(String(arc4random()%100))
        tableView.endRefreshing(num: dataArray.count, count: 1)
    }
}


//MARK:------- UITableViewDataSource
extension Myviewcontroller: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("autoCell", forIndexPath: indexPath)
        
        let titleName =  cell.contentView.viewWithTag(10)as! UILabel
//        let techonlogys = ["渐变","简单滤镜","复杂滤镜"]
//        if indexPath.row > (techonlogys.count - 1){
           titleName.text  =  Array(count: Int(arc4random()%50), repeatedValue: "军").joinWithSeparator(".")
//        }else{
//           titleName.text = techonlogys[indexPath.row]
//        }
      
      
        //    let identifier = "cell0"
        //    var cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        //    if cell == nil{
        //      cell = UITableViewCell(style: UITableViewCellStyle.Value2,reuseIdentifier: identifier)
        //    }
        //    cell?.textLabel?.text = String()
      

        return cell
    }
}
//MARK:------- UITableViewDelegate
extension  Myviewcontroller: UITableViewDelegate{
  
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {//选中哪一行
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
      
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view =  UIView()
        view.frame = CGRect(x: 0, y: 0, width: App_width + 25, height: 20)
//        createBlurBackground(UIImage(named: "大榕树.jpg")!, view: view, blurRadius: 8)
        return view
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view =  UIView()
        view.backgroundColor? = UIColor.redColor()
        return view
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.addGradientBackgroundColorWith(randomColor(), middleColor: randomColor())
//    }
}
//创建高斯模糊效果的背景
func createBlurBackground (image:UIImage,view:UIView,blurRadius:Float) {
    //处理原始NSData数据
    let originImage = CIImage(CGImage: image.CGImage!)
    //创建高斯模糊滤镜
    let filter = CIFilter(name: "CIGaussianBlur")
    filter!.setValue(originImage, forKey: kCIInputImageKey)
    filter!.setValue(NSNumber(float: blurRadius), forKey: "inputRadius")
    //生成模糊图片
    let context = CIContext(options: nil)
    let result:CIImage = filter!.valueForKey(kCIOutputImageKey) as! CIImage
    let blurImage = UIImage(CGImage: context.createCGImage(result, fromRect: result.extent)!)
    //将模糊图片加入背景
    let blurImageView = UIImageView(frame: view.frame)
    blurImageView.clipsToBounds = true
    blurImageView.contentMode = UIViewContentMode.ScaleAspectFill
    //        blurImageView.autoresizingMask = [.FlexibleWidth ,.FlexibleHeight]
    blurImageView.image = blurImage
    view.addSubview(blurImageView)
}
