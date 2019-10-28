//
//  SharePlayer.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/18.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class SharePlayer: NSObject {
    var audioPlayer: HCAudioPlayer!
    // 设计成单例
    static let shareIntance : SharePlayer = {
        let tools = SharePlayer()
        return tools
    }()

    override init() {
        super.init()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            let pathS = Bundle.main.path(forResource: "defaultVoice", ofType: "wav")!
            let url = URL.init(fileURLWithPath: pathS)
            try audioPlayer = HCAudioPlayer.init(contentsOf: url)
            audioPlayer.prepareToPlay()
        } catch {
            HCPrint(message: "播放器初始化失败")
        }
    }
        
}
