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
    func uploadObjectAsync(){
        let put = OSSPutObjectRequest()
        put.bucketName = "zhj1214"
        put.objectKey = "大榕树.jpg"
        let image = UIImage(named: "大榕树")
        image?.contentType = .JPEG
        put.uploadingData = image!.data! as Data
        put.contentType = "image/jpg"
        
        // 设置回调参数 {"mimeType":${mimeType},"size":${size}}
//        put.callbackParam = ["callbackUrl":ALY_endpoint,"callbackBody":["mimeType":"${mimeType}","size":"${size}"]]
        
        let putTask = client?.putObject(put)
        put.uploadProgress = { (bytesSent,totalByteSent,totalBytesExpectedToSend)  in
            //            int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend
            Log.info("上传 \(bytesSent)\(totalByteSent)\(totalBytesExpectedToSend)")
        }
        let url = client?.presignConstrainURLWithzhj1214("zhj1214", withObjectKey: "大榕树.jpg")
        client?.presignConstrainURL(withBucketName: "zhj1214", withObjectKey: "大榕树", withExpirationInterval: 36000)
        
        putTask?.continue({ (task: OSSTask) -> Any? in
            if (task.error != nil) {
                Log.info("上传出错\(task.error!)")
                return "上传出错"
            } else {
                let getResult = task.result as? OSSPutObjectResult
                Log.info("上传成功\(String(describing: getResult?.serverReturnJsonString))----- \(String(describing: getResult?.eTag))")
                return "上传成功"
            }
        })
      
    }
   
    
    // 异步下载
    func downloadObjectAsync(callBack:@escaping (Data)->()) {
        var data = Data()
        let request = OSSGetObjectRequest()
        request.bucketName = "zhj1214"
        request.objectKey = "照片墙.gif"
        request.xOssProcess = "image/resize,m_lfit,w_100,h_100"
//        request.downloadProgress = { (bytesSent,totalByteSent,totalBytesExpectedToSend)  in
//            //            int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend
//            Log.info("下载 \(bytesSent)\(totalByteSent)\(totalBytesExpectedToSend)")
//        }
        let gettask = client?.getObject(request)
        gettask?.continue({ (task: OSSTask) -> Any? in
            if (task.error != nil) {
                Log.info("sssssssssssss\(task.error!)")
            } else {
                let getobj = task.result as? OSSGetObjectResult
                data = (getobj?.downloadedData)!
                callBack(data)
                Log.info("sssssssssssss\(String(describing: getobj?.objectMeta))")
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
