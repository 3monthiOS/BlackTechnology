//
//  RegisteredViewController.swift
//  App
//
//  Created by 红军张 on 16/9/10.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//import Swiften
import SwiftyGif

class RegisteredViewController: UIViewController,UINavigationControllerDelegate{

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var imageBG: UIImageView!
    
    let transition = JumpAnimationcontroller()
    let maskLayer: CAShapeLayer = SwiftLogoLayer.logoLayer()
    
    var phoneNumbertext = ""
    let user = User()
    var userkeyArray = [Dictionary<String,String>]()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.phoneNumber.resignFirstResponder()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //移除 遮罩图
        //        view.layer.mask = nil
        
        if #available(iOS 11.0, *) {
            self.view.insetsLayoutMarginsFromSafeArea = false
            self.additionalSafeAreaInsets = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //把 遮罩图 添加到视图上
//        maskLayer.position = CGPoint(x: view.layer.bounds.size.width/2,y: view.layer.bounds.size.height/2)
//        view.layer.mask = maskLayer
        navigationController?.delegate = self
        self.title = "注册"
        let gifImage = UIImage(gifName: "gif131")
        self.imageBG.setGifImage(gifImage)
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        phoneNumber.returnKeyType = UIReturnKeyType.done
        getDBuser()
        let _ = createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.right, Title: "完成", normalImage: nil, highlightImage: nil, action: #selector(registerClick))
    }
    func getDBuser(){
        if let userkeyArray = session.object(forKey: USERGROUPOBJECTKEY) as? [Dictionary<String,String>] {
            self.userkeyArray = userkeyArray
        }
    }
    func registerClick(){
        guard let text = phoneNumber.text, !text.isEmpty else{toast("请输入手机号");return}
        
        if checkMobileReg(text){
            for dic in userkeyArray {
                if dic["phone"] == text{
                    alert("手机号已被注册，请更换");return
                }
            }
            // 新用户注册
            user.userphone = text
            user.password = text.substring(3, 11)
            let userKey = "user" + String(describing: userkeyArray) + "key"
            let userdic = ["primaryKey":userKey,"phone":text]
            userkeyArray.append(userdic)
            session.setObject(userkeyArray as AnyObject, forKey: USERGROUPOBJECTKEY)
            cache.setObject(user, forKey: userKey)
        }else{
            alert("坏淫，手机号不对");return
        }
        Log.info("这个手机里面的用户数量：\(userkeyArray.count) \(String(describing: userkeyArray.last!["phone"]))")
        alert("谢谢您留下手机号，小军一定好好保管，密码为手机号后8位。", title: "注册") {
            self.navigationController?.popViewController(animated: true)
        }
//        let VC = UIViewController.loadViewControllerFromStoryboard("Login", storyboardID: "Loginview") as! LoginviewController
//        JumpAnimation(Animations.SuckEffect, Direction: "top", CurrentVc: self, ForVc:VC , isJump: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Mark: -------- UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        transition.isCustom = false
        transition.fromeVC = fromVC
        transition.ToVC = toVC
        transition.AnimationsOBJ = Animations.cube
        transition.Direction = "left"
        return transition
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
