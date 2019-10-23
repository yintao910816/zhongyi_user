//
//  GroupManagerViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    lazy var infoL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 10)
        l.layer.borderColor = kDefaultThemeColor.cgColor
        l.layer.borderWidth = 1
        l.layer.cornerRadius = 5
        l.textColor = kDefaultThemeColor
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(infoL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        infoL.frame = bounds
    }

    
}
