//
//  SharePlayer.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SharePlayer: NSObject {
    // 设计成单例
    static let shareIntance : SharePlayer = {
        let tools = SharePlayer()
        return tools
    }()

    lazy var audioPlayer : HCAudioPlayer = {
        
        var p = HCAudioPlayer.init()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            let pathS = Bundle.main.path(forResource: "defaultVoice.wav", ofType: nil)
            let url = URL.init(string: pathS!)
            try p = HCAudioPlayer.init(contentsOf: url!)
            p.prepareToPlay()
            return p
        } catch {
            HCPrint(message: "播放器初始化失败")
        }
        return p
    }()
    
}
