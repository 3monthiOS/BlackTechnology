//
//  NativeShareTestVC.swift
//  App
//
//  Created by XiuXiu on 2017/6/23.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class NativeShareTestVC: UIViewController {
let width = UIScreen.main.bounds.width
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "原生分享"
      view.backgroundColor = UIColor.white
      
      let lba = UILabel(frame:CGRect(x:0.0,y:350.0,width:width,height:30))
      lba.text = "点击view即可分享"
      lba.textColor = UIColor.black
      view.addSubview(lba)
      
    }

  func nativeShare() {
    
    // activityItems 这个 参数可以传 UIActivityItemProvider 这个类 但是 相关信息不多 不知道怎么用  姑且就只传了个url
    let ccc = CBActivity()
    let act =  UIActivityViewController(activityItems: [URL(string:"http://www.baidu.com")!], applicationActivities: [ccc])
    act.completionWithItemsHandler = {( a:UIActivityType?, b:Bool, p:[Any]?, e:Error?)  in
      
      print(a,b,p,e)
      act.completionWithItemsHandler = nil
    }
    // 在 iphone 上 只能 present 
    // 在 iPad 上需要用 pop 的方式
    present(act, animated: true, completion: nil)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    nativeShare()
  }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

/// 这个 UIActivity 只能被继承使用   一些 属性和方法必须重写
fileprivate class CBActivity: UIActivity {
  var url: URL?
  override var activityType: UIActivityType {
    return UIActivityType("CB")
  }
  override var activityTitle: String? {
    return "自定义Action"
  }
  override var activityImage: UIImage? {
    return UIImage(named: "iconfont-password.png")
  }
  override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
    return activityItems.contains(where: {$0 is URL})
  }
  override func prepare(withActivityItems activityItems: [Any]) {
    url = activityItems.filter({$0 is URL}).first as? URL
    
  }
  override func perform() {
    super.perform()
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url!)
      
    }
    activityDidFinish(true)
  }
}
