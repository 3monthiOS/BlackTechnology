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
    
    //FSAudioStream
    var streamPlayer = ZHJAudioPlayer.shared
    var chosesPlayer = true
    var currentPosionbeifen: Float = 0.0
    // 数据源
    var musicUrl = [String]()
    var musicData = [FSPlaylistItem]()
    var totalSecond: Float = 0 {
        didSet{
            intervalValue = Float((1 - 0.1)/totalSecond * 2)
        }
    }
    var intervalValue: Float = 0.0
    //MARK: -- 页面消失时取消歌曲播放结束通知监听
    override func viewWillDisappear(_ animated: Bool) {
        if let streamPlayer = self.streamPlayer.player {
            streamPlayer.pause()
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
            self.playTm.text = currentTime
            self.playTime.text = totalTime
            if fabsf(currentPosion - self.currentPosionbeifen) < (1 - 0.1)/self.totalSecond || self.currentPosionbeifen == 0.0 || currentPosion == 0.0 {
                self.currentPosionbeifen = currentPosion
                self.playbackSlider.setValue(currentPosion, animated: true)
            }
            if self.totalSecond == 0 && currentPosion == 0.0 {
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
                    Log.info("停止 播放音乐")
                case .fsAudioStreamBuffering:
                    Log.info("开始 缓冲音乐")
                case .fsAudioStreamPlaying:
                    self.totalSecond = 0
                    self.currentPosionbeifen = 0.0
                    Log.info("开始 播放音乐   此时我把 值重置")
                case .fsAudioStreamPaused:
                    self.setInfoCenterProgress()
                    Log.info("暂停 暂停音乐")
                case .fsAudioStreamSeeking:
                    Log.info("搜索 搜索音乐")
                case .fsAudioStreamEndOfFile:
                    self.setInfoCenterCredentials()
                    Log.info("缓冲结束 当前歌曲缓冲完毕 初始化 锁屏界面")
                case .fsAudioStreamFailed:
                    Log.info("失败 播放失败")
                case .fsAudioStreamRetryingStarted:
                    Log.info("重试 开始重试")
                case .fsAudioStreamRetryingSucceeded:
                    Log.info("重试 成功")
                case .fsAudioStreamRetryingFailed:
                    Log.info("重试 失败")
                case .fsAudioStreamPlaybackCompleted:
                    Log.info("结束 播放完成 ")
                case .fsAudioStreamUnknownState:
                    Log.info("歌曲 未知状态")
                default:
                    Log.info(" 歌曲状态 枚举")
                }
                // 添加代理
                if let play = streamPlayer.activeStream  {
                    play.delegate = ZHJAudioPlayer.shared
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
                }
                ZHJAudioPlayer.shared.getCacheSize()
            }
        } else {
            if let player = self.player {
                //根据rate属性判断当天是否在播放
                if player.rate == 0 {
                    player.play()
                    playButton.setTitle("暂停", for: .normal)
                } else {
                    player.pause()
                    playButton.setTitle("播放", for: .normal)
                    //后台播放显示信息进度停止
                    setInfoCenterCredentials()
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
        currentPosionbeifen = 0.0
    }
    //MARK: --  下一首
    @IBAction func nextMusicPlay(_ sender: UIButton) {
        if chosesPlayer {
            guard self.streamPlayer.player != nil  else {return}
            ZHJAudioPlayer.shared.nextMusicPlay()
        }else{
            
        }
        currentPosionbeifen = 0.0
    }
    //MARK: --  拖动进度条改变值时触发
    @IBAction func playbackSliderValueChanged(_ sender: UISlider) {
        if chosesPlayer {
            if let streamPlayer = self.streamPlayer.player  {
                if let play = streamPlayer.activeStream {
                    self.currentPosionbeifen = sender.value + self.intervalValue
                    var value = FSStreamPosition()
                    value.position = sender.value
                    play.seek(to: value)
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
    func setInfoCenterCredentials() {
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
                               MPNowPlayingInfoPropertyPlaybackRate: 1.0]// 默认就是正常速率
        
    }
    
    //MARK: --  快进的时候 设置后台播放 进度
    func setInfoCenterProgress() {
        var mpic = MPNowPlayingInfoCenter.default().nowPlayingInfo
        let total = (self.playTime.text?.substring(0, 2)?.integer)! * 60 + (self.playTime.text?.substring(3, (self.playTime.text?.length)!)?.integer)!
        let currentSecondS = (self.playTm.text?.substring(0, 2)?.integer)! * 60 + (self.playTm.text?.substring(3, (self.playTm.text?.length)!)?.integer)!
        mpic = [MPNowPlayingInfoPropertyElapsedPlaybackTime: currentSecondS,// 已经播放的时间
            MPMediaItemPropertyPlaybackDuration: total,
            MPNowPlayingInfoPropertyPlaybackRate: 1.0]// 默认就是正常速率
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

