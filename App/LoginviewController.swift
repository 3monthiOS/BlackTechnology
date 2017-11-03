//
//  LoginviewController.swift
//  App
//
//  Created by 红军张 on 16/9/9.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
//import Swiften

enum JxbLoginShowType: Int {
    case jxbLoginShowType_NONE = 0
    case jxbLoginShowType_USER = 1
    case jxbLoginShowType_PASS = 2
}

protocol AppLoginSucessDelegate: NSObjectProtocol {
    func loginSucess(_ Viewcontroller:LoginviewController)
}
class LoginviewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageBG: UIImageView!
    @IBOutlet weak var mainview: UIView!
    
    @IBOutlet weak var QQ: UIButton!
    @IBOutlet weak var Wecht: UIButton!
    @IBOutlet weak var Sina: UIButton!
    
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
    var userkeyArray = [Dictionary<String,String>]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        getDBuser()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //把 swiftlogo 添加到视图上
        //        logo.position = CGPoint(x: view.layer.bounds.size.width/2,
        //                                y: view.layer.bounds.size.height/2+30)
        //        logo.fillColor = UIColor.redColor().CGColor
        //        view.layer.addSublayer(logo)
        
        navigationController?.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.view.insetsLayoutMarginsFromSafeArea = false
            self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        
        self.title = "登录"
        addWatermark()
        InitUI()
        //友盟初始化
        SocialUtils.initSocial()

        initThirdButton(btn: self.QQ)
        initThirdButton(btn: self.Wecht)
        initThirdButton(btn: self.Sina)
    }
    func initThirdButton(btn: UIButton) {
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = btn.bounds.size.width/2
    }
    //MARK: -- 控件 布局
    func InitUI(){
        showType = JxbLoginShowType.jxbLoginShowType_NONE
        
        let vLogin = UIView(frame: CGRect(x: 15, y: self.view.centerY - 290/2,width: App_width - 30, height: 190))
        vLogin.layer.borderWidth = 0.5;
        vLogin.layer.borderColor = UIColor.lightGray.cgColor
        vLogin.backgroundColor = UIColor.white
        mainview.addSubview(vLogin)
        
        imgLeftHand = UIImageView(frame: CGRect(x: App_width / 2 - 100, y: vLogin.top - 10, width: 40, height: 65))
        imgLeftHand!.image = UIImage(named: "owl-login-arm-left")
        mainview.addSubview(imgLeftHand!)
        mainview.sendSubview(toBack: imgLeftHand!)
        
        imgRightHand = UIImageView(frame: CGRect(x: App_width / 2 + 62, y: vLogin.top - 10, width: 40, height: 65))
        imgRightHand!.image = UIImage(named: "owl-login-arm-right")
        mainview.addSubview(imgRightHand!)
        mainview.sendSubview(toBack: imgRightHand!)
        
        imgLeftHandGone = UIImageView(frame: CGRect(x: App_width / 2 - 100, y: vLogin.frame.origin.y - 22, width: 40, height: 40))
        imgLeftHandGone!.image = UIImage(named: "icon_hand")
        mainview.addSubview(imgLeftHandGone!)
        
        imgRightHandGone = UIImageView(frame: CGRect(x: App_width / 2 + 62, y: vLogin.frame.origin.y - 22, width: 40, height: 40))
        imgRightHandGone!.image = UIImage(named: "icon_hand")
        mainview.addSubview(imgRightHandGone!)
        
        let imgLogin = UIImageView(frame:CGRect(x: vLogin.centerX - 211/2 ,y:vLogin.top - 100 ,width: 211,height: 109))
        imgLogin.image = UIImage(named:"owl-login")
        imgLogin.layer.masksToBounds = true
        imgLogin.isUserInteractionEnabled = true
        mainview.addSubview(imgLogin)
        mainview.sendSubview(toBack: imgLogin)
    
        let tgp = UITapGestureRecognizer()
        tgp.numberOfTapsRequired = 2
        tgp.addTarget(self, action: #selector(JumpMainViecontrol))
        imgLogin.addGestureRecognizer(tgp)
        
        txtUser = UITextField(frame: CGRect(x: 30, y: 30, width: vLogin.frame.size.width - 60, height: 44))
        txtUser!.delegate = self
        txtUser?.keyboardType = .numberPad
        txtUser?.placeholder = "好男人就是我"
        txtUser!.layer.cornerRadius = 5
        txtUser!.layer.borderColor = UIColor.lightGray.cgColor
        txtUser!.layer.borderWidth = 0.5;
        txtUser!.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        txtUser!.leftViewMode = UITextFieldViewMode.always
        let imgUser = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgUser.image = UIImage(named: "iconfont-user")
        txtUser?.leftView?.addSubview(imgUser)
        vLogin.addSubview(txtUser!)
        
        
        txtPwd = UITextField(frame: CGRect(x: 30, y: 90, width: vLogin.frame.size.width - 60, height: 44))
        txtPwd!.delegate = self
        txtPwd?.keyboardType = .numberPad
        txtPwd?.placeholder = "我就是小军"
        txtPwd!.layer.cornerRadius = 5;
        txtPwd!.layer.borderColor = UIColor.lightGray.cgColor
        txtPwd!.layer.borderWidth = 0.5;
        txtPwd!.isSecureTextEntry = true;
        txtPwd!.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        txtPwd!.leftViewMode = .always;
        let imgPwd = UIImageView(frame: CGRect(x: 11, y: 11, width: 22, height: 22))
        imgPwd.image = UIImage(named: "iconfont-password")
        txtPwd!.leftView?.addSubview(imgPwd)
        vLogin.addSubview(txtPwd!)
        
        let registed = UIButton(frame:CGRect(x: 60 + (vLogin.frame.size.width - 120)/5 * 3, y: 145, width:(vLogin.frame.size.width - 120)/5 * 2, height: 35))
        registed.addTarget(self, action: #selector(registeredClick(_:)), for: .touchUpInside)
        registed.setTitle("注册", for: UIControlState())
        registed.layer.cornerRadius = 5
        registed.tag = 11
        registed.setTitleColor(UIColor.brown, for: UIControlState())
        registed.layer.borderColor = UIColor.black.cgColor
        registed.layer.borderWidth = SIZE_1PX
        vLogin.addSubview(registed)
        
        let loginBtn = UIButton(frame:CGRect(x: 60, y: 145, width: (vLogin.frame.size.width - 120)/5 * 2, height: 35))
        loginBtn.addTarget(self, action: #selector(registeredClick(_:)), for: .touchUpInside)
        loginBtn.setTitle("登录", for: UIControlState())
        loginBtn.layer.cornerRadius = 5
        loginBtn.tag = 10
        loginBtn.setTitleColor(UIColor.brown, for: UIControlState())
        loginBtn.layer.borderColor = UIColor.black.cgColor
        loginBtn.layer.borderWidth = SIZE_1PX
        vLogin.addSubview(loginBtn)
    }
    //MARK: -- UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.isEqual(txtUser){
            if showType?.hashValue != 2{
                showType = JxbLoginShowType.jxbLoginShowType_USER
                return
            }
            showType = JxbLoginShowType.jxbLoginShowType_USER
            UIView.animate(withDuration: 0.4, animations: {
                self.imgLeftHand!.frame = CGRect(x: self.imgLeftHand!.frame.origin.x - 57, y: self.imgLeftHand!.frame.origin.y + 30, width: self.imgLeftHand!.frame.size.width, height: self.imgLeftHand!.frame.size.height);
                self.imgRightHand!.frame = CGRect(x: self.imgRightHand!.frame.origin.x + 48, y: self.imgRightHand!.frame.origin.y + 30, width: self.imgRightHand!.frame.size.width, height: self.imgRightHand!.frame.size.height);
                self.imgLeftHandGone!.frame = CGRect(x: self.imgLeftHandGone!.frame.origin.x - 70, y: self.imgLeftHandGone!.frame.origin.y, width: 40, height: 40);
                self.imgRightHandGone!.frame = CGRect(x: self.imgRightHandGone!.frame.origin.x + 30, y: self.imgRightHandGone!.frame.origin.y, width: 40, height: 40);
                }, completion: { (b) in
                    print(b)
            })
        }else if textField.isEqual(txtPwd){
            if showType?.hashValue == 2{
                showType = JxbLoginShowType.jxbLoginShowType_PASS
                return
            }
            showType = JxbLoginShowType.jxbLoginShowType_PASS
            
            UIView.animate(withDuration: 0.4, animations: {
                self.imgLeftHand!.frame = CGRect(x: self.imgLeftHand!.frame.origin.x + 51, y: self.imgLeftHand!.frame.origin.y - 30, width: self.imgLeftHand!.frame.size.width, height: self.imgLeftHand!.frame.size.height);
                self.imgRightHand!.frame = CGRect(x: self.imgRightHand!.frame.origin.x - 48, y: self.imgRightHand!.frame.origin.y - 30, width: self.imgRightHand!.frame.size.width, height: self.imgRightHand!.frame.size.height);
                
                self.imgLeftHandGone!.frame = CGRect(x: self.imgLeftHandGone!.frame.origin.x + 70, y: self.imgLeftHandGone!.frame.origin.y, width: 0, height: 0);
                
                self.imgRightHandGone!.frame = CGRect(x: self.imgRightHandGone!.frame.origin.x - 30, y: self.imgRightHandGone!.frame.origin.y, width: 0, height: 0);
            }, completion: { (b) in
                print(b)
            }) 
        }
    }
    
    func JumpMainViecontrol(){
        self.loginDelegate?.loginSucess(self)
    }
    //MARK: -- 登录注册 事件
    func registeredClick(_ btn: UIButton){
        if btn.tag == 11{// 注册
            self.navigationController?.pushViewController(RegisteredViewController(nibName: "RegisteredViewController", bundle: nil), animated: true)
        }else{// 登录
            if !checkMobileReg((txtUser?.text)!){alert("请输入正确的手机号");return}
            if userkeyArray.count == 0 {
                alert("新装应用请先注册，才可以使用");return
            }
            for item in userkeyArray {
                if let primaryKey = item["primaryKey"]{
                    if let userinfo: User = cache.object(forKey: CacheManager.Key.User.rawValue) {
                        if userinfo.userphone == txtUser!.text{
                            if txtPwd?.text == userinfo.password {
                                userinfo.state = 1
                                userinfo.one_t = 1
                                cache.setObject(userinfo, forKey: CacheManager.Key.User.rawValue)
//                                cache.setObject(userinfo, forKey: primaryKey) //更新用户状态
                                user = userinfo
                                self.loginDelegate?.loginSucess(self)
                                return
                            }else{
                                alert("密码错误");return
                            }
                        }
                    }
                }
            }
            alert("用户不存在")
        }
    }
   
    @IBAction func thirdloginClick(_ sender: UIButton) {
        switch sender.tag {
        case 200:
            let _ = SocialUtils.ThirdPartyLoginAction(type: UMSocialPlatformType.QQ, Viewcontroller: self)
            Log.info("QQ")
        case 201:
            let _ = SocialUtils.ThirdPartyLoginAction(type: UMSocialPlatformType.wechatSession, Viewcontroller: self)
            Log.info("Wechat")
        case 202:
            let _ = SocialUtils.ThirdPartyLoginAction(type: UMSocialPlatformType.sina, Viewcontroller: self)
            Log.info("sina")
        default:
            Log.info("啥玩意")
        }
    }
    
    // MARK: -------- UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation

        transition.isCustom = false
        transition.fromeVC = fromVC
        transition.ToVC = toVC
        transition.AnimationsOBJ = Animations.rippleEffect
        transition.Direction = "left"
        return transition
    }
    //MARK:-----添加水印
    func addWatermark(){
        imageBG.image = UIImage(named: "LoginBG.jpg")?.waterMarkedImage("要想生活过得去，朋友必须有小军").waterMarkedImage("☀️", corner: .topLeft, margin: CGPoint(x: 24,y: 28), waterMarkTextColor: UIColor.brown, waterMarkTextFont: UIFont.systemFont(ofSize: 45), backgroundColor: UIColor.clear)
    }
    //MARK:-----获取用户数据
    func getDBuser(){
        if let userkeyArray = session.object(forKey: USERGROUPOBJECTKEY) as? [Dictionary<String,String>] {
            self.userkeyArray = userkeyArray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
