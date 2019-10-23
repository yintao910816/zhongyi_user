//
//  imageButton.swift
//  aileyun
//
//  Created by huchuang on 2017/6/20.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class imageButton: UIButton {

    let imgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.addSubview(imgV)
        imgV.contentMode = UIViewContentMode.scaleToFill
        imgV.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        imgV.frame = bounds
    }

}
