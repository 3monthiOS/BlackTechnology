//
// SocialUtils.swift
// aha
//
// Created by date13 on 15/12/16.
// Copyright © 2015年 Ledong. All rights reserved.
//

import Foundation

enum ShareObjectType : String {
    case UMSocialShareTextObjectConfig = "text"
    case UMSocialShareImageObjectConfig = "Image"
    case UMSocialShareMusicObjectConfig = "music"
    case UMSocialShareVideoObjectConfig = "video"
    case UMSocialShareWebpageObjectConfig = "webpage"
    case UMSocialShareEmailObjectConfig = "Email"
    case UMSocialShareSmsObjectConfig = "sms"
    case UMSocialShareEmotionObjectConfig = "Emotion"
    case UMSocialShareFileObjectConfig = "File"
    case UMShareMiniProgramObject = "MiniProgram"
}

class SocialUtils {
    //友盟
    static let umengAppKey : String = "59476c7cf29d986990001a42"
    //微信
    static let wxAppId : String = "wx182608b1458c541c"
    static let wxAppSecret : String = "91fb307ff44a0178bbe5f135056e84eb"
    //QQ 在友盟后台配置实用 ，前端配置实用
    static let qqAppId : String = "1106159325"
    static let qqAppKey : String = "Om8wkz5p71TOgqBt"
    //新浪 在友盟后台配置使用
    static let sinaAppId : String = "2514846423"
    static let sinaAppSecret : String = "25a1237841d60a7445d2f944483e0715" //5680a81ee0f55a739b001164
    // 蚂蚁金服
    static let antfinancialId: String = "2017061907522608"
    //新浪微博回调页
    static let sinaSecureDomain : String = "http://sns.whalecloud.com/sina2/callback"
    
    static var shareTypeMap = [Int: Int]()
    static var webShareTypeMap = [String:String]()
    
    static let ahaDefaultUrl : String = "http://m.ahasou.com/"
    // UM
    //    static let _ = UMSocialDataManager()
    static let config = UMSocialManager.default()
    // 分享对象
    static let share =  UMSocialMessageObject()
    //MARK: 初始化 友盟配置
    static func initSocial() {
        // 设置KEY
        config?.umSocialAppkey = umengAppKey
        //        config?.umSocialAppSecret = "" 必须是企业账号才可以 有AppSecret
        config?.openLog(true)
        // 微信 聊天
        config?.setPlaform(UMSocialPlatformType.wechatSession, appKey: wxAppId, appSecret: wxAppSecret, redirectURL: "http://mobile.umeng.com/social")
        // 微信 朋友圈
        config?.setPlaform(UMSocialPlatformType.wechatTimeLine, appKey: wxAppId, appSecret: wxAppSecret, redirectURL: "http://mobile.umeng.com/social")
        // 腾讯 QQ
        config?.setPlaform(UMSocialPlatformType.QQ, appKey: qqAppId, appSecret: qqAppKey, redirectURL: "http://mobile.umeng.com/social")
        // 腾讯 QQ空间
        config?.setPlaform(UMSocialPlatformType.qzone, appKey: qqAppId, appSecret: qqAppKey, redirectURL: "http://mobile.umeng.com/social")
        // 新浪微博
        config?.setPlaform(UMSocialPlatformType.sina, appKey: sinaAppId, appSecret: sinaAppSecret, redirectURL: "http://mobile.umeng.com/social")
        // 蚂蚁金服 支付宝分享
        config?.setPlaform(UMSocialPlatformType.alipaySession, appKey: antfinancialId, appSecret: "", redirectURL: "http://mobile.umeng.com/social")
        // 添加 预定义分享平台
        UMSocialUIManager.setPreDefinePlatforms(config?.platformTypeArray)
        
        // 水印
        let watermark = UMSocialWarterMarkConfig.default()
        watermark?.stringWarterMarkConfig.warterMarkAttributedString = setingwatermark()
        watermark?.stringAndImageWarterMarkPositon = UMSocialStringAndImageWarterMarkPositon.stringWarterMarkBottomRightAndImageWarterMarkTopRight
        watermark?.spaceBetweenStringWarterMarkAndImageWarterMark = 12.0
        // 分享文本限制
        UMSocialGlobal.shareInstance().isTruncateShareText = true
        // 添加分享水印
        UMSocialGlobal.shareInstance().isUsingWaterMark = true
    }
    
    //MARK: 设置水印
    static func setingwatermark() -> NSMutableAttributedString{
        //定义富文本即有格式的字符串
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let name : NSAttributedString = NSAttributedString(string: "小张", attributes: [ NSBackgroundColorAttributeName : UIColor.clear,NSForegroundColorAttributeName : UIColor.blue, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17.0)])
        let APP : NSAttributedString = NSAttributedString(string: "APP", attributes: [NSForegroundColorAttributeName : UIColor.red, NSFontAttributeName : UIFont.systemFont(ofSize: 15.0)])
        let smileImage : UIImage = UIImage(named: "owl-login")!
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = smileImage
        textAttachment.bounds = CGRect(x: 0, y: -4, width: 22, height: 22)
        
        attributedStrM.append(name)
        attributedStrM.append(APP)
        attributedStrM.append(NSAttributedString(attachment: textAttachment))
        return attributedStrM
    }
    
    
}
//MARK: ------------------ 分享 --------------
extension SocialUtils {
    //MARK: 展示分享视图
    static func showUI(Viewcontroller: UIViewController,contentObject :ShareObject){
        setingShareObject(data: contentObject)
        setingshowUI()
        UMSocialUIManager.showShareMenuViewInWindow { ( type: UMSocialPlatformType, Dic :[AnyHashable : Any]?) in
            setingShareObjectValue(contentObject: contentObject)
            sharefilter(contentObject: contentObject, type: type)
            shareContent(Viewcontroller: Viewcontroller,type: type)
        }
    }
    
    //MARK: 各个平台 分享配置 （就是分享限制条件）
    static func setingShareObject(data: ShareObject){
        let typp = UMSocialHandlerConfig()
        switch data.ContentObject! {
        case "text":
            typp.shareTextObjectConfig.textLimit = 199
        case "Image":
            typp.shareImageObjectConfig.shareImageDataLimit = UInt(200.0)
            typp.shareImageObjectConfig.shareImageURLLimit = UInt(150.0)
        case "music":
            typp.shareMusicObjectConfig.musicUrlLimit = 887889 ;//"音乐网页网址"
            typp.shareMusicObjectConfig.musicDataUrlLimit = 887889;//"音乐数据网址"
        case "video":
            typp.shareVideoObjectConfig.videoUrlLimit = 887889;//"视频网页地址"
            typp.shareVideoObjectConfig.videoStreamUrlLimit = 887889;//"视频数据地址"
        case "webpage":
            typp.shareWebpageObjectConfig.webpageUrlLimit = 887889;//"WEB网页地址"
        case "Email":
            typp.shareEmailObjectConfig.toRecipientLimit = 23232332; // 接收人
            typp.shareEmailObjectConfig.ccRecipientLimit = 23232332; // 抄送人
            typp.shareEmailObjectConfig.bccRecipientLimit = 23232332; // 密送人
            typp.shareEmailObjectConfig.emailContentLimit = 23232332; // 文本内容
            typp.shareEmailObjectConfig.emailImageDataLimit = 23232332; // 图片大小
            typp.shareEmailObjectConfig.emailImageUrlLimit = 23232332; // 图片URL大小
            typp.shareEmailObjectConfig.emailSendDataLimit = 23232332; // 文件（NSData）
            typp.shareEmailObjectConfig.fileType = ["",""]; // 允许的文件格式
            typp.shareEmailObjectConfig.fileNameLimit = 23232332; // 文件名,(例如图片 imageName.png, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)
        case "sms":
            typp.shareSmsObjectConfig.recipientLimit = 345678;// 接收人
            typp.shareSmsObjectConfig.smsContentLimit = 345678;// 文本内容
            typp.shareSmsObjectConfig.smsImageDataLimit = 345678;// 图片数据
            typp.shareSmsObjectConfig.smsImageUrlLimit = 345678;// 图片链接
            typp.shareSmsObjectConfig.smsSendDataLimit = 345678;// 文件数据fileType
            typp.shareSmsObjectConfig.fileType = ["",""];// 文件格式 必填，必须指定数据格式，如png图片格式应传入@"png"
            typp.shareSmsObjectConfig.fileNameLimit = 345678;// 文件名,(例如图片 imageName.png, 文件名后要跟文件后缀名，否则没法识别，导致类似图片不显示的问题)
            typp.shareSmsObjectConfig.fileUrlLimit = 345678;// 文件地址url
        case "Emotion":
            typp.shareEmotionObjectConfig.emotionDataLimit = 21324546;
        case "File":
            typp.shareFileObjectConfig.fileExtensionLimit = 23456;
            typp.shareFileObjectConfig.fileDataLimit = 23456;
        case "Extend":
            typp.shareExtendObjectConfig.urlLimit = 34567;
            typp.shareExtendObjectConfig.extInfoLimit = 34567;
            typp.shareExtendObjectConfig.fileDataLimit = 34567;
        default:
            return
        }
    }
    
    //MARK: 分享UI展示 设置
    static func setingshowUI(){
        UMSocialShareUIConfig.shareInstance().sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType.bottom
        UMSocialShareUIConfig.shareInstance().sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType.iconAndBGRadius
    }
    
    //MARK: 设置分享对象
    static func setingShareObjectValue(contentObject :ShareObject){
        switch contentObject.ContentObject! {
        case "text":
            share.text = contentObject.title! + contentObject.content!
            Log.info("默认就是文本对象 不包含标题和分享对象，只有迅雷才会显示标题")
        case "Image":
            let Object = UMShareImageObject.shareObject(withTitle: contentObject.title, descr: contentObject.content, thumImage: (contentObject.img != nil) ? contentObject.img : contentObject.thumbnailImg)
            Object?.shareImage = contentObject.img
            share.shareObject = Object
        case "music":
            let Object = UMShareMusicObject.shareObject(withTitle: contentObject.title, descr: contentObject.content, thumImage:(contentObject.img != nil) ? contentObject.img : contentObject.thumbnailImg)
            Object?.musicUrl = "https://y.qq.com/n/yqq/song/003VRFq60linmL.html"
            share.shareObject = Object
        case "video":
            let Object = UMShareVideoObject.shareObject(withTitle: contentObject.title, descr: contentObject.content, thumImage: (contentObject.img != nil) ? contentObject.img : contentObject.thumbnailImg)
            Object?.videoUrl = "http://www.iqiyi.com/v_19rrokvq3k.html?vfm=2008_aldbd"
            share.shareObject = Object
        case "webpage":
            let Object = UMShareWebpageObject.shareObject(withTitle: contentObject.title, descr: contentObject.content, thumImage: (contentObject.img != nil) ? contentObject.img : contentObject.thumbnailImg)
            Object?.webpageUrl = "http://www.toutiao.com"
            share.shareObject = Object
        case "Email":
            let object = UMShareEmailObject()
            object.subject = "主题就是APP分享"
            object.toRecipients = ["524903249@qq.com","201949192@qq.com","594966623@qq.com"]
            object.ccRecipients = ["524903249@qq.com","201949192@qq.com","594966623@qq.com"]
            object.bccRecipients = ["1179474422@qq.com"]
            object.emailContent = "来自小军APP的问候，工作愉快"
            object.emailImage = contentObject.thumbnailImg
            object.emailImageType = "image/ *"
            object.emailImageName = "分享缩略图"
            object.emailSendData = contentObject.img // 图片文件
            object.fileType = "image/ *"
            object.fileName = "分享缩略图"
            share.shareObject = object
        case "sms":
            let object = UMShareSmsObject()
            object.recipients = ["小张","小张","小张","小张","小张","小张"]
            object.subject = "来自APP的短信分享"
            object.smsContent = "来自小军APP的问候，工作愉快"
            object.smsImage = UIImage(named: "分享缩略图")
            object.imageType = "jpg"
            object.imageName = "分享缩略图.jpg"
            object.smsSendData = contentObject.thumbnailImg
            object.fileType = "txt"
            object.fileName = "分享缩略图.txt"
            object.fileUrl = "文件地址"
            share.shareObject = object
        case "Emotion":
            let object = UMShareEmotionObject.shareObject(withTitle: contentObject.title, descr: contentObject.content, thumImage: contentObject.thumbnailImg)
            object?.emotionData = UIImage(gifName: "gif131").imageData
            share.shareObject = object
        case "File":
            let object = UMShareFileObject()
            object.fileExtension = ".jpg"
            object.fileData = contentObject.img
            share.shareObject = object
        case "MiniProgram":
            let object = UMShareMiniProgramObject() // 微信小程序
            object.webpageUrl = "" // 低版本微信链接
            object.userName = "" // 小程序username
            object.path = "" // 小程序页面路径
            share.shareObject = object
        default:
            return
        }
    }
    
    //MARK: 开始分享
    static func shareContent(Viewcontroller: UIViewController ,type: UMSocialPlatformType){
        // 如果是邮件、短信 吊用此方法
        if type == .email || type == .sms {
            config?.getUserInfo(with: type, currentViewController: Viewcontroller, completion: { (data, error) in
                if (error != nil) {
                    Log.info("分享出错了\(String(describing: error))")
                }
            })
        }
        config?.share(to: type, messageObject: share, currentViewController: Viewcontroller, completion: { (data, Error) in
            if (Error != nil) {
                alert("分享出错了")
            }
        })
    }
    static func sharefilter(contentObject :ShareObject,type: UMSocialPlatformType){
        if contentObject.ContentObject == "Emotion" {
            if type != UMSocialPlatformType.wechatSession {
                alert("表情分享，暂时只支持微信聊天的分享")
                return
            }
        }
    }
}
//MARK: ------------- 第三方登录 ------------
extension SocialUtils {
    static func ThirdPartyLoginAction(type: UMSocialPlatformType,Viewcontroller: UIViewController) -> User {
//        config?.cancelAuth(with: type, completion: { (data, error) in
//            Log.info("取消")
//        })
        config?.getUserInfo(with: type, currentViewController: Viewcontroller, completion: { (data, error) in
            if let obj = data as? UMSocialUserInfoResponse {
                Log.info("你都返回了些啥啊 --  \(String(describing: obj.name))------\(String(describing: obj.iconurl))-------\(String(describing: obj.unionGender))----\(String(describing: obj.gender))")
            }
            if (error != nil) {
                Log.info("第三方登录出错了？  \(String(describing: error))")
            }
        })
        return User()
    }
}
