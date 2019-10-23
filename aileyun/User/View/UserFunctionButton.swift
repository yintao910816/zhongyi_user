//
//  UserFunctionButton.swift
//  aileyun
//
//  Created by huchuang on 2017/8/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class UserFunctionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont.init(name: kReguleFont, size: 14)
        setTitleColor(kLightTextColor, for: UIControlState.normal)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ratio : CGFloat = 0.7
        imageView?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height * ratio)
        titleLabel?.frame = CGRect(x: 0, y: frame.height * (ratio - 0.1), width: frame.width, height: frame.height * (1 - ratio))
    }


}
