//
//  moreButton.swift
//  aileyun
//
//  Created by huchuang on 2017/6/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class moreButton: UIButton {

    let imgV = UIImageView()
    let titelL = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        titelL.text = "更多超值服务"
        titelL.font = UIFont.init(name: kReguleFont, size: 14)
        titelL.textColor = kTextColor
        titelL.textAlignment = NSTextAlignment.right
        self.addSubview(titelL)
        
        imgV.image = UIImage.init(named: "箭头")
        imgV.contentMode = UIViewContentMode.left
        self.addSubview(imgV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        let height = self.frame.size.height
        let width = self.frame.size.width
        
        titelL.frame = CGRect.init(x: 0, y: 0, width: width * 0.7, height: height)
        imgV.frame = CGRect.init(x: width * 0.8, y: 0, width: width * 0.2, height: height)
    }

}
