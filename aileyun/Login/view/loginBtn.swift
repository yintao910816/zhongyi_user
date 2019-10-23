//
//  loginBtn.swift
//  aileyun
//
//  Created by huchuang on 2017/7/4.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class loginBtn: UIButton {
    
    let imgv = UIImageView()
    let titleL = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleL.textAlignment = NSTextAlignment.left
        titleL.textColor = kTextColor
        titleL.font = UIFont.init(name: kReguleFont, size: 14)
        self.addSubview(titleL)
        
        imgv.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imgv)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        titleL.snp.updateConstraints { (make) in
            make.centerX.equalTo(self).offset(30)
            make.centerY.equalTo(self)
            make.width.equalTo(80)
        }
        
        imgv.snp.updateConstraints({ (make) in
            make.right.equalTo(titleL.snp.left).offset(-10)
            make.centerY.equalTo(self)
            make.width.height.equalTo(32)
        })
        
    }
    
}
