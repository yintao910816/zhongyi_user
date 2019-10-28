//
//  titleImageButton.swift
//  aileyun
//
//  Created by huchuang on 2017/7/25.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class titleImageButton: UIButton {
    
    var textCol : UIColor? {
        didSet{
            titleL.textColor = textCol
            borderTitleL.textColor = textCol
            borderTitleL.layer.borderColor = textCol?.cgColor
        }
    }
    
    lazy var titleL : UILabel = {
        let t = UILabel()
        t.font = UIFont.init(name: kBoldFont, size: kTextSize)
        return t
    }()
    
    lazy var contentL : UILabel = {
        let c = UILabel()
        c.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        c.textColor = kLightTextColor
        return c
    }()

    lazy var borderTitleL : UILabel = {
        let b = UILabel()
        b.font = UIFont.init(name: kReguleFont, size: kTextSize - 2)
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 10
        b.textAlignment = NSTextAlignment.center
        return b
    }()
    
    let imgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.addSubview(imgV)
        imgV.contentMode = .scaleToFill
        imgV.clipsToBounds = true
        
        self.addSubview(titleL)
        self.addSubview(contentL)
        self.addSubview(borderTitleL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        imgV.snp.updateConstraints { (make) in
            make.width.height.equalTo(120)
            make.right.bottom.equalTo(self)
        }
        titleL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(20)
        }
        contentL.snp.updateConstraints { (make) in
            make.left.equalTo(titleL)
            make.top.equalTo(titleL.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        borderTitleL.snp.updateConstraints { (make) in
            make.left.equalTo(titleL)
            make.top.equalTo(contentL.snp.bottom).offset(5)
            make.height.equalTo(22)
            make.width.equalTo(50)
        }
    }
}
