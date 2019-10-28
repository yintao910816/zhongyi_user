//
//  ShareButton.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/7/10.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class ShareButton: UIButton {
    let imgV = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 60))
    
    let titleL = UILabel.init(frame: CGRect.init(x: 0, y: 65, width: 60, height: 10))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imgV)
        imgV.contentMode = .scaleAspectFit
        
        self.addSubview(titleL)
        titleL.font = UIFont.systemFont(ofSize: 10)
        titleL.textAlignment = NSTextAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        //
    }
}
