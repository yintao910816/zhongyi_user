//
//  AudioButton.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/22.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class AudioButton: UIButton {

    let secondsLabel = UILabel()
    let voiceIV = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        
        secondsLabel.text = "12'"
        secondsLabel.textColor = UIColor.white
        self.addSubview(secondsLabel)
        secondsLabel.isHidden = true
        
        voiceIV.image = UIImage.init(named: "hc_yuyin33")
        voiceIV.contentMode = UIViewContentMode.right
        self.addSubview(voiceIV)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        secondsLabel.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.centerY.equalTo(self)
        }
        
        voiceIV.snp.updateConstraints({ (make) in
            make.right.equalTo(self).offset(-20)
            make.centerY.equalTo(self)
            make.width.height.equalTo(30)
        })
    }
}
