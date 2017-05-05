//
//  AppDelegate.swift
//  App
//
//  Created by 红军张 on 16/9/6.
//  Copyright © 2016年 IndependentRegiment. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import MapKit
import CoreLocation
//import Swiften
import RealmSwift
import ObjectMapper

//let api = LDApiSettings()
let cache = CacheManager(cachable: RealmCache(realm: Realm.sharedRealm))
var user = User()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var Home: HomeTabBarController?
    var Login: LoginviewController?
    var isok = false
    fileprivate var searchingReverseGeoCode = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let them = ThemeManager.currentTheme()
        ThemeManager.overrideApplyTheme(them)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        //友盟初始化
//        UMHelper.initSdkWithAppKey(UMENG_APPKEY, channelId: "", launchOptions: launchOptions)
        // 初始化融云
        initRCIM()
        //推送处理1
        if #available(iOS 8.0, *) {
            //注册推送,用于iOS8以上系统
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(types:[.alert, .badge, .sound], categories: nil))
        } else {
            //注册推送,用于iOS8以下系统
            application.registerForRemoteNotifications(matching: [.badge, .alert, .sound])
        }
        
        // 初始化百度地图
        let mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        if !mapManager.start(BAIDU_KEY, generalDelegate: self) {
            Log.error("BMK: baidu map manager start failed!")
        }
        
        Notifications.locationUpdated.addObserver(self, selector: #selector(locationUpdatedNotification(_:)), sender: nil)
        // IQ 键盘
        IQKeyboardManager.sharedManager().enable = true
        // 运行手机的信息
        Log.info(Device.getVersionCode())
        // 跳转
        gotoMainViewController()
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        BaiduLocationManager.stopLocationService()
        Notifications.timerChatMessageUpdate.post("end" as AnyObject)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.info("AppDelegate: application will enter foreground");
        
        Notifications.timerChatMessageUpdate.post("star" as AnyObject)
        
        application.applicationIconBadgeNumber = 0
        BaiduLocationManager.startLocationService()//进入前台获取位置
        
    }

    //分享 支付 回调  ios 8
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        Log.info("AppDelegate: application open url \"\(url)\" from source application \"\(sourceApplication)\"");
//        let result = UMSocialSnsService.handleOpenURL(url)
//        if !result {
//            Log.info("application openURL: \(url) \(sourceApplication)")
//        } else {
//            let notificationSheare = NSNotificationCenter.defaultCenter()
//            notificationSheare.postNotificationName("photoSheare", object: nil)
//        }
//        return result
        return true
    }
    
    // iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey:Any]) -> Bool {
        Log.info("AppDelegate: ZHJ   application open url \"\(url)\" from source application")
//        let result = UMSocialSnsService.handleOpenURL(url)
//        if !result {
//        } else {
//            let notificationSheare = NSNotificationCenter.defaultCenter()
//            notificationSheare.postNotificationName("photoSheare", object: nil)
//        }
//        return result
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "IndependentRegiment.zhj.App" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "App", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as AnyObject
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    //
}
extension AppDelegate: RCIMConnectionStatusDelegate, RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMReceiveMessageDelegate{
    func initRCIM(){
        RCIM.shared().initWithAppKey(RY_APPKEY)
        //设置监听连接状态
        RCIM.shared().connectionStatusDelegate = self
        //设置消息接收的监听
        RCIM.shared().receiveMessageDelegate = self
        //设置用户信息提供者，需要提供正确的用户信息，否则SDK无法显示用户头像、用户名和本地通知
        RCIM.shared().userInfoDataSource = self
        //设置群组信息提供者，需要提供正确的群组信息，否则SDK无法显示群组头像、群名称和本地通知
        RCIM.shared().groupInfoDataSource = self
    }
    //推送处理2
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //注册推送,用于iOS8以上系统
        application.registerForRemoteNotifications()
    }
    
    //推送处理3
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var rcDevicetoken = deviceToken.description
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: "<", with: "")
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: ">", with: "")
        rcDevicetoken = rcDevicetoken.replacingOccurrences(of: " ", with: "")
        
        RCIMClient.shared().setDeviceToken(rcDevicetoken)
    }
    
    //推送处理4
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //远程推送的userInfo内容格式请参考官网文档
        //http://www.rongcloud.cn/docs/ios.html#App_接收的消息推送格式
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        //本地通知
    }
    
    //监听连接状态变化
    func onRCIMConnectionStatusChanged(_ status: RCConnectionStatus) {
        print("RCConnectionStatus = \(status.rawValue)")
    }
    
    //用户信息提供者。您需要在completion中返回userId对应的用户信息，SDK将根据您提供的信息显示头像和用户名
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        print("用户信息提供者，getUserInfoWithUserId:\(userId)")
        
        //简单的示例，根据userId获取对应的用户信息并返回
        //建议您在本地做一个缓存，只有缓存没有该用户信息的情况下，才去您的服务器获取，以提高用户体验
        if (userId == "me") {
            //如果您提供的头像地址是http连接，在iOS9以上的系统中，请设置使用http，否则无法正常显示
            //具体可以参考Info.plist中"App Transport Security Settings->Allow Arbitrary Loads"
            completion(RCUserInfo(userId: userId, name: "我的名字", portrait: "http://www.rongcloud.cn/images/newVersion/logo/baixing.png"))
        } else if (userId == "you") {
            completion(RCUserInfo(userId: userId, name: "你的名字", portrait: "http://www.rongcloud.cn/images/newVersion/logo/qichezc.png"))
        } else {
            let imageUrl = ["http://img3.a0bi.com/upload/ttq/20160924/1474720548478.jpg","http://img2.a0bi.com/upload/ttq/20160924/1474720730902.jpg","http://www.itotii.com/wp-content/uploads/2016/09/07/1473228073_GdOpxKrS.jpg","http://img2.a0bi.com/upload/ttq/20160924/1474706687409.jpg","http://www.soideas.cn/uploads/allimg/120612/3-www.soideas.cn1206120HQ5.jpg"]
            completion(RCUserInfo(userId: userId, name: "unknown", portrait:imageUrl[Int(arc4random()%4)]))
        }
    }
    
    //群组信息提供者。您需要在Block中返回groupId对应的群组信息，SDK将根据您提供的信息显示头像和群组名
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        print("群组信息提供者，getGroupInfoWithGroupId:\(groupId)")
        
        //简单的示例，根据groupId获取对应的群组信息并返回
        //建议您在本地做一个缓存，只有缓存没有该群组信息的情况下，才去您的服务器获取，以提高用户体验
        if (groupId == "group01") {
            //如果您提供的头像地址是http连接，在iOS9以上的系统中，请设置使用http，否则无法正常显示
            //具体可以参考Info.plist中"App Transport Security Settings->Allow Arbitrary Loads"
            completion(RCGroup(groupId: groupId, groupName: "第一个群", portraitUri: "http://www.rongcloud.cn/images/newVersion/logo/aipai.png"))
        } else {
            completion(RCGroup(groupId: groupId, groupName: "unknown", portraitUri: "http://www.rongcloud.cn/images/newVersion/logo/qiugongl.png"))
        }
    }
    
    //监听消息接收
    func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        if (left != 0) {
            print("收到一条消息，当前的接收队列中还剩余\(left)条消息未接收，您可以等待left为0时再刷新UI以提高性能")
        } else {
            print("收到一条消息")
        }
    }
}
// MARK: - Location Service
extension AppDelegate: BMKGeneralDelegate, BMKGeoCodeSearchDelegate {
    
    func locationUpdatedNotification(_ notification : Notification) {
        if let location = notification.object as? CLLocation {
            let coord = location.coordinate
            
            let searcher = BMKGeoCodeSearch()
            searcher.delegate = self
            
            let reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
            reverseGeoCodeSearchOption.reverseGeoPoint = coord
            
            if !searchingReverseGeoCode {
                searchingReverseGeoCode = true
                BaiduLocationManager.stopLocationService()
                
                if !searcher.reverseGeoCode(reverseGeoCodeSearchOption) {
                    Log.error("BMK: 反geo检索发送失败")
                    BaiduLocationManager.startLocationService()
                    searchingReverseGeoCode = false
                }
            }
        }
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        searchingReverseGeoCode = false
        switch error {
        case BMK_SEARCH_NO_ERROR:
            let coord = result.location
            let locObj = Location(lat: coord.latitude, lng: coord.longitude)
            // Location name
            locObj.locName = result.addressDetail.streetName
            // province
            locObj.province = result.addressDetail.province
            // district
            locObj.district = result.addressDetail.district
            // Street address
            locObj.street = result.addressDetail.streetName + result.addressDetail.streetNumber
            locObj.city = result.addressDetail.city
            session.city = locObj.city
            Log.info("城市：\(String(describing: locObj.city))")
            // Zip code
            
            Log.info("BMK ReverseGeoCodeResult: \(result.addressDetail.province) \(result.addressDetail.city) \(result.addressDetail.district) \(result.addressDetail.streetName) \(result.addressDetail.streetNumber) 商业圈： \(result.businessCircle) 经度：\(result.location.longitude) 维度：\(result.location.latitude) 地址周边POI信息，成员类型为BMKPoiInfo \(result.poiList)")
            
            Log.info("place update: \(locObj.locName ?? "") in \(locObj.city ?? "")")
            locObj.lasttime = Date().timestamp
//            cache.setObject(Mapper(). toJSONString(locObj.city), forKey: CacheManager.Key.Location.rawValue)
//            cache[.Location] = Mapper().toJSONString(locObj)
            Notifications.placeUpdated.post(locObj)
            
            return
            
        case BMK_SEARCH_AMBIGUOUS_KEYWORD:
            Log.error("BMK: 检索词有岐义")
        case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
            Log.error("BMK: 检索地址有岐义")
        case BMK_SEARCH_NOT_SUPPORT_BUS:
            Log.error("BMK: 该城市不支持公交搜索")
        case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
            Log.error("BMK: 不支持跨城市公交")
        case BMK_SEARCH_RESULT_NOT_FOUND:
            Log.error("BMK: 没有找到检索结果")
        case BMK_SEARCH_ST_EN_TOO_NEAR:
            Log.error("BMK: 起终点太近")
        case BMK_SEARCH_KEY_ERROR:
            Log.error("BMK: key错误")
        case BMK_SEARCH_NETWOKR_ERROR:
            Log.error("BMK: 网络连接错误")
        case BMK_SEARCH_NETWOKR_TIMEOUT:
            Log.error("BMK: 网络连接超时")
        case BMK_SEARCH_PERMISSION_UNFINISHED:
            Log.error("BMK: 还未完成鉴权，请在鉴权通过后重试")
        default:
            Log.error("BMK: 未知错误")
        }
        
        BaiduLocationManager.startLocationService()
    }
    
    //MARK: - BMKGeneralDelegate
    
    func onGetNetworkState(_ iError: Int32) {
        if (0 == iError) {
            Log.info("BMK: baidu联网成功")
        } else {
            Log.error("BMK: baidu联网失败，错误代码：Error \(iError)")
        }
    }
    
    func onGetPermissionState(_ iError: Int32) {
        if (0 == iError) {
            Log.info("BMK: baidu授权成功")
            BaiduLocationManager.startLocationService()
        } else {
            Log.error("BMK: 授权失败，错误代码：Error \(iError)")
        }
    }
    
}
extension AppDelegate: AppLoginSucessDelegate{
    func loginSucess(_ Viewcontroller: LoginviewController) {
        self.isok = true
        gotoMainViewController()
    }
}
extension AppDelegate {
    func gotoMainViewController(){
        if let userinfos: User = cache.object(forKey: CacheManager.Key.User.rawValue) {
            if let number = userinfos.state{
                if number == 1 {
                    isok = true
                }else{
                    isok = false
                }
            }
        }else{
            if user.state == 1 {
                isok = true
            }else{
                isok = false
            }
        }
        
        if isok {
            if self.Login != nil{
                self.Login = nil
            }
            let homeTabar = UIViewController.loadViewControllerFromStoryboard("Main", storyboardID: "HomeTabBarController")
            if let _ = homeTabar{
                self.window?.rootViewController = homeTabar
                self.window?.makeKey()
            }
        }else{
            if Home != nil {
                Home = nil
            }
            let tabvc = UIViewController.loadViewControllerFromStoryboard("Login", storyboardID: "LoginviewController") as! UINavigationController
            let login = tabvc.viewControllers[0] as! LoginviewController
            login.loginDelegate = self
            window?.rootViewController = tabvc
            window?.makeKey()
        }
    }
}
/*
 //        let launchView = UIViewController.viewControllerWithIdentifier("LaunchScreen", storyboardName: "LaunchScreen").view
 //        let mainWindow = UIApplication.sharedApplication().keyWindow//获取到app的主屏幕
 
 //        launchView.frame = CGRect(x: 0,y: 0,width: App_width,height: App_height)
 //        mainWindow?.addSubview(launchView)//将自定义的View加载在主屏上
 
 //        let launchView = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewControllerWithIdentifier("LaunchScreen").view
 //
 ////        let mainWindow = UIApplication.sharedApplication().delegate?.window//获取到app的主屏幕
 ////        launchView.frame = (mainWindow?!.frame)!
 //        self.window?.addSubview(launchView) //将自定义的View加载在主屏上
 //
 //        let images = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg"]
 //        let number = arc4random()%UInt32(images.count)
 //        let imageviews = UIImageView()
 //        imageviews.frame = launchView.frame
 //        imageviews.image = UIImage(named: images[Int(number)])
 //        launchView.addSubview(imageviews)
 //        isok = false
 //        gotoMainViewController()
 //        self.Login = UIViewController.loadViewControllerFromStoryboard("Login", storyboardID: "LoginviewController") as? LoginviewController
 //        window?.rootViewController = self.Login
 */
