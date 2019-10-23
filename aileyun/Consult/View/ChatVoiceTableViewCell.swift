//
//  ChatVoiceTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ChatVoiceTableViewCell : BaseChatTableViewCell {

    let voiceBtn = AudioButton()
    
    var voiceLocalPath : String = ""
    var voiceLocalWav : String = ""
    
    var timer : Timer?
    
    var convertSuccess : Bool = true
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(voiceBtn)
        voiceBtn.addTarget(self, action: #selector(ChatVoiceTableViewCell.clickVoice), for: UIControlEvents.touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var viewModel: HC_consultViewmodel? {
        didSet{
            voiceBtn.frame = viewModel?.voiceF ?? CGRect.zero
            let timeStr = viewModel?.model?.createT
            if let timeStr = timeStr {
                let tempS = timeStr.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: ":", with: "")
                voiceLocalPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/" + tempS + ".amr"
                voiceLocalWav = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/" + tempS + ".wav"
                
                if let picList = viewModel?.model?.imageList {
                    let voiceStr = String.init(format: "%@%@", IMAGE_URL, picList)
                    
                    convertAudio(path: voiceStr)
                }
            }
        }
    }
    
    func clickVoice(){
        
        var localURL : URL!
        
        if convertSuccess == true {
            localURL = URL.init(string: voiceLocalWav)
        }else{
            localURL = URL.init(string: voiceLocalPath)
        }
        
        if SharePlayer.shareIntance.audioPlayer.url == localURL {
            if SharePlayer.shareIntance.audioPlayer.isPlaying {
                SharePlayer.shareIntance.audioPlayer.stop()
            }else{
                SharePlayer.shareIntance.audioPlayer.play()
                startTimer()
            }
        }else{
            if SharePlayer.shareIntance.audioPlayer.isPlaying {
                SharePlayer.shareIntance.audioPlayer.stop()
            }
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayback)
                try SharePlayer.shareIntance.audioPlayer = HCAudioPlayer.init(contentsOf: localURL!)
                SharePlayer.shareIntance.audioPlayer.delegate = self
                SharePlayer.shareIntance.audioPlayer.chatVoiceCell = self
                SharePlayer.shareIntance.audioPlayer.play()
                startTimer()
            } catch {
                HCPrint(message: "未能初始化播放器")
            }
        }
    }
    
    func startTimer(){
        var num = 1
        if #available(iOS 10.0, *) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self](t) in
                if num == 1{
                    self?.voiceBtn.voiceIV.image = UIImage.init(named: "hc_yuyin11")
                }else if num == 2{
                    self?.voiceBtn.voiceIV.image = UIImage.init(named: "hc_yuyin22")
                }else if num == 3{
                    self?.voiceBtn.voiceIV.image = UIImage.init(named: "hc_yuyin33")
                    num = 1
                    return
                }
                num = num + 1
            })
        } else {
            // Fallback on earlier versions
        }
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    deinit {
        timer?.invalidate()
    }
  

    
    func convertAudio(path : String){
        if FileManager.default.fileExists(atPath: voiceLocalPath){
            HCPrint(message: "已经有本地语音！")
            
            let url = URL.init(string: self.voiceLocalPath)
            if let url = url {
                let player = try? AVAudioPlayer.init(contentsOf: url)
                if let player = player {
                    DispatchQueue.main.async {
                        HCPrint(message: String.init(format: "%d", NSInteger(player.duration)))
                        self.voiceBtn.secondsLabel.text = String.init(format: "%d'", NSInteger(player.duration))
                        self.voiceBtn.secondsLabel.isHidden = false
                    }
                }
            }

            
            if !FileManager.default.fileExists(atPath: voiceLocalWav){
                DispatchQueue.global().async {[weak self]()in
                    
                    let isSuccess = VoiceConverter.convertAmr(toWav: self?.voiceLocalPath, wavSavePath: self?.voiceLocalWav)
                    HCPrint(message: isSuccess)
                    self?.convertSuccess = isSuccess == 0 ? false : true
                }
            }
        }else{
            HCPrint(message: "没有本地语音！")
            let url = URL.init(string: path)
            DispatchQueue.global().async {
                HttpClient.shareIntance.downloadVoice(url: url!, destiPath: self.voiceLocalPath, callback:{
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        self.convertAudio(path: path)
                    }
                })
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}

extension ChatVoiceTableViewCell : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        voiceBtn.voiceIV.image = UIImage.init(named: "hc_yuyin33")
    }
}
