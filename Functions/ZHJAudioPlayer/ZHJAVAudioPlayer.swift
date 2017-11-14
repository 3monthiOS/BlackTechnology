//
//  ZHJAVAudioPlayer.swift
//  App
//
//  Created by 红军张 on 2017/9/15.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import Foundation
import AVFoundation
import FreeStreamer

typealias changeBlock = (_ totalTime: String,_ currentTime: String,_ currentPosion: Float) -> Void

class ZHJAudioPlayer : NSObject {
    static let shared = ZHJAudioPlayer()
    // 播放器
    var player: FSAudioController?
    // 播放器配置 可选
    let configuration = FSStreamConfiguration()
    // 当前歌曲 url
    private var firstMusicUrl: String?{
        didSet{
            initAVAudioPlayerFuntion(url: firstMusicUrl!)
        }
    }
    // 定时器
    var change:changeBlock?
    // 总时间
    var totalTime: String = "00:00"
    // 当前时间
    var currentTime: String = "00:00" //请设置默认时间为 "00:00"
    // 当前进度
    var currentPosion: Float = 0.0
    // 音量控制
    var volume: Float?
    // 是不是切换到了后台
    var switchAPPMisuic = false
    // 数据源
    var musicData = [FSPlaylistItem](){
        didSet{
            getCurrentMusicUrldata()
        }
    }
    // 当前正在播放第几首歌曲
    var currentMusicNumber = 1
    // 共有几首歌曲
    var totalMusicCount = 0
    //
    private var musicUrls = [String]()
    
    //MARK: --  初始化
    override init() {
        super.init()
        configurationFuntion()
    }

    func configurationFuntion(){
        //缓存区数量
        configuration.bufferCount = 6
        // 每个缓冲区的大小。
        configuration.bufferSize = 20
        // 包描述大小
        configuration.maxPacketDescs = 6
        // HTTP连接缓冲区大小。
        configuration.httpConnectionBufferSize = 6
        // 输出采样率。
        configuration.outputSampleRate = 6
        // 是否边播放便保存
        configuration.cacheEnabled = true
        // 缓存目录
        //        configuration.cacheDirectory = ""
        // 自动处理音频会话的属性
        configuration.automaticAudioSessionHandlingEnabled = true
    }
    
    func initAVAudioPlayerFuntion(url: String) {
        if player != nil {return}
        player = FSAudioController(url: URL(string: url))
        guard let streamPlayer = player else {return}
        // 一进来就开始播放
        streamPlayer.play(from: URL(string: url))
        // 添加 磁带
        let item = FSPlaylistItem()
        item.url = URL(string: url)
        streamPlayer.add(item)
        
        //        streamPlayer.configuration = configurationFuntion()
        streamPlayer.delegate = self
        // 是否默认加载下一个音频数据
        streamPlayer.preloadNextPlaylistItemAutomatically = true
        // 打印调试日志
        streamPlayer.enableDebugOutput = true
        // 自动处理音频会话的属性
        streamPlayer.automaticAudioSessionHandlingEnabled = true
        
    }
    
    func getCurrentMusicUrldata(){
        if musicData.count<1 {return}
        // 不能重复添加
        let number0:UInt =  UInt(musicData.count)
        if number0 == player?.countOfItems() {return}
        for obj in musicData {
            musicUrls.append(obj.url.absoluteString)
        }
        firstMusicUrl = musicUrls[0]
        for obj in musicData {
            if obj.url.absoluteString != firstMusicUrl {
                addMusicData(item: obj)
            }
        }
    }
    //MARK: --  增加一首歌曲 （增加一张磁带）
    func addMusicData(item:FSPlaylistItem){
        if let streamPlayer = player {
            streamPlayer.add(item)
            totalMusicCount = Int(streamPlayer.countOfItems())
            Log.info("总共 几首歌曲 \(streamPlayer.countOfItems())")
        }
    }
    //MARK: --  删除指定索引歌曲
    func addMusicData(index: UInt){
        if let streamPlayer = player {
            streamPlayer.removeItem(at: index)
        }
    }
    
    //MARK: --  上一首
    func lastMusicPlay() {
        if let streamPlayer = self.player  {
            streamPlayer.playPreviousItem()
        }
    }
    //MARK: --  下一首
    func nextMusicPlay() {
        if let streamPlayer = self.player  {
            streamPlayer.playNextItem()
        }
    }
    
    //MARK: --  时间
    func initPlayerTime(){
        if let streamPlayer = player  {
            // 设置时间
            if let play = streamPlayer.activeStream {
                if play.currentTimePlayed.playbackTimeInSeconds > 0 {
                    let minute = play.currentTimePlayed.minute > 10 ? play.currentTimePlayed.minute.description : "0" + play.currentTimePlayed.minute.description
                    let second = play.currentTimePlayed.second < 10 ? "0" + play.currentTimePlayed.second.description : play.currentTimePlayed.second.description
                    currentTime = minute + ":" + second
                }
                if play.duration.playbackTimeInSeconds > 0 && self.currentTime == "00:00" {
                    let minute = play.duration.minute > 10 ? play.duration.minute.description : "0" + play.duration.minute.description
                    totalTime = minute + ":" + (play.duration.second.description.int < 10 ? "0" + play.duration.second.description : play.duration.second.description)
                }
            }
            guard self.change != nil else { return }
            if currentPosion <= 1 {
                change!(totalTime,currentTime,currentPosion)
            }
            
            // 设置当前正在播放第几首歌曲
            guard let item = streamPlayer.currentPlaylistItem  else {return}
            for i:Int in 0..<musicUrls.count {
                let musicName = item.url.absoluteString
                let url = musicUrls[i]
                if url == musicName {
                    if i != self.currentMusicNumber {
                        self.currentMusicNumber = i
                    }
                }
            }
        }
    }
    
    //MARK: --  歌曲缓存信息 待完善
    func getCacheSize(){
        initPlayerTime()
        if let audioStream = player {
            //            var totalCacheSize = 0
            var array = [String]()
            do {
                array = try! FileManager.default.contentsOfDirectory(atPath: audioStream.configuration.cacheDirectory)
            } catch  {
                Log.error(error)
            }
            for str: String in array {
                Log.info(" \(audioStream.configuration.cacheDirectory) 目录下面都是啥 \(str)")
            }
        }
    }
    //MARK: --  缓存
    
    func cleanLocationMusicData(){ // 缓存清理
        if let audioStream = player {
            audioStream.activeStream.expungeCache()
        }
    }
    
//    func sdasadfffas(){
//        FSStreamPosition cur = self.audioStream.currentTimePlayed;
//        self.playbackTime =cur.playbackTimeInSeconds/1;
//        self.ProgressView.progress = cur.position;//播放进度
//        self.progress = cur.position;
//        float  prebuffer = (float)self.audioStream.prebufferedByteCount;
//        float contentlength = (float)self.audioStream.contentLength;
//
//        if (contentlength>0) {
//            self.ProgressView.cacheProgress = prebuffer /contentlength;//缓存进度
//        }
//    }
}

extension ZHJAudioPlayer: FSAudioControllerDelegate {
    func audioController(_ audioController: FSAudioController!, preloadStartedFor stream: FSAudioStream!) {
        let title = audioController.currentPlaylistItem.title
        let url = audioController.currentPlaylistItem.url
        let originatingUrl = audioController.currentPlaylistItem.originatingUrl
        let size = audioController.currentPlaylistItem.audioDataByteCount/1024
        Log.info("歌曲信息：歌名\(String(describing: title)) 歌曲链接 \(String(describing: url)) 歌曲缓存地址：\(String(describing: originatingUrl)) 歌曲大小 \(size)")
    }
    func audioController(_ audioController: FSAudioController!, allowPreloadingFor stream: FSAudioStream!) -> Bool {
        // 每次切换歌曲的时候 都要给当前歌曲添加代理
        if let play = audioController.activeStream  {
            play.delegate = self
        }
        return true
    }
}
extension ZHJAudioPlayer: FSPCMAudioStreamDelegate {
    func audioStream(_ audioStream: FSAudioStream!, samplesAvailable samples: UnsafeMutablePointer<AudioBufferList>!, frames: UInt32, description: AudioStreamPacketDescription) {
        DispatchQueue.main.async {
            if self.currentPosion != 1 {
                if let streamPlayer = self.player  {
                    if let play = streamPlayer.activeStream {
                        self.currentPosion = play.currentTimePlayed.position
                    }
                }
                self.initPlayerTime()
            } else {
                let posion = audioStream?.currentTimePlayed.position ?? 0
                if posion > 0.0 && posion < 0.001 {
                    self.currentPosion = posion
                }
            }
        }
    }
}
/**
    还有那些问题没有解决
 1. 播放下一首的同事点击暂停按钮 导致歌曲在播放但是进度条和时间不变化，代理方法也没有走
 解决思路（每次音乐开始播放的时候 设置一个bool值 当代理方法进去第一次的时候就是true 没有进入代理方法的时候就是 false， 只有当值是true的时候点击暂停才会暂停否则就return）
*/
