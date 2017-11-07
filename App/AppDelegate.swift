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
import UserNotifications
import AliyunOSSiOS
import AVFoundation

let locationUser = locationServiceUser.sharedInstance
let cache = CacheManager(cachable: RealmCache(realm: Realm.sharedRealm))
var user = User()
var loader: FillableLoader = WavesLoader.showLoader(with: path())
var ALY: ALYPhotoTool?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var Home: TabbarHomeController?
    var Login: LoginviewController?
    var isok = false
    fileprivate var searchingReverseGeoCode = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // IndependentRegiment.BT.App identifer ID
        
        // 调试窗口
        self.debugInformationTest()
        
        // app主题
        let them = ThemeManager.currentTheme()
        ThemeManager.overrideApplyTheme(them)
        
        //MARK: 阿里云初始化各种设置
        ALY = ALYPhotoTool.shared
        
        //MARK: 初始化融云
        initRCIM()
        registerNotification(application)
        
        //MARK: 初始化百度地图
        //        let mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        //        if !mapManager.start(BAIDU_KEY, generalDelegate: self) {
        //            Log.error("BMK: baidu map manager start failed!")
        //        }
        //        Notifications.locationUpdated.addObserver(self, selector: #selector(locationUpdatedNotification(_:)), sender: nil)
        
        if #available(iOS 9.0, *) {
            locationUser.LocationMonitoringUser()
        } else {
            LocationManager.sharedInstance.startUpdateLocation()
        }
        
        Log.debug(LocationManager.sharedInstance.address)
        //MARK: IQ 键盘
        IQKeyboardManager.sharedManager().enable = true
        
        // MARK: -- 输出设备信息
        Log.info(Device.version())
        
        //MARK: 跳转
        gotoMainViewController()
        
        //MARK: 注册音乐后台播放
        let session = AVAudioSession.sharedInstance()
        do{
            try? session.setActive(true)
            try? session.setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print(error)
        }
        
        return true
    }
    
    // 进入后台
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
        //        BaiduLocationManager.stopLocationService()
        Notifications.timerChatMessageUpdate.post("end" as AnyObject)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.info("AppDelegate: application will enter foreground");
        
        Notifications.timerChatMessageUpdate.post("star" as AnyObject)
        
        application.applicationIconBadgeNumber = 0
        //        BaiduLocationManager.startLocationService()//进入前台获取位置
    }
    // no equiv. notification. return NO if the application can't open for some reason
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        Log.info("AppDelegate: application open url \"\(url)");
        //          BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        let result = UMSocialManager().handleOpen(url)
        if !result {
            Log.info("application openURL: \(url)")
        }
        return result
    }
    
    //MARK: --  ios 8 分享 支付 回调
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Log.info("AppDelegate: application open url \"\(url)\" from source application \"\(String(describing: sourceApplication))\"");
        //          BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        let result = UMSocialManager().handleOpen(url)
        if !result {
            Log.info("application openURL: \(url) \(String(describing: sourceApplication))")
        }
        return result
    }
    
    //MARK: iOS 9 以上请用这个
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey:Any]) -> Bool {
        Log.info("AppDelegate: ZHJ   application open url \"\(url)\" from source application")
        let result = UMSocialManager().handleOpen(url)
        if !result {
            Log.info("application openURL: \(url)")
        }
        return result
    }
    
    //MARK: - Core Data stack
    
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
    
    //MARK: - Core Data Saving support
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
    
    //UIDebuggingInformationOverlay
    // 调试窗口
    func debugInformationTest() {
        let ovwerlayClass = NSClassFromString("UIDebuggingInformationOverlay") as? UIWindow.Type
        _ = ovwerlayClass?.perform(NSSelectorFromString("prepareDebuggingOverlay"))
        //参考:http://www.jianshu.com/p/4dd369c9ec56
    }
}

//MARK: 登录代理
extension AppDelegate: AppLoginSucessDelegate {
    func loginSucess(_ Viewcontroller: LoginviewController) {
        self.isok = true
        gotoMainViewController()
    }
    func gotoMainViewController(){
        if let userinfos: User = cache.object(forKey: CacheManager.Key.User.rawValue) {
            user = userinfos // 获取缓存的 用户对象
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
//MARK: 推送通知
@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    /// 在前台时收到本地推送时 需要如何通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge,.sound,.alert])
    }
    /// 后台的时候点击通知进入app
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response is UNTextInputNotificationResponse {  // input action
            
        }else { //  default action
            
        }
        completionHandler()
    }
}
//MARK: 视频
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

//MARK: - Location Service
//extension AppDelegate: BMKGeneralDelegate, BMKGeoCodeSearchDelegate {
//
//    func locationUpdatedNotification(_ notification : Notification) {
//        if let location = notification.object as? CLLocation {
//            let coord = location.coordinate
//
//            let searcher = BMKGeoCodeSearch()
//            searcher.delegate = self
//
//            let reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
//            reverseGeoCodeSearchOption.reverseGeoPoint = coord
//
//            if !searchingReverseGeoCode {
//                searchingReverseGeoCode = true
//                BaiduLocationManager.stopLocationService()
//
//                if !searcher.reverseGeoCode(reverseGeoCodeSearchOption) {
//                    Log.error("BMK: 反geo检索发送失败")
//                    BaiduLocationManager.startLocationService()
//                    searchingReverseGeoCode = false
//                } else {
//                    searcher.delegate = nil
//                }
//            }
//        }
//    }
//
//    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
//        searchingReverseGeoCode = false
//        switch error {
//        case BMK_SEARCH_NO_ERROR:
//            let coord = result.location
//            let locObj = Location(lat: coord.latitude, lng: coord.longitude)
//            // Location name
//            locObj.locName = result.addressDetail.streetName
//            // province
//            locObj.province = result.addressDetail.province
//            // district
//            locObj.district = result.addressDetail.district
//            // Street address
//            locObj.street = result.addressDetail.streetName + result.addressDetail.streetNumber
//            locObj.city = result.addressDetail.city
//            session.city = locObj.city
//            Log.info("城市：\(String(describing: locObj.city))")
//            // Zip code
//
//            Log.info("BMK ReverseGeoCodeResult: \(result.addressDetail.province) \(result.addressDetail.city) \(result.addressDetail.district) \(result.addressDetail.streetName) \(result.addressDetail.streetNumber) 商业圈： \(result.businessCircle) 经度：\(result.location.longitude) 维度：\(result.location.latitude) 地址周边POI信息，成员类型为BMKPoiInfo \(result.poiList)")
//
//            Log.info("place update: \(locObj.locName ?? "") in \(locObj.city ?? "")")
//            locObj.lasttime = Date().timestamp
////            cache.setObject(Mapper(). toJSONString(locObj.city), forKey: CacheManager.Key.Location.rawValue)
////            cache[.Location] = Mapper().toJSONString(locObj)
//            Notifications.placeUpdated.post(locObj)
//
//            return
//
//        case BMK_SEARCH_AMBIGUOUS_KEYWORD:
//            Log.error("BMK: 检索词有岐义")
//        case BMK_SEARCH_AMBIGUOUS_ROURE_ADDR:
//            Log.error("BMK: 检索地址有岐义")
//        case BMK_SEARCH_NOT_SUPPORT_BUS:
//            Log.error("BMK: 该城市不支持公交搜索")
//        case BMK_SEARCH_NOT_SUPPORT_BUS_2CITY:
//            Log.error("BMK: 不支持跨城市公交")
//        case BMK_SEARCH_RESULT_NOT_FOUND:
//            Log.error("BMK: 没有找到检索结果")
//        case BMK_SEARCH_ST_EN_TOO_NEAR:
//            Log.error("BMK: 起终点太近")
//        case BMK_SEARCH_KEY_ERROR:
//            Log.error("BMK: key错误")
//        case BMK_SEARCH_NETWOKR_ERROR:
//            Log.error("BMK: 网络连接错误")
//        case BMK_SEARCH_NETWOKR_TIMEOUT:
//            Log.error("BMK: 网络连接超时")
//        case BMK_SEARCH_PERMISSION_UNFINISHED:
//            Log.error("BMK: 还未完成鉴权，请在鉴权通过后重试")
//        default:
//            Log.error("BMK: 未知错误")
//        }
//
//        BaiduLocationManager.startLocationService()
//    }
//
//    //MARK: - BMKGeneralDelegate
//
//    func onGetNetworkState(_ iError: Int32) {
//        if (0 == iError) {
//            Log.info("BMK: baidu联网成功")
//        } else {
//            Log.error("BMK: baidu联网失败，错误代码：Error \(iError)")
//        }
//    }
//
//    func onGetPermissionState(_ iError: Int32) {
//        if (0 == iError) {
//            Log.info("BMK: baidu授权成功")
//            BaiduLocationManager.startLocationService()
//        } else {
//            Log.error("BMK: 授权失败，错误代码：Error \(iError)")
//        }
//    }
//
//}

