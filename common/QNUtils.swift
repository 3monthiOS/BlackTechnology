//
//  LDQNUtils.swift
//  grapefruit
//
//  Created by Cator Vee on 3/13/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation
import Qiniu
import Swiften
import SwiftyJSON
/**
 * 七牛工具集
 */
struct QNUtils {
    enum ResourceType : Int {
        case Image = 1
        case Video = 2
        case LiveVideo = 3
    }
    
    enum UploadResult {
        case Success(url: String, response: [NSObject: AnyObject]?, info: QNResponseInfo!)
        case Failure(error: NSError?)
    }
    
    static let qiniuTokenFormator = "{ \"key\":$(key), \"mimeType\":$(mimeType), \"bucket\":$(bucket), \"name\":$(fname),\"size\":$(fsize),\"w\":$(imageInfo.width),\"h\":$(imageInfo.height),\"hash\":$(etag)}"
    
    static func getHost(resourceType: ResourceType) -> String {
        switch resourceType {
        case .Image:
            return QINIU_URL_STATIC
        case .Video, .LiveVideo:
            return QINIU_URL_MEDIA
        }
    }
    
    static func keyForImage(image: UIImage) -> String? {
        let uid = "sangexiaoheshang"
        return "\(uid)\(String(Int(NSDate().timeIntervalSince1970)))\(image.contentType.extendName)"
    }
    
    static func keyForVideo() -> String? {
         let uid = "sangexiaoheshang"
        return "\(uid)\(String(Int(NSDate().timeIntervalSince1970))).mp4"
    }
    
    
    static func putData(data: NSData, withKey key: String, token: String,resourceType: ResourceType, isQuiet: Bool = false,completion: (UploadResult) -> Void) {
        let config = QNConfiguration.build { (builder: QNConfigurationBuilder!) in
            builder.setZone(QNZone.zone0())
        }
        let uploadManager = QNUploadManager(configuration: config)
        
        Log.info("QiNiu: put data (token=\(token), key=\(key), type=\(resourceType.rawValue))")
        uploadManager.putData(data, key: key, token: token, complete: {
            (info, key, resp) in
            if info.statusCode == 200 {
                //上传完毕
                if let respKey = resp?["key"] as? String {
                    let qiniuUrl = getHost(resourceType)
                    let url = "\(qiniuUrl)\(respKey)"
                    Log.info("QiNiu: put data success (\(url))")
                    completion(.Success(url: url, response: resp, info: info))
                    return
                }
            }else if info.statusCode == 401{
                generateToken(true)
                alert("token已重置,请重新上传")
            }else if info.statusCode == -5 {
                alert("token错误,请检查你的证书秘钥")
            }
            Log.error("QiNiu: put data failure (\(info.error))")
            completion(.Failure(error: info.error))
            
            }, option: nil)
    }
    static func generateToken(overdue: Bool = false) -> String{
        let accessKey = "faXFztmwdVEgWAVRM4Q7KQJYh85yBX3MjliJt6YJ", secretKey = "76tJyg9XLZ1p1z62eAgxyjifh4_kW8Rr_kPleKQo" , bucketName = "zhj1214"
        let userdefaults = NSUserDefaults.standardUserDefaults()
        if overdue {
            let deadline = NSDate().timeIntervalSince1970
            print(deadline)
            print(Int(deadline))
            let json = "{\"scope\":\"\(bucketName)\",\"deadline\":\(Int(deadline) + 3600)}"
            // MARK: - 过滤指定字符串   里面的指定字符根据自己的需要添加
                    print("将上传策略序列化成为json格式:\(json)")
            let policyData = json.dataUsingEncoding(NSUTF8StringEncoding)
            let encodedPolicy = QN_GTM_Base64.stringByWebSafeEncodingData(policyData, padded: true)
                    print("对json序列化后的上传策略进行URL安全的Base64编码,得到如下encoded:\(encodedPolicy)")
            
            let hmacData = encodedPolicy.hmacData(.SHA1, key: secretKey)
            let encodedSigned = QN_GTM_Base64.stringByWebSafeEncodingData(hmacData, padded: true)
            //        print("秘钥再次加密：\(encodedSigned)-------")
            let token = "\(accessKey):\(encodedSigned!):\(encodedPolicy)"
            userdefaults.setObject(token, forKey: "QNtoken")
            return token
        }else{
            let token = userdefaults.objectForKey("QNtoken") as? String
            if let token = token{
                return token
            }else{
                return generateToken(true)
            }
        }
    }
    /*
     结果
     第一步:
     确定上传策略
     第二步:
     将上传策略序列化成为json格式:
     {"scope":"zhj1214","deadline":1480705574}
     第三步:
     对json序列化后的上传策略进行URL安全的Base64编码,得到如下encoded:
     eyJzY29wZSI6InpoajEyMTQiLCJkZWFkbGluZSI6MTQ4MDcwNTU3NH0=
     第四步:
     用SecretKey对编码后的上传策略进行HMAC-SHA1加密，并且做URL安全的Base64编码,得到如下的encoded_signed:
     JSyU+zCDaHZVskCbyOg+cvGUzNU=
     第五步:
     将 AccessKey、encode_signed 和 encoded 用 “:” 连接起来,得到如下的UploadToken:
     faXFztmwdVEgWAVRM4Q7KQJYh85yBX3MjliJt6YJ:JSyU-zCDaHZVskCbyOg-cvGUzNU=:eyJzY29wZSI6InpoajEyMTQiLCJkZWFkbGluZSI6MTQ4MDcwNTU3NH0=
     */
}
