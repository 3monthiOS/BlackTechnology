//
//  RegisteredViewController.swift
//  App
//
//  Created by 红军张 on 16/9/10.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
//
class RegisteredViewController: UIViewController,UINavigationControllerDelegate{

    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var imageBG: UIImageView!
    
    let transition = JumpAnimationcontroller()
    let maskLayer: CAShapeLayer = SwiftLogoLayer.logoLayer()
    
    var phoneNumbertext = ""
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.phoneNumber.resignFirstResponder()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBarHidden = false
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //移除 遮罩图
//        view.layer.mask = nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //把 遮罩图 添加到视图上
//        maskLayer.position = CGPoint(x: view.layer.bounds.size.width/2,y: view.layer.bounds.size.height/2)
//        view.layer.mask = maskLayer
        navigationController?.delegate = self
        self.title = "注册"
        imageBG.image = UIImage.gifWithName("b05启动")
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        phoneNumber.returnKeyType = UIReturnKeyType.Done
        createBarButtonItemAtPosition(UIViewController.BarButtonItemPosition.Right, Title: "完成", normalImage: nil, highlightImage: nil, action: #selector(registerClick))
    }
    
    func registerClick(){
        guard let text = phoneNumber.text where !text.isEmpty else{toast("请输入手机号");return}
        if checkMobileReg(text){
            alert("谢谢您留下手机号，小军一定好好保管。摸摸头即可登录")
        }else{
            alert("坏淫，手机号不对")
        }
        self.navigationController?.popViewControllerAnimated(true)
//        let VC = UIViewController.loadViewControllerFromStoryboard("Login", storyboardID: "Loginview") as! LoginviewController
//        JumpAnimation(Animations.SuckEffect, Direction: "top", CurrentVc: self, ForVc:VC , isJump: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    // Mark: -------- UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        transition.isCustom = false
        transition.fromeVC = fromVC
        transition.ToVC = toVC
        transition.AnimationsOBJ = Animations.Cube
        transition.Direction = "left"
        return transition
    }
    // Mark: -------- 手机号正则表达式
    func checkMobileReg(mobile: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: REGEXP_MOBILES,
                                             options: [.CaseInsensitive])
        
        return regex.firstMatchInString(mobile, options: [],
                                        range: NSRange(location: 0, length: mobile.utf16.count))?.range.length != nil
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
