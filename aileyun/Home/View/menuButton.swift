//
//  menuButton.swift
//  aileyun
//
//  Created by huchuang on 2017/8/10.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class menuButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let ratio : CGFloat = 0.4
        imageView?.frame = CGRect(x: 0, y: 0, width: frame.width * ratio, height: frame.height)
        titleLabel?.frame = CGRect(x: (imageView?.frame.maxX)!, y: 0, width: frame.width * (1 - ratio), height: frame.height)
    }

}
