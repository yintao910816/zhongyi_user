//
//  chooseButton.swift
//  aileyun
//
//  Created by huchuang on 2017/6/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class chooseButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.init(name: kReguleFont, size: 13)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.setTitleColor(kTextColor, for: .normal)
        self.setTitleColor(kDefaultThemeColor, for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
