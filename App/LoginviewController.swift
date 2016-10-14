//
//  LoginviewController.swift
//  App
//
//  Created by 红军张 on 16/9/9.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit

enum JxbLoginShowType: Int {
    case JxbLoginShowType_NONE = 0
    case JxbLoginShowType_USER = 1
    case JxbLoginShowType_PASS = 2
}

protocol AppLoginSucessDelegate: NSObjectProtocol {
    func loginSucess(Viewcontroller:LoginviewController)
}
class LoginviewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var mainview: UIView!
    var loginDelegate: AppLoginSucessDelegate?
    var txtUser: UITextField?
    var txtPwd: UITextField?
    var imgLeftHand: UIImageView?
    var imgRightHand: UIImageView?
    var imgLeftHandGone: UIImageView?
    var imgRightHandGone: UIImageView?
    var showType: JxbLoginShowType?
    
    let transition = JumpAnimationcontroller()
    let logo = SwiftLogoLayer.logoLayer()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //把 swiftlogo 添加到视图上
//        logo.position = CGPoint(x: view.layer.bounds.size.width/2,
//                                y: view.layer.bounds.size.height/2+30)
//        logo.fillColor = UIColor.redColor().CGColor
//        view.layer.addSublayer(logo)
        
        navigationController?.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登录"
        addWatermark()
        InitUI()
    }
    func InitUI(){
        showType = JxbLoginShowType.JxbLoginShowType_NONE
        let imgLogin = UIImageView(frame:CGRect(x: App_width/2 - 211/2,y: 100,width: 211,height: 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        imgLogin.userInteractionEnabled = true
        mainview.addSubview(imgLogin)
        let tgp = UITapGestureRecognizer()
        tgp.numberOfTapsRequired = 2
        tgp.addTarget(self, action: #selector(JumpMainViecontrol))
        imgLogin.addGestureRecognizer(tgp)
        
        imgLeftHand = UIImageView(frame: CGRect(x: 60, y: 190, width: 40, height: 65))
        imgLeftHand!.image = UIImage(named: "owl-login-arm-left")
        mainview.addSubview(imgLeftHand!)
        
        imgRightHand = UIImageView(frame: CGRect(x: 220, y: 190, width: 40, height: 65))
        imgRightHand!.image = UIImage(named: "owl-login-arm-right")
        mainview.addSubview(imgRightHand!)
        
        let vLogin = UIView(frame: CGRect(x: 15, y: 200,width: App_width - 30, height: 190))
        
        vLogin.layer.borderWidth = 0.5;
        vLogin.layer.borderColor = UIColor.lightGrayColor().CGColor
        vLogin.backgroundColor = UIColor.whiteColor()
        mainview.addSubview(vLogin)
       
        imgLeftHandGone = UIImageView(frame: CGRect(x: App_width / 2 - 100, y: vLogin.frame.origin.y - 22, width: 40, height: 40))
        imgLeftHandGone!.image = UIImage(named: "icon_hand")
        mainview.addSubview(imgLeftHandGone!)
        
        imgRightHandGone = UIImageView(frame: CGRect(x: App_width / 2 + 62, y: vLogin.frame.origin.y - 22, width: 40, height: 40))
        imgRightHandGone!.image = UIImage(named: "icon_hand")
        mainview.addSubview(imgRightHandGone!)
        
        
        txtUser = UITextField(frame: CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser!.delegate = self
        txtUser?.placeholder = "连峰去天不盈尺好男人就是我"
        txtUser!.layer.cornerRadius = 5
        txtUser!.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtUser!.layer.borderWidth = 0.5;
        txtUser!.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser!.leftViewMode = UITextFieldViewMode.Always
        let imgUser = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named: "iconfont-user")
        txtUser?.leftView?.addSubview(imgUser)
        vLogin.addSubview(txtUser!)
        
        
        txtPwd = UITextField(frame: CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd!.delegate = self
        txtPwd?.placeholder = "枯松倒挂倚绝壁我就是小军"
        txtPwd!.layer.cornerRadius = 5;
        txtPwd!.layer.borderColor = UIColor.lightGrayColor().CGColor
        txtPwd!.layer.borderWidth = 0.5;
        txtPwd!.secureTextEntry = true;
        txtPwd!.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd!.leftViewMode = .Always;
        let imgPwd = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named: "iconfont-password")
        txtPwd!.leftView?.addSubview(imgPwd)
        vLogin.addSubview(txtPwd!)
        
        let registed = UIButton(frame:CGRect(x: 100, y: 145, width: vLogin.frame.size.width - 200, height: 35))
        registed.addTarget(self, action: #selector(registeredClick), forControlEvents: .TouchUpInside)
        registed.setTitle("注册", forState: .Normal)
        registed.layer.cornerRadius = 5
        registed.setTitleColor(UIColor.brownColor(), forState: .Normal)
        registed.layer.borderColor = UIColor.blackColor().CGColor
        registed.layer.borderWidth = SIZE_1PX
        vLogin.addSubview(registed)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.isEqual(txtUser){
            if showType?.hashValue != 2{
                showType = JxbLoginShowType.JxbLoginShowType_USER
                return
            }
            showType = JxbLoginShowType.JxbLoginShowType_USER
            UIView.animateWithDuration(0.4, animations: {
                self.imgLeftHand!.frame = CGRect(x: self.imgLeftHand!.frame.origin.x - 57, y: self.imgLeftHand!.frame.origin.y + 30, width: self.imgLeftHand!.frame.size.width, height: self.imgLeftHand!.frame.size.height);
                self.imgRightHand!.frame = CGRect(x: self.imgRightHand!.frame.origin.x + 48, y: self.imgRightHand!.frame.origin.y + 30, width: self.imgRightHand!.frame.size.width, height: self.imgRightHand!.frame.size.height);
                self.imgLeftHandGone!.frame = CGRect(x: self.imgLeftHandGone!.frame.origin.x - 70, y: self.imgLeftHandGone!.frame.origin.y, width: 40, height: 40);
                self.imgRightHandGone!.frame = CGRect(x: self.imgRightHandGone!.frame.origin.x + 30, y: self.imgRightHandGone!.frame.origin.y, width: 40, height: 40);
                }, completion: { (b) in
                    print(b)
            })
        }else if textField.isEqual(txtPwd){
            if showType?.hashValue == 2{
                showType = JxbLoginShowType.JxbLoginShowType_PASS
                return
            }
            showType = JxbLoginShowType.JxbLoginShowType_PASS
            
            UIView.animateWithDuration(0.4, animations: {
                self.imgLeftHand!.frame = CGRect(x: self.imgLeftHand!.frame.origin.x + 57, y: self.imgLeftHand!.frame.origin.y - 30, width: self.imgLeftHand!.frame.size.width, height: self.imgLeftHand!.frame.size.height);
                self.imgRightHand!.frame = CGRect(x: self.imgRightHand!.frame.origin.x - 48, y: self.imgRightHand!.frame.origin.y - 30, width: self.imgRightHand!.frame.size.width, height: self.imgRightHand!.frame.size.height);
                
                self.imgLeftHandGone!.frame = CGRect(x: self.imgLeftHandGone!.frame.origin.x + 70, y: self.imgLeftHandGone!.frame.origin.y, width: 0, height: 0);
                
                self.imgRightHandGone!.frame = CGRect(x: self.imgRightHandGone!.frame.origin.x - 30, y: self.imgRightHandGone!.frame.origin.y, width: 0, height: 0);
            }) { (b) in
                print(b)
            }
        }
    }
    
    func JumpMainViecontrol(){
        self.loginDelegate?.loginSucess(self)
    }
    
    func registeredClick(){
        self.navigationController?.pushViewController(RegisteredViewController(), animated: true)
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
        transition.AnimationsOBJ = Animations.RippleEffect
        transition.Direction = "left"
        return transition
    }
    //MARK:-----添加水印
    func addWatermark(){
        imageBG.image = UIImage(named: "3")?.waterMarkedImage("要想生活过得去，朋友必须有小军").waterMarkedImage("☀️", corner: .TopLeft, margin: CGPoint(x: 24,y: 28), waterMarkTextColor: UIColor.brownColor(), waterMarkTextFont: UIFont.systemFontOfSize(45), backgroundColor: UIColor.clearColor())
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
