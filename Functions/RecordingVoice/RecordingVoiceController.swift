//
//  RecordingVoiceController.swift
//  App
//
//  Created by 红军张 on 2017/6/12.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit

class RecordingVoiceController: APPviewcontroller {

    @IBOutlet weak var paly: UIButton!
    @IBOutlet weak var recording: UIButton!
    @IBOutlet weak var voiceSize: UILabel!
    @IBOutlet weak var BtnView: UIView!
    
    var recorder:AVAudioRecorder? //录音器
    var player:AVAudioPlayer? //播放器
    var recorderSeetingsDic:[String : Any]? //录音器设置参数数组
    var volumeTimer:Timer! //定时器线程，循环监测录音的音量大小
    var aacPath:String? //录音存储路径
    
    override func setup() {
        super.setup()
        contentView?.addSubview(voiceSize)
        contentView?.addSubview(BtnView)
        
        
        // 初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // 设置录音类型
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        // 设置支持后台
        try! session.setActive(true)
        // 获取document目录
        let docdir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        // 组合录音文件路径
        aacPath = docdir+"/play.aac"
        // 初始化字典 并添加设置参数
        recorderSeetingsDic = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,// 录音的声道数量
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 320000,
            AVSampleRateKey: 44100.0 // 录音器美妙采集的录音样本数
        ]
    }

    // 停止录音
    @IBAction func RecordingBtn(_ sender: UIButton) {
        // 停止录音
        recorder?.stop()
        // 录音器释放
        recorder = nil
        // 暂停定时器
        volumeTimer.invalidate()
        volumeTimer = nil
        voiceSize.text = "录音音量：0"
    }
    // 长安录音
    @IBAction func touchDownBtn(_ sender: Any) {
        // 初始化录音器
        recorder = try! AVAudioRecorder(url: URL(string: aacPath!)!, settings: recorderSeetingsDic!)
        if recorder != nil {
            // 开启仪表计数功能
            recorder?.isMeteringEnabled = true
            // 准备录音
            recorder?.prepareToRecord()
            // 开始录音
            recorder?.record()
            // 启动定时器，定时更新录音音量
            if #available(iOS 10.0, *) {
                volumeTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (t) in
                    self.recorder?.updateMeters()
                    _ = self.recorder?.averagePower(forChannel: 0)// 获取音量平均值
                    let maxV = self.recorder?.peakPower(forChannel: 0) // 获取音量最大值
                    let lowpassResult = pow(10, Double(0.05*maxV!))
                    self.voiceSize.text = "录音音量：\(lowpassResult)"
                })
            } else {
                volumeTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(levelTimer), userInfo: nil, repeats: true)
            }
        }
    }
     // 播放
    @IBAction func playBtn(_ sender: UIButton) {
        player = try! AVAudioPlayer(contentsOf: URL(string: aacPath!)!)
        if player == nil {
            Log.info("播放失败")
        }else{
            player?.play()
        }
    }
    // 定时器
    func levelTimer() {
        recorder?.updateMeters()
        _ = recorder?.averagePower(forChannel: 0)// 获取音量平均值
        let maxV = recorder?.peakPower(forChannel: 0) // 获取音量最大值
        let lowpassResult = pow(10, Double(0.05*maxV!))
        voiceSize.text = "录音音量：\(lowpassResult)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
