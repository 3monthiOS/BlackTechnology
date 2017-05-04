//
//  GifViewController.swift
//  App
//
//  Created by 红军张 on 2017/5/3.
//  Copyright © 2017年 IndependentRegiment. All rights reserved.
//

import UIKit
import SwiftyGif

class GifViewController: APPviewcontroller {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var rewindButton: UIButton!
    
    var gifName: UIImage?
    let gifManager = SwiftyGifManager(memoryLimit:60)
    var _rewindTimer: Timer?
    var _forwardTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GIF"
        contentView?.addSubview(imageView)
        contentView?.addSubview(playPauseButton)
        contentView?.addSubview(forwardButton)
        contentView?.addSubview(rewindButton)
        
        self.imageView.delegate = self
        
        if let imgName = self.gifName {
            self.imageView.setGifImage(imgName, manager: gifManager, loopCount: -1)
        }
        
        // Gestures for gif control
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(self.panGesture))
        self.imageView.addGestureRecognizer(panGesture)
        self.imageView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.togglePlay))
        self.imageView.addGestureRecognizer(tapGesture)
    }
    
    // PRAGMA - Logic
    
    func rewind(){
        self.imageView.showFrameForIndexDelta(-1)
    }
    
    func forward(){
        self.imageView.showFrameForIndexDelta(1)
    }
    
    func stop(){
        self.imageView.stopAnimatingGif()
        self.playPauseButton.setTitle("►", for: .normal)
    }
    
    func play(){
        self.imageView.startAnimatingGif()
        self.playPauseButton.setTitle("❚❚", for: .normal)
    }
    
    // PRAGMA - Actions
    
    @IBAction func togglePlay(){ // 暂停和播放
        if self.imageView.isAnimatingGif() {
            stop()
        }else {
            play()
        }
    }
    
    @IBAction func rewindDown(){ // 快退
        stop()
        _rewindTimer = Timer.scheduledTimer(timeInterval: 1.0/30.0, target: self, selector: #selector(self.rewind), userInfo: nil, repeats: true)
    }
    
    @IBAction func rewindUp(){ // 退一步
        _rewindTimer?.invalidate()
        _rewindTimer = nil
    }
    
    @IBAction func forwardDown(){ // 快进
        stop()
        _forwardTimer = Timer.scheduledTimer(timeInterval: 1.0/30.0, target: self, selector: #selector(self.forward), userInfo: nil, repeats: true)
    }
    
    @IBAction func forwardUp(){ // 进一帧
        _forwardTimer?.invalidate()
        _forwardTimer = nil
    }
    
    // PRAGMA - Gestures
    
    func panGesture(sender:UIPanGestureRecognizer){
        
        switch sender.state {
        case .began:
            stop()
            break
            
        case .changed:
            if sender.velocity(in: sender.view).x > 0 {
                forward()
            } else{
                rewind()
            }
            break
            
        default:
            break
        }
    }
}
extension GifViewController : SwiftyGifDelegate {
    
    func gifDidStart() {
        print("gifDidStart")
    }
    
    func gifDidLoop() {
        print("gifDidLoop")
    }
    
    func gifDidStop() {
        print("gifDidStop")
    }
}
