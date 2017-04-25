//
//  VideoRecorderViewController.swift
//  Maintenance
//
//  Created by XiuXiu on 2017/4/18.
//  Copyright © 2017年 ST. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos
class VideoRecorderViewController: UIViewController {

  var captureSession = AVCaptureSession()
  var captureDeviceInput: AVCaptureDeviceInput?
  var captureMovieFileOutput: AVCaptureMovieFileOutput =  AVCaptureMovieFileOutput()
  var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
  var outView: UIView?
  // 没什么用
  var enableRotation = false {
    didSet{
      overturnBtn.isHidden = !enableRotation
    }
  }
//  var rotationBounds: CGRect?
  var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
  var overturnBtn: UIButton!

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  setting()
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    captureSession.startRunning()
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    captureSession.stopRunning()
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      view.backgroundColor = UIColor.white
      outView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: App_width, height: App_height - 120))
      view.addSubview(outView!)
      
      let recorderBtn = UIButton(type: .custom)
      recorderBtn.translatesAutoresizingMaskIntoConstraints = false
      recorderBtn.setTitle("录制", for: .normal)
      recorderBtn.setTitleColor(UIColor.black, for: .normal)
      recorderBtn.addTarget(self, action: #selector(recorderClick(btn:)), for: .touchUpInside)
      view.addSubview(recorderBtn)
      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btn(30)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["btn":recorderBtn]))
      view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: recorderBtn, attribute: .centerX, multiplier: 1, constant: 0))
       overturnBtn = UIButton(type: .custom)
      overturnBtn.translatesAutoresizingMaskIntoConstraints = false
      overturnBtn.setTitleColor(UIColor.black, for: .normal)
      overturnBtn.setTitle("翻转摄像头", for: .normal)
      overturnBtn.addTarget(self, action: #selector(overturnCameraClick(btn:)), for: .touchUpInside)
       view.addSubview(overturnBtn)
      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btn(80)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["btn":overturnBtn]))
      view.addConstraint(NSLayoutConstraint(item: overturnBtn, attribute: .centerY, relatedBy: .equal, toItem: recorderBtn, attribute: .centerY, multiplier: 1, constant: 0))
    }

  func  setting(){
    // 分辨率
    if captureSession.canSetSessionPreset(AVCaptureSessionPreset1280x720){
      captureSession.sessionPreset = AVCaptureSessionPreset1280x720
    }
    //获得输入设备
   let  captureDevice =  getCameraDeviceWithPosition(.back)//取得后置摄像头
    guard let _ = captureDevice else {debugPrint("后置摄像头有问题") ;   return  }
    
    //添加一个音频输入设备
    let audioCaptureDevice = AVCaptureDevice.devices(withMediaType: AVMediaTypeAudio).first as! AVCaptureDevice
    //根据输入设备初始化设备输入对象，用于获得输入数据
   
    do {
      captureDeviceInput  = try AVCaptureDeviceInput(device: captureDevice)
      let  audioCaptureDeviceInput = try AVCaptureDeviceInput(device: audioCaptureDevice)
      //将设备输入添加到会话中
      if captureSession.canAddInput(captureDeviceInput) {
        captureSession.addInput(captureDeviceInput)
        captureSession.addInput(audioCaptureDeviceInput)
        let captureConnection = captureMovieFileOutput.connection(withMediaType: AVMediaTypeVideo)
        if  let captureConnection = captureConnection , captureConnection.isVideoStabilizationSupported {
          captureConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
        }
      }
    }catch {
      debugPrint("取得设备输入对象时出错，错误原因\(error.localizedDescription)")
    }
    
    //将设备输出添加到会话中
    if captureSession.canAddOutput(captureMovieFileOutput) {
      captureSession.addOutput(captureMovieFileOutput)
    }

    
    //创建视频预览层，用于实时展示摄像头状态
    captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    let layer =  outView?.layer
    layer?.masksToBounds = true
    
    
    captureVideoPreviewLayer?.frame = layer!.bounds
    captureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill //填充模式
    //将视频预览层添加到界面中
    layer?.insertSublayer(captureVideoPreviewLayer!, at: 0)
//    layer?.insertSublayer(captureVideoPreviewLayer, below: )
    enableRotation = true
  }
  
  func getCameraDeviceWithPosition(_ position :AVCaptureDevicePosition)-> AVCaptureDevice? {
    let cameras = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
    for   camera  in cameras! {
      if  (camera as! AVCaptureDevice).position ==  position {
    return (camera as! AVCaptureDevice)
      }
    }
    return nil
  }
 
  func recorderClick(btn: UIButton){
    let captureConnection = captureMovieFileOutput.connection(withMediaType: AVMediaTypeAudio)
    //根据连接取得设备输出的数据
    if !captureMovieFileOutput.isRecording {
       enableRotation = false
    
     //如果支持多任务则则开始多任务
    if  UIDevice.current.isMultitaskingSupported {
      backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
    }
    //预览图层和视频方向保持一致
    captureConnection?.videoOrientation = captureVideoPreviewLayer!.connection.videoOrientation
    
    let path = NSTemporaryDirectory() + "myMovie.mov"
    let  fileUrl = URL(fileURLWithPath: path)
    captureMovieFileOutput.startRecording(toOutputFileURL: fileUrl, recordingDelegate: self)
      btn.setTitle("正在录制", for: .normal)
    }else{
      btn.setTitle("录制", for: .normal)
      captureMovieFileOutput.stopRecording()
    }
  }
  
  func overturnCameraClick(btn:UIButton){
    let currentDevice = captureDeviceInput?.device
    let currentPosition = currentDevice?.position
    let toChangeDevice: AVCaptureDevice?
    var toChangePosition = AVCaptureDevicePosition.front
    if currentPosition! == .front || currentPosition! == .unspecified {
      toChangePosition = .back
    }
    toChangeDevice = getCameraDeviceWithPosition(toChangePosition)
    do {
      //获得要调整的设备输入对象
      let  toChangeDeviceInput = try AVCaptureDeviceInput(device: toChangeDevice!)
       //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
      captureSession.beginConfiguration()
      //移除原有输入对象
      captureSession.removeInput(captureDeviceInput)
      //添加新的输入对象
      if captureSession.canAddInput(toChangeDeviceInput){
        captureSession.addInput(toChangeDeviceInput)
      }
      captureDeviceInput = toChangeDeviceInput
      //提交会话配置
      captureSession.commitConfiguration()
    }catch{
      debugPrint(error.localizedDescription)
    }
  }
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension VideoRecorderViewController: AVCaptureFileOutputRecordingDelegate{
  func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!){
    enableRotation = true
    let lastBackgroundTaskIdentifier = backgroundTaskIdentifier
    backgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    
    if #available(iOS 9, *){
      let pp = PHPhotoLibrary.shared()
      pp.performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputFileURL)
      }) { (gwc, error) in
        DispatchQueue.main.async {
          debugPrint(error?.localizedDescription as Any,Thread.current)
          self.navigationController?.popViewController(animated: true)
        }
      }
    }else {
      let ass = ALAssetsLibrary()
      ass.writeVideoAtPath(toSavedPhotosAlbum: outputFileURL) { (url, error) in
        debugPrint(error?.localizedDescription as Any)
        self.navigationController?.popViewController(animated: true)
      }
    }
    if lastBackgroundTaskIdentifier != UIBackgroundTaskInvalid {
      UIApplication.shared.endBackgroundTask(lastBackgroundTaskIdentifier!)
    }
   
  }
}
