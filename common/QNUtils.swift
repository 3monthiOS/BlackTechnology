//
//  LDQNUtils.swift
//  grapefruit
//
//  Created by Cator Vee on 3/13/16.
//  Copyright © 2016 Ledong. All rights reserved.
//

import Foundation
import Qiniu
//import Swiften
import SwiftyJSON
/**
 * 七牛工具集
 */
struct QNUtils {
    enum ResourceType : Int {
        case image = 1
        case video = 2
        case liveVideo = 3
    }
    
    enum UploadResult {
        case success(url: String, response: [AnyHashable: Any]?, info: QNResponseInfo?)
        case failure(error: NSError?)
    }
    
    static let qiniuTokenFormator = "{ \"key\":$(key), \"mimeType\":$(mimeType), \"bucket\":$(bucket), \"name\":$(fname),\"size\":$(fsize),\"w\":$(imageInfo.width),\"h\":$(imageInfo.height),\"hash\":$(etag)}"
    
    static func getHost(_ resourceType: ResourceType) -> String {
        switch resourceType {
        case .image:
            return QINIU_URL_STATIC
        case .video, .liveVideo:
            return QINIU_URL_MEDIA
        }
    }
    
    static func keyForImage(_ image: UIImage) -> String? {
        let uid = "sangexiaoheshang"
        return "\(uid)\(String(Int(Date().timeIntervalSince1970)))\(image.contentType.extendName)"
    }
    
    static func keyForVideo() -> String? {
         let uid = "sangexiaoheshang"
        return "\(uid)\(String(Int(Date().timeIntervalSince1970))).mp4"
    }
    
    static func getlistdata(){
        //        bucket=<UrlEncodedBucket>&marker=<Marker>&limit=<Limit>&prefix=<UrlEncodedPrefix>&delimiter=<UrlEncodedDelimiter>
//        zhj1214=
//        api.updateLiveTrailer.post(["id": curLiveNotice!.id!, "startTime": self.liveTime!]){
//            (response: LDApiResponse<LiveNotice>) in
//            self.submitBtn.userInteractionEnabled = true
//            response.failureDefault().success { msg in
//                msg.status = -1//更新
//                self.submitBtn.enabled = true
//                Notifications.liveNotice.post(msg)
//                self.navigationController?.popViewControllerAnimated(true)
//                //
//                UMHelper.postEvent("mine_update_live_pre-broadcast")
//            }
//        }
        let bucket = "zhj1214"
        let url = "http://rsf.qbox.me/list?bucket=\(bucket.urlEncoded)"
    
        Log.info(url)
//        api.getQNlistdata.post(<#T##params: [String : AnyObject]?##[String : AnyObject]?#>, start: <#T##Int?#>, limit: <#T##Int?#>) { (response) in
//            <#code#>
//        }
    }
    static func putData(_ data: Data, withKey key: String, token: String,resourceType: ResourceType, isQuiet: Bool = false,completion: @escaping (UploadResult) -> Void) {
        let config = QNConfiguration.build { (builder: QNConfigurationBuilder!) in
            builder.setZone(QNZone.zone0())
        }
        let uploadManager = QNUploadManager(configuration: config)
        
        Log.info("QiNiu: put data (token=\(token), key=\(key), type=\(resourceType.rawValue))")
        uploadManager?.put(data, key: key, token: token, complete: {
            (info, key, resp) in
            if info?.statusCode == 200 {
                //上传完毕
                if let respKey = resp?["key"] as? String {
                    let qiniuUrl = getHost(resourceType)
                    let url = "\(qiniuUrl)\(respKey)"
                    Log.info("QiNiu: put data success (\(url))")
                    completion(.success(url: url, response: resp, info: info))
                    return
                }
            }else if info?.statusCode == 401{
                generateToken(true)
                alert("token已重置,请重新上传")
            }else if info?.statusCode == -5 {
                alert("token错误,请检查你的证书秘钥")
            }
            Log.error("QiNiu: put data failure (\(info?.error))")
            completion(.failure(error: info?.error as! NSError))
            
            }, option: nil)
    }
    
    static func getaccesskey()-> String{
        //http://rsf.qbox.me/list?bucket=zhj1214
        let accessKey = "faXFztmwdVEgWAVRM4Q7KQJYh85yBX3MjliJt6YJ", secretKey = "76tJyg9XLZ1p1z62eAgxyjifh4_kW8Rr_kPleKQo"
        let signingStr = "/list?\nbucket=zhj1214&limit=20"
        let sign = signingStr.hmacData(.sha1, key: secretKey)
        let encodedSigned = QN_GTM_Base64.string(byWebSafeEncoding: sign, padded: true)
        let accesstoken = "\(accessKey):\(encodedSigned)"
        Log.info("最后的key___      \(accesstoken)")
        return accesstoken
    }
    /*
    # 假设有如下的管理请求：
    AccessKey = "MY_ACCESS_KEY"
    SecretKey = "MY_SECRET_KEY"
    url = "http://rs.qiniu.com/move/bmV3ZG9jczpmaW5kX21hbi50eHQ=/bmV3ZG9jczpmaW5kLm1hbi50eHQ="
    
    #则待签名的原始字符串是：
    signingStr = "/move/bmV3ZG9jczpmaW5kX21hbi50eHQ=/bmV3ZG9jczpmaW5kLm1hbi50eHQ=\n"
    
    #签名字符串是：
    sign = "157b18874c0a1d83c4b0802074f0fd39f8e47843"
    注意：签名结果是二进制数据，此处输出的是每个字节的十六进制表示，以便核对检查。
    
    #编码后的签名字符串是：
    encodedSign = "FXsYh0wKHYPEsIAgdPD9OfjkeEM="
    
    #最终的管理凭证是：
    accessToken = "MY_ACCESS_KEY:FXsYh0wKHYPEsIAgdPD9OfjkeEM="
     */
    static func generateToken(_ overdue: Bool = false) -> String{
        let accessKey = "faXFztmwdVEgWAVRM4Q7KQJYh85yBX3MjliJt6YJ", secretKey = "76tJyg9XLZ1p1z62eAgxyjifh4_kW8Rr_kPleKQo" , bucketName = "zhj1214"
        
//        let userdefaults = NSUserDefaults.standardUserDefaults()
        if overdue {
            let deadline = Date().timeIntervalSince1970
            print(deadline)
            print(Int(deadline))
            let json = "{\"scope\":\"\(bucketName)\",\"deadline\":\(Int(deadline) + 36000)}"
            // MARK: - 过滤指定字符串   里面的指定字符根据自己的需要添加
                    print("将上传策略序列化成为json格式:\(json)")
            let policyData = json.data(using: String.Encoding.utf8)
            let encodedPolicy = QN_GTM_Base64.string(byWebSafeEncoding: policyData, padded: true)
                    print("对json序列化后的上传策略进行URL安全的Base64编码,得到如下encoded:\(encodedPolicy)")
            
            let hmacData = encodedPolicy?.hmacData(.sha1, key: secretKey)
            let encodedSigned = QN_GTM_Base64.string(byWebSafeEncoding: hmacData, padded: true)
            let token = "\(accessKey):\(encodedSigned!):\(encodedPolicy)"
//            userdefaults.setObject(token, forKey: "QNtoken")
            session.setObject(token as AnyObject, forKey: "QNtoken")
            return token
        }else{
            let token = session.object(forKey: "QNtoken")
//            let token = userdefaults.objectForKey("QNtoken") as? String
            if let token = token{
                return token as! String
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
