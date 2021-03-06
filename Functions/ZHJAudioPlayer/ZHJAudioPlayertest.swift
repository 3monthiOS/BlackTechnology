//
//  ZHJAudioPlayertest.swift
//  App
//
//  Created by 红军张 on 2017/9/15.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import FreeStreamer
import Dispatch

class ZHJAudioPlayertest: UIViewController {
    // UI
    @IBOutlet weak var playTime: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playTm: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var bigsmall: UISlider!
    @IBOutlet weak var segmentButton: UISegmentedControl!
    @IBOutlet weak var lastMusic: UIButton!
    @IBOutlet weak var nextMusic: UIButton!
    @IBOutlet weak var addMusic: UIButton!
    @IBOutlet weak var misucCount: UILabel!
    @IBOutlet weak var misicIngNumber: UILabel!
    
    //AVPlayer 播放器相关
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    //FSAudioStream 框架
    var streamPlayer = ZHJAudioPlayer.shared
    var isSliding = false               // 决定是谁来控制slider
    var totalSecond: Float = 0.0
    var endChange: Float = 0.0
    var firstChange: Float = 0.0
    
    // 默认是 true  使用的是 FSAudioStream 播放器，因为家在AVPlayer 它比较耗时
    var chosesPlayer = true
    
    // 数据源
    var musicUrl = [String]()
    var musicData = [FSPlaylistItem]()
   
    //MARK: -- 页面消失时取消歌曲播放结束通知监听
    override func viewWillDisappear(_ animated: Bool) {
        if let streamPlayer = self.streamPlayer.player {
            if !streamPlayer.isPlaying() {
                streamPlayer.pause()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        musicUrl = ["https://img.xinrongnews.com/data/20170818/98181503022847437.mp3",
                    "https://img.xinrongnews.com/data/20170823/99111503467789766.mp3",
                    "http://sc1.111ttt.com/2016/4/06/13/199132227259.mp3",
                    "https://img.xinrongnews.com/data/20170823/16831503467601006.mp3",
                    "https://img.xinrongnews.com/data/20170823/84381503456784322.mp3",
                    "https://img.xinrongnews.com/data/20170823/69311503467833640.mp3",
                    "https://img.xinrongnews.com/data/20170823/43191503467534220.mp3",
                    "http://sc1.111ttt.com/2016/5/02/18/195182051017.mp3"]
        for url in musicUrl {
            let item = FSPlaylistItem()
            item.url = URL(string: url)
            musicData.append(item)
        }
        
        segmentButton.selectedSegmentIndex = 0
        playbackSlider.minimumValue = 0.0
        playbackSlider.maximumValue = 1.0
        playbackSlider.setValue(0.0, animated: true)
        
        ZHJAudioPlayer.shared.musicData = musicData
        ZHJAudioPlayer.shared.change = { (totalTime: String,currentTime: String,currentPosion:Float) in
            if currentPosion == 0.0 &&  self.streamPlayer.switchAPPMisuic {
                self.streamPlayer.switchAPPMisuic = false;
                delay(UInt64(1.0), task: {
                    var fsstream = FSStreamPosition()
                    fsstream.position = self.playbackSlider.value
                    ZHJAudioPlayer.shared.player?.activeStream.seek(to: fsstream)
                })
                return;
            }
            self.playTm.text = currentTime
            self.playTime.text = totalTime
            
            if !self.isSliding {
                // 防止滑动 闪烁  播放新歌曲的时候滑动条 归零
                if (self.firstChange - self.endChange) <= 0 {
                    // 快进
                    if self.endChange == 1 {
                        self.playTm.text = totalTime;return
                    }
                    if currentPosion < self.endChange { return}
                } else {
                    // 快退
                    if self.endChange == 1 {
                        self.playTm.text = totalTime;return
                    }
                    if currentPosion > self.firstChange {return}
                }
                self.playbackSlider.setValue(currentPosion, animated: true)
                Log.info("代理 控制 ==\(currentPosion)-------\(self.endChange)")
            } else {
//                Log.info("不是代理控制滑动的 ==\(currentPosion) --------\(self.endChange)")
            }

            if currentPosion == 0.0 {
                self.totalSecond = Float(Int((self.playTime.text?.substring(0, 2)?.int)! * 60) + Int((self.playTime.text?.substring(3, (self.playTime.text?.length)!)?.integer)!))
                Log.info("这首歌曲 总共 \(self.totalSecond) 秒")
            }
        }
        
        misucCount.text = ZHJAudioPlayer.shared.totalMusicCount.string
        
        // 初始化 AVplayer 比较耗时间
//        initAVPlayerFuntion()

        if let streamPlayer = self.streamPlayer.player {
            streamPlayer.onStateChange = { (status)  in
                switch status {
                case .fsAudioStreamStopped:
                    Log.info("停止 播放音乐 不管是手动下一曲还是自动下一曲都会走这个")
                    self.endChange = 0.0
                    self.firstChange = 0.0
                    self.playButton.setTitle("播放", for: .normal)
                case .fsAudioStreamBuffering:
                    Log.info("开始 缓冲音乐")
                case .fsAudioStreamPlaying:
                    Log.info("开始 播放音乐  此时我把 值重置")
                    if self.playButton.currentTitle == "播放" {
                        self.playButton.setTitle("暂停", for: .normal)
                    }
                    self.setInfoCenterCredentials(isStop: false)
                    self.isSliding = false
                case .fsAudioStreamPaused:
                    //只给锁屏界面的进度条 赋值
                    self.setInfoCenterProgress(isStop: true)
                    Log.info("暂停 暂停音乐")
                case .fsAudioStreamSeeking:
                    Log.info("搜索 搜索音乐")
                    self.isSliding = true
                case .fsAudioStreamEndOfFile:
                    if !(streamPlayer.isPlaying()) { // 暂停的情况下 快进 快退
                        streamPlayer.pause()
                    }
                    Log.info("缓冲结束 当前歌曲缓冲完毕 初始化 锁屏界面")
                    self.isSliding = false
                case .fsAudioStreamFailed:
                    Log.info("失败 播放失败")
                    self.isSliding = true
                case .fsAudioStreamRetryingStarted:
                    Log.info("重试 开始重试")
                case .fsAudioStreamRetryingSucceeded:
                    Log.info("重试 成功")
                    self.isSliding = false
                case .fsAudioStreamRetryingFailed:
                    Log.info("重试 失败")
                    self.isSliding = true
                case .fsAudioStreamPlaybackCompleted:
                    Log.info("结束 播放完成 代表着自动播放完成 手动滑动到最后不会走这个 点击下一首也不会走这个")
                    self.isSliding = false
                    self.nextMusicPlay(UIButton())
                case .fsAudioStreamUnknownState:
                    Log.info("歌曲 未知状态")
                default:
                    Log.info(" 歌曲状态 枚举")
                }
                
            }
        }
    }
    
    //MARK: --  添加一首歌曲  其实就是 重新进来这个页面加载另一首歌曲
    @IBAction func addMusicItem(_ sender: Any) {
        if chosesPlayer {
            if let streamPlayer = self.streamPlayer.player {
                let number = (misucCount.text?.integer)! - 1
                streamPlayer.add(musicData[number+1])
                
                misucCount.text = Int(streamPlayer.countOfItems()).string
                Log.info("总共 几首歌曲 \(streamPlayer.countOfItems())")
            }
        } else {
            
        }
    }
    //MARK: --  切换
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        if let streamPlayer = self.streamPlayer.player  {streamPlayer.pause()}
        if let player = self.player {player.pause()}
        if sender.selectedSegmentIndex == 1 {
            chosesPlayer = false
        } else {
            chosesPlayer = true
        }
    }
    
    //MARK: -- 播放按钮点击
    @IBAction func playButtonTapped(_ sender: Any) {
        if chosesPlayer {
            if let streamPlayer = self.streamPlayer.player  {
                streamPlayer.activeStream.pause()
                if playButton.currentTitle == "暂停" {
                    playButton.setTitle("播放", for: .normal)
                } else {
                    playButton.setTitle("暂停", for: .normal)
                    var fsstream = FSStreamPosition()
                    fsstream.position = self.playbackSlider.value
                    if  self.streamPlayer.switchAPPMisuic {
                        var offset = FSSeekByteOffset()
                        offset.position = self.playbackSlider.value
                        streamPlayer.activeStream?.play(from: offset)
//                        streamPlayer.activeStream?.play()
                    } else {
                        streamPlayer.activeStream.seek(to: fsstream)
                    }
                    
                    print("我将要从这里开始播放-----\(self.firstChange) ---- \(self.endChange)  --- \(String(describing: streamPlayer.activeStream.currentTimePlayed.position))     \(self.playbackSlider.value)")
                }
                ZHJAudioPlayer.shared.getCacheSize()
            }
        } else {
            if let player = self.player {
                //根据rate属性判断当天是否在播放
                if player.rate == 0 {
                    player.play()
                    playButton.setTitle("暂停", for: .normal)
                    setInfoCenterCredentials(isStop: false)
                } else {
                    player.pause()
                    playButton.setTitle("播放", for: .normal)
                    //后台播放显示信息进度停止
                    setInfoCenterCredentials(isStop: true)
                }
            }
        }
    }
    //MARK: --  改变声音大小
    @IBAction func changeMusicBigsmall(_ sender: UISlider) {
        if let player = self.player {
            player.volume = sender.value
        }
        if let streamPlayer = self.streamPlayer.player  {
            streamPlayer.volume = sender.value/10
        }
    }
    //MARK: --  上一首
    @IBAction func lastMusicPlay(_ sender: Any) {
        if chosesPlayer {
            guard self.streamPlayer.player != nil  else {return}
            ZHJAudioPlayer.shared.lastMusicPlay()
        }else{
            
        }
    }
    //MARK: --  下一首
    @IBAction func nextMusicPlay(_ sender: UIButton) {
        if chosesPlayer {
            guard self.streamPlayer.player != nil  else {return}
            ZHJAudioPlayer.shared.nextMusicPlay()
        }else{
            
        }
    }
    //MARK: --  时间进度条 slider
  
    @IBAction func playnakSliderTuochdown(_ sender: UISlider) {
        firstChange = sender.value
        self.isSliding = true
    }
    @IBAction func playbackSliderValueChanged(_ sender: UISlider) {
        if chosesPlayer {
            if let streamPlayer = self.streamPlayer.player  {
                if let play = streamPlayer.activeStream {
                    self.isSliding = false
                    self.endChange = sender.value
                    if sender.value == 1.0 { // 手动下一首
                        nextMusicPlay(UIButton())
                    } else {
                        var value = FSStreamPosition()
                        value.position = sender.value
                        play.seek(to: value)
                    }
                }
            }
        } else {
            let seconds : Int64 = Int64(playbackSlider.value)
            let targetTime:CMTime = CMTimeMake(seconds, 1)
            if let player = self.player {
                //播放器定位到对应的位置
                player.seek(to: targetTime)
                //如果当前时暂停状态，则自动播放
                if player.rate == 0
                {
                    player.play()
                    playButton.setTitle("暂停", for: .normal)
                }
            }
        }
    }
    
    //MARK: -- 播放器的监听
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = object as? AVPlayerItem else { return }
        if keyPath == "status"{
            // 监听状态改变
            if playerItem.status == AVPlayerItemStatus.readyToPlay {
                gettotalTime()
                //                self.player?.play()
                //                playButton.setTitle("暂停", for: .normal)
            } else if playerItem.status == AVPlayerItemStatus.failed {
                toast("加载失败，网络或者服务器出现问题")
            } else {
                toast("未知状态")
            }
        }
        if keyPath == "loadedTimeRanges" {
            let array = playerItem.loadedTimeRanges
            let timeRange: CMTimeRange = array.first as! CMTimeRange //本次缓冲的时间范围
            let totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
            Log.info(totalBuffer)
        }
    }
    
    //MARK: ------------------------------ 页面显示时添加歌曲播放结束通知监听----------------------------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        //告诉系统接受远程响应事件，并注册成为第一响应者
        UIApplication.shared.beginReceivingRemoteControlEvents()
        self.becomeFirstResponder()
    }
    
    
    //是否能成为第一响应对象
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: --  设置后台播放显示信息
    func setInfoCenterCredentials(isStop: Bool) {
        let mpic = MPNowPlayingInfoCenter.default()
        
        //专辑封面
        let mySize = CGSize(width: 400, height: 400)
        let albumArt: MPMediaItemArtwork?
        if #available(iOS 10.0, *) {
            albumArt = MPMediaItemArtwork(boundsSize:mySize) { sz in
                return UIImage(named: "1")!
            }
        } else {
            // Fallback on earlier versions
            albumArt = MPMediaItemArtwork(image: UIImage(named: "1")!)
        }
        let total = (self.playTime.text?.substring(0, 2)?.integer)! * 60 + (self.playTime.text?.substring(3, (self.playTime.text?.length)!)?.integer)!
        let currentSecondS = (self.playTm.text?.substring(0, 2)?.integer)! * 60 + (self.playTm.text?.substring(3, (self.playTm.text?.length)!)?.integer)!
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle: "我是歌曲标题",
                               MPMediaItemPropertyAlbumTitle: "专辑名称",
                               MPMediaItemPropertyArtist: "张红军",
                               MPMediaItemPropertyArtwork: albumArt ?? MPMediaItemArtwork(image: UIImage(named: "1")!),
                               MPNowPlayingInfoPropertyElapsedPlaybackTime: currentSecondS,// 已经播放的时间
                               MPMediaItemPropertyPlaybackDuration: total,
                               MPNowPlayingInfoPropertyPlaybackRate: isStop ? 0.0 : 1.0]// 默认就是正常速率
        
    }
    
    //MARK: --  快进的时候 设置后台播放 进度
    func setInfoCenterProgress(isStop: Bool) {
        var mpic = MPNowPlayingInfoCenter.default().nowPlayingInfo
        let total = (self.playTime.text?.substring(0, 2)?.integer)! * 60 + (self.playTime.text?.substring(3, (self.playTime.text?.length)!)?.integer)!
        let currentSecondS = (self.playTm.text?.substring(0, 2)?.integer)! * 60 + (self.playTm.text?.substring(3, (self.playTm.text?.length)!)?.integer)!
        mpic![MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentSecondS
        mpic![MPMediaItemPropertyPlaybackDuration] = total
        mpic![MPNowPlayingInfoPropertyPlaybackRate] = isStop ? 0.0 : 1.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = mpic
    }
    
    //MARK: --  后台操作
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {print("no event\n");return}
        guard let streamPlayer = self.streamPlayer.player else {print("无播放器");return}
        
        if event.type == UIEventType.remoteControl {
            switch event.subtype {
            case .remoteControlTogglePlayPause:
                print("暂停/播放")
            case .remoteControlPreviousTrack:
                ZHJAudioPlayer.shared.lastMusicPlay()
                print("上一首")
            case .remoteControlNextTrack:
                ZHJAudioPlayer.shared.lastMusicPlay()
                print("下一首")
            case .remoteControlPlay:
                streamPlayer.activeStream.pause()
                if playButton.currentTitle == "暂停" {
                    playButton.setTitle("播放", for: .normal)
                } else {
                    playButton.setTitle("暂停", for: .normal)
                }
                print("播放")
            case .remoteControlPause:
                print("暂停")
                streamPlayer.activeStream.pause()
                if playButton.currentTitle == "暂停" {
                    playButton.setTitle("播放", for: .normal)
                } else {
                    playButton.setTitle("暂停", for: .normal)
                }
            default:
                break
            }
        }
    }
    
    deinit {
        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
        self.playerItem?.removeObserver(self, forKeyPath: "status")
        NotificationCenter.default.removeObserver(self)
        //停止接受远程响应事件
        UIApplication.shared.endReceivingRemoteControlEvents()
        self.resignFirstResponder()
        if let streamPlayer = self.streamPlayer.player {
            streamPlayer.stop()
        }
    }
    
}


