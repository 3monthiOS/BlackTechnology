//
//  LocalNotificationVC.swift
//  App
//
//  Created by XiuXiu on 2017/6/14.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import UserNotifications
class LocalNotificationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      view.backgroundColor = UIColor.white
      let btn = UIButton(type: .custom)
      btn.center = view.center
      btn.bounds = CGRect(x: 0.0, y: 0.0, width: 200, height: 40)
      btn.setTitle("点击10s后发送本地通知", for: .normal)
      btn.setTitleColor(UIColor.black, for: .normal)
      btn.addTarget(self, action: #selector(localNoti), for: .touchUpInside)
      view.addSubview(btn)
     
    }

  func localNoti() {
    if #available(iOS 10.0, *) {
      let content = UNMutableNotificationContent()
      // 和注册通知时声明的category 的identifier 保持一样
      content.categoryIdentifier = "category"
      content.title = "这是个标题"
      content.subtitle = "这个是subtitle"
      content.badge = 1
      content.body = "这个是body ---esddfdgfdkgjflgjfl"
      content.sound = UNNotificationSound.default()
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
      let requst = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(requst, withCompletionHandler: { (error) in
        debugPrint(error?.localizedDescription ?? "no error")
      })
    } else {
      let local = UILocalNotification()
      // 和注册通知时声明的category 的identifier 保持一样
      local.category = "category1"
      local.alertBody = "这个是body ---sdssdsdasdasda"
      local.fireDate = Date(timeInterval: 10, since: Date())
      local.soundName = UILocalNotificationDefaultSoundName
      local.alertAction = "ok"
      UIApplication.shared.scheduleLocalNotification(local)
    }

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
