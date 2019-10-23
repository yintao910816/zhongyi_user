//
//  PhotoesCollectionViewCell.swift
//  pregnancyForD
//
//  Created by huchuang on 2017/6/5.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class PhotoesCollectionViewCell: UICollectionViewCell {
    
    let photoIV = UIImageView()
    
    var contentS : String? {
        didSet{
            photoIV.HC_setImageFromURL(urlS: contentS!, placeHolder: "HC-placeHolder")
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoIV)
        photoIV.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }

    
}
