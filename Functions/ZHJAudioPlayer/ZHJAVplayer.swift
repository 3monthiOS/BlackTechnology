//
//  ZHJAVplayer.swift
//  App
//
//  Created by 红军张 on 2017/9/19.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation

extension ZHJAudioPlayertest {
    
    func initAVPlayerFuntion(){
        async {
            // 音量
            self.bigsmall.transform = CGAffineTransform.identity.rotated(by: CGFloat(-Double.pi/2))
            self.bigsmall.minimumValue = 0
            self.bigsmall.maximumValue = 10
            
            //初始化播放器
            self.playNetworkMusic()
            //        getLocationMusicData()
            // 设置是否静音
            self.player?.isMuted = false
            
            //设置进度条相关属性
            let duration : CMTime = self.playerItem!.asset.duration
            let seconds : Float64 = CMTimeGetSeconds(duration)
            self.playbackSlider!.minimumValue = 0
            self.playbackSlider!.maximumValue = Float(seconds)
            self.playbackSlider!.isContinuous = false
            
            //播放过程中动态改变进度条值和时间标签
            self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1),queue: DispatchQueue.main) { (CMTime) -> Void in
                if self.player!.currentItem?.status == .readyToPlay && self.player?.rate != 0 {
                    //更新进度条进度值
                    let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                    self.playbackSlider!.value = Float(currentTime)
                    //更新播放时间
                    self.playTm!.text = self.computationsTotalTimeFuntion(time: currentTime)
                    //设置后台播放显示信息
                    self.setInfoCenterCredentials(isStop: false)
                }
            }
            // 添加 缓存进度监听和播放状态监听
            self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
            self.playerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }

    // 初始化 播放器
    func playNetworkMusic(){
        let url = URL(string: "https://img.xinrongnews.com/data/20170818/98181503022847437.mp3")
        self.playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem!)
    }
    func getLocationMusicData() {
        let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: "", ofType: "")!)
        self.player = AVPlayer(url: url as URL)
        self.playerItem = player?.currentItem
    }

    //获取音频的总时间
    func gettotalTime(){
        let totalTime = CMTimeGetSeconds((self.playerItem?.duration)!)
        //更新播放时间
        self.playTime!.text = computationsTotalTimeFuntion(time: totalTime)
    }

    //歌曲播放完毕
    func finishedPlaying(myNotification:NSNotification) {
        print("播放完毕!")
        let stopedPlayerItem: AVPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: kCMTimeZero)
    }
    
    func computationsTotalTimeFuntion(time: Float64) -> String{
        let all:Int=Int(time)
        let m:Int=all % 60
        let f:Int=Int(all/60)
        var times:String=""
        if f<10{
            times="0\(f):"
        }else {
            times="\(f)"
        }
        
        if m<10{
            times+="0\(m)"
        }else {
            times+="\(m)"
        }
        return times
    }
}
