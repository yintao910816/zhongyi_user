//
//  selbutton.swift
//  aileyun
//
//  Created by huchuang on 2017/6/20.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class selbutton: UIButton {
    
    let imgV = UIImageView()
    let titelL = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        imgV.contentMode = UIViewContentMode.bottom
        self.addSubview(imgV)
        
        titelL.font = UIFont.init(name: kReguleFont, size: 14)
        titelL.textColor = kTextColor
        titelL.textAlignment = NSTextAlignment.center
        self.addSubview(titelL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        let height = self.frame.size.height
        let width = self.frame.size.width
        
        imgV.frame = CGRect.init(x: 0, y: 0, width: width, height: height * 0.6)
        titelL.frame = CGRect.init(x: 0, y: height * 0.6, width: width, height: height * 0.3)
    }


}
