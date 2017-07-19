//
//  ALYPhotoController.swift
//  App
//
//  Created by 红军张 on 2017/7/10.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import AliyunOSSiOS
class ALYPhotoTool {
    
    // 由阿里云颁发的AccessKeyId/AccessKeySecret构造一个CredentialProvider。
    private let credential = OSSPlainTextAKSKPairCredentialProvider(plainTextAccessKey: ALY_AccessKey, secretKey: ALY_SecretKey)
    
    private let config = OSSClientConfiguration()
    
    static let shared = ALYPhotoTool.init()
    
    let client: OSSClient?
    
    private init(){
        OSSLog.disableLog() // 调试开关
        
        config.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
        config.timeoutIntervalForRequest = 30 // 网络请求的超时时间
        config.timeoutIntervalForResource = 24 * 60 * 60 // 允许资源传输的最长时间
        
        client = OSSClient(endpoint: ALY_endpoint, credentialProvider: credential!,clientConfiguration: config)
    }
    
    // MARK: -- 异步上传
    func uploadObjectAsync(fileName:String,data: Data?,callback:@escaping (String)->()){
        let put = OSSPutObjectRequest()
        put.bucketName = ALY_BucketName
        put.objectKey = fileName //"大榕树.jpg"
        if let data = data  {
            put.uploadingData = data
        } else {
          alert("上传数据为空")
            return
        }
        if fileName.hasSuffix(".jpg") || fileName.hasSuffix(".jpeg") {
            put.contentType = "image/jpg"
        } else if fileName.hasSuffix(".png"){
            put.contentType = "image/png"
        } else if fileName.hasSuffix(".gif"){
            put.contentType = "image/gif"
        }
        
        // 设置回调参数 回调内容将返回给设置的url {"mimeType":${mimeType},"size":${size}}
        //        put.callbackParam = ["callbackUrl":ALY_endpoint,"callbackBody":["mimeType":"${mimeType}","size":"${size}"]]
        
        let putTask = client?.putObject(put)
        put.uploadProgress = { (bytesSent,totalByteSent,totalBytesExpectedToSend)  in
            //            int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend
//            Log.info("上传 \(bytesSent)\(totalByteSent)\(totalBytesExpectedToSend)")
        }
        putTask?.continue({ (task: OSSTask) -> Any? in
            if (task.error != nil) {
                alert("上传出错\(task.error!)")
            } else {
                let getResult = task.result as? OSSPutObjectResult
                // 生成 资源链接
                let url = self.client?.presignConstrainURLWithzhj1214(ALY_BucketName, withObjectKey: fileName)
                callback(url!)
                Log.info("上传成功\(String(describing: getResult?.serverReturnJsonString))----- \(String(describing: getResult?.eTag))")
            }
            return nil
        })
    }
    
    // 异步下载
    func downloadObjectAsync(fileName: String, callBack:@escaping (Data)->()) {
        locationfileiscache(fileName) { (path) in
            if !path.isEmpty {
                if !path.isEmpty{
                    guard let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {return}
                    callBack(imageData)
                    return
                }
            }
        }
        var data = Data()
        let request = OSSGetObjectRequest()
        request.bucketName = ALY_BucketName
        request.objectKey = fileName //"照片墙.gif" 带上扩展名
        request.xOssProcess = "image/resize,m_lfit,w_100,h_100" // 当文件类型为图片时必选
//        request.downloadProgress = { (bytesSent,totalByteSent,totalBytesExpectedToSend)  in
//            //            int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend
//            Log.info("下载 \(bytesSent)\(totalByteSent)\(totalBytesExpectedToSend)")
//        }
        let gettask = client?.getObject(request)
        gettask?.continue({ (task: OSSTask) -> Any? in
            if (task.error != nil) {
                callBack(UIImage(named: "Placeholder Image")!.data! as Data)
                Log.debug("文件\(fileName) 下载时出错： \(task.error!)")
            } else {
                let getobj = task.result as? OSSGetObjectResult
                data = (getobj?.downloadedData)!
                callBack(data)
                if baocunphotoLocation(data: data, img: nil) { // 保存到本地 不用重复下载
                     Log.info("图片缓存保存成功")
                }else {
                    Log.info("图片保存失败")
                }
                Log.info("下载成功： \(String(describing: getobj?.objectMeta))")
            }
            return nil
        })
    }
    
    // 资源列举
    func getBucketListData(callback:@escaping ([Any])->()){
        let getBucket = OSSGetBucketRequest()
        getBucket.bucketName = ALY_BucketName
        getBucket.delimiter = "";
        getBucket.prefix = "";
        
        let list = client?.getBucket(getBucket)
        list?.continue({ (task) -> Any? in
            if (task.error != nil){
                Log.info("列举出错\(String(describing: task.error))")
            } else {
                let getobj = task.result as? OSSGetBucketResult
                /**{ 返回格式
                 ETag = "\"D70C1D0652AB96647556AF6ECBEA2D22\"";
                 Key = "\U5927\U6995\U6811.jpg";
                 LastModified = "2017-07-10T09:24:41.000Z";
                 Owner =     {
                 DisplayName = 1945599651705522;
                 ID = 1945599651705522;
                 };
                 Size = 1617222;
                 StorageClass = Standard;
                 Type = Normal;
                 }
                 */
//                Log.info("下载成功： \(String(describing: getobj?.contents))")
                callback((getobj?.contents)!)
            }
            return nil
        })
        
    }
    // 断点续传
//    - (void)resumableUpload {
//    __block NSString * recordKey;
//    
//    NSString * docDir = [self getDocumentDirectory];
//    NSString * filePath = [docDir stringByAppendingPathComponent:@"file10m"];
//    NSString * bucketName = @"android-test";
//    NSString * objectKey = @"uploadKey";
//    
//    [[[[[[OSSTask taskWithResult:nil] continueWithBlock:^id(OSSTask *task) {
//    // 为该文件构造一个唯一的记录键
//    NSURL * fileURL = [NSURL fileURLWithPath:filePath];
//    NSDate * lastModified;
//    NSError * error;
//    [fileURL getResourceValue:&lastModified forKey:NSURLContentModificationDateKey error:&error];
//    if (error) {
//    return [OSSTask taskWithError:error];
//    }
//    recordKey = [NSString stringWithFormat:@"%@-%@-%@-%@", bucketName, objectKey, [OSSUtil getRelativePath:filePath], lastModified];
//    // 通过记录键查看本地是否保存有未完成的UploadId
//    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//    return [OSSTask taskWithResult:[userDefault objectForKey:recordKey]];
//    }] continueWithSuccessBlock:^id(OSSTask *task) {
//    if (!task.result) {
//    // 如果本地尚无记录，调用初始化UploadId接口获取
//    OSSInitMultipartUploadRequest * initMultipart = [OSSInitMultipartUploadRequest new];
//    initMultipart.bucketName = bucketName;
//    initMultipart.objectKey = objectKey;
//    initMultipart.contentType = @"application/octet-stream";
//    return [client multipartUploadInit:initMultipart];
//    }
//    OSSLogVerbose(@"An resumable task for uploadid: %@", task.result);
//    return task;
//    }] continueWithSuccessBlock:^id(OSSTask *task) {
//    NSString * uploadId = nil;
//    
//    if (task.error) {
//    return task;
//    }
//    
//    if ([task.result isKindOfClass:[OSSInitMultipartUploadResult class]]) {
//    uploadId = ((OSSInitMultipartUploadResult *)task.result).uploadId;
//    } else {
//    uploadId = task.result;
//    }
//    
//    if (!uploadId) {
//    return [OSSTask taskWithError:[NSError errorWithDomain:OSSClientErrorDomain
//    code:OSSClientErrorCodeNilUploadid
//    userInfo:@{OSSErrorMessageTOKEN: @"Can't get an upload id"}]];
//    }
//    // 将“记录键：UploadId”持久化到本地存储
//    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault setObject:uploadId forKey:recordKey];
//    [userDefault synchronize];
//    return [OSSTask taskWithResult:uploadId];
//    }] continueWithSuccessBlock:^id(OSSTask *task) {
//    // 持有UploadId上传文件
//    OSSResumableUploadRequest * resumableUpload = [OSSResumableUploadRequest new];
//    resumableUpload.bucketName = bucketName;
//    resumableUpload.objectKey = objectKey;
//    resumableUpload.uploadId = task.result;
//    resumableUpload.uploadingFileURL = [NSURL fileURLWithPath:filePath];
//    resumableUpload.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//    NSLog(@"%lld %lld %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
//    };
//    return [client resumableUpload:resumableUpload];
//    }] continueWithBlock:^id(OSSTask *task) {
//    if (task.error) {
//    if ([task.error.domain isEqualToString:OSSClientErrorDomain] && task.error.code == OSSClientErrorCodeCannotResumeUpload) {
//    // 如果续传失败且无法恢复，需要删除本地记录的UploadId，然后重启任务
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
//    }
//    } else {
//    NSLog(@"upload completed!");
//    // 上传成功，删除本地保存的UploadId
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:recordKey];
//    }
//    return nil;
//    }];
//    }

    
 
}
extension OSSClient {
  
  func presignConstrainURLWithzhj1214(_ bucketName: String, withObjectKey key: String) -> String {
    var resource: String = "/\(bucketName)/\(key)"
    let expires: String = "\(UInt64(NSDate.oss_clockSkewFixed().timeIntervalSince1970 + 3600))"
    var wholeSign: String? = nil
    var token: OSSFederationToken? = nil
    if credentialProvider is OSSFederationCredentialProvider {
      do {
        token = try (credentialProvider as! OSSFederationCredentialProvider).getToken()
      } catch {
        return ""
      }
    } else if credentialProvider is OSSFederationCredentialProvider {
      token = (credentialProvider as! OSSStsTokenCredentialProvider).getToken()
    }
    
    if (credentialProvider is OSSFederationCredentialProvider) || (credentialProvider is OSSStsTokenCredentialProvider) {
      resource = "\(resource)?security-token=\(token?.tToken ?? "")"
      let string2sign: String = "GET\n\n\n\(expires)\n\(resource)"
      wholeSign = OSSUtil.sign(string2sign, with: token!)
    } else {
      let string2sign: String = "GET\n\n\n\(expires)\n\(resource)"
      do {
        wholeSign = try credentialProvider.sign!(string2sign)
      } catch {
        return ""
      }
    }
    
    let splitResult: [String] = wholeSign?.components(separatedBy: ":") ?? []
    if splitResult.isEmpty {return ""}
    if splitResult.count != 2 || !splitResult.first!.hasPrefix("OSS ") {
      return ""
    }
    let accessKey: String = splitResult.first!.substring(4)!
    let signature: String = splitResult[1]
    let endpointURL: URL? = URL(string: endpoint)
    var host: String? = endpointURL?.host
    guard let _ = host else {return ""}
    if OSSUtil.isOssOriginBucketHost(host!) {
      host = "\(bucketName).\(host!)"
    }
    var stringURL: String = "\(endpointURL?.scheme ?? "")://\(host!)/\(OSSUtil.encodeURL(key)!)?OSSAccessKeyId=\(OSSUtil.encodeURL(accessKey)!)&Expires=\(expires)&Signature=\(OSSUtil.encodeURL(signature)!)"
    if (credentialProvider is OSSFederationCredentialProvider) || (credentialProvider is OSSStsTokenCredentialProvider) {
      stringURL = "\(stringURL)&security-token=\(OSSUtil.encodeURL(token?.tToken ?? "")!)"
    }
    return stringURL
  }
}
